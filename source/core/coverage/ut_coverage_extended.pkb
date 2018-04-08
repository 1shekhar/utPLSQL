create or replace package body ut_coverage_extended is
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

  /**
  * Public functions
  */ 

  function get_extended_coverage(a_coverage_options ut_coverage_options) return ut_coverage.t_coverage is
    l_result              ut_coverage.t_coverage;
    l_result_block        ut_coverage.t_coverage;
    l_result_profiler     ut_coverage.t_coverage;
    l_source_objects_crsr ut_coverage_helper.t_tmp_table_objects_crsr;
    l_source_object       ut_coverage_helper.t_tmp_table_object;
    l_new_unit            ut_coverage.t_unit_coverage;
    l_line_no             binary_integer;
  begin
    l_result_block := ut_coverage_block.get_coverage_data_block(a_coverage_options => a_coverage_options);
    l_result_profiler:= ut_coverage_proftab.get_coverage_data_profiler(a_coverage_options => a_coverage_options);
    
    
    ut_coverage.populate_tmp_table(a_coverage_options,ut_coverage.get_cov_sources_sql(a_coverage_options,'N'));
    
    l_source_objects_crsr := ut_coverage_helper.get_tmp_table_objects_cursor();
    loop
      fetch l_source_objects_crsr
        into l_source_object;
      exit when l_source_objects_crsr%notfound;
      --check if we have a hits in any of reporters
      if l_result_block.total_lines > 0 or l_result_profiler.total_lines > 0 then
        --update total stats
        l_result.total_lines := nvl(l_result.total_lines,0) + l_source_object.lines_count;
        l_result.total_blocks := nvl(l_result_block.total_blocks,0);
        l_result.uncovered_blocks := nvl(l_result_block.uncovered_blocks,0);
        l_result.covered_blocks := nvl(l_result_block.covered_blocks,0);
        l_result.partcovered_lines := nvl(l_result_block.partcovered_lines,0);
        
        --populate object level coverage stats
        if not l_result.objects.exists(l_source_object.full_name) then
          l_result.objects(l_source_object.full_name) := l_new_unit;
          l_result.objects(l_source_object.full_name).owner := l_source_object.owner;
          l_result.objects(l_source_object.full_name).name := l_source_object.name;          
          l_result.objects(l_source_object.full_name).total_lines := l_source_object.lines_count;
          l_result.objects(l_source_object.full_name).total_blocks := nvl(l_result_block.objects(l_source_object.full_name).total_blocks,0);
          l_result.objects(l_source_object.full_name).uncovered_blocks := nvl(l_result_block.objects(l_source_object.full_name).uncovered_blocks,0);
          l_result.objects(l_source_object.full_name).covered_blocks := nvl(l_result_block.objects(l_source_object.full_name).covered_blocks,0);
          l_result.objects(l_source_object.full_name).partcovered_lines := nvl(l_result_block.objects(l_source_object.full_name).partcovered_lines,0);       
        end if;
        
        l_line_no := least(l_result_block.objects(l_source_object.full_name).lines.first,
                            l_result_profiler.objects(l_source_object.full_name).lines.first);
        
        if l_line_no is null then
          l_result.uncovered_lines := l_result.uncovered_lines + l_source_object.lines_count;
          l_result.objects(l_source_object.full_name).uncovered_lines := l_source_object.lines_count;
        else
         loop
            exit when l_line_no is null;           
              
            -- Set executions to zero at beginning, specific coverage will overwrite if exists.
            l_result.objects(l_source_object.full_name).lines(l_line_no).executions := 0;
            l_result.objects(l_source_object.full_name).lines(l_line_no).no_blocks := 0;
            l_result.objects(l_source_object.full_name).lines(l_line_no).covered_blocks := 0;
            l_result.objects(l_source_object.full_name).lines(l_line_no).partcove := 0;
             
            -- we need to check if given index exists for that coverage type or we get no data found
            if l_result_block.objects(l_source_object.full_name).lines.exists(l_line_no) then
             l_result.objects(l_source_object.full_name).lines(l_line_no).no_blocks := NVL(l_result_block.objects(l_source_object.full_name).lines(l_line_no).no_blocks,0);
             l_result.objects(l_source_object.full_name).lines(l_line_no).covered_blocks := NVL(l_result_block.objects(l_source_object.full_name).lines(l_line_no).covered_blocks,0);
             l_result.objects(l_source_object.full_name).lines(l_line_no).partcove := NVL(l_result_block.objects(l_source_object.full_name).lines(l_line_no).partcove,0);
             --We capture block executions here, since block coverage do not capture more than 1
             --if profiler executions exists we will use that number as profiler shows hits correctly
             
             l_result.objects(l_source_object.full_name).lines(l_line_no).executions := l_result_block.objects(l_source_object.full_name).lines(l_line_no).executions;
            end if;
           
            if l_result_profiler.objects(l_source_object.full_name).lines.exists(l_line_no) then
             l_result.objects(l_source_object.full_name).lines(l_line_no).executions := l_result_profiler.objects(l_source_object.full_name).lines(l_line_no).executions; 
            end if;
            
            -- Recalculate total lines
            if l_result.objects(l_source_object.full_name).lines(l_line_no).executions > 0 then
             -- total level stats
             l_result.executions := l_result.executions + l_result.objects(l_source_object.full_name).lines(l_line_no).executions;
             l_result.covered_lines := l_result.covered_lines + 1;            
             -- object level stats
             l_result.objects(l_source_object.full_name).covered_lines := l_result.objects(l_source_object.full_name)
                                                                             .covered_lines + 1;
            elsif l_result.objects(l_source_object.full_name).lines(l_line_no).executions = 0 then
             -- total level stats
             l_result.uncovered_lines := l_result.uncovered_lines + 1;
             -- object level stats
             l_result.objects(l_source_object.full_name).uncovered_lines := l_result.objects(l_source_object.full_name)
                                                                           .uncovered_lines + 1;
            end if;
            
            l_line_no := least(l_result_block.objects(l_source_object.full_name).lines.next(l_line_no),
                            l_result_profiler.objects(l_source_object.full_name).lines.next(l_line_no));
               
         end loop;
       end if;
      end if;
    
    end loop;
    close l_source_objects_crsr;
    return l_result;

  end get_extended_coverage; 
  
end;
/
