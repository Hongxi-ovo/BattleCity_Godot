@echo off
setlocal enabledelayedexpansion

rem 遍历编号从4到35
for /L %%i in (4,1,35) do (
    rem 创建文件名
    set "filename=%%i.map"
    
    rem 创建文件并写入内容
    echo [Level] > "!filename!"
    echo MapArr = >> "!filename!"
)

echo 所有文件已创建完成。
