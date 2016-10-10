create or replace package body ut_utils is

  function quote_string(a_value varchar2) return varchar2 is
  begin
    return case when a_value is not null then ''''||a_value||'''' else gc_null_string end;
  end;

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
    l_len integer := coalesce(length(a_value),0);
  begin
    return
      case
        when l_len <= gc_max_input_string_length then quote_string(a_value)
        else quote_string(substr(a_value,1,gc_overflow_substr_len)) || gc_more_data_string
      end;
  end;

  function to_string(a_value clob) return varchar2 is
    l_len integer := coalesce(dbms_lob.getlength(a_value), 0);
  begin
    return
      case
        when l_len <= gc_max_input_string_length then quote_string(a_value)
        else quote_string(dbms_lob.substr(a_value, gc_overflow_substr_len)) || gc_more_data_string
      end;
  end;

  function to_string(a_value blob) return varchar2 is
    l_len integer := coalesce(dbms_lob.getlength(a_value), 0);
  begin
    return
      case
        when l_len <= gc_max_input_string_length then quote_string(rawtohex(a_value))
        else to_string( rawtohex(dbms_lob.substr(a_value, gc_overflow_substr_len)) )
      end;
  end;

  function to_string(a_value boolean) return varchar2 is
  begin
    return case a_value when true then 'TRUE' when false then 'FALSE' else gc_null_string end;
  end;

  function to_string(a_value number) return varchar2 is
  begin
    return coalesce(to_char(a_value,gc_number_format), gc_null_string);
  end;

  function to_string(a_value date) return varchar2 is
  begin
    return coalesce(to_char(a_value,gc_date_format), gc_null_string);
  end;

  function to_string(a_value timestamp_unconstrained) return varchar2 is
  begin
    return coalesce(to_char(a_value,gc_timestamp_format), gc_null_string);
  end;

  function to_string(a_value timestamp_tz_unconstrained) return varchar2 is
  begin
    return coalesce(to_char(a_value,gc_timestamp_tz_format), gc_null_string);
  end;

  function to_string(a_value timestamp_ltz_unconstrained) return varchar2 is
  begin
    return coalesce(to_char(a_value,gc_timestamp_format), gc_null_string);
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
