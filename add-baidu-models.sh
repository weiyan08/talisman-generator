#!/bin/bash

# OpenClaw 百度千帆模型配置脚本
# 使用方法：bash /Users/weiyan/.openclaw/workspace/add-baidu-models.sh

CONFIG_FILE="$HOME/.openclaw/openclaw.json"
BACKUP_FILE="$HOME/.openclaw/openclaw.json.backup"

# 备份原配置
echo "📦 备份原配置..."
cp "$CONFIG_FILE" "$BACKUP_FILE"

# 添加百度千帆配置
echo "⚙️  添加百度千帆配置..."

# 使用 Python 来修改 JSON 配置
python3 << 'PYTHON_SCRIPT'
import json
import os

config_path = os.path.expanduser("~/.openclaw/openclaw.json")

# 读取配置
with open(config_path, 'r', encoding='utf-8') as f:
    config = json.load(f)

# 添加百度千帆 provider
if "models" not in config:
    config["models"] = {}
if "providers" not in config["models"]:
    config["models"]["providers"] = {}

config["models"]["providers"]["wenxin"] = {
    "baseUrl": "https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop",
    "apiKey": "请填入你的API_Key",
    "secretKey": "请填入你的Secret_Key",
    "models": [
        {
            "id": "ernie-4.5-turbo-128k",
            "name": "ERNIE-4.5-Turbo-128K (百度)",
            "contextWindow": 128000,
            "maxTokens": 8192
        },
        {
            "id": "ernie-4.5-turbo-32k",
            "name": "ERNIE-4.5-Turbo-32K (百度)",
            "contextWindow": 32000,
            "maxTokens": 8192
        },
        {
            "id": "ernie-4.5-turbo-vl",
            "name": "ERNIE-4.5-Turbo-VL (视觉)",
            "contextWindow": 128000,
            "maxTokens": 8192,
            "supportsVision": True
        },
        {
            "id": "qwen3-coder-480b",
            "name": "Qwen3-Coder-480B (百度)",
            "contextWindow": 32768,
            "maxTokens": 4096
        },
        {
            "id": "qwen3-235b",
            "name": "Qwen3-235B (百度)",
            "contextWindow": 32768,
            "maxTokens": 4096
        },
        {
            "id": "qwen3-30b",
            "name": "Qwen3-30B (百度)",
            "contextWindow": 32768,
            "maxTokens": 4096
        },
        {
            "id": "qwen3-coder-30b",
            "name": "Qwen3-Coder-30B (百度)",
            "contextWindow": 32768,
            "maxTokens": 4096
        },
        {
            "id": "bge-large-en",
            "name": "BGE-Large-EN (向量模型)",
            "contextWindow": 512,
            "maxTokens": 512,
            "type": "embedding"
        },
        {
            "id": "bge-large-zh",
            "name": "BGE-Large-ZH (中文向量模型)",
            "contextWindow": 512,
            "maxTokens": 512,
            "type": "embedding"
        }
    ]
}

# 写回配置
with open(config_path, 'w', encoding='utf-8') as f:
    json.dump(config, f, ensure_ascii=False, indent=2)

print("✅ 配置已更新！")
PYTHON_SCRIPT

echo ""
echo "🎉 配置完成！"
echo ""
echo "📝 下一步："
echo "1. 编辑配置文件填入你的 API Key 和 Secret Key："
echo "   nano ~/.openclaw/openclaw.json"
echo ""
echo "2. 找到 'wenxin' 部分，替换以下内容："
echo "   'apiKey': '你的API_Key'"
echo "   'secretKey': '你的Secret_Key'"
echo ""
echo "3. 重启 OpenClaw："
echo "   openclaw restart"
echo ""
echo "4. 验证配置："
echo "   openclaw doctor"
echo ""
echo "📦 备份文件位置: $BACKUP_FILE"