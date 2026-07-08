#!/bin/bash
# deploy.sh - 自动部署符箓生成器

# 服务器配置
SERVERS=("106.14.237.27" "172.24.19.113")
PROJECT_PATH="/var/www/fu"
BACKUP_DIR="/var/backups/fu"
LOCAL_FILE="index.html"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 显示使用说明
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "使用方法: $0 [选项]"
    echo "选项:"
    echo "  -h, --help     显示此帮助信息"
    echo "  --test         测试模式，不实际部署"
    echo "  --backup-only  仅备份，不部署"
    exit 0
fi

# 测试模式
if [ "$1" = "--test" ]; then
    echo "${YELLOW}测试模式：显示将要执行的命令，但不实际执行${NC}"
    TEST_MODE=true
else
    TEST_MODE=false
fi

# 仅备份模式
if [ "$1" = "--backup-only" ]; then
    echo "${YELLOW}仅备份模式：只创建备份，不部署新文件${NC}"
    BACKUP_ONLY=true
else
    BACKUP_ONLY=false
fi

# 检查文件是否存在
if [ ! -f "$LOCAL_FILE" ]; then
    echo "${RED}错误: 本地文件 $LOCAL_FILE 不存在${NC}"
    exit 1
fi

echo "================================"
echo "符箓生成器自动部署脚本"
echo "================================"
echo "部署时间: $(date)"
echo "本地文件: $LOCAL_FILE"
echo "目标路径: $PROJECT_PATH"
echo "================================"

# 部署函数
deploy_to_server() {
    local server=$1
    echo "正在部署到服务器: $server"
    echo "--------------------------------"
    
    # 检查SSH连接
    if ssh -o ConnectTimeout=5 root@$server "exit" 2>/dev/null; then
        echo "${GREEN}✓ SSH连接正常${NC}"
        
        # 创建备份
        echo "正在创建备份..."
        if [ "$TEST_MODE" = false ]; then
            ssh root@$server "mkdir -p $BACKUP_DIR && cp $PROJECT_PATH/index.html $BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).html"
        else
            echo "测试: ssh root@$server \"mkdir -p $BACKUP_DIR && cp $PROJECT_PATH/index.html $BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).html\""
        fi
        
        # 如果不是仅备份模式，则上传文件
        if [ "$BACKUP_ONLY" = false ]; then
            echo "正在上传文件..."
            if [ "$TEST_MODE" = false ]; then
                scp $LOCAL_FILE root@$server:$PROJECT_PATH/
                echo "${GREEN}✓ 文件上传完成${NC}"
            else
                echo "测试: scp $LOCAL_FILE root@$server:$PROJECT_PATH/"
            fi
            
            # 设置权限
            echo "正在设置权限..."
            if [ "$TEST_MODE" = false ]; then
                ssh root@$server "chmod 644 $PROJECT_PATH/index.html"
                ssh root@$server "chmod -R 755 $PROJECT_PATH/images/"
                echo "${GREEN}✓ 权限设置完成${NC}"
            else
                echo "测试: ssh root@$server \"chmod 644 $PROJECT_PATH/index.html\""
                echo "测试: ssh root@$server \"chmod -R 755 $PROJECT_PATH/images/\""
            fi
            
            # 重启服务
            echo "正在重启Nginx..."
            if [ "$TEST_MODE" = false ]; then
                ssh root@$server "systemctl restart nginx"
                echo "${GREEN}✓ Nginx重启完成${NC}"
            else
                echo "测试: ssh root@$server \"systemctl restart nginx\""
            fi
        else
            echo "${YELLOW}仅备份模式，跳过文件上传${NC}"
        fi
        
        echo "${GREEN}服务器 $server 操作完成${NC}"
    else
        echo "${RED}✗ SSH连接失败${NC}"
        return 1
    fi
    
    echo "--------------------------------"
    return 0
}

# 部署到所有服务器
success_count=0
for server in "${SERVERS[@]}"; do
    if deploy_to_server $server; then
        ((success_count++))
    fi
done

# 显示结果
echo "================================"
echo "部署结果统计:"
echo "总服务器数: ${#SERVERS[@]}"
echo "成功数: $success_count"
echo "失败数: $((${#SERVERS[@]} - success_count))"
echo "================================"

if [ $success_count -eq ${#SERVERS[@]} ]; then
    echo "${GREEN}所有服务器部署成功！${NC}"
    echo "访问地址: https://ai-newland.com/fu.html"
    
    # 检查网站访问
    echo "正在验证网站访问..."
    if curl -s --head https://ai-newland.com/fu.html | grep -q "200 OK"; then
        echo "${GREEN}✓ 网站访问正常${NC}"
    else
        echo "${YELLOW}⚠ 网站访问可能存在问题，请手动检查${NC}"
    fi
else
    echo "${RED}部分服务器部署失败，请检查错误信息${NC}"
    exit 1
fi

echo "================================"
echo "部署完成！"
echo "================================"