import os
import re
import sys

dts_path = "target/linux/mediatek/dts/mt7622-netgear-wax206.dts"

if not os.path.exists(dts_path):
    print(f"ERROR: 找不到目标文件 {dts_path}")
    sys.exit(1)

with open(dts_path, "r", encoding="utf-8") as f:
    content = f.read()

# 匹配 partition@600000 下 label="ubi" 的整个节点定义并替换其 reg 长度为 0xfa00000 (约 250MB)
pattern = r"(partition@600000\s*\{\s*label\s*=\s*\"ubi\";\s*reg\s*=\s*<0x600000\s+)0x[0-9a-fA-F]+(>;)"

new_content, count = re.subn(pattern, r"\g<1>0xfa00000\2", content)

if count > 0:
    with open(dts_path, "w", encoding="utf-8") as f:
        f.write(new_content)
    print("SUCCESS: 成功将 WAX206 UBI 分区扩容至 250MB！")
else:
    print("ERROR: 未在 DTS 中定位到 label = \"ubi\" 节点！")
    sys.exit(1)
