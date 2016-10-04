create or replace package body ut_utils is

  function test_result_to_char(a_test_result integer) return varchar2 as
  begin
    return case a_test_result
                  when tr_success then tr_success_char
                  when tr_failure then tr_failure_char
                  when tr_error   then tr_error_char
                  else 'Unknown(' || coalesce(to_char(a_test_result),'NULL') || ')'
                end;
  end test_result_to_char;


  function to_test_result(a_test boolean) return integer is
  begin
    return case a_test
             when true then tr_success
             else tr_failure
           end;
  end;

  procedure debug_log(a_message varchar2) is
  begin
    $if $$ut_trace $then
      dbms_output.put_line(a_message);
    $else
      null;
    $end
  end;


  function to_string(a_value varchar2) return varchar2 is
  begin
    return case
      when length(a_value) <= gc_max_sring_length then a_value
      else substr(a_value,1,gc_overflow_substr_len) || gc_more_data_string
    end;
  end;

  function to_string(a_value boolean) return varchar2 is
  begin
    return case a_value when true then 'TRUE' when false then 'FALSE' else 'NULL' end;
  end;

  function to_string(a_value number) return varchar2 is
  begin
    return to_char(a_value,gc_number_format);
  end;

  function to_string(a_value date) return varchar2 is
  begin
    return to_char(a_value,gc_date_format);
  end;

  function to_string(a_value timestamp_unconstrained) return varchar2 is
  begin
    return to_char(a_value,gc_timestamp_format);
  end;

  function boolean_to_int(a_value boolean) return integer is
  begin
    return case a_value when true then 1 when false then 0 end;
  end;

  function int_to_boolean(a_value integer) return boolean is
  begin
    return case a_value when 1 then true when 0 then false end;
  end;

end ut_utils;
/
