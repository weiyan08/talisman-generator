# Git推送说明

## 推送代码到GitHub仓库

### 1. 首次推送（需要认证）

```bash
cd /Users/weiyan/.openclaw/workspace/talisman-generator

# 推送到GitHub（需要输入GitHub用户名和密码或Personal Access Token）
git push -u origin main
```

### 2. 如果使用Personal Access Token

```bash
# 生成Personal Access Token后：
git push https://weiyan08:your_token@github.com/weiyan08/talisman-generator.git main
```

### 3. 配置SSH密钥（推荐）

```bash
# 检查是否已有SSH密钥
ls -la ~/.ssh/

# 如果没有，生成新的SSH密钥
ssh-keygen -t rsa -b 4096 -C "weiyan08@example.com"

# 启用SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# 复制公钥到GitHub
cat ~/.ssh/id_rsa.pub
# 将输出的公钥添加到GitHub账户的SSH keys中

# 修改远程仓库为SSH格式
git remote set-url origin git@github.com:weiyan08/talisman-generator.git

# 推送代码
git push -u origin main
```

## 已提交的文件

### 主要文件
- `index.html` - 符箓生成器源代码
- `README.md` - 项目说明文档
- `.gitignore` - Git忽略文件配置

### 文档目录 (`docs/`)
- `PROJECT_HANDOVER.md` - 项目交接文档
- `TECH_ANALYSIS.md` - 技术分析文档
- `SERVER_INFO.md` - 服务器信息文档
- `DEPLOY_GUIDE.md` - 部署指南
- `QUICK_SCRIPTS.md` - 快速操作脚本

### 脚本目录 (`scripts/`)
- `deploy.sh` - 自动部署脚本
- `health_check.sh` - 健康检查脚本

## 项目信息

### 项目概述
符箓生成器是一个基于八字五行分析的道教符箓生成工具，用户输入姓名、出生日期等信息后，系统会根据五行八卦算法生成专属的符图屏保。

### 技术特点
- 纯HTML/CSS/JavaScript实现
- 无框架依赖
- 响应式设计
- 移动端适配

### 服务器信息
- **主服务器**：106.14.237.27
- **备用服务器**：172.24.19.113
- **项目路径**：/var/www/fu/
- **访问地址**：https://ai-newland.com/fu.html

## 使用说明

### 1. 本地运行
```bash
# 启动本地服务器
python -m http.server 8000

# 访问项目
open http://localhost:8000/index.html
```

### 2. 部署到服务器
```bash
# 使用自动部署脚本
./scripts/deploy.sh

# 或手动部署
scp index.html root@106.14.237.27:/var/www/fu/
ssh root@106.14.237.27 "chmod 644 /var/www/fu/index.html && systemctl restart nginx"
```

### 3. 健康检查
```bash
# 使用健康检查脚本
./scripts/health_check.sh
```

## 注意事项

1. **GitHub认证**：首次推送需要GitHub认证，建议使用SSH密钥
2. **服务器权限**：部署脚本需要SSH访问服务器的权限
3. **文件权限**：确保服务器上的文件权限设置正确
4. **定期备份**：建议定期备份项目代码和服务器文件

## 版本信息

- 当前版本：v1.0
- 上线时间：2026年7月
- 最后更新：2026年7月3日
- Git提交：34da676

## 联系方式

如有任何问题，请联系：
- 项目负责人：[待补充]
- 技术支持：[待补充]
- 设计师：[待补充]