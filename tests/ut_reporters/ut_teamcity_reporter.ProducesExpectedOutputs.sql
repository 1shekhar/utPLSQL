create or replace package ut_output_tests
as
 --%suite

 --%beforeeach
 procedure beforeeach;

 --%aftereach
 procedure aftereach;

 --%test
 --%beforetest(beforetest)
 --%aftertest(aftertest)
 procedure ut_passing_test;

 procedure beforetest;

 procedure aftertest;

 --%beforeall
 procedure beforeall;
 --%afterall
 procedure afterall;

end;
/

create or replace package body ut_output_tests
as

 procedure beforetest is
 begin
   dbms_output.put_line('<!beforetest!>');
 end;

 procedure aftertest
 is
 begin
   dbms_output.put_line('<!aftertest!>');
 end;

 procedure beforeeach is
 begin
   dbms_output.put_line('<!beforeeach!>');
 end;

 procedure aftereach is
 begin
   dbms_output.put_line('<!aftereach!>');
 end;

 procedure ut_passing_test
 is
 begin
   dbms_output.put_line('<!thetest!>');
   ut.expect(1,'Test 1 Should Pass').to_equal(1);
 end;

 procedure beforeall is
 begin
   dbms_output.put_line('<!beforeall!>');
 end;

 procedure afterall is
 begin
   dbms_output.put_line('<!afterall!>');
 end;

end;
/

declare
  l_output_data       ut_varchar2_list;
  l_output            clob;
begin
  --act
  select *
  bulk collect into l_output_data
  from table(ut.run('ut_output_tests',ut_teamcity_reporter()));

  l_output := ut_utils.table_to_clob(l_output_data);
  --assert

  if l_output like '%##teamcity[testStarted%<!beforeeach!>%<!beforetest!>%<!thetest!>%<!aftertest!>%<!aftereach!>%##teamcity[testFinished%' then
    :test_result := ut_utils.tr_success;
  else
    for i in 1 .. l_output_data.count loop
      dbms_output.put_line(l_output_data(i));
    end loop;
  end if;

end;
/

drop package ut_output_tests
/

