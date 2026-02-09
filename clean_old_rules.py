# -*- coding: utf-8 -*-
import sqlite3
import os

db_path = os.path.join(os.environ['LOCALAPPDATA'], 'warp', 'Warp', 'data', 'warp.sqlite')

print(f"Connecting to: {db_path}")
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# 只删除旧的乱码规则，保留 ID 107 和 108（正确的中文规则）
print("\nDeleting old corrupted rules (ID: 102-106)...")
cursor.execute("DELETE FROM generic_string_objects WHERE id IN (102, 103, 104, 105, 106)")
deleted = cursor.rowcount
conn.commit()

print(f"[OK] Deleted {deleted} old rules")

# 验证剩余规则
cursor.execute("SELECT id, data FROM generic_string_objects WHERE data LIKE '%memory%'")
remaining = cursor.fetchall()
print(f"\nRemaining rules: {len(remaining)}")
for row in remaining:
    print(f"  ID: {row[0]}")
    print(f"  Data: {row[1][:100]}...")

conn.close()
print("\n[Done] Only correct Chinese rules remain!")

