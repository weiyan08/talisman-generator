# 符箓生成器

> 传统文化 × AI生成，专属符图屏保

## 项目简介

符箓生成器是一个基于八字五行分析的道教符箓生成工具，用户输入姓名、出生日期等信息后，系统会根据五行八卦算法生成专属的符图屏保。

## 功能特色

- ⚡ 传统文化 × AI生成
- 📱 专属符图屏保
- 🔮 基于五行八卦算法
- 💰 付费功能（弹窗模式）

## 快速开始

### 1. 运行项目

```bash
# 进入项目目录
cd /workspace/talisman-mini/

# 启动本地服务器
python -m http.server 8000

# 打开浏览器访问
open http://localhost:8000/index.html
```

### 2. 项目结构

```
/workspace/talisman-mini/
├── index.html      # 主页面
├── styles.css      # 样式文件
├── script.js       # 核心JavaScript代码
└── images/         # 图片资源
    └── payment/    # 付款相关图片
```

### 3. 核心功能

- 八字转换：公历→天干地支→五行
- 五行分析：补缺/财星/印星/桃花星
- 符箓生成：根据分析结果生成符图
- 付费功能：弹窗模式收款

## 开发指南

### 修改符图绘制

当前使用Canvas绘制简单线条，需要替换为专业设计师手绘的符文素材：

```javascript
// 替换前
function drawTalismanLines(ctx, type) {
    // Canvas绘制代码
}

// 替换后
function drawTalismanImage(type) {
    const img = document.getElementById(`talisman-${type}`);
    ctx.drawImage(img, 0, 0, 300, 300);
}
```

### 更新收款信息

替换 `images/payment/` 目录下的：
- 收款码图片
- 客服微信二维码
- 客服微信号文字

## 技术栈

- 纯HTML/CSS/JavaScript
- 无框架依赖
- 响应式设计
- 移动端适配

## 注意事项

1. **符文素材质量**：必须使用专业设计师手绘的符文
2. **道教文化准确性**：确保符文符合道教传统
3. **法律合规**：确保符文内容不涉及封建迷信

## 免责声明

本工具基于传统文化五行八卦算法，仅供娱乐参考，不构成任何预测或建议。

## 版本信息

- 当前版本：v1.0
- 上线时间：2026年7月
- 最后更新：2026年7月3日

## 联系方式

如有任何问题，请联系：
- 项目负责人：[待补充]
- 技术支持：[待补充]
- 设计师：[待补充]