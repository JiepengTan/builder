@echo off
rd /s /q .builds
if not exist .builds mkdir .builds
copy ..\..\..\spx\tutorial\00-Hello\.builds\web\* .builds
del .builds\gdspx.wasm

if not exist .builds mkdir .builds
setlocal

set GOOS=js
set GOARCH=wasm

go build -tags canvas -o .builds/gdspx.wasm main.go

endlocal

:: Kills all python processes
for /f "tokens=2" %%i in ('tasklist ^| findstr python') do taskkill /F /PID %%i
:: Runs your python script

cd .builds
copy ..\runner.html .
copy ..\run.py .
copy ..\test.zip .
copy ..\wasm_exec.js .

:: Check if port is provided as command line argument
if "%~1"=="" (
    set PORT=8005
) else (
    set PORT=%~1
)

start  /B  python run.py -p %PORT%
cd ..
