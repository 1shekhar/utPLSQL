create or replace type body ut_assertion_clob as

  constructor function ut_assertion_clob(self in out nocopy ut_assertion_clob, a_actual clob, a_message varchar2 default null) return self as result is
  begin
    self.message := a_message;
    self.actual_data := ut_data_value_clob('clob', ut_utils.boolean_to_int( (a_actual is null) ), ut_utils.to_string(a_actual), a_actual);
    return;
  end;

  overriding member procedure to_equal(self in ut_assertion_clob, a_expected clob, a_nulls_are_equal boolean := null) is
  begin
    ut_utils.debug_log('ut_assertion_clob.to_equal(self in ut_assertion, a_expected clob)');
    self.to_( equal(a_expected, a_nulls_are_equal) );
  end;

  member procedure to_be_like(self in ut_assertion_clob, a_mask in varchar2, a_escape_char in varchar2 := null) is
    l_condition boolean;
    l_escape_msg varchar2(100) := case when a_escape_char is not null then ' using escape '''||a_escape_char||'''' end;
  begin
    if a_escape_char is not null then
      l_condition := treat(self.actual_data as ut_data_value_clob).value like a_mask escape a_escape_char;
    else
      l_condition := treat(self.actual_data as ut_data_value_clob).value like a_mask;
    end if;
    self.build_assert_result(l_condition, 'to be like', ut_utils.to_string(a_mask)||l_escape_msg);
  end;

  member procedure to_match(self in ut_assertion_clob, a_pattern in varchar2, a_modifier in varchar2 default null) is
    l_modifiers_msg varchar2(100) := case when a_modifier is not null then ' using modifiers '''||a_modifier||'''' end;
  begin
    self.build_assert_result((regexp_like(treat(self.actual_data as ut_data_value_clob).value, a_pattern, a_modifier)), 'to be matching', ut_utils.to_string(a_pattern)||l_modifiers_msg);
  end;

end;
/
