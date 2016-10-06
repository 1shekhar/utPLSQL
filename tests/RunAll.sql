set echo off
set feedback off
set verify off
Clear Screen
set linesize 5000
set pagesize 0
set serveroutput on size unlimited format truncated
@@lib/RunVars.sql

--Global setup
@@helpers/ut_example_tests.pks
@@helpers/ut_example_tests.pkb
@@helpers/check_annotation_parsing.prc

--Tests to invoke

@@lib/RunTest.sql ut_test/ut_test.OwnerNameInvalid.sql
@@lib/RunTest.sql ut_test/ut_test.OwnerNameNull.sql
@@lib/RunTest.sql ut_test/ut_test.PackageInInvalidState.sql
@@lib/RunTest.sql ut_test/ut_test.PackageNameInvalid.sql
@@lib/RunTest.sql ut_test/ut_test.PackageNameNull.sql
@@lib/RunTest.sql ut_test/ut_test.ProcedureNameInvalid.sql
@@lib/RunTest.sql ut_test/ut_test.ProcedureNameNull.sql
@@lib/RunTest.sql ut_test/ut_test.SetupExecutedBeforeTest.sql
@@lib/RunTest.sql ut_test/ut_test.SetupProcedureNameInvalid.sql
@@lib/RunTest.sql ut_test/ut_test.SetupProcedureNameNull.sql
@@lib/RunTest.sql ut_test/ut_test.TeardownExecutedAfterTest.sql
@@lib/RunTest.sql ut_test/ut_test.TeardownProcedureNameInvalid.sql
@@lib/RunTest.sql ut_test/ut_test.TeardownProcedureNameNull.sql
@@lib/RunTest.sql ut_utils/ut_utils.test_result_to_char.RunsWithInvalidValues.sql
@@lib/RunTest.sql ut_utils/ut_utils.test_result_to_char.RunsWithNullValue.sql
@@lib/RunTest.sql ut_utils/ut_utils.test_result_to_char.Success.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.Blob.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.veryBigBlob.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.Clob.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.veryBigClob.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.Date.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.Timestamp.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.veryBigNumber.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.verySmallNumber.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.Varchar2.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.veryBigVarchar2.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.NullBlob.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.NullClob.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.NullDate.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.NullNumber.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.NullTimestamp.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.NullVarchar2.sql

@@lib/RunTest.sql ut_metadata/ut_metadata.form_name.TrimStandaloneProgramName.sql

@@lib/RunTest.sql ut_assert/ut_assert.are_equal.number.GivesSuccessForEqualValues.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.number.GivesFailureForDifferentValues.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.number.GivesFailureWhenActualIsNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.number.GivesFailureWhenBothAreNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.number.GivesFailureWhenExpectedIsNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.number.with_text.GivesTheProvidedTextAsMessage.sql

@@lib/RunTest.sql ut_assert/ut_assert.are_equal.anydata.GivesSuccessWhenComparingTheSameData.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.anydata.GivesFailureWhenComparingDifferentData.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.anydata.PutsObjectStrucureIntoAssert.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.cursor.GivesFailureWhenComparingDifferentResultSets.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.cursor.GivesSuccessWhenComparingIdenticalResultSets.sql

@@lib/RunTest.sql ut_assert/ut_assert.this.GivesFailureWhenExpressionEvaluatesToFalse.sql
@@lib/RunTest.sql ut_assert/ut_assert.this.GivesFailureWhenExpressionEvaluatesToNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.this.GivesSuccessWhenExpressionEvaluatesToTrue.sql

@@lib/RunTest.sql ut_assert/ut_assert.are_equal.varchar2.GivesFailureForDifferentValues.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.varchar2.GivesFailureWhenActualIsNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.varchar2.GivesFailureWhenBothAreNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.varchar2.GivesFailureWhenExpectedIsNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.varchar2.GivesSuccessForEqualValues.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.varchar2.with_text.GivesTheProvidedTextAsMessage.sql

@@lib/RunTest.sql ut_assert/ut_assert.are_equal.date.GivesFailureForDifferentValues.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.date.GivesFailureWhenActualIsNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.date.GivesFailureWhenBothAreNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.date.GivesFailureWhenExpectedIsNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.date.GivesSuccessForEqualValues.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.date.with_text.GivesTheProvidedTextAsMessage.sql

@@lib/RunTest.sql ut_assert/ut_assert.are_equal.timestamp.GivesFailureForDifferentValues.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.timestamp.GivesFailureWhenActualIsNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.timestamp.GivesFailureWhenBothAreNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.timestamp.GivesFailureWhenExpectedIsNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.timestamp.GivesSuccessForEqualValues.sql
@@lib/RunTest.sql ut_assert/ut_assert.are_equal.timestamp.with_text.GivesTheProvidedTextAsMessage.sql

@@lib/RunTest.sql ut_assert/ut_assert.are_equal.scalar.FailsToExecuteWhenNullsPassedAsParameters.sql

@@lib/RunTest.sql ut_assert/ut_assert.is_not_null.date.GivesFailureForNullValue.sql
@@lib/RunTest.sql ut_assert/ut_assert.is_not_null.date.GivesSuccessForNotNullValue.sql

@@lib/RunTest.sql ut_assert/ut_assert.is_null.anydata.GivesFailureWhenDataIsNotNull.sql
@@lib/RunTest.sql ut_assert/ut_assert.is_null.anydata.GivesSuccessWhenDataIsNull.sql

@@lib/RunTest.sql ut_assert/ut_assert.is_null.date.GivesFailureForNotNullValue.sql
@@lib/RunTest.sql ut_assert/ut_assert.is_null.date.GivesSuccessForNullValue.sql

@@lib/RunTest.sql ut_assert/ut_assert.is_like.GivesSuccessForLikeString.sql
@@lib/RunTest.sql ut_assert/ut_assert.is_like.GivesSuccessForLikeStringWithEscape.sql
@@lib/RunTest.sql ut_assert/ut_assert.is_like.GivesFailureForLikeString.sql
@@lib/RunTest.sql ut_assert/ut_assert.is_like.GivesFailureForLikeStringWithEscape.sql
@@lib/RunTest.sql ut_assert/ut_assert.is_matching.GivesSuccessForMatchingString.sql
@@lib/RunTest.sql ut_assert/ut_assert.is_matching.GivesSuccessForMatchingStringWithModifier.sql
@@lib/RunTest.sql ut_assert/ut_assert.is_matching.GivesFailureForMatchingString.sql

@@lib/RunTest.sql ut_utils/ut_utils.to_string.verySmallNumber.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.veryBigNumber.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.Date.sql
@@lib/RunTest.sql ut_utils/ut_utils.to_string.Timestamp.sql


@@lib/RunTest.sql ut_annotations/ut_annotations.parse_package_annotations.ParsePackageLevelAnnotation.sql
@@lib/RunTest.sql ut_annotations/ut_annotations.parse_package_annotations.ParsePackageLevelAnnotationWithMultilineComment.sql
@@lib/RunTest.sql ut_annotations/ut_annotations.parse_package_annotations.ParsePackageLevelAnnotationWithKeyValue.sql
@@lib/RunTest.sql ut_annotations/ut_annotations.parse_package_annotations.ParseAnnotationNotBeforeProcedure.sql
@@lib/RunTest.sql ut_annotations/ut_annotations.parse_package_annotations.ParsePackageAndProcedureLevelAnnotations.sql
@@lib/RunTest.sql ut_annotations/ut_annotations.parse_package_annotations.ParseAnnotationMixedWithWrongBeforeProcedure.sql
@@lib/RunTest.sql ut_annotations/ut_annotations.parse_package_annotations.ParseComplexPackage.sql

@@lib/RunTest.sql asssertions/ut.expect.to_equal.blob.GivesFailureForDifferentValues.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.blob.GivesFailureWhenActualIsNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.blob.GivesFailureWhenBothValuesAreNullAndArgumentAreNullEqualIsFalse.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.blob.GivesFailureWhenBothValuesAreNullAndConfigurationAreNullEqualIsFalse.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.blob.GivesFailureWhenExpectedIsNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.blob.GivesSuccessForEqualValues.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.blob.GivesSuccessWhenBothValuesAreNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.blob.GivesSuccessWhenBothValuesAreNullAndArgumentAreNullEqualIsTrue.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.blob.PutsNullIntoStringValueWhenActualIsNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.blob.PutsNullIntoStringValueWhenExpectedIsNull.sql

@@lib/RunTest.sql asssertions/ut.expect.to_equal.clob.GivesFailureForDifferentValues.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.clob.GivesFailureWhenActualIsNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.clob.GivesFailureWhenBothValuesAreNullAndArgumentAreNullEqualIsFalse.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.clob.GivesFailureWhenBothValuesAreNullAndConfigurationAreNullEqualIsFalse.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.clob.GivesFailureWhenExpectedIsNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.clob.GivesSuccessForEqualValues.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.clob.GivesSuccessWhenBothValuesAreNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.clob.GivesSuccessWhenBothValuesAreNullAndArgumentAreNullEqualIsTrue.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.clob.PutsNullIntoStringValueWhenActualIsNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.clob.PutsNullIntoStringValueWhenExpectedIsNull.sql

@@lib/RunTest.sql asssertions/ut.expect.to_equal.number.GivesFailureForDifferentValues.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.number.GivesSuccessForEqualValues.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.number.GivesSuccessWhenBothValuesAreNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.number.GivesFailureWhenActualIsNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.number.GivesFailureWhenExpectedIsNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.number.PutsNullIntoStringValueWhenActualIsNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.number.GivesFailureWhenBothValuesAreNullAndArgumentAreNullEqualIsFalse.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.number.GivesSuccessWhenBothValuesAreNullAndArgumentAreNullEqualIsTrue.sql

@@lib/RunTest.sql asssertions/ut.expect.to_equal.varchar.GivesFailureForDifferentValues.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.varchar.GivesSuccessForEqualValues.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.varchar.GivesSuccessWhenBothValuesAreNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.varchar.GivesFailureWhenActualIsNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.varchar.GivesFailureWhenExpectedIsNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.varchar.PutsNullIntoStringValueWhenActualIsNull.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.varchar.GivesFailureWhenBothValuesAreNullAndArgumentAreNullEqualIsFalse.sql
@@lib/RunTest.sql asssertions/ut.expect.to_equal.varchar.GivesSuccessWhenBothValuesAreNullAndArgumentAreNullEqualIsTrue.sql

@@lib/RunTest.sql asssertions/ut_assert_processor.nulls_are_equal.raisesExceptionWhenTryingToSetNullValue.sql

--Global cleanup
drop package ut_example_tests;
drop procedure check_annotation_parsing;

--Finally
@@lib/RunSummary
--can be used by CI to check for tests status
exit :failures_count
