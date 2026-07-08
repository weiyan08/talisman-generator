# 符箓生成器服务器信息

## 服务器基本信息

### 服务器地址
- **主服务器**：106.14.237.27
- **备用服务器**：172.24.19.113
- **域名**：ai-newland.com
- **项目路径**：/var/www/fu/

### 连接信息
```bash
# 主服务器连接
ssh root@106.14.237.27

# 备用服务器连接
ssh root@172.24.19.113

# 域名解析验证
nslookup ai-newland.com
```

## 服务器配置详情

### 系统信息
```bash
# 查看系统信息
uname -a
cat /etc/os-release

# 查看硬件信息
lscpu
free -h
df -h
```

### Web服务器配置
```bash
# Nginx版本
nginx -v

# Nginx配置文件位置
nginx -T

# 站点配置
cat /etc/nginx/sites-available/ai-newland.com
```

### 项目文件权限
```bash
# 查看当前权限
ls -la /var/www/fu/

# 标准权限设置
chmod 644 /var/www/fu/index.html
chmod -R 755 /var/www/fu/images/
```

## 部署脚本

### 1. 自动部署脚本
```bash
#!/bin/bash
# deploy.sh - 自动部署符箓生成器

SERVER_IP="106.14.237.27"
PROJECT_PATH="/var/www/fu"
BACKUP_DIR="/var/backups/fu"

# 创建备份
mkdir -p $BACKUP_DIR
timestamp=$(date +%Y%m%d_%H%M%S)
cp -r $PROJECT_PATH $BACKUP_DIR/fu_backup_$timestamp

# 上传文件
scp index.html root@$SERVER_IP:$PROJECT_PATH/

# 设置权限
ssh root@$SERVER_IP "chmod 644 $PROJECT_PATH/index.html"
ssh root@$SERVER_IP "chmod -R 755 $PROJECT_PATH/images/"

# 重启Nginx
ssh root@$SERVER_IP "systemctl restart nginx"

# 验证部署
echo "部署完成，请访问：https://ai-newland.com/fu.html"
```

### 2. 批量更新脚本
```bash
#!/bin/bash
# batch_update.sh - 批量更新到两个服务器

SERVERS=("106.14.237.27" "172.24.19.113")
PROJECT_PATH="/var/www/fu"

for server in "${SERVERS[@]}"; do
    echo "正在更新服务器: $server"
    
    # 备份
    ssh root@$server "mkdir -p /var/backups/fu && cp -r $PROJECT_PATH /var/backups/fu/backup_$(date +%Y%m%d_%H%M%S)"
    
    # 上传文件
    scp index.html root@$server:$PROJECT_PATH/
    
    # 设置权限
    ssh root@$server "chmod 644 $PROJECT_PATH/index.html"
    ssh root@$server "chmod -R 755 $PROJECT_PATH/images/"
    
    # 重启服务
    ssh root@$server "systemctl restart nginx"
    
    echo "服务器 $server 更新完成"
done

echo "所有服务器更新完成"
```

## 监控脚本

### 1. 健康检查脚本
```bash
#!/bin/bash
# health_check.sh - 健康检查

SERVERS=("106.14.237.27" "172.24.19.113")
URL="https://ai-newland.com/fu.html"

for server in "${SERVERS[@]}"; do
    echo "检查服务器: $server"
    
    # 检查SSH连接
    if ssh -o ConnectTimeout=5 root@$server "exit" 2>/dev/null; then
        echo "✓ SSH连接正常"
    else
        echo "✗ SSH连接失败"
    fi
    
    # 检查Web服务
    if curl -s --head $URL | grep -q "200 OK"; then
        echo "✓ Web服务正常"
    else
        echo "✗ Web服务异常"
    fi
    
    # 检查磁盘空间
    disk_usage=$(ssh root@$server "df -h /var/www | tail -1 | awk '{print \$5}' | sed 's/%//'")
    if [ $disk_usage -gt 80 ]; then
        echo "⚠ 磁盘空间使用率: $disk_usage%"
    else
        echo "✓ 磁盘空间正常"
    fi
    
    echo "--------------------------------"
done
```

### 2. 性能监控脚本
```bash
#!/bin/bash
# performance_monitor.sh - 性能监控

SERVERS=("106.14.237.27" "172.24.19.113")

for server in "${SERVERS[@]}"; do
    echo "监控服务器: $server"
    echo "时间: $(date)"
    
    # CPU使用率
    cpu_usage=$(ssh root@$server "top -bn1 | grep 'Cpu(s)' | awk '{print \$2}' | sed 's/%us,//'")
    echo "CPU使用率: $cpu_usage%"
    
    # 内存使用率
    mem_usage=$(ssh root@$server "free | grep Mem | awk '{printf \"%.2f\", \$3/\$2 * 100.0}'")
    echo "内存使用率: $mem_usage%"
    
    # 磁盘使用率
    disk_usage=$(ssh root@$server "df -h /var/www | tail -1 | awk '{print \$5}' | sed 's/%//'")
    echo "磁盘使用率: $disk_usage%"
    
    # 网络连接数
    connections=$(ssh root@$server "netstat -an | grep ESTABLISHED | wc -l")
    echo "活跃连接数: $connections"
    
    echo "--------------------------------"
done
```

## 故障排除

### 1. 常见问题解决方案

#### 问题1：无法连接到服务器
```bash
# 检查网络连通性
ping 106.14.237.27
ping 172.24.19.113

# 检查SSH端口
telnet 106.14.237.27 22
telnet 172.24.19.113 22

# 检查防火墙
ssh root@106.14.237.27 "ufw status"
```

#### 问题2：网站无法访问
```bash
# 检查Nginx状态
ssh root@106.14.237.27 "systemctl status nginx"

# 检查Nginx配置
ssh root@106.14.237.27 "nginx -t"

# 检查网站文件
ssh root@106.14.237.27 "ls -la /var/www/fu/"

# 检查错误日志
ssh root@106.14.237.27 "tail -f /var/log/nginx/error.log"
```

#### 问题3：性能问题
```bash
# 检查系统负载
ssh root@106.14.237.27 "uptime"

# 检查进程
ssh root@106.14.237.27 "ps aux | grep nginx"

# 检查内存使用
ssh root@106.14.237.27 "free -h"

# 检查磁盘IO
ssh root@106.14.237.27 "iostat"
```

### 2. 紧急恢复脚本
```bash
#!/bin/bash
# emergency_restore.sh - 紧急恢复

SERVER_IP="106.14.237.27"
PROJECT_PATH="/var/www/fu"
BACKUP_DIR="/var/backups/fu"

# 列出可用备份
echo "可用备份:"
ls -la $BACKUP_DIR

# 选择备份
read -p "请输入要恢复的备份名称: " backup_name

# 执行恢复
if [ -d "$BACKUP_DIR/$backup_name" ]; then
    echo "正在恢复备份: $backup_name"
    
    # 停止服务
    ssh root@$SERVER_IP "systemctl stop nginx"
    
    # 恢复文件
    ssh root@$SERVER_IP "cp -r $BACKUP_DIR/$backup_name/* $PROJECT_PATH/"
    
    # 设置权限
    ssh root@$SERVER_IP "chmod 644 $PROJECT_PATH/index.html"
    ssh root@$SERVER_IP "chmod -R 755 $PROJECT_PATH/images/"
    
    # 重启服务
    ssh root@$SERVER_IP "systemctl start nginx"
    
    echo "恢复完成"
else
    echo "备份不存在: $backup_name"
fi
```

## 安全配置

### 1. 防火墙配置
```bash
# 在服务器上配置防火墙
ssh root@106.14.237.27 << 'EOF'
# 安装UFW
apt update
apt install -y ufw

# 配置防火墙规则
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw enable

# 查看状态
ufw status
EOF
```

### 2. SSL证书配置
```bash
# 在服务器上配置SSL
ssh root@106.14.237.27 << 'EOF'
# 安装Certbot
apt update
apt install -y certbot python3-certbot-nginx

# 获取SSL证书
certbot --nginx -d ai-newland.com

# 自动续期
systemctl status certbot.timer
certbot renew --dry-run
EOF
```

## 联系信息

### 服务器管理员
- **主服务器**：106.14.237.27
- **备用服务器**：172.24.19.113
- **紧急联系**：[待补充]

### 技术支持
- **项目负责人**：[待补充]
- **技术支持**：[待补充]
- **设计师**：[待补充]

### 监控和报警
- **监控频率**：每小时一次
- **报警阈值**：CPU > 80%，内存 > 85%，磁盘 > 90%
- **报警方式**：[待补充]

## 维护计划

### 日常维护
- [ ] 检查服务器状态
- [ ] 检查网站访问情况
- [ ] 检查错误日志
- [ ] 备份重要文件

### 每周维护
- [ ] 清理临时文件
- [ ] 更新系统安全补丁
- [ ] 检查备份完整性
- [ ] 性能优化检查

### 每月维护
- [ ] 全面系统检查
- [ ] 安全审计
- [ ] 性能评估
- [ ] 容量规划