create or replace type body ut_expectation_timestamp_tz as

  overriding member procedure to_equal(self in ut_expectation_timestamp_tz, a_expected timestamp_tz_unconstrained, a_nulls_are_equal boolean := null) is
  begin
    ut_utils.debug_log('ut_expectation_timestamp_tz.to_equal(self in ut_expectation, a_expected timestamp_tz_unconstrained, a_nulls_are_equal boolean := null)');
    self.to_( equal(a_expected, a_nulls_are_equal) );
  end;

end;
/
