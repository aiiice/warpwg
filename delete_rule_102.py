import sqlite3, os
db = os.path.join(os.environ['LOCALAPPDATA'], 'warp', 'Warp', 'data', 'warp.sqlite')
conn = sqlite3.connect(db)
c = conn.cursor()
c.execute('DELETE FROM generic_string_objects WHERE id=102')
conn.commit()
print(f'Deleted rule 102')
c.execute('SELECT id, data FROM generic_string_objects WHERE data LIKE "%memory%"')
print('Remaining rules:')
for r in c.fetchall():
    print(f'  ID:{r[0]}, Data:{r[1][:60]}...')
conn.close()

