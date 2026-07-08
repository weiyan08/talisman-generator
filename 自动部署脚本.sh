#!/bin/bash
# auto-deploy.sh - 自动部署脚本

# 服务器配置
SERVERS=("106.14.237.27" "172.24.19.113")
PROJECT_PATH="/var/www/fu"
LOCAL_REPO="/tmp/talisman-generator"

echo "================================"
echo "符箓生成器自动部署脚本"
echo "================================"
echo "部署时间: $(date)"
echo ""

# 检查是否有更新
check_updates() {
    echo "检查GitHub更新..."
    
    # 克隆或更新仓库
    if [ ! -d "$LOCAL_REPO" ]; then
        echo "克隆GitHub仓库..."
        git clone https://github.com/weiyan08/talisman-generator.git $LOCAL_REPO
    else
        echo "更新本地仓库..."
        cd $LOCAL_REPO
        git pull origin main
    fi
    
    # 检查是否有更新
    cd $LOCAL_REPO
    git fetch origin
    
    if [ $(git rev-list HEAD...origin/main --count) -gt 0 ]; then
        echo "✓ 发现更新，开始部署..."
        deploy
        return 0
    else
        echo "✓ 没有更新"
        return 1
    fi
}

# 部署函数
deploy() {
    echo "开始部署..."
    
    # 部署到每个服务器
    for server in "${SERVERS[@]}"; do
        echo "--------------------------------"
        echo "部署到服务器: $server"
        
        # 创建备份
        echo "创建备份..."
        ssh root@$server "mkdir -p $PROJECT_PATH/backups && cp $PROJECT_PATH/index.html $PROJECT_PATH/backups/backup_$(date +%Y%m%d_%H%M%S).html" 2>/dev/null || echo "警告: 备份失败"
        
        # 上传文件
        echo "上传文件..."
        scp $LOCAL_REPO/index.html root@$server:$PROJECT_PATH/index.html 2>/dev/null || echo "错误: 文件上传失败"
        
        # 设置权限
        echo "设置权限..."
        ssh root@$server "chmod 644 $PROJECT_PATH/index.html" 2>/dev/null || echo "警告: 权限设置失败"
        
        # 重启服务
        echo "重启服务..."
        ssh root@$server "systemctl restart nginx" 2>/dev/null || echo "警告: 服务重启失败"
        
        echo "✓ 服务器 $server 部署完成"
    done
    
    echo "--------------------------------"
    echo "✓ 所有服务器部署完成！"
    echo "访问地址: https://ai-newland.com/fu.html"
}

# 验证部署
verify_deployment() {
    echo "验证部署结果..."
    
    for server in "${SERVERS[@]}"; do
        echo "检查服务器 $server..."
        
        # 检查文件是否存在
        if ssh root@$server "test -f $PROJECT_PATH/index.html"; then
            echo "✓ 文件存在"
            
            # 检查文件大小
            file_size=$(ssh root@$server "wc -c < $PROJECT_PATH/index.html")
            echo "✓ 文件大小: $file_size 字节"
            
            # 检查Nginx状态
            nginx_status=$(ssh root@$server "systemctl is-active nginx" 2>/dev/null)
            if [ "$nginx_status" = "active" ]; then
                echo "✓ Nginx运行正常"
            else
                echo "✗ Nginx未运行"
            fi
        else
            echo "✗ 文件不存在"
        fi
        
        echo ""
    done
}

# 主菜单
show_menu() {
    echo "请选择操作:"
    echo "1. 检查更新并部署"
    echo "2. 仅检查更新"
    echo "3. 仅部署"
    echo "4. 验证部署"
    echo "5. 退出"
    echo ""
    read -p "请输入选择 (1-5): " choice
}

# 主循环
while true; do
    show_menu
    
    case $choice in
        1)
            check_updates
            verify_deployment
            ;;
        2)
            check_updates
            ;;
        3)
            deploy
            verify_deployment
            ;;
        4)
            verify_deployment
            ;;
        5)
            echo "退出脚本"
            exit 0
            ;;
        *)
            echo "无效选择"
            ;;
    esac
    
    echo ""
    read -p "按回车键继续..."
done