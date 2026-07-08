#!/bin/bash

# 符箓生成器部署脚本
# 使用说明：请确保已配置SSH密钥认证，或使用密码认证

# 服务器配置
SERVERS=("106.14.237.27" "172.24.19.113")
PROJECT_PATH="/var/www/fu"
LOCAL_FILE="符箓生成器_源代码.html"

# 检查本地文件是否存在
if [ ! -f "$LOCAL_FILE" ]; then
    echo "错误: 本地文件 $LOCAL_FILE 不存在"
    exit 1
fi

echo "================================"
echo "符箓生成器部署脚本"
echo "================================"
echo "部署时间: $(date)"
echo "本地文件: $LOCAL_FILE"
echo "目标路径: $PROJECT_PATH"
echo ""

# 部署到每个服务器
for server in "${SERVERS[@]}"; do
    echo "正在部署到服务器: $server"
    echo "--------------------------------"
    
    # 创建备份
    echo "创建备份..."
    ssh root@$server "mkdir -p /var/backups/fu && cp $PROJECT_PATH/index.html /var/backups/fu/backup_$(date +%Y%m%d_%H%M%S).html" 2>/dev/null || echo "警告: 无法创建备份"
    
    # 上传文件
    echo "上传文件..."
    scp "$LOCAL_FILE" root@$server:$PROJECT_PATH/index.html 2>/dev/null || echo "错误: 文件上传失败"
    
    # 设置权限
    echo "设置权限..."
    ssh root@$server "chmod 644 $PROJECT_PATH/index.html" 2>/dev/null || echo "警告: 权限设置失败"
    ssh root@$server "chmod -R 755 $PROJECT_PATH/images/" 2>/dev/null || echo "警告: 图片目录权限设置失败"
    
    # 重启服务
    echo "重启服务..."
    ssh root@$server "systemctl restart nginx" 2>/dev/null || echo "警告: 服务重启失败"
    
    echo "服务器 $server 部署完成"
    echo ""
done

echo "================================"
echo "所有服务器部署完成！"
echo "访问地址: https://ai-newland.com/fu.html"
echo ""
echo "如果部署遇到问题，请检查："
echo "1. SSH密钥是否正确配置"
echo "2. 服务器连接是否正常"
echo "3. 文件权限是否正确"
echo "4. Nginx服务是否正常运行"
echo "================================"