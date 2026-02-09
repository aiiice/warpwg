# JOJO Warp Gateway

Warp IDE 账号无感切换网关 - 通过 MITM 代理实现多账号自动切换，无需重启 IDE。

## 🌟 功能特点

- 🔄 **无感切换** - IDE 无需重启即可自动切换账号
- 🌐 **代理网关模式** - 基于 mitmproxy 拦截和修改请求
- 📊 **实时监控** - 积分使用状态实时显示
- 🚀 **自动切换** - 积分用完自动切换下一个账号
- ⛔ **封号检测** - 自动检测并跳过被封禁的账号
- 📝 **日志记录** - 详细的操作和切换日志
- 🎨 **现代界面** - Electron 桌面应用，简洁易用

## 📁 项目结构

```
jojo-warp-gateway/
├── electron-app/           # Electron 桌面应用
│   ├── main.js             # 主进程 (IPC、进程管理)
│   ├── preload.js          # 预加载脚本
│   ├── app.js              # 渲染进程逻辑
│   ├── index.html          # 主界面
│   ├── styles.css          # 样式文件
│   └── package.json        # Electron 配置
├── backend/                # Python 后端
│   ├── config.py           # 路径配置
│   ├── gateway/            # 网关模块
│   │   └── warp_gateway_pro.py  # MITM 代理核心
│   ├── manager/            # 账号管理模块
│   │   └── warp_manager.py
│   └── utils/              # 工具模块
├── resources/              # 运行时资源
│   ├── python-embed/       # 嵌入式 Python 3.13 (含 mitmproxy)
│   └── elevate.exe         # 权限提升工具
├── scripts/                # 构建脚本
│   └── pre-build-clean.ps1
├── data/                   # 数据文件 (运行时生成)
│   └── gateway_accounts.json
├── logs/                   # 日志文件 (运行时生成)
├── icon.ico                # 应用图标
├── requirements.txt        # Python 依赖
└── .gitignore
```

## 🔧 技术栈

- **前端**: Electron 28 + 原生 HTML/CSS/JS
- **后端**: Python 3.13 + mitmproxy
- **代理**: MITM (Man-in-the-Middle) HTTPS 代理
- **数据**: JSON 文件存储

## 🚀 快速开始

### 开发模式

```powershell
# 1. 安装 Electron 依赖
cd electron-app
npm install

# 2. 启动应用
npm start
```

### 打包发布

```powershell
cd electron-app
npm run build        # 打包 NSIS 安装程序
npm run build:portable  # 打包便携版
```

## 📖 使用说明

### 1. 添加账号

在「账号」页面添加 Warp 账号，需要提供：
- Email
- API Key (从 Warp 凭证文件获取)
- UID

### 2. 安装证书（首次使用）

在「网关」页面点击「安装证书」，或手动安装：
```
%USERPROFILE%\.mitmproxy\mitmproxy-ca-cert.cer
```

安装到「受信任的根证书颁发机构」。

### 3. 启动网关

在「网关」页面点击「启动」，会自动：
1. 启动 MITM 代理 (默认端口 1986)
2. 配置环境变量 `HTTPS_PROXY`
3. 启动 Warp IDE

### 4. 无感切换

网关会自动：
- 拦截 Warp API 请求，替换为当前账号的 API Key
- 修改 GetRequestLimitInfo 响应，显示总积分池
- 检测账号用完或封禁，自动切换下一个

## 🛠️ 工作原理

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Warp IDE   │────▶│ MITM Proxy  │────▶│  Warp API   │
│             │◀────│ (Port 1986) │◀────│             │
└─────────────┘     └─────────────┘     └─────────────┘
                          │
                    ┌─────┴─────┐
                    │ 核心功能  │
                    ├───────────┤
                    │ 1. 替换 API Key
                    │ 2. 修改额度显示
                    │ 3. 检测封禁响应
                    │ 4. 自动切换账号
                    └───────────┘
```

## 📝 日志文件

| 文件 | 说明 |
|------|------|
| `logs/gateway_pro.log` | 网关运行日志 |
| `logs/manager.log` | 账号管理日志 |

## ⚠️ 注意事项

1. **证书安装**: 首次使用必须安装 mitmproxy CA 证书
2. **杀毒软件**: 可能需要将程序加入白名单
3. **防火墙**: 确保代理端口未被阻止
4. **账号安全**: 请妥善保管 API Key，不要泄露

## 📋 更新日志

### v1.0.1 (2024-12-01)
- ✨ 封号自动检测和跳过
- 🎨 现代化 GUI 界面
- 🔧 优化切换逻辑
- 📊 实时统计显示

### v1.0.0
- 🎉 首次发布
- 🔄 多账号无感切换
- 🌐 MITM 代理网关
- 📊 积分池管理

## 📄 License

MIT License

## 👤 作者

JOJO
