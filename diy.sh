#!/bin/bash
# 应用大分区补丁
if [ -d "patches" ]; then
    for patch in patches/*.patch; do
        [ -f "$patch" ] && git apply "$patch" || true
    done
fi

# 确保官方源 feeds 更新
./scripts/feeds update -a
./scripts/feeds install -a
