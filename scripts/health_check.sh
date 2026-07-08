#!/bin/bash
# health_check.sh - 健康检查符箓生成器服务器状态

# 服务器配置
SERVERS=("106.14.237.27" "172.24.19.113")
URL="https://ai-newland.com/fu.html"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 显示使用说明
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "使用方法: $0 [选项]"
    echo "选项:"
    echo "  -h, --help     显示此帮助信息"
    echo "  --verbose      详细模式"
    echo "  --quiet        静默模式"
    exit 0
fi

# 详细模式
if [ "$1" = "--verbose" ]; then
    VERBOSE=true
else
    VERBOSE=false
fi

# 静默模式
if [ "$1" = "--quiet" ]; then
    QUIET=true
else
    QUIET=false
fi

# 检查函数
check_server() {
    local server=$1
    local server_name=$2
    
    if [ "$QUIET" = false ]; then
        echo "服务器: $server_name ($server)"
        echo "--------------------------------"
    fi
    
    # 检查SSH连接
    if ssh -o ConnectTimeout=5 root@$server "exit" 2>/dev/null; then
        if [ "$QUIET" = false ]; then
            echo "${GREEN}✓ SSH连接正常${NC}"
        fi
        
        # 检查Nginx状态
        nginx_status=$(ssh root@$server "systemctl is-active nginx" 2>/dev/null)
        if [ "$nginx_status" = "active" ]; then
            if [ "$QUIET" = false ]; then
                echo "${GREEN}✓ Nginx运行正常${NC}"
            fi
        else
            if [ "$QUIET" = false ]; then
                echo "${RED}✗ Nginx未运行${NC}"
            fi
            return 1
        fi
        
        # 检查磁盘空间
        disk_usage=$(ssh root@$server "df -h /var/www | tail -1 | awk '{print \$5}' | sed 's/%//'")
        if [ $disk_usage -gt 80 ]; then
            if [ "$QUIET" = false ]; then
                echo "${YELLOW}⚠ 磁盘空间使用率: $disk_usage%${NC}"
            fi
        else
            if [ "$QUIET" = false ]; then
                echo "${GREEN}✓ 磁盘空间正常 (${disk_usage}%)${NC}"
            fi
        fi
        
        # 检查内存使用
        mem_usage=$(ssh root@$server "free | grep Mem | awk '{printf \"%.1f\", \$3/\$2 * 100.0}'")
        if [ "$QUIET" = false ]; then
            echo "内存使用率: ${mem_usage}%"
        fi
        
        # 详细模式显示更多信息
        if [ "$VERBOSE" = true ]; then
            # CPU使用率
            cpu_usage=$(ssh root@$server "top -bn1 | grep 'Cpu(s)' | awk '{print \$2}' | sed 's/%us,//'")
            echo "CPU使用率: ${cpu_usage}%"
            
            # 网络连接数
            connections=$(ssh root@$server "netstat -an | grep ESTABLISHED | wc -l")
            echo "活跃连接数: $connections"
            
            # 系统负载
            load=$(ssh root@$server "uptime | awk -F'load average:' '{print \$2}' | sed 's/,//g' | xargs")
            echo "系统负载: $load"
        fi
        
    else
        if [ "$QUIET" = false ]; then
            echo "${RED}✗ SSH连接失败${NC}"
        fi
        return 1
    fi
    
    if [ "$QUIET" = false ]; then
        echo ""
    fi
    return 0
}

# 检查网站访问
check_website() {
    if [ "$QUIET" = false ]; then
        echo "网站访问检查:"
    fi
    
    if curl -s --head $URL | grep -q "200 OK"; then
        if [ "$QUIET" = false ]; then
            echo "${GREEN}✓ 网站访问正常${NC}"
            
            # 测量响应时间
            response_time=$(curl -o /dev/null -s -w '%{time_total}' $URL)
            echo "响应时间: ${response_time}s"
            
            # 检查页面大小
            page_size=$(curl -s $URL | wc -c)
            echo "页面大小: $((page_size / 1024))KB"
        fi
        return 0
    else
        if [ "$QUIET" = false ]; then
            echo "${RED}✗ 网站访问异常${NC}"
        fi
        return 1
    fi
}

# 执行检查
echo "${BLUE}================================${NC}"
echo "${BLUE}符箓生成器服务器健康检查${NC}"
echo "${BLUE}================================${NC}"
echo "检查时间: $(date)"
echo ""

# 检查所有服务器
success_count=0
for i in "${!SERVERS[@]}"; do
    server=${SERVERS[$i]}
    server_name="主服务器"
    if [ $i -eq 1 ]; then
        server_name="备用服务器"
    fi
    
    if check_server $server "$server_name"; then
        ((success_count++))
    fi
done

# 检查网站访问
website_success=false
if check_website; then
    website_success=true
fi

# 显示结果
echo "${BLUE}================================${NC}"
echo "${BLUE}检查结果统计:${NC}"
echo "服务器检查: $success_count/${#SERVERS[@]} 成功"
if [ "$website_success" = true ]; then
    echo "网站检查: ${GREEN}成功${NC}"
else
    echo "网站检查: ${RED}失败${NC}"
fi

# 总体状态
if [ $success_count -eq ${#SERVERS[@]} ] && [ "$website_success" = true ]; then
    echo "${GREEN}所有检查正常！${NC}"
    exit 0
else
    echo "${RED}存在异常，请检查详情${NC}"
    exit 1
fi

echo "${BLUE}================================${NC}"