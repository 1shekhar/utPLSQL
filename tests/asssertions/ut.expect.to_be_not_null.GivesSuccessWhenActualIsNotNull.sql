PROMPT Gives success when actual blob value is not null
@@asssertions/common/ut.expect.unuary_comparator.scalar.common.sql 'blob' 'to_blob(''abc'')' 'to_be_not_null' 'ut_utils.tr_success'

PROMPT Gives success when actual boolean value is not null
@@asssertions/common/ut.expect.unuary_comparator.scalar.common.sql 'boolean' 'true' 'to_be_not_null' 'ut_utils.tr_success'

PROMPT Gives success when actual clob value is not null
@@asssertions/common/ut.expect.unuary_comparator.scalar.common.sql 'clob' '''abc''' 'to_be_not_null' 'ut_utils.tr_success'

PROMPT Gives success when actual date value is not null
@@asssertions/common/ut.expect.unuary_comparator.scalar.common.sql 'date' 'sysdate' 'to_be_not_null' 'ut_utils.tr_success'

PROMPT Gives success when actual number value is not null
@@asssertions/common/ut.expect.unuary_comparator.scalar.common.sql 'number' '1234' 'to_be_not_null' 'ut_utils.tr_success'

PROMPT Gives success when actual timestamp value is not null
@@asssertions/common/ut.expect.unuary_comparator.scalar.common.sql 'timestamp' 'systimestamp' 'to_be_not_null' 'ut_utils.tr_success'

PROMPT Gives success when actual timestamp with local time zone value is not null
@@asssertions/common/ut.expect.unuary_comparator.scalar.common.sql 'timestamp with local time zone' 'systimestamp' 'to_be_not_null' 'ut_utils.tr_success'

PROMPT Gives success when actual timestamp with time zone value is not null
@@asssertions/common/ut.expect.unuary_comparator.scalar.common.sql 'timestamp with time zone' 'systimestamp' 'to_be_not_null' 'ut_utils.tr_success'

PROMPT Gives success when actual varchar2 value is not null
@@asssertions/common/ut.expect.unuary_comparator.scalar.common.sql 'varchar2(4000)' '''abc''' 'to_be_not_null' 'ut_utils.tr_success'
