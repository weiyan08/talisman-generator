# GitHub Secrets 配置步骤

## 🚨 必需配置的Secrets

### 1. SSH_USERNAME
- **Name**: SSH_USERNAME
- **Value**: root

### 2. SSH_PRIVATE_KEY
- **Name**: SSH_PRIVATE_KEY  
- **Value**: 您的SSH私钥内容

## 📝 配置步骤

### 步骤1：访问GitHub Secrets页面
访问：https://github.com/weiyan08/talisman-generator/settings/secrets/actions

### 步骤2：添加SSH_USERNAME
1. 点击 "New repository secret"
2. Name: `SSH_USERNAME`
3. Value: `root`
4. 点击 "Add secret"

### 步骤3：添加SSH_PRIVATE_KEY
1. 再次点击 "New repository secret"
2. Name: `SSH_PRIVATE_KEY`
3. Value: 复制下面的SSH私钥内容（完整内容，包括BEGIN和END行）
4. 点击 "Add secret"

### 获取SSH私钥的方法：
```bash
# 复制完整的SSH私钥内容
cat ~/.ssh/id_rsa
```

## 🔑 SSH私钥格式示例
```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBp4sMFE+4ztVnTjFT6xcdrAWcgzzb4zq5A+rzFurEE/dKWE0+NftSqf0r
DWwv4e9X7+jGIHInqhRXknH/9ePuZxrHEnABfiMugkzdHSwBWq0u0TBD5upj7Jrz/Xs92
r8NcAL9lu4PrGX42JxvPFa9RNzYw6baaJ2R6PW9lVmiy34+41XqEK60esa62GphYOQ23+
PrwAbhiFIRhjF7Yfo8XpQX0t8cXijl+i2N4+mh4foKvMCgUs46VJIdlI8117T+ev7AXIB
xqhKHdjt/06F6SOxw3q/NVnCUYnBljO8JMr0WrEVxopeVXxeCesX7vigJP2ml+q5SJxSR
VX0MXcSzH7ZTC/9u0JiNTqZYHhcb4rLA58qnCpoqWHTPDDQyv0KzyS+75GKVq+q4Z7VL
RR3mVK0JZTojFV/FvunQ+Nk+NToHDjQ0ClFurozBUCTm/v2xxGvHK2Wr0hkxmtbwvOoe
OcDzHeFYG7QDugKebnSAOIpfsmbLhjTBqdI5JB6PzwQcpUF8pcHJIpynK7U9vZeZGc12
2qbdwSAxrnKY+OaZCQANndDiacyW6M1GDhIiCXevnkT6zkzJYBpJDMwt2nYWsmcV+XyY
2L4XdfpimRqJYZ7tuJOOdqLK/onNuLhV7rdI4LjTi4sAAAAGFdlaXlhbjA4QGV4YW1wbG
UuY29tAQIDBAU=
-----END OPENSSH PRIVATE KEY-----
```

## ✅ 配置完成后的效果

配置完成后：
1. 推送代码到GitHub：`git push origin main`
2. GitHub Actions自动触发部署
3. 自动部署到106.14.237.27和172.24.19.113
4. 自动备份原文件
5. 自动重启Nginx
6. 网站自动更新

## 🔍 验证配置

配置完成后，可以通过以下方式验证：

### 1. 查看GitHub Actions状态
访问：https://github.com/weiyan08/talisman-generator/actions

### 2. 查看Secrets配置
访问：https://github.com/weiyan08/talisman-generator/settings/secrets/actions

### 3. 触发测试部署
推送一个小更改来测试自动部署是否工作

## 🚨 故障排除

### 如果部署失败：
1. 检查Secrets是否正确配置
2. 检查SSH私钥是否完整
3. 检查服务器连接是否正常
4. 查看GitHub Actions日志

### 常见问题：
- SSH连接失败：检查SSH_USERNAME和SSH_PRIVATE_KEY
- 文件复制失败：检查文件路径和权限
- Nginx重启失败：检查Nginx配置

---
**配置状态**：需要配置GitHub Secrets ⏳  
**下一步**：按照上述步骤配置Secrets