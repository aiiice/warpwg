# -*- coding: utf-8 -*-
import sqlite3
import os
import sys

# Warp 数据库路径
db_path = os.path.join(os.environ['LOCALAPPDATA'], 'warp', 'Warp', 'data', 'warp.sqlite')

print(f"数据库路径: {db_path}")

if not os.path.exists(db_path):
    print("数据库文件不存在！")
    sys.exit(1)

print("\n正在连接数据库...")
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# 查看当前的规则
print("\n【当前的规则】")
cursor.execute("SELECT id, data FROM generic_string_objects WHERE data LIKE '%memory%' AND data LIKE '%content%'")
rows = cursor.fetchall()
print(f"找到 {len(rows)} 条规则")

if len(rows) == 0:
    print("没有需要清理的规则")
    conn.close()
    sys.exit(0)

for idx, row in enumerate(rows, 1):
    print(f"{idx}. ID={row[0]}, Data preview: {row[1][:100]}...")

# 自动删除
print(f"\n正在删除 {len(rows)} 条规则...")
cursor.execute("DELETE FROM generic_string_objects WHERE data LIKE '%memory%' AND data LIKE '%content%'")
deleted = cursor.rowcount
conn.commit()
print(f"\n[OK] 已删除 {deleted} 条规则")

# 验证
cursor.execute("SELECT COUNT(*) FROM generic_string_objects WHERE data LIKE '%memory%' AND data LIKE '%content%'")
remaining = cursor.fetchone()[0]
print(f"剩余规则数: {remaining}")

conn.close()
print("\n完成！")
print("\n下一步：")
print("1. 在 Warp 中创建新的规则（Settings -> AI -> Rules -> Manage rules -> Global -> + Add）")
print("2. 或者重启网关应用，点击'刷新'从 Warp 读取现有规则")

