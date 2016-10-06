create or replace type ut_assertion as object
(
  data_type           varchar2(250 char),
  is_null             number(1,0),
  actual_value_string varchar2(4000 char),
  message             varchar2(4000 char),
  final member procedure build_assert_result( self in ut_assertion, a_assert_result boolean, a_assert_name varchar2,
    a_expected_value_string in varchar2, a_expected_data_type varchar2 := null),
  member procedure to_equal(self in ut_assertion, a_expected varchar2, a_nulls_are_equal boolean := null),
  member procedure to_equal(self in ut_assertion, a_expected number, a_nulls_are_equal boolean := null),
  member procedure to_equal(self in ut_assertion, a_expected clob, a_nulls_are_equal boolean := null),
  member procedure to_equal(self in ut_assertion, a_expected blob, a_nulls_are_equal boolean := null),
  final member procedure to_be_null,
  final member procedure to_be_not_null
)
not final not instantiable
/
