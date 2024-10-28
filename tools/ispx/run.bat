@echo off
if not exist .builds mkdir .builds
setlocal

set GOOS=js
set GOARCH=wasm

go build -tags canvas -o ./.builds/main.wasm main.go

endlocal

:: Kills all python processes
for /f "tokens=2" %%i in ('tasklist ^| findstr python') do taskkill /F /PID %%i
:: Runs your python script

cd .builds
copy ..\index.html .
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

start  /B  python run.py %PORT%
cd ..
