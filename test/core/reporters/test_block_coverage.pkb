create or replace package body test_block_coverage is

  g_run_id integer;

  function get_mock_run_id return integer is
    v_result integer;
  begin
    select nvl(min(run_id),0) - 1 into v_result
      from ut3.dbmspcc_runs;
    return v_result;
  end;

  procedure create_dummy_coverage_package is
    pragma autonomous_transaction;
  begin
    execute immediate q'[create or replace package UT3.DUMMY_COVERAGE is
      procedure do_stuff(i_input in number);
    end;]';
    execute immediate q'[create or replace package body UT3.DUMMY_COVERAGE is
      procedure do_stuff(i_input in number) is
      begin
        if i_input = 2 then
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
        dummy_coverage.do_stuff(1);
        ut.expect(1).to_equal(1);
      end;
    end;]';
  end;

  procedure mock_coverage_data(a_run_id integer) is
    c_unit_id   constant integer := 1;
  begin
    insert into ut3.dbmspcc_runs ( run_id, run_owner, run_timestamp, run_comment)
    values(a_run_id, user, sysdate, 'unit testing utPLSQL');

    insert into ut3.dbmspcc_units ( run_id, object_id, type, owner, name,last_ddl_time)
    values(a_run_id, c_unit_id, 'PACKAGE BODY', 'UT3', 'DUMMY_COVERAGE',sysdate);

    insert into ut3.dbmspcc_blocks ( run_id,  object_id, line,block,col,covered,not_feasible)
    select a_run_id, c_unit_id,4,1,1,1,0  from dual union all
    select a_run_id, c_unit_id,5,2,0 ,1,0 from dual union all
    select a_run_id, c_unit_id,7,3,1,1,0  from dual;
  end;

  procedure setup_dummy_coverage is
    pragma autonomous_transaction;
  begin
    create_dummy_coverage_package();
    create_dummy_coverage_test();
    g_run_id := get_mock_run_id();
    ut3.ut_coverage_helper.mock_coverage_id(g_run_id);
    mock_coverage_data(g_run_id);
    commit;
  end;

  procedure cleanup_dummy_coverage is
    pragma autonomous_transaction;
  begin
    begin execute immediate q'[drop package ut3.test_dummy_coverage]'; exception when others then null; end;
    begin execute immediate q'[drop package ut3.dummy_coverage]'; exception when others then null; end;
    delete from ut3.dbmspcc_blocks where run_id = g_run_id;
    delete from ut3.dbmspcc_units where run_id = g_run_id;
    delete from ut3.dbmspcc_runs where run_id = g_run_id;
    commit;
  end;

  procedure coverage_for_object is
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
    --Assert
    l_actual := ut3.ut_utils.table_to_clob(l_results);
    ut.expect(l_actual).to_be_like(l_expected);
  end;

  procedure coverage_for_schema is
    l_expected  clob;
    l_actual    clob;
    l_results   ut3.ut_varchar2_list;
  begin
    --Arrange
    l_expected := '<file path="ut3.%">';
    l_expected := '%'||l_expected||'%'||l_expected||'%';
    --Act
    select *
      bulk collect into l_results
      from table(
        ut3.ut.run(
          a_path => 'ut3.test_dummy_coverage',
          a_reporter=> ut3.ut_coverage_sonar_reporter( ),
          a_coverage_type => 'block',
          a_coverage_schemes => ut3.ut_varchar2_list( 'ut3' )
        )
      );
    --Assert
    l_actual := ut3.ut_utils.table_to_clob(l_results);
    ut.expect(l_actual).to_be_like(l_expected);
  end;

  procedure coverage_for_file is
    l_expected  clob;
    l_actual    clob;
    l_results   ut3.ut_varchar2_list;
    l_file_path varchar2(100);
  begin
    --Arrange
    l_file_path := lower('test/ut3.dummy_coverage.pkb');
    l_expected := '%<file path="'||l_file_path||'">%';
    --Act
    select *
      bulk collect into l_results
      from table(
        ut3.ut.run(
          a_path => 'ut3.test_dummy_coverage',
          a_reporter=> ut3.ut_coverage_sonar_reporter( ),
          a_coverage_type => 'block',
          a_source_files => ut3.ut_varchar2_list( l_file_path ),
          a_test_files => ut3.ut_varchar2_list( )
        )
      );
    --Assert
    l_actual := ut3.ut_utils.table_to_clob(l_results);
    ut.expect(l_actual).to_be_like(l_expected);
  end;

end;
/
