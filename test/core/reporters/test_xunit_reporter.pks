create or replace package test_xunit_reporter as

  --%suite(ut_xunit_reporter)
  --%suitepath(utplsql.core.reporters)

  --%beforeall
  procedure crate_a_test_package;

  --%test(Escapes special characters from test and suite description)
  procedure escapes_special_chars;

  --%test(Reports only failed expectations and exceptions)
  procedure reports_only_failed_or_errored;

  --%test(Reports failed line of test)
  procedure reports_failed_line;

  --%afterall
  procedure remove_test_package;
end;
/
