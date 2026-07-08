# 百度文心一言配置指南

## 步骤一：打开配置文件

编辑 `~/.openclaw/openclaw.json`

## 步骤二：添加百度模型提供商

在 `models.providers` 下添加：

```json
"wenxin": {
  "baseUrl": "https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop",
  "apiKey": "你的API_Key",
  "secretKey": "你的Secret_Key",
  "models": [
    {
      "id": "ernie-3.5-8k",
      "name": "ERNIE-3.5-8K (免费)",
      "contextWindow": 8192,
      "maxTokens": 2048
    },
    {
      "id": "ernie-speed-8k",
      "name": "ERNIE-Speed-8K (免费)",
      "contextWindow": 8192,
      "maxTokens": 2048
    }
  ]
}
```

## 步骤三：重启 OpenClaw

```bash
openclaw restart
```

## 步骤四：验证

运行 `openclaw doctor` 查看模型列表