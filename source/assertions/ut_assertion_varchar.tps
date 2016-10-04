create or replace type ut_assertion_varchar under ut_assertion
(
  actual varchar2(32767 char),
  constructor function ut_assertion_varchar(self in out nocopy ut_assertion_varchar, a_actual varchar2, a_message varchar2 default null) return self as result,
  overriding member procedure to_be_equal(self in ut_assertion_varchar, a_expected varchar2),
  member procedure to_be_like(self in ut_assertion_varchar, a_mask in varchar, a_escape_char in varchar2 := null),
  member procedure to_be_matching(self in ut_assertion_varchar, a_pattern in varchar2, a_modifier in varchar2 := null)
)
/
