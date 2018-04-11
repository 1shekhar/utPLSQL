create or replace package body test_not_existing_block is

  g_run_id integer;

  function get_mock_run_id return integer is
    v_result integer;
  begin
    select nvl(min(runid),0) - 1 into v_result
      from ut3.plsql_profiler_runs;
    return v_result;
  end;

  procedure create_dummy_coverage_package is
    pragma autonomous_transaction;
  begin
    execute immediate q'[create or replace package UT3.DUMMY_COVERAGE is
      procedure do_stuff;
    end;]';
    execute immediate q'[create or replace package body UT3.DUMMY_COVERAGE is
      procedure do_stuff is
      begin
        if 1 = 2 then
          dbms_output.put_line('should not get here');
        else
          dbms_output.put_line('should get here');
        end if;
      end;
    end;]';
  end;

  procedure create_dummy_coverage_test is
    pragma autonomous_transaction;
  begin
    execute immediate q'[create or replace package UT3.TEST_DUMMY_COVERAGE is
      --%suite(dummy coverage test)
      --%suitepath(coverage_testing)

      --%test
      procedure test_do_stuff;
    end;]';
    execute immediate q'[create or replace package body UT3.TEST_DUMMY_COVERAGE is
      procedure test_do_stuff is
      begin
        dummy_coverage.do_stuff;
      end;
    end;]';
  end;

  procedure create_dummy_coverage_test_1 is
    pragma autonomous_transaction;
  begin
    execute immediate q'[create or replace package UT3.DUMMY_COVERAGE_1 is
      procedure do_stuff;
    end;]';
    execute immediate q'[create or replace package body UT3.DUMMY_COVERAGE_1 is
      procedure do_stuff is
      begin
        if 1 = 2 then
          dbms_output.put_line('should not get here');
        else
          dbms_output.put_line('should get here');
        end if;
      end;
    end;]';
    execute immediate q'[create or replace package UT3.TEST_DUMMY_COVERAGE_1 is
      --%suite(dummy coverage test 1)
      --%suitepath(coverage_testing)

      --%test
      procedure test_do_stuff;
    end;]';
    execute immediate q'[create or replace package body UT3.TEST_DUMMY_COVERAGE_1 is
      procedure test_do_stuff is
      begin
        dummy_coverage_1.do_stuff;
      end;
    end;]';
  end;

  procedure drop_dummy_coverage_test_1 is
    pragma autonomous_transaction;
  begin
    execute immediate q'[drop package UT3.DUMMY_COVERAGE_1]';
    execute immediate q'[drop package UT3.TEST_DUMMY_COVERAGE_1]';
  end;


  procedure mock_coverage_data(a_run_id integer) is
    c_unit_id   constant integer := 1;
  begin
    insert into ut3.plsql_profiler_runs ( runid, run_owner, run_date, run_comment)
    values(a_run_id, user, sysdate, 'unit testing utPLSQL');

    insert into ut3.plsql_profiler_units ( runid, unit_number, unit_type, unit_owner, unit_name)
    values(a_run_id, c_unit_id, 'PACKAGE BODY', 'UT3', 'DUMMY_COVERAGE');

    insert into ut3.plsql_profiler_data ( runid,  unit_number, line#, total_occur, total_time)
    select a_run_id, c_unit_id,     4,           1, 1  from dual union all
    select a_run_id, c_unit_id,     5,           0, 0  from dual union all
    select a_run_id, c_unit_id,     7,           1, 1  from dual;
  end;

  procedure setup_dummy_coverage is
    pragma autonomous_transaction;
  begin
    create_dummy_coverage_package();
    create_dummy_coverage_test();
    g_run_id := get_mock_run_id();
    ut3.ut_coverage_helper.mock_coverage_id(g_run_id,ut3.ut_coverage.gc_block_coverage);
    mock_coverage_data(g_run_id);
    commit;
  end;

  procedure cleanup_dummy_coverage is
    pragma autonomous_transaction;
  begin
    begin execute immediate q'[drop package ut3.test_dummy_coverage]'; exception when others then null; end;
    begin execute immediate q'[drop package ut3.dummy_coverage]'; exception when others then null; end;
    delete from ut3.plsql_profiler_data where runid = g_run_id;
    delete from ut3.plsql_profiler_units where runid = g_run_id;
    delete from ut3.plsql_profiler_runs where runid = g_run_id;
    commit;
  end;

  procedure invalid_coverage_type is
    l_expected  clob;
    l_actual    clob;
    l_results   ut3.ut_varchar2_list;
  begin
    --Arrange
    l_expected := '%<file path="ut3.dummy_coverage">%';
    --Act
    select *
      bulk collect into l_results
      from table(
        ut3.ut.run(
          a_path => 'ut3.test_dummy_coverage',
          a_reporter=> ut3.ut_coverage_sonar_reporter( ),
          a_coverage_type => 'block',
          a_include_objects => ut3.ut_varchar2_list( 'ut3.dummy_coverage' )
        )
      );
  end;

end;
/
