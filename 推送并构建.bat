@echo off
chcp 65001 >nul
echo ==========================================
echo GitHub Actions 自动构建脚本
echo ==========================================
echo.

REM 检查是否有 Git
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未找到 Git，请先安装 Git
    pause
    exit /b 1
)

REM 检查是否在 Git 仓库中
git rev-parse --git-dir >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 当前目录不是 Git 仓库
    echo 请先初始化 Git 仓库：
    echo   git init
    echo   git remote add origin https://github.com/你的用户名/你的仓库名.git
    pause
    exit /b 1
)

echo [1/5] 检查 Git 状态...
git status

echo.
echo [2/5] 添加所有文件...
git add .

echo.
set /p commit_msg="请输入提交信息（直接回车使用默认）: "
if "%commit_msg%"=="" set commit_msg=更新代码并准备构建

echo [3/5] 提交更改...
git commit -m "%commit_msg%"
if %errorlevel% neq 0 (
    echo [提示] 没有需要提交的更改
)

echo.
echo [4/5] 推送到 GitHub...
git push origin main
if %errorlevel% neq 0 (
    echo [错误] 推送失败，请检查：
    echo   1. 是否已设置远程仓库
    echo   2. 是否有推送权限
    echo   3. 网络连接是否正常
    pause
    exit /b 1
)

echo.
echo [5/5] 推送成功！
echo.
echo ==========================================
echo 下一步操作：
echo ==========================================
echo.
echo 方式一：手动触发构建（推荐）
echo   1. 访问: https://github.com/你的用户名/你的仓库名/actions
echo   2. 点击左侧 "Test Build (Manual)"
echo   3. 点击 "Run workflow"
echo   4. 选择要构建的平台（both 表示同时构建）
echo   5. 点击绿色的 "Run workflow" 按钮
echo.
echo 方式二：创建 Tag 自动构建
echo   运行以下命令：
echo   git tag v3.0.4
echo   git push origin v3.0.4
echo.
echo ==========================================
pause
