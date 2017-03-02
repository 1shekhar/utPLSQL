create or replace package body ut_coverage is
  /*
  utPLSQL - Version X.X.X.X
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

  g_skipped_objects ut_object_names;
  g_schema_names    ut_varchar2_list;
  g_include_list    ut_object_names;
  g_exclude_list    ut_object_names;
  g_file_mappings   ut_coverage_file_mappings;


  /**
   * Private functions
   */
  function to_ut_object_list( a_names ut_varchar2_list) return ut_object_names is
    l_result ut_object_names;
  begin
    if a_names is not null then
      l_result := ut_object_names();
      for i in 1 .. a_names.count loop
        l_result.extend;
        l_result(l_result.last) := ut_object_name(a_names(i));
      end loop;
    end if;
    return l_result;
  end;

  /**
  * Public functions
  */
  function default_file_to_obj_type_map return ut_key_value_pairs is
  begin
    return ut_key_value_pairs(
        ut_key_value_pair('tpb', 'TYPE BODY'),
        ut_key_value_pair('pkb', 'PACKAGE BODY'),
        ut_key_value_pair('trg', 'TRIGGER')
    );
  end;

  function build_file_mappings(
    a_file_paths ut_varchar2_list, a_file_to_object_type_mapping ut_key_value_pairs,
    a_regex_pattern varchar2, a_object_owner_subexpression positive, a_object_name_subexpression positive, a_object_type_subexpression positive
  ) return ut_coverage_file_mappings is
    type tt_key_values is table of varchar2(4000) index by varchar2(4000);
    l_key_values tt_key_values;
    l_mappings   ut_coverage_file_mappings;
    l_mapping    ut_coverage_file_mapping;
    l_object_type_key varchar2(4000);
    l_object_type     varchar2(4000);
    l_file_to_object_type_mapping ut_key_value_pairs;
  begin
    l_file_to_object_type_mapping := nvl(a_file_to_object_type_mapping, default_file_to_obj_type_map());
    for i in 1 .. l_file_to_object_type_mapping.count loop
      l_key_values(upper(l_file_to_object_type_mapping(i).key)) := l_file_to_object_type_mapping(i).value;
    end loop;
    if a_file_paths is not null then
      l_mappings := ut_coverage_file_mappings();
      for i in 1 .. a_file_paths.count loop
        l_object_type_key := upper(regexp_substr(a_file_paths(i), a_regex_pattern,1,1,'i',a_object_type_subexpression));
        if l_key_values.exists(l_object_type_key) then
          l_object_type := l_key_values(l_object_type_key);
        else
          l_object_type := null;
        end if;
        l_mapping := ut_coverage_file_mapping(
          file_name => a_file_paths(i),
          object_owner => nvl(
            upper(regexp_substr(a_file_paths(i), a_regex_pattern, 1, 1, 'i', a_object_owner_subexpression))
            , sys_context('USERENV', 'CURRENT_SCHEMA')
          ),
          object_name => upper(regexp_substr(a_file_paths(i), a_regex_pattern, 1, 1, 'i', a_object_name_subexpression)),
          object_type => l_object_type
        );
        l_mappings.extend();
        l_mappings(l_mappings.last) := l_mapping;
      end loop;
    end if;
    return l_mappings;
  end;

  function get_coverage_id return integer is
  begin
    return ut_coverage_helper.get_coverage_id;
  end;

  function get_include_schema_names return ut_varchar2_list is
  begin
    return g_schema_names;
  end;

  procedure set_include_schema_names(a_schema_names ut_varchar2_list) is
  begin
    g_schema_names  := a_schema_names;
  end;

  procedure init(
    a_schema_names        ut_varchar2_list,
    a_include_object_list ut_varchar2_list,
    a_exclude_object_list ut_varchar2_list
  ) is
  begin
    g_schema_names  := a_schema_names;
    g_include_list  := to_ut_object_list(a_include_object_list);
    g_exclude_list  := to_ut_object_list(a_exclude_object_list);
  end;

  procedure init(
    a_file_mappings       ut_coverage_file_mappings,
    a_include_object_list ut_varchar2_list,
    a_exclude_object_list ut_varchar2_list
  ) is
  begin
    g_include_list  := to_ut_object_list(a_include_object_list);
    g_exclude_list  := to_ut_object_list(a_exclude_object_list);
    g_file_mappings := a_file_mappings;
  end;

  function coverage_start return integer is
  begin
    g_skipped_objects := ut_object_names();
    return ut_coverage_helper.coverage_start('utPLSQL Code coverage run '||ut_utils.to_string(systimestamp));
  end;

  procedure coverage_start is
    l_coverage_id integer;
  begin
    l_coverage_id := coverage_start();
  end;

  procedure coverage_start_develop is
  begin
    g_skipped_objects := ut_object_names();
    ut_coverage_helper.coverage_start_develop();
  end;

  procedure coverage_flush is
  begin
    ut_coverage_helper.coverage_flush();
  end;

  procedure coverage_pause is
  begin
    ut_coverage_helper.coverage_pause();
  end;

  procedure coverage_resume is
  begin
    ut_coverage_helper.coverage_resume();
  end;

  procedure coverage_stop is
  begin
    ut_coverage_helper.coverage_stop();
  end;

  procedure skip_coverage_for(a_owner varchar2, a_name varchar2) is
  begin
    if g_skipped_objects is null then
      g_skipped_objects := ut_object_names();
    end if;
    g_skipped_objects.extend;
    g_skipped_objects(g_skipped_objects.last) := ut_object_name(a_owner, a_name);
  end;

  function get_coverage_data return t_coverage is

    pragma autonomous_transaction;

    type t_coverage_row is record(
      name          varchar2(500),
      line_number   integer,
      total_occur   number(38,0)
    );
    type tt_coverage_rows is table of t_coverage_row;
    l_line_calls       ut_coverage_helper.unit_line_calls;
    l_result           t_coverage;
    l_new_unit         t_unit_coverage;
    l_skipped_objects  ut_object_names := ut_object_names();

    type t_source_lines is table of binary_integer;
    l_source_lines     t_source_lines;
    line_no            binary_integer;
    l_schema_names     ut_varchar2_list := coalesce(g_schema_names,ut_varchar2_list(sys_context('USERENV','CURRENT_SCHEMA')));
  begin

    if not ut_coverage_helper.is_develop_mode() then
      l_skipped_objects := ut_utils.get_utplsql_objects_list() multiset union set(g_skipped_objects);
    end if;

    --prepare global temp table with sources
    delete from ut_coverage_sources_tmp;

    if g_file_mappings is not null then
      insert into ut_coverage_sources_tmp(full_name,owner,name,line,text, to_be_skipped)
      select f.file_name, s.owner,s.name,s.line,s.text,
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
                    '^\s*(((not)?\s*(overriding|final|instantiable)\s*)*(static|constructor|member)?\s*(procedure|function)|package(\s+body)|begin|end(\s+\S+)?\s*;)', 'i'
                 )
                then 'Y'
             end as to_be_skipped
        from all_source s
        join table(g_file_mappings) f
          on s.name  = f.object_name
         and s.type  = f.object_type
         and s.owner = f.object_owner
       where s.type not in ('PACKAGE', 'TYPE')
         and (g_include_list is null or (s.owner, s.name) in (select il.owner, il.name from table(g_include_list) il))
         and (s.owner, s.name) not in (select el.owner, el.name from table(g_exclude_list) el)
         --Exclude calls to utPLSQL framework and Unit Test packages
         and (s.owner, s.name) not in (select so.owner, so.name from table(l_skipped_objects) so);
    else
      insert into ut_coverage_sources_tmp(full_name,owner,name,line,text, to_be_skipped)
      select lower(s.owner||'.'||s.name), s.owner,s.name,s.line,s.text,
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
                    '^\s*(((not)?\s*(overriding|final|instantiable)\s*)*(static|constructor|member)?\s*(procedure|function)|package(\s+body)|begin|end(\s+\S+)?\s*;)', 'i'
                 )
                then 'Y'
             end as to_be_skipped
        from all_source s
       where s.type not in ('PACKAGE', 'TYPE')
         and  s.owner in (select t.column_value from table(l_schema_names) t)
         and (g_include_list is null or (s.owner, s.name) in (select il.owner, il.name from table(g_include_list) il ) )
         and (s.owner, s.name) not in (select el.owner, el.name from table(g_exclude_list) el)
         --Exclude calls to utPLSQL framework and Unit Test packages
         and (s.owner, s.name) not in (select so.owner, so.name from table(l_skipped_objects) so);
    end if;

    for src_object in (
      select o.owner, o.name, o.full_name, max(o.line) lines_count,
             cast(
               collect(decode(to_be_skipped, 'Y', to_char(line))) as ut_varchar2_list
             ) to_be_skipped_list
        from ut_coverage_sources_tmp o
       group by o.owner, o.name, o.full_name
    ) loop

      --get coverage data
      l_line_calls := ut_coverage_helper.get_raw_coverage_data( src_object.owner, src_object.name );

      --if there is coverage, we need to filter out the garbage (badly indicated data from dbms_profiler)
      if l_line_calls.count > 0 then
        --remove lines that should not be indicted as meaningful
        for i in 1 .. src_object.to_be_skipped_list.count loop
          if src_object.to_be_skipped_list(i) is not null then
            l_line_calls.delete(src_object.to_be_skipped_list(i));
          end if;
        end loop;
      end if;

      if not l_result.objects.exists(src_object.full_name) then
        l_result.objects(src_object.full_name) := l_new_unit;
        l_result.objects(src_object.full_name).owner := src_object.owner;
        l_result.objects(src_object.full_name).name  := src_object.name;
      end if;
      l_result.total_lines := l_result.total_lines + src_object.lines_count;
      l_result.objects(src_object.full_name).total_lines := src_object.lines_count;
      --map to results
      line_no := l_line_calls.first;
      if line_no is null then
        l_result.uncovered_lines := l_result.uncovered_lines + src_object.lines_count;
        l_result.objects(src_object.full_name).uncovered_lines := src_object.lines_count;
      else
        loop
          exit when line_no is null;

          if l_line_calls(line_no) > 0 then
            l_result.covered_lines := l_result.covered_lines + 1;
            l_result.executions := l_result.executions + l_line_calls(line_no);
            l_result.objects(src_object.full_name).covered_lines := l_result.objects(src_object.full_name).covered_lines + 1;
            l_result.objects(src_object.full_name).executions := l_result.objects(src_object.full_name).executions + l_line_calls(line_no);
          elsif l_line_calls(line_no) = 0 then
            l_result.uncovered_lines := l_result.uncovered_lines + 1;
            l_result.objects(src_object.full_name).uncovered_lines := l_result.objects(src_object.full_name).uncovered_lines + 1;
          end if;
          l_result.objects(src_object.full_name).lines(line_no) := l_line_calls(line_no);

          line_no := l_line_calls.next(line_no);
        end loop;
      end if;


    end loop;

    commit;
    return l_result;
  end get_coverage_data;

end;
/
