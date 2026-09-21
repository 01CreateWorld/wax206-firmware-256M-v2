#!/bin/bash

# 1. 动态修改设备树 DTS: 将 UBI 分区从官方小区间拓展至 0xc000000 (192MB)
DTS_FILE="target/linux/mediatek/dts/mt7622-netgear-wax206.dts"
if [ -f "$DTS_FILE" ]; then
    echo "Updating $DTS_FILE for 256M layout..."
    sed -i 's/partition@2000000/partition@4000000/g' "$DTS_FILE"
    sed -i 's/reg = <0x2000000 0x2000000>;/reg = <0x4000000 0xc000000>;/g' "$DTS_FILE"
fi

# 2. 动态修改 Makefile: 声明大容量 UBI 根文件系统尺寸
MK_FILE="target/linux/mediatek/image/mt7622.mk"
if [ -f "$MK_FILE" ]; then
    echo "Updating $MK_FILE with UBI_ROOT_SIZE..."
    sed -i '/DEVICE_MODEL := WAX206/a \  UBI_ROOT_SIZE := 160MiB' "$MK_FILE"
fi

# 3. 校验是否替换成功
echo "=== Verification ==="
git diff target/linux/mediatek/dts/mt7622-netgear-wax206.dts || true
git diff target/linux/mediatek/image/mt7622.mk || true
echo "===================="
