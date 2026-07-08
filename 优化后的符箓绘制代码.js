// 优化后的符箓绘制代码
// 专业符箓大师设计

// 传统配色方案
const TRADITIONAL_COLORS = {
  金: {
    primary: '#C83828',    // 朱砂红
    secondary: '#FFD700',  // 金黄
    accent: '#8B4513',     // 深棕
    background: '#FFF8DC',  // 米白
    text: '#8B4513'        // 深棕文字
  },
  木: {
    primary: '#228B22',    // 森林绿
    secondary: '#90EE90',  // 浅绿
    accent: '#006400',     // 深绿
    background: '#F0FFF0', // 浅绿背景
    text: '#006400'        // 深绿文字
  },
  水: {
    primary: '#000080',    // 深蓝
    secondary: '#4169E1',  // 皇家蓝
    accent: '#87CEEB',     // 天蓝
    background: '#E0F6FF', // 浅蓝背景
    text: '#000080'        // 深蓝文字
  },
  火: {
    primary: '#DC143C',    // 深红
    secondary: '#FF6347',  // 番茄红
    accent: '#FFD700',     // 金黄
    background: '#FFF0F5', // 浅粉背景
    text: '#DC143C'        // 深红文字
  },
  土: {
    primary: '#8B4513',    // 深棕
    secondary: '#DEB887',  // 浅棕
    accent: '#D2691E',     // 巧克力棕
    background: '#F5DEB3', // 小麦色背景
    text: '#8B4513'        // 深棕文字
  }
};

// 符文数据库
const FU_WEN_DATABASE = {
  peace: ['平', '安', '守', '护'],
  wealth: ['财', '富', '禄', '贵'],
  study: ['文', '昌', '智', '慧'],
  love: ['缘', '情', '爱', '合'],
  health: ['康', '宁', '寿', '福']
};

const JIAO_WENS = ['天', '地', '人', '和'];

// 主绘制函数 - 专业符箓
function drawProfessionalTalisman(ctx, W, H, config, bazi, gua, colors) {
  // 1. 背景处理
  drawBackground(ctx, W, H, config, colors);
  
  // 2. 符头绘制
  drawFuTou(ctx, W, H, config, colors);
  
  // 3. 符胆绘制
  drawFuDan(ctx, W, H, config, bazi, gua, colors);
  
  // 4. 符脚绘制
  drawFuJiao(ctx, W, H, config, bazi, colors);
  
  // 5. 符尾绘制
  drawFuWei(ctx, W, H, config, colors);
  
  // 6. 装饰元素
  drawDecorations(ctx, W, H, config, colors);
  
  // 7. 文字信息
  drawProfessionalText(ctx, W, H, config, bazi);
}

// 背景绘制
function drawBackground(ctx, W, H, config, colors) {
  // 渐变背景
  const gradient = ctx.createLinearGradient(0, 0, W, H);
  gradient.addColorStop(0, colors.background);
  gradient.addColorStop(1, colors.accent + '20');
  
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, W, H);
  
  // 添加纹理效果
  ctx.fillStyle = colors.primary + '05';
  for (let i = 0; i < 50; i++) {
    ctx.beginPath();
    ctx.arc(
      Math.random() * W,
      Math.random() * H,
      Math.random() * 3 + 1,
      0,
      Math.PI * 2
    );
    ctx.fill();
  }
}

// 符头绘制
function drawFuTou(ctx, W, H, config, colors) {
  const centerX = W / 2;
  const centerY = H / 4;
  
  // 绘制符头（朱砂点）
  ctx.beginPath();
  ctx.arc(centerX, centerY, 30, 0, Math.PI * 2);
  ctx.fillStyle = colors.primary;
  ctx.fill();
  
  // 符头光芒效果
  for (let i = 0; i < 3; i++) {
    ctx.beginPath();
    ctx.arc(centerX, centerY, 40 + i * 15, 0, Math.PI * 2);
    ctx.strokeStyle = colors.primary + (60 - i * 20).toString(16);
    ctx.lineWidth = 2;
    ctx.stroke();
  }
  
  // 符头文字
  ctx.fillStyle = '#FFFFFF';
  ctx.font = 'bold 28px serif';
  ctx.textAlign = 'center';
  ctx.fillText('符', centerX, centerY + 8);
}

// 符胆绘制
function drawFuDan(ctx, W, H, config, bazi, gua, colors) {
  const centerX = W / 2;
  const centerY = H / 2;
  
  // 绘制符胆边框
  ctx.strokeStyle = colors.primary;
  ctx.lineWidth = 3;
  
  // 外框
  ctx.beginPath();
  ctx.rect(centerX - 120, centerY - 120, 240, 240);
  ctx.stroke();
  
  // 内框
  ctx.beginPath();
  ctx.rect(centerX - 80, centerY - 80, 160, 160);
  ctx.stroke();
  
  // 中心符文
  const fuWen = getFuWen(config.type);
  ctx.fillStyle = colors.primary;
  ctx.font = 'bold 48px serif';
  ctx.textAlign = 'center';
  ctx.fillText(fuWen, centerX, centerY + 15);
  
  // 符胆光芒
  drawGlowEffect(ctx, centerX, centerY, colors);
}

// 符脚绘制
function drawFuJiao(ctx, W, H, config, bazi, colors) {
  const centerX = W / 2;
  const centerY = H * 3 / 4;
  
  // 绘制符脚
  for (let i = 0; i < 4; i++) {
    const angle = (i * Math.PI) / 2;
    const x = centerX + Math.cos(angle) * 100;
    const y = centerY + Math.sin(angle) * 100;
    
    // 符脚圆圈
    ctx.beginPath();
    ctx.arc(x, y, 25, 0, Math.PI * 2);
    ctx.fillStyle = colors.secondary;
    ctx.fill();
    
    // 符脚边框
    ctx.beginPath();
    ctx.arc(x, y, 25, 0, Math.PI * 2);
    ctx.strokeStyle = colors.primary;
    ctx.lineWidth = 2;
    ctx.stroke();
    
    // 符脚文字
    ctx.fillStyle = '#FFFFFF';
    ctx.font = 'bold 20px serif';
    ctx.textAlign = 'center';
    ctx.fillText(JIAO_WENS[i], x, y + 7);
  }
}

// 符尾绘制
function drawFuWei(ctx, W, H, config, colors) {
  const centerX = W / 2;
  const bottomY = H - 100;
  
  // 绘制符尾印章
  ctx.fillStyle = colors.primary;
  ctx.fillRect(centerX - 40, bottomY, 80, 80);
  
  // 印章文字
  ctx.fillStyle = '#FFFFFF';
  ctx.font = 'bold 32px serif';
  ctx.textAlign = 'center';
  ctx.fillText('印', centerX, bottomY + 40);
}

// 装饰元素绘制
function drawDecorations(ctx, W, H, config, colors) {
  // 绘制祥云
  drawClouds(ctx, W, H, colors);
  
  // 绘制符咒边框
  drawFuBorder(ctx, W, H, colors);
  
  // 绘制八卦符号
  drawBaguaSymbols(ctx, W, H, gua, colors);
}

// 祥云绘制
function drawClouds(ctx, W, H, colors) {
  ctx.fillStyle = colors.secondary + '30';
  
  // 左上祥云
  drawCloud(ctx, 120, 120, 60);
  drawCloud(ctx, W - 150, 100, 50);
  drawCloud(ctx, 100, H - 120, 55);
  drawCloud(ctx, W - 120, H - 100, 65);
}

function drawCloud(ctx, x, y, size) {
  ctx.beginPath();
  ctx.arc(x, y, size, 0, Math.PI * 2);
  ctx.arc(x + size * 0.6, y - size * 0.3, size * 0.8, 0, Math.PI * 2);
  ctx.arc(x + size * 1.2, y, size * 0.7, 0, Math.PI * 2);
  ctx.fill();
}

// 符咒边框
function drawFuBorder(ctx, W, H, colors) {
  ctx.strokeStyle = colors.primary;
  ctx.lineWidth = 2;
  
  // 外框
  ctx.strokeRect(30, 30, W - 60, H - 60);
  
  // 内框
  ctx.strokeRect(60, 60, W - 120, H - 120);
  
  // 角落装饰
  drawCornerDecoration(ctx, 30, 30, colors);
  drawCornerDecoration(ctx, W - 30, 30, colors);
  drawCornerDecoration(ctx, 30, H - 30, colors);
  drawCornerDecoration(ctx, W - 30, H - 30, colors);
}

function drawCornerDecoration(ctx, x, y, colors) {
  ctx.strokeStyle = colors.primary;
  ctx.lineWidth = 2;
  
  // 左上角
  if (x === 30 && y === 30) {
    ctx.beginPath();
    ctx.moveTo(x, y + 20);
    ctx.lineTo(x, y);
    ctx.lineTo(x + 20, y);
    ctx.stroke();
  }
  
  // 右上角
  if (x === W - 30 && y === 30) {
    ctx.beginPath();
    ctx.moveTo(x, y + 20);
    ctx.lineTo(x, y);
    ctx.lineTo(x - 20, y);
    ctx.stroke();
  }
  
  // 左下角
  if (x === 30 && y === H - 30) {
    ctx.beginPath();
    ctx.moveTo(x, y - 20);
    ctx.lineTo(x, y);
    ctx.lineTo(x + 20, y);
    ctx.stroke();
  }
  
  // 右下角
  if (x === W - 30 && y === H - 30) {
    ctx.beginPath();
    ctx.moveTo(x, y - 20);
    ctx.lineTo(x, y);
    ctx.lineTo(x - 20, y);
    ctx.stroke();
  }
}

// 八卦符号
function drawBaguaSymbols(ctx, W, H, gua, colors) {
  const centerX = W / 2;
  const centerY = H / 2;
  
  // 绘制八卦符号在四个角落
  const positions = [
    { x: 100, y: 100 },
    { x: W - 100, y: 100 },
    { x: 100, y: H - 100 },
    { x: W - 100, y: H - 100 }
  ];
  
  positions.forEach((pos, index) => {
    drawGuaSymbol(ctx, pos.x, pos.y, gua, colors);
  });
}

function drawGuaSymbol(ctx, x, y, gua, colors) {
  ctx.fillStyle = colors.primary;
  ctx.font = 'bold 24px serif';
  ctx.textAlign = 'center';
  ctx.fillText(gua.symbol, x, y);
}

// 光芒效果
function drawGlowEffect(ctx, x, y, colors) {
  // 绘制多层光芒
  for (let i = 0; i < 5; i++) {
    ctx.beginPath();
    ctx.arc(x, y, 80 + i * 20, 0, Math.PI * 2);
    ctx.strokeStyle = colors.primary + (30 - i * 6).toString(16);
    ctx.lineWidth = 2;
    ctx.stroke();
  }
}

// 专业文字绘制
function drawProfessionalText(ctx, W, H, config, bazi) {
  const colors = config.colors;
  
  // 标题
  ctx.fillStyle = colors.primary;
  ctx.font = 'bold 56px serif';
  ctx.textAlign = 'center';
  ctx.fillText(config.label, W / 2, 150);
  
  // 卦象信息
  ctx.font = '28px serif';
  ctx.fillText(`${gua.name}卦 · ${gua.nature}`, W / 2, 200);
  
  // 个人信息
  ctx.font = '24px serif';
  ctx.fillText(`${state.name} · ${state.birthDate}`, W / 2, H - 200);
  
  // 五行信息
  ctx.font = '20px serif';
  ctx.fillStyle = colors.text;
  ctx.fillText(`金${bazi.wc.金} 木${bazi.wc.木} 水${bazi.wc.水} 火${bazi.wc.火} 土${bazi.wc.土}`, W / 2, H - 150);
  
  // 祝福语
  ctx.font = 'bold 32px serif';
  ctx.fillStyle = colors.primary;
  ctx.fillText(config.blessing, W / 2, H - 80);
}

// 获取符文
function getFuWen(type) {
  const words = FU_WEN_DATABASE[type];
  return words[Math.floor(Math.random() * words.length)];
}

// 风格特定的绘制函数
function drawTaoistStyle(ctx, W, H, config, bazi, gua, colors) {
  drawProfessionalTalisman(ctx, W, H, config, bazi, gua, colors);
}

function drawGuochaoStyle(ctx, W, H, config, bazi, gua, colors) {
  // 国潮风格 - 更现代的设计
  drawProfessionalTalisman(ctx, W, H, config, bazi, gua, colors);
  
  // 添加国潮特有的装饰
  drawGuochaoDecorations(ctx, W, H, colors);
}

function drawInkStyle(ctx, W, H, config, bazi, gua, colors) {
  // 简约风格 - 墨色设计
  drawProfessionalTalisman(ctx, W, H, config, bazi, gua, colors);
  
  // 添加墨色效果
  drawInkEffects(ctx, W, H, colors);
}

// 国潮装饰
function drawGuochaoDecorations(ctx, W, H, colors) {
  // 添加现代几何元素
  ctx.strokeStyle = colors.secondary;
  ctx.lineWidth = 1;
  
  // 绘制几何图案
  for (let i = 0; i < 8; i++) {
    const angle = (i * Math.PI) / 4;
    const x = W / 2 + Math.cos(angle) * 200;
    const y = H / 2 + Math.sin(angle) * 200;
    
    ctx.beginPath();
    ctx.arc(x, y, 5, 0, Math.PI * 2);
    ctx.fillStyle = colors.secondary;
    ctx.fill();
  }
}

// 墨色效果
function drawInkEffects(ctx, W, H, colors) {
  // 添加墨色晕染效果
  ctx.fillStyle = colors.primary + '10';
  
  // 绘制墨色晕染
  for (let i = 0; i < 10; i++) {
    ctx.beginPath();
    ctx.arc(
      Math.random() * W,
      Math.random() * H,
      Math.random() * 50 + 20,
      0,
      Math.PI * 2
    );
    ctx.fill();
  }
}

// 导出函数
function drawTalisman() {
  const canvas = document.getElementById("talismanCanvas");
  const ctx = canvas.getContext("2d");
  const W = 1080, H = 1920;
  const c = state.config, b = state.bazi, colors = c.colors;

  ctx.clearRect(0, 0, W, H);

  // 卦象
  const guaIdx = (state.birthYear + state.birthMonth + state.birthDay) % 8;
  const gua = BAGUA[guaIdx];

  // 根据风格绘制
  if (state.style === "taoist") {
    drawTaoistStyle(ctx, W, H, c, b, gua, colors);
  } else if (state.style === "guochao") {
    drawGuochaoStyle(ctx, W, H, c, b, gua, colors);
  } else {
    drawInkStyle(ctx, W, H, c, b, gua, colors);
  }
}