@echo off
chcp 65001 >nul
echo ===============================================
echo   检查 Python 嵌入式环境
echo ===============================================
echo.

echo [1/4] 检查 Python 解释器...
if exist "resources\python-embed\python.exe" (
    echo ✓ python.exe 存在
    resources\python-embed\python.exe --version
) else (
    echo ✗ python.exe 不存在
    echo    路径: resources\python-embed\python.exe
    goto :error
)

echo.
echo [2/4] 检查 pip...
if exist "resources\python-embed\Scripts\pip.exe" (
    echo ✓ pip.exe 存在
    resources\python-embed\Scripts\pip.exe --version
) else (
    echo ! pip.exe 不存在（不影响运行，但无法安装新包）
)

echo.
echo [3/4] 检查 mitmdump...
if exist "resources\python-embed\Scripts\mitmdump.exe" (
    echo ✓ mitmdump.exe 存在
    resources\python-embed\Scripts\mitmdump.exe --version
) else (
    echo ✗ mitmdump.exe 不存在
    echo    路径: resources\python-embed\Scripts\mitmdump.exe
    goto :error
)

echo.
echo [4/4] 检查后端脚本...
if exist "backend\gateway\warp_gateway_pro.py" (
    echo ✓ warp_gateway_pro.py 存在
) else (
    echo ✗ warp_gateway_pro.py 不存在
    echo    路径: backend\gateway\warp_gateway_pro.py
    goto :error
)

echo.
echo ===============================================
echo   ✓ 环境检查通过，可以正常使用！
echo ===============================================
echo.
echo 提示：
echo - 可以启动应用: npm start
echo - 或运行打包后的 exe 文件
echo.
pause
exit /b 0

:error
echo.
echo ===============================================
echo   ✗ 环境检查失败
echo ===============================================
echo.
echo 请按照以下步骤配置环境:
echo.
echo 1. 查看配置指南:
echo    Python嵌入式环境配置指南.txt
echo.
echo 2. 或运行自动配置脚本:
echo    setup-python-env.bat
echo.
pause
exit /b 1

