# -*- coding: utf-8 -*-
import sqlite3
import os

db_path = os.path.join(os.environ['LOCALAPPDATA'], 'warp', 'Warp', 'data', 'warp.sqlite')

print(f"Connecting to: {db_path}")
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# 删除乱码规则 (ID: 103, 104, 105)
print("\nDeleting corrupted rules (ID: 103, 104, 105)...")
cursor.execute("DELETE FROM generic_string_objects WHERE id IN (103, 104, 105)")
deleted = cursor.rowcount
conn.commit()

print(f"[OK] Deleted {deleted} corrupted rules")

# 验证剩余规则
cursor.execute("SELECT id, data FROM generic_string_objects WHERE data LIKE '%memory%'")
remaining = cursor.fetchall()
print(f"\nRemaining rules: {len(remaining)}")
for row in remaining:
    print(f"  ID: {row[0]}, Data: {row[1][:80]}...")

conn.close()
print("\n[Done] Database cleaned!")

