create or replace package body ut_coverage_proftab is
  /*
  utPLSQL - Version 3
  Copyright 2016 - 2017 utPLSQL Project

  Licensed under the Apache License, Version 2.0 (the "License"):
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  */

  -- The source query has two important transformations done in it.
  -- the flag: to_be_skipped ='Y' is set for a line of code that is badly reported by DBMS_PROFILER as executed 0 times.
  -- This includes lines that are:
  --   - PACKAGE, PROCEDURE, FUNCTION definition line,
  --   - BEGIN, END  of a block
  -- Another transformation is adjustment of line number for TRIGGER body.
  -- DBMS_PROFILER is reporting line numbers for triggers not as defined in DBA_SOURCE, its usign line numbers as defined in DBA_TRIGGERS
  -- the DBA_TRIGGERS does not contain the trigger specification lines, only lines that define the trigger body.
  -- the query adjusts the line numbers for triggers by finding first occurrence of begin|declare|compound in the trigger body line.
  -- The subquery is optimized by:
  -- - COALESCE function -> it will execute only for TRIGGERS
  -- - scalar subquery cache -> it will only execute once for one trigger source code.
  function get_cov_sources_sql(a_coverage_options ut_coverage_options) return varchar2 is
    l_result varchar2(32767);
    l_full_name varchar2(100);
    l_view_name      varchar2(200) := ut_metadata.get_dba_view('dba_source');
  begin
    if a_coverage_options.file_mappings is not null and a_coverage_options.file_mappings.count > 0 then
      l_full_name := 'f.file_name';
    else
      l_full_name := 'lower(s.owner||''.''||s.name)';
    end if;
    l_result := '
      select full_name, owner, name, line, to_be_skipped, text
        from (
          select '||l_full_name||q'[ as full_name,
                 s.owner,
                 s.name,
                 s.line -
                 coalesce(
                   case when type!='TRIGGER' then 0 end,
                   (select min(t.line) - 1
                      from ]'||l_view_name||q'[ t
                     where t.owner = s.owner and t.type = s.type and t.name = s.name
                       and regexp_like( t.text, '[A-Za-z0-9$#_]*(begin|declare|compound).*','i'))
                 ) as line,
                 s.text,
                 case
                   when
                     -- to avoid execution of regexp_like on every line
                     -- first do a rough check for existence of search pattern keyword
                     (lower(s.text) like '%procedure%'
                      or lower(s.text) like '%function%'
                      or lower(s.text) like '%begin%'
                      or lower(s.text) like '%end%'
                      or lower(s.text) like '%package%'
                     ) and
                     regexp_like(
                        s.text,
                        '^([\t ]*(((not)?\s*(overriding|final|instantiable)[\t ]*)*(static|constructor|member)?[\t ]*(procedure|function)|package([\t ]+body)|begin|end([\t ]+\S+)*[ \t]*;))', 'i'
                     )
                    then 'Y'
                 end as to_be_skipped
                 from ]'||l_view_name||q'[ s]';
            
    if a_coverage_options.file_mappings is not empty then
      l_result := l_result || '
            join table(:file_mappings) f
              on s.name  = f.object_name
             and s.type  = f.object_type
             and s.owner = f.object_owner
           where 1 = 1';
    elsif a_coverage_options.include_objects is not empty then
      l_result := l_result || '
           where (s.owner, s.name) in (select il.owner, il.name from table(:include_objects) il)';
    else
      l_result := l_result || '
           where s.owner in (select upper(t.column_value) from table(:l_schema_names) t)';
    end if;
    l_result := l_result || q'[
             and s.type not in ('PACKAGE', 'TYPE', 'JAVA SOURCE')
             --Exclude calls to utPLSQL framework, Unit Test packages and objects from a_exclude_list parameter of coverage reporter
             and (s.owner, s.name) not in (select el.owner, el.name from table(:l_skipped_objects) el)
             )
       where line > 0]';
    return l_result;
  end;

  /**
  * Public functions
  */
  function get_coverage_data_profiler(a_coverage_options ut_coverage_options) return ut_coverage.t_coverage is
    l_line_calls          ut_coverage_helper.t_unit_line_calls;
    l_result              ut_coverage.t_coverage;
    l_new_unit            ut_coverage.t_unit_coverage;
    l_line_no             binary_integer;
    l_source_objects_crsr ut_coverage_helper.t_tmp_table_objects_crsr;
    l_source_object       ut_coverage_helper.t_tmp_table_object;
  begin

    --prepare global temp table with sources
    ut_coverage.populate_tmp_table(a_coverage_options,get_cov_sources_sql(a_coverage_options));

    l_source_objects_crsr := ut_coverage_helper.get_tmp_table_objects_cursor();
    loop
      fetch l_source_objects_crsr into l_source_object;
      exit when l_source_objects_crsr%notfound;

      --get coverage data
      l_line_calls := ut_proftab_helper.get_raw_coverage_data_profiler( l_source_object.owner, l_source_object.name);

      --if there is coverage, we need to filter out the garbage (badly indicated data from dbms_profiler)
      if l_line_calls.count > 0 then
        --remove lines that should not be indicted as meaningful
        for i in 1 .. l_source_object.to_be_skipped_list.count loop
          if l_source_object.to_be_skipped_list(i) is not null then
            l_line_calls.delete(l_source_object.to_be_skipped_list(i));
          end if;
        end loop;
      end if;

      --if there are no file mappings or object was actually captured by profiler
      if a_coverage_options.file_mappings is null or l_line_calls.count > 0 then

        --populate total stats
        l_result.total_lines := nvl(l_result.total_lines,0) + l_source_object.lines_count;
        --populate object level coverage stats
        if not l_result.objects.exists(l_source_object.full_name) then
          l_result.objects(l_source_object.full_name) := l_new_unit;
          l_result.objects(l_source_object.full_name).owner := l_source_object.owner;
          l_result.objects(l_source_object.full_name).name  := l_source_object.name;
          l_result.objects(l_source_object.full_name).total_lines := l_source_object.lines_count;
        end if;
        --map to results
        l_line_no := l_line_calls.first;
        if l_line_no is null then
          l_result.uncovered_lines := l_result.uncovered_lines + l_source_object.lines_count;
          l_result.objects(l_source_object.full_name).uncovered_lines := l_source_object.lines_count;
        else
          loop
            exit when l_line_no is null;

            if l_line_calls(l_line_no).calls > 0 then
              --total stats
              l_result.covered_lines := l_result.covered_lines + 1;
              l_result.executions := l_result.executions + l_line_calls(l_line_no).calls;
              --object level stats
              l_result.objects(l_source_object.full_name).covered_lines := l_result.objects(l_source_object.full_name).covered_lines + 1;
              l_result.objects(l_source_object.full_name).executions := l_result.objects(l_source_object.full_name).executions + l_line_calls(l_line_no).calls;
            elsif l_line_calls(l_line_no).calls = 0 then
              l_result.uncovered_lines := l_result.uncovered_lines + 1;
              l_result.objects(l_source_object.full_name).uncovered_lines := l_result.objects(l_source_object.full_name).uncovered_lines + 1;
            end if;
            l_result.objects(l_source_object.full_name).lines(l_line_no).executions := l_line_calls(l_line_no).calls;

            l_line_no := l_line_calls.next(l_line_no);
          end loop;
        end if;
      end if;

    end loop;

    close l_source_objects_crsr;

    return l_result;
  end get_coverage_data_profiler;
  
end;
/
