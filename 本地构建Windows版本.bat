@echo off
chcp 65001 >nul
echo ==========================================
echo 本地构建 Windows 版本
echo ==========================================
echo.

REM 检查 Node.js
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未找到 Node.js
    echo 请先安装 Node.js: https://nodejs.org/
    pause
    exit /b 1
)

echo [✓] Node.js 版本:
node --version
echo.

REM 进入 electron-app 目录
cd electron-app

REM 检查 node_modules
if not exist "node_modules" (
    echo [1/3] 安装依赖...
    echo 这可能需要几分钟，请耐心等待...
    call npm install
    if %errorlevel% neq 0 (
        echo [错误] 依赖安装失败
        pause
        exit /b 1
    )
) else (
    echo [1/3] 依赖已安装，跳过...
)

echo.
echo [2/3] 开始构建 Windows 便携版...
echo 这可能需要 5-10 分钟，请耐心等待...
echo.

call npm run build:portable

if %errorlevel% equ 0 (
    echo.
    echo ==========================================
    echo ✓ 构建成功！
    echo ==========================================
    echo.
    echo 构建产物位置：
    echo electron-app\exe\
    echo.
    
    REM 列出构建的文件
    if exist "exe\*.exe" (
        echo 生成的文件：
        dir /b exe\*.exe
    )
    
    echo.
    echo 你可以在 electron-app\exe\ 目录找到安装包
    echo ==========================================
) else (
    echo.
    echo [错误] 构建失败
    echo 请查看上面的错误信息
)

echo.
pause
