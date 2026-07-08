# GitHub推送指南

## 当前状态
✅ **代码已提交到本地仓库**
❌ **需要认证才能推送到GitHub**

## 推送到GitHub的步骤

### 方法一：使用GitHub CLI（推荐）
```bash
# 1. 安装GitHub CLI（如果尚未安装）
# macOS: brew install gh
# Ubuntu/Debian: sudo apt install gh

# 2. 登录GitHub
gh auth login

# 3. 推送代码
git push origin main
```

### 方法二：使用个人访问令牌（PAT）
```bash
# 1. 生成个人访问令牌
# 访问：https://github.com/settings/tokens
# 创建新的token，选择repo权限

# 2. 设置Git凭据
git config --global user.name "your-username"
git config --global user.email "your-email@example.com"

# 3. 推送代码（会提示输入token）
git push origin main
```

### 方法三：使用SSH密钥
```bash
# 1. 检查是否已有SSH密钥
ls -la ~/.ssh/

# 2. 如果没有，生成新的SSH密钥
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"

# 3. 将公钥添加到GitHub
# 复制公钥内容：cat ~/.ssh/id_rsa.pub
# 添加到GitHub：https://github.com/settings/keys

# 4. 修改远程仓库URL为SSH格式
git remote set-url origin git@github.com:weiyan08/talisman-generator.git

# 5. 推送代码
git push origin main
```

### 方法四：直接在GitHub网页操作
1. 访问GitHub仓库：https://github.com/weiyan08/talisman-generator
2. 点击"Contribute" → "Create pull request"
3. 点击"Compare & pull request"
4. 填写标题和描述，点击"Create pull request"
5. 点击"Merge pull request"

## 当前Git状态
```bash
# 仓库信息
git remote -v
# origin	https://github.com/weiyan08/talisman-generator.git (fetch)
# origin	https://github.com/weiyan08/talisman-generator.git (push)

# 最近提交
git log --oneline -3
# 36a3a34 添加符箓生成器项目文件和部署脚本
# 34da676 Initial commit: 符箓生成器项目

# 文件状态
git status
# 所有文件已添加并提交，等待推送
```

## 推送后的验证
```bash
# 验证推送成功
git log --oneline -3
# 应该能看到最新的提交

# 访问GitHub仓库查看
# https://github.com/weiyan08/talisman-generator
```

## 常见问题

### 1. 认证失败
- 检查GitHub用户名和密码
- 确认个人访问令牌是否有效
- 检查网络连接

### 2. 权限错误
- 确认GitHub账户有仓库写入权限
- 检查SSH密钥是否正确添加

### 3. 网络问题
- 检查网络连接
- 尝试使用代理或VPN

## 推荐操作流程
1. 使用GitHub CLI进行认证（最简单）
2. 执行 `git push origin main` 推送代码
3. 访问GitHub仓库确认推送成功

## 完成后的操作
推送成功后，您可以：
- 在GitHub仓库中查看所有文件
- 创建GitHub Pages部署
- 设置CI/CD流水线
- 协作开发