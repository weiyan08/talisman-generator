# 符箓生成器快速操作脚本

## 日常维护脚本

### 1. 快速部署脚本
```bash
#!/bin/bash
# quick_deploy.sh - 快速部署符箓生成器

# 服务器列表
SERVERS=("106.14.237.27" "172.24.19.113")
PROJECT_PATH="/var/www/fu"
LOCAL_FILE="index.html"

# 检查文件是否存在
if [ ! -f "$LOCAL_FILE" ]; then
    echo "错误: 本地文件 $LOCAL_FILE 不存在"
    exit 1
fi

# 部署到每个服务器
for server in "${SERVERS[@]}"; do
    echo "正在部署到服务器: $server"
    
    # 创建备份
    ssh root@$server "mkdir -p /var/backups/fu && cp $PROJECT_PATH/index.html /var/backups/fu/backup_$(date +%Y%m%d_%H%M%S).html"
    
    # 上传文件
    scp $LOCAL_FILE root@$server:$PROJECT_PATH/
    
    # 设置权限
    ssh root@$server "chmod 644 $PROJECT_PATH/index.html"
    ssh root@$server "chmod -R 755 $PROJECT_PATH/images/"
    
    # 重启服务
    ssh root@$server "systemctl restart nginx"
    
    echo "服务器 $server 部署完成"
    echo "--------------------------------"
done

echo "所有服务器部署完成！"
echo "访问地址: https://ai-newland.com/fu.html"
```

### 2. 快速检查脚本
```bash
#!/bin/bash
# quick_check.sh - 快速检查服务器状态

SERVERS=("106.14.237.27" "172.24.19.113")
URL="https://ai-newland.com/fu.html"

echo "================================"
echo "符箓生成器服务器状态检查"
echo "================================"
echo "检查时间: $(date)"
echo ""

for server in "${SERVERS[@]}"; do
    echo "服务器: $server"
    echo "--------------------------------"
    
    # 检查SSH连接
    if ssh -o ConnectTimeout=5 root@$server "exit" 2>/dev/null; then
        echo "✓ SSH连接正常"
        
        # 检查Nginx状态
        nginx_status=$(ssh root@$server "systemctl is-active nginx" 2>/dev/null)
        if [ "$nginx_status" = "active" ]; then
            echo "✓ Nginx运行正常"
        else
            echo "✗ Nginx未运行"
        fi
        
        # 检查磁盘空间
        disk_usage=$(ssh root@$server "df -h /var/www | tail -1 | awk '{print \$5}' | sed 's/%//'")
        if [ $disk_usage -gt 80 ]; then
            echo "⚠ 磁盘空间使用率: $disk_usage%"
        else
            echo "✓ 磁盘空间正常 ($disk_usage%)"
        fi
        
        # 检查内存使用
        mem_usage=$(ssh root@$server "free | grep Mem | awk '{printf \"%.1f\", \$3/\$2 * 100.0}'")
        echo "内存使用率: ${mem_usage}%"
        
    else
        echo "✗ SSH连接失败"
    fi
    
    echo ""
done

# 检查网站访问
echo "网站访问检查:"
if curl -s --head $URL | grep -q "200 OK"; then
    echo "✓ 网站访问正常"
    response_time=$(curl -o /dev/null -s -w '%{time_total}' $URL)
    echo "响应时间: ${response_time}s"
else
    echo "✗ 网站访问异常"
fi

echo "================================"
```

### 3. 快速备份脚本
```bash
#!/bin/bash
# quick_backup.sh - 快速备份符箓生成器

SERVERS=("106.14.237.27" "172.24.19.113")
PROJECT_PATH="/var/www/fu"
BACKUP_DIR="/var/backups/fu"
LOCAL_BACKUP_DIR="./backups"

# 创建本地备份目录
mkdir -p $LOCAL_BACKUP_DIR

echo "================================"
echo "符箓生成器备份"
echo "================================"
echo "备份时间: $(date)"
echo ""

for server in "${SERVERS[@]}"; do
    echo "正在备份服务器: $server"
    echo "--------------------------------"
    
    # 在服务器上创建备份
    ssh root@$server "mkdir -p $BACKUP_DIR && cp -r $PROJECT_PATH $BACKUP_DIR/fu_backup_$(date +%Y%m%d_%H%M%S)"
    
    # 下载备份到本地
    backup_name="fu_backup_$(date +%Y%m%d_%H%M%S)_${server//./_}"
    scp -r root@$server:$BACKUP_DIR/fu_backup_* $LOCAL_BACKUP_DIR/ 2>/dev/null || echo "警告: 无法下载备份"
    
    # 清理旧备份（保留最近7天）
    ssh root@$server "find $BACKUP_DIR -name 'fu_backup_*' -mtime +7 -delete"
    
    echo "服务器 $server 备份完成"
    echo ""
done

echo "本地备份文件:"
ls -la $LOCAL_BACKUP_DIR/
echo "================================"
```

### 4. 快速更新脚本
```bash
#!/bin/bash
# quick_update.sh - 快速更新符箓生成器特定部分

SERVERS=("106.14.237.27" "172.24.19.113")
PROJECT_PATH="/var/www/fu"

echo "================================"
echo "符箓生成器快速更新"
echo "================================"
echo "更新时间: $(date)"
echo ""

# 选择更新类型
echo "请选择更新类型:"
echo "1. 更新HTML文件"
echo "2. 更新图片资源"
echo "3. 更新CSS样式"
echo "4. 更新JavaScript代码"
echo "5. 更新付费信息"
echo "0. 退出"
read -p "请输入选择 (0-5): " choice

case $choice in
    1)
        echo "正在更新HTML文件..."
        read -p "请输入HTML文件路径: " html_file
        if [ -f "$html_file" ]; then
            for server in "${SERVERS[@]}"; do
                scp $html_file root@$server:$PROJECT_PATH/
                ssh root@$server "chmod 644 $PROJECT_PATH/index.html"
                ssh root@$server "systemctl restart nginx"
                echo "服务器 $server HTML文件更新完成"
            done
        else
            echo "错误: 文件不存在"
        fi
        ;;
    2)
        echo "正在更新图片资源..."
        read -p "请输入图片目录路径: " img_dir
        if [ -d "$img_dir" ]; then
            for server in "${SERVERS[@]}"; do
                scp -r $img_dir/* root@$server:$PROJECT_PATH/images/
                ssh root@$server "chmod -R 755 $PROJECT_PATH/images/"
                ssh root@$server "systemctl restart nginx"
                echo "服务器 $server 图片资源更新完成"
            done
        else
            echo "错误: 目录不存在"
        fi
        ;;
    3)
        echo "正在更新CSS样式..."
        # 这里可以添加CSS更新的具体逻辑
        echo "CSS样式更新功能待实现"
        ;;
    4)
        echo "正在更新JavaScript代码..."
        # 这里可以添加JavaScript更新的具体逻辑
        echo "JavaScript代码更新功能待实现"
        ;;
    5)
        echo "正在更新付费信息..."
        read -p "请输入解锁码（多个用逗号分隔）: " unlock_codes
        if [ -n "$unlock_codes" ]; then
            # 创建临时文件
            temp_file="/tmp/update_codes.txt"
            echo "const validCodes = [\"$unlock_codes\"]; // 自动生成的解锁码" > $temp_file
            
            for server in "${SERVERS[@]}"; do
                # 更新JavaScript代码中的解锁码
                ssh root@$server "sed -i '/const validCodes = \[/,/];/c\\const validCodes = [\"$unlock_codes\"]; // 自动生成的解锁码' $PROJECT_PATH/index.html"
                ssh root@$server "systemctl restart nginx"
                echo "服务器 $server 付费信息更新完成"
            done
            
            # 清理临时文件
            rm -f $temp_file
        else
            echo "错误: 解锁码不能为空"
        fi
        ;;
    0)
        echo "退出更新"
        exit 0
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac

echo "================================"
echo "更新完成！"
```

### 5. 紧急恢复脚本
```bash
#!/bin/bash
# emergency_restore.sh - 紧急恢复符箓生成器

SERVERS=("106.14.237.27" "172.24.19.113")
PROJECT_PATH="/var/www/fu"
BACKUP_DIR="/var/backups/fu"
LOCAL_BACKUP_DIR="./backups"

echo "================================"
echo "符箓生成器紧急恢复"
echo "================================"
echo "恢复时间: $(date)"
echo ""

# 显示可用备份
echo "可用备份:"
ls -la $LOCAL_BACKUP_DIR/ 2>/dev/null || echo "本地备份目录不存在"
echo ""
echo "服务器备份:"
for server in "${SERVERS[@]}"; do
    echo "服务器 $server:"
    ssh root@$server "ls -la $BACKUP_DIR/ | tail -10"
    echo ""
done

# 选择恢复方式
echo "请选择恢复方式:"
echo "1. 从本地备份恢复"
echo "2. 从服务器备份恢复"
echo "3. 恢复到指定版本"
echo "0. 退出"
read -p "请输入选择 (0-3): " choice

case $choice in
    1)
        echo "从本地备份恢复"
        ls -la $LOCAL_BACKUP_DIR/
        read -p "请输入要恢复的备份文件: " backup_file
        if [ -f "$LOCAL_BACKUP_DIR/$backup_file" ]; then
            for server in "${SERVERS[@]}"; do
                echo "正在恢复服务器 $server..."
                scp $LOCAL_BACKUP_DIR/$backup_file root@$server:$PROJECT_PATH/
                ssh root@$server "chmod 644 $PROJECT_PATH/index.html"
                ssh root@$server "systemctl restart nginx"
                echo "服务器 $server 恢复完成"
            done
        else
            echo "错误: 备份文件不存在"
        fi
        ;;
    2)
        echo "从服务器备份恢复"
        read -p "请输入服务器IP (106.14.237.27 或 172.24.19.113): " server_ip
        if [[ "$server_ip" == "106.14.237.27" || "$server_ip" == "172.24.19.113" ]]; then
            ssh root@$server_ip "ls -la $BACKUP_DIR/"
            read -p "请输入要恢复的备份文件: " backup_file
            if ssh root@$server_ip "test -f $BACKUP_DIR/$backup_file"; then
                echo "正在从服务器 $server_ip 恢复..."
                ssh root@$server_ip "cp $BACKUP_DIR/$backup_file $PROJECT_PATH/index.html"
                ssh root@$server_ip "chmod 644 $PROJECT_PATH/index.html"
                ssh root@$server_ip "systemctl restart nginx"
                echo "恢复完成"
            else
                echo "错误: 备份文件不存在"
            fi
        else
            echo "错误: 无效的服务器IP"
        fi
        ;;
    3)
        echo "恢复到指定版本"
        read -p "请输入版本号 (如: 20260703): " version
        if [ -n "$version" ]; then
            for server in "${SERVERS[@]}"; do
                backup_file="fu_backup_${version}"
                if ssh root@$server "test -f $BACKUP_DIR/$backup_file"; then
                    echo "正在恢复服务器 $server 到版本 $version..."
                    ssh root@$server "cp $BACKUP_DIR/$backup_file $PROJECT_PATH/index.html"
                    ssh root@$server "chmod 644 $PROJECT_PATH/index.html"
                    ssh root@$server "systemctl restart nginx"
                    echo "服务器 $server 恢复完成"
                else
                    echo "警告: 服务器 $server 不存在版本 $version"
                fi
            done
        else
            echo "错误: 版本号不能为空"
        fi
        ;;
    0)
        echo "退出恢复"
        exit 0
        ;;
    *)
        echo "无效选择"
        exit 1
        ;;
esac

echo "================================"
echo "恢复完成！"
```

## 使用说明

### 1. 赋予执行权限
```bash
chmod +x quick_deploy.sh
chmod +x quick_check.sh
chmod +x quick_backup.sh
chmod +x quick_update.sh
chmod +x emergency_restore.sh
```

### 2. 日常使用
```bash
# 快速部署
./quick_deploy.sh

# 快速检查
./quick_check.sh

# 快速备份
./quick_backup.sh

# 快速更新
./quick_update.sh

# 紧急恢复
./emergency_restore.sh
```

### 3. 定时任务
```bash
# 添加到crontab，每天凌晨2点自动备份
0 2 * * * /path/to/quick_backup.sh

# 每小时自动检查
0 * * * * /path/to/quick_check.sh
```

## 注意事项

1. **权限要求**：脚本需要SSH访问服务器的权限
2. **网络连接**：确保网络连接稳定
3. **备份验证**：定期验证备份文件的完整性
4. **测试环境**：建议先在测试环境验证脚本
5. **安全考虑**：妥善保管SSH密钥和备份文件

## 联系信息

如有问题，请联系：
- 系统管理员：[待补充]
- 技术支持：[待补充]
- 项目负责人：[待补充]