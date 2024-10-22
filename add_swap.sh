#!/bin/bash

# 设置swap大小，单位为MB
SWAP_SIZE=2048

# 检查是否已经存在swap文件
if swapon --show | grep -q "/swapfile"; then
    echo "Swap 已经存在，退出程序。"
    exit 1
fi

# 创建swap文件
echo "创建 ${SWAP_SIZE}MB 的 swap 文件..."
fallocate -l ${SWAP_SIZE}M /swapfile

# 设置swap文件权限
chmod 600 /swapfile

# 配置swap文件
mkswap /swapfile

# 启用swap
swapon /swapfile

# 将swap信息添加到 /etc/fstab 文件中以便开机自动加载
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

# 显示启用的swap信息
echo "Swap 文件创建完成，当前的 swap 信息："
swapon --show

# 调整内核参数，优化swap使用
sysctl vm.swappiness=10
echo "vm.swappiness=10" | tee -a /etc/sysctl.conf

sysctl vm.vfs_cache_pressure=50
echo "vm.vfs_cache_pressure=50" | tee -a /etc/sysctl.conf

echo "Swap 分区配置完成！"
