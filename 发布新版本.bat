@echo off
chcp 65001 >nul
echo ==========================================
echo 发布新版本到 GitHub
echo ==========================================
echo.

REM 读取当前版本
for /f "tokens=2 delims=:, " %%a in ('findstr /C:"\"version\"" electron-app\package.json') do (
    set current_version=%%a
)
set current_version=%current_version:"=%

echo 当前版本: %current_version%
echo.

REM 输入新版本号
set /p new_version="请输入新版本号（例如 3.0.4）: "
if "%new_version%"=="" (
    echo [错误] 版本号不能为空
    pause
    exit /b 1
)

echo.
echo 将要执行以下操作：
echo   1. 更新 package.json 版本号为 %new_version%
echo   2. 提交所有更改
echo   3. 创建 Git Tag: v%new_version%
echo   4. 推送到 GitHub
echo   5. 自动触发构建和发布
echo.
set /p confirm="确认继续？(y/n): "
if /i not "%confirm%"=="y" (
    echo 已取消
    pause
    exit /b 0
)

echo.
echo [1/6] 更新版本号...
powershell -Command "(Get-Content electron-app\package.json) -replace '\"version\": \".*\"', '\"version\": \"%new_version%\"' | Set-Content electron-app\package.json"

echo [2/6] 添加文件...
git add .

echo [3/6] 提交更改...
git commit -m "发布 v%new_version%"

echo [4/6] 创建 Tag...
git tag v%new_version%

echo [5/6] 推送代码...
git push origin main

echo [6/6] 推送 Tag...
git push origin v%new_version%

if %errorlevel% equ 0 (
    echo.
    echo ==========================================
    echo ✓ 发布成功！
    echo ==========================================
    echo.
    echo GitHub Actions 正在自动构建...
    echo.
    echo 查看构建进度：
    echo https://github.com/你的用户名/你的仓库名/actions
    echo.
    echo 构建完成后，Release 会自动创建：
    echo https://github.com/你的用户名/你的仓库名/releases
    echo.
    echo 预计等待时间：15-20 分钟
    echo ==========================================
) else (
    echo.
    echo [错误] 推送失败，请检查网络和权限
)

echo.
pause
