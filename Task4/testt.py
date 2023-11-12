import psycopg2
conn = psycopg2.connect(dbname = 'postgres',
                        user = 'Elizabeth',
                        password = '----',
                        host = 'localhost')

cur = conn.cursor()
cur.execute("DROP TABLE IF EXISTS test CASCADE")
cur.execute("CREATE TABLE test(test integer)")
cur.execute("INSERT INTO test(test) VALUES(1)")
conn.commit()
cur.execute("SELECT * FROM test")
result = cur.fetchall()
print(result)
cur.execute("DROP TABLE test")
conn.commit()
conn.close()