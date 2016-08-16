create or replace type body ut_test_suite is

  constructor function ut_test_suite(a_suite_name varchar2, a_items ut_objects_list default ut_objects_list())
    return self as result is
  begin
    self.name  := a_suite_name;
		self.object_type := 2;
    self.items := a_items;
    return;
  end ut_test_suite;

  member procedure add_item(self in out nocopy ut_test_suite, a_item ut_test_object) is
  begin
    self.items.extend;
    self.items(self.items.last) := a_item;
  end add_item;

  overriding member procedure execute(self in out nocopy ut_test_suite, a_reporter ut_suite_reporter) is
    l_reporter ut_suite_reporter := a_reporter;
  begin
    l_reporter := execute(l_reporter);
  end;

  overriding member function execute(self in out nocopy ut_test_suite, a_reporter ut_suite_reporter) return ut_suite_reporter is
    l_reporter ut_suite_reporter := a_reporter;
    l_test_object ut_test_object;
  begin
    if l_reporter is not null then
      l_reporter.begin_suite(self);
    end if;
  
    ut_utils.debug_log('ut_test_suite.execute');

    self.start_time := current_timestamp;
  
    for i in self.items.first .. self.items.last loop
      l_test_object := treat(self.items(i) as ut_test_object);
      l_reporter := l_test_object.execute(a_reporter => l_reporter);
      self.items(i) := l_test_object;
    end loop;
  
    self.end_time := current_timestamp;
		
		self.calc_execution_result;
  
    if l_reporter is not null then
      l_reporter.end_suite(self);
    end if;
    return l_reporter;
  end;

  overriding member procedure execute(self in out nocopy ut_test_suite) is
	 l_null_reporter ut_suite_reporter;
  begin
    self.execute(l_null_reporter);
  end;

end;
/
