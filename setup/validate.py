#!/usr/bin/env python
import os
import snowflake.connector
# Gets the version

USER = os.getenv('SNOWSQL_USR')
PASSWORD = os.getenv('SNOWSQL_PWD')
ACCOUNT = os.getenv('SNOWSQL_ACC')
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