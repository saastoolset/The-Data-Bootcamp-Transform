#!/usr/bin/env python
import os
import snowflake.connector
# Gets the version

# https://docs.snowflake.com/en/user-guide/snowsql-start

USER = os.getenv('SNOWSQL_USER')
PASSWORD = os.getenv('SNOWSQL_PWD')
ACCOUNT = os.getenv('SNOWSQL_ACCOUNT')
ctx = snowflake.connector.connect(
    user=USER,
    password=PASSWORD,
    account=ACCOUNT
    )
cs = ctx.cursor()
try:
    cs.execute("SELECT current_version()")
    one_row = cs.fetchone()
    print(one_row[0])
finally:
    cs.close()
ctx.close()