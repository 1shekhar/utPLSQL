create or replace type body ut_reporter is

  constructor function ut_reporter return self as result is
  begin
    self.name := 'Null reporter';
    return;
  end;

  member procedure before_run(self in out nocopy ut_reporter, a_suites in ut_objects_list) is
  begin
    null;
  end;
  member procedure after_run(self in out nocopy ut_reporter, a_suites in ut_objects_list) is
  begin
    null;
  end;
  member procedure before_suite(self in out nocopy ut_reporter, a_suite in ut_object) is
  begin
    null;
  end;
  member procedure before_suite_setup(self in out nocopy ut_reporter, a_suite in ut_object) is
  begin
    null;
  end;
  member procedure after_suite_setup(self in out nocopy ut_reporter, a_suite in ut_object) is
  begin
    null;
  end;
  member procedure before_suite_item(self in out nocopy ut_reporter, a_suite in ut_object, a_item_index pls_integer) is
  begin
    null;
  end;
  member procedure after_suite_item(self in out nocopy ut_reporter, a_suite in ut_object, a_item_index pls_integer) is
  begin
    null;
  end;
  member procedure before_suite_teardown(self in out nocopy ut_reporter, a_suite in ut_object) is
  begin
    null;
  end;
  member procedure after_suite_teardown(self in out nocopy ut_reporter, a_suite in ut_object) is
  begin
    null;
  end;
  member procedure after_suite(self in out nocopy ut_reporter, a_suite in ut_object) is
  begin
    null;
  end;
  member procedure before_test(self in out nocopy ut_reporter, a_test in ut_object) is
  begin
    null;
  end;
  member procedure before_test_setup(self in out nocopy ut_reporter, a_test in ut_object) is
  begin
    null;
  end;
  member procedure after_test_setup(self in out nocopy ut_reporter, a_test in ut_object) is
  begin
    null;
  end;
  member procedure before_test_execute(self in out nocopy ut_reporter, a_test in ut_object) is
  begin
    null;
  end;
  member procedure after_test_execute(self in out nocopy ut_reporter, a_test in ut_object) is
  begin
    null;
  end;
  member procedure before_test_teardown(self in out nocopy ut_reporter, a_test in ut_object) is
  begin
    null;
  end;
  member procedure after_test_teardown(self in out nocopy ut_reporter, a_test in ut_object) is
  begin
    null;
  end;
  member procedure before_asserts_process(self in out nocopy ut_reporter, a_test in ut_object) is
  begin
    null;
  end;
  member procedure on_assert_process(self in out nocopy ut_reporter, a_assert in ut_object) is
  begin
    null;
  end;
  member procedure after_asserts_process(self in out nocopy ut_reporter, a_test in ut_object) is
  begin
    null;
  end;
  member procedure after_test(self in out nocopy ut_reporter, a_test in ut_object) is
  begin
    null;
  end;

end;
/
