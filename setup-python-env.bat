@echo off
chcp 65001 >nul
echo ===============================================
echo   自动配置 Python 嵌入式环境
echo ===============================================
echo.
echo 本脚本将自动配置项目所需的 Python 环境
echo 配置内容:
echo - 复制系统 Python 到项目目录
echo - 安装 mitmproxy（如果缺失）
echo - 验证环境完整性
echo.
pause

set PYTHON_DIR=resources\python-embed

echo.
echo [1/6] 检查系统 Python...
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo ✗ 系统未安装 Python
    echo.
    echo 请先安装 Python:
    echo 1. 访问: https://www.python.org/downloads/
    echo 2. 下载并安装 Python 3.11 或更高版本
    echo 3. 安装时勾选 "Add Python to PATH"
    echo 4. 安装完成后重新运行本脚本
    goto :error
)

echo ✓ 找到系统 Python
for /f "tokens=*" %%i in ('where python') do set SYSTEM_PYTHON=%%i
for /f "tokens=*" %%i in ('python --version') do echo   版本: %%i
echo   路径: %SYSTEM_PYTHON%

echo.
echo [2/6] 检查系统 mitmproxy...
where mitmdump >nul 2>&1
if %errorlevel% neq 0 (
    echo ! 系统未安装 mitmproxy
    echo   正在安装 mitmproxy...
    pip install mitmproxy
    if %errorlevel% neq 0 (
        echo ✗ 安装失败，请手动安装: pip install mitmproxy
        goto :error
    )
    echo ✓ mitmproxy 安装成功
) else (
    echo ✓ mitmproxy 已安装
)

echo.
echo [3/6] 创建项目 Python 目录...
if not exist %PYTHON_DIR% (
    mkdir %PYTHON_DIR%
    echo ✓ 创建目录: %PYTHON_DIR%
) else (
    echo ! 目录已存在: %PYTHON_DIR%
    echo   将覆盖现有文件
)

echo.
echo [4/6] 复制 Python 文件...
for %%i in ("%SYSTEM_PYTHON%") do set PYTHON_ROOT=%%~dpi
echo   从: %PYTHON_ROOT%
echo   到: %PYTHON_DIR%\
echo.
echo   正在复制文件，请稍候...

xcopy "%PYTHON_ROOT%*" "%PYTHON_DIR%\" /E /I /Y /Q >nul
if %errorlevel% neq 0 (
    echo ✗ 复制失败
    goto :error
)
echo ✓ 复制完成

echo.
echo [5/6] 检查并安装 mitmproxy...
if exist "%PYTHON_DIR%\Scripts\mitmdump.exe" (
    echo ✓ mitmdump.exe 已存在
) else (
    echo ! mitmdump.exe 不存在，正在安装...
    if exist "%PYTHON_DIR%\Scripts\pip.exe" (
        "%PYTHON_DIR%\Scripts\pip.exe" install mitmproxy
        if %errorlevel% neq 0 (
            echo ✗ 安装失败
            goto :error
        )
        echo ✓ mitmproxy 安装成功
    ) else (
        echo ✗ pip.exe 不存在，无法安装 mitmproxy
        goto :error
    )
)

echo.
echo [6/6] 验证环境...
echo.
echo Python 版本:
"%PYTHON_DIR%\python.exe" --version
echo.
echo Mitmdump 版本:
"%PYTHON_DIR%\Scripts\mitmdump.exe" --version

echo.
echo ===============================================
echo   ✓ 配置完成！
echo ===============================================
echo.
echo 环境已配置完成，现在可以:
echo.
echo 1. 运行环境检查:
echo    check-python.bat
echo.
echo 2. 启动应用:
echo    npm start
echo.
echo 3. 或运行打包后的 exe 文件
echo.
pause
exit /b 0

:error
echo.
echo ===============================================
echo   ✗ 配置失败
echo ===============================================
echo.
echo 请查看详细配置指南:
echo Python嵌入式环境配置指南.txt
echo.
echo 或手动配置:
echo 1. 确保已安装 Python 3.11+
echo 2. 安装 mitmproxy: pip install mitmproxy
echo 3. 将 Python 目录复制到: resources\python-embed\
echo.
pause
exit /b 1

