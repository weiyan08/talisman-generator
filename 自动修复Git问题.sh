#!/bin/bash

# 自动修复Git推送问题
echo "================================"
echo "自动修复Git推送问题"
echo "================================"

# 1. 进入项目目录
echo "1. 进入项目目录..."
cd /Users/weiyan/.openclaw/workspace

# 2. 检查当前状态
echo "2. 检查Git状态..."
git status
echo ""
git branch
echo ""
git log --oneline -3

# 3. 添加所有文件
echo "3. 添加项目文件..."
git add .

# 4. 提交代码
echo "4. 提交代码..."
git commit -m "添加符箓生成器项目文件和部署脚本"

# 5. 强制推送到GitHub
echo "5. 推送到GitHub..."
git push origin main --force

# 6. 验证推送成功
echo "6. 验证推送状态..."
git log --oneline -3

echo "================================"
echo "Git修复完成！"
echo "================================"
echo "访问地址: https://github.com/weiyan08/talisman-generator"