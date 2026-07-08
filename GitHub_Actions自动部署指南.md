# GitHub Actions 自动部署配置指南

## 🚀 自动部署工作流程

您的项目已经配置了GitHub Actions自动部署，每次推送到main分支时会自动触发部署。

## 📋 当前配置

### GitHub Actions文件
- **位置**：`.github/workflows/auto-deploy.yml`
- **触发条件**：推送到main分支
- **部署服务器**：
  - 主服务器：106.14.237.27
  - 备用服务器：172.24.19.113

### 自动部署流程
1. 代码推送到GitHub main分支
2. GitHub Actions自动触发
3. 部署到主服务器 (106.14.237.27)
4. 部署到备用服务器 (172.24.19.113)
5. 重启Nginx服务
6. 自动备份原文件

## 🔧 GitHub Secrets 配置

需要在GitHub仓库中配置以下Secrets：

### 必需的Secrets
- `SSH_USERNAME`: 服务器用户名 (如：root)
- `SSH_PRIVATE_KEY`: SSH私钥内容

### 配置步骤
1. 访问GitHub仓库：https://github.com/weiyan08/talisman-generator/settings/secrets/actions
2. 点击"New repository secret"
3. 添加以下secrets：
   - Name: `SSH_USERNAME`, Value: `root`
   - Name: `SSH_PRIVATE_KEY`, Value: `[您的SSH私钥内容]`

### 获取SSH私钥
```bash
# 复制SSH私钥内容（不包含换行符）
cat ~/.ssh/id_rsa | tr -d '\n'
```

## 📝 自动部署文件说明

### .github/workflows/auto-deploy.yml
```yaml
name: 自动部署符箓生成器

on:
  push:
    branches: [ main ]

jobs:
  deploy-to-servers:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout repository
      uses: actions/checkout@v3
      
    - name: Deploy to main server
      uses: appleboy/ssh-action@v1.0.0
      # ... 部署配置
```

## 🔄 工作流程

### 正常部署流程
1. 本地代码提交：`git commit -m "更新符箓生成器"`
2. 推送到GitHub：`git push origin main`
3. GitHub Actions自动触发
4. 自动部署到服务器
5. 网站自动更新

### 查看部署状态
- 访问：https://github.com/weiyan08/talisman-generator/actions
- 查看最新的部署工作流
- 查看部署日志和状态

## 🛠️ 部署特性

### 自动备份
- 每次部署前自动备份原文件
- 备份文件名：`backup_20260707_121500.html`
- 备份位置：`/var/www/fu/backups/`

### 权限管理
- 自动设置文件权限：644
- 确保Nginx有读取权限

### 服务重启
- 自动重启Nginx服务
- 确保更改立即生效

### 双服务器部署
- 同时部署到主服务器和备用服务器
- 确保高可用性

## 🚨 故障排除

### 部署失败检查
1. 检查GitHub Actions日志
2. 检查服务器SSH连接
3. 检查文件权限
4. 检查Nginx服务状态

### 常见问题
1. **SSH连接失败**：检查SSH私钥和用户名
2. **文件复制失败**：检查文件路径和权限
3. **Nginx重启失败**：检查Nginx配置和服务状态

## 📊 监控和通知

### 部署日志
- GitHub Actions自动记录部署日志
- 包含部署时间、提交信息、文件信息

### 部署通知
- 部署完成后显示部署信息
- 包含访问地址和部署状态

## 🎯 使用建议

### 开发流程
1. 在本地开发和测试
2. 提交到本地Git：`git commit -am "新功能"`
3. 推送到GitHub：`git push origin main`
4. 等待自动部署完成
5. 访问网站验证部署

### 分支管理
- main分支：生产环境，自动部署
- develop分支：开发环境，不自动部署
- feature/*分支：功能分支，不自动部署

## 🔒 安全建议

1. **Secrets管理**：定期更新SSH密钥
2. **访问控制**：限制GitHub仓库访问权限
3. **日志监控**：定期检查GitHub Actions日志
4. **备份策略**：保留多个版本的备份文件

## 📞 获取帮助

### GitHub Actions文档
- 官方文档：https://docs.github.com/en/actions
- SSH Action文档：https://github.com/appleboy/ssh-action

### 项目相关
- 仓库地址：https://github.com/weiyan08/talisman-generator
- 网站地址：https://ai-newland.com/fu.html

---
**更新时间**：2026-07-07 12:18 GMT+8  
**配置状态**：GitHub Actions自动部署已配置 ⏳