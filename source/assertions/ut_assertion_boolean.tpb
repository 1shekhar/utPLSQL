create or replace type body ut_assertion_boolean as

  overriding member procedure to_equal(self in ut_assertion_boolean, a_expected boolean, a_nulls_are_equal boolean := null) is
  begin
    ut_utils.debug_log('ut_assertion_boolean.to_equal(self in ut_assertion, a_expected boolean)');
    self.to_( equal(a_expected, a_nulls_are_equal) );
  end;

end;
/
