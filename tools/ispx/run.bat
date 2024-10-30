@echo off
:: Check if the export directory exists and delete it if so
if exist .builds\editor rd /s /q .builds\editor
mkdir .builds\editor

:: Copy files from the source directory to the export directory
copy /Y ..\..\..\spx\tutorial\08-CacheMode\.builds\web\* .builds\editor
del /Q .builds\editor\gdspx.wasm

:: Set up environment variables for Go build
setlocal
set GOOS=js
set GOARCH=wasm

:: Build Go project
go build -tags canvas -o .builds\editor\gdspx.wasm main.go
endlocal

:: Kill all Python processes
for /f "tokens=2" %%i in ('tasklist ^| findstr python') do taskkill /F /PID %%i

:: Prepare files and run Python script
cd .builds\editor
copy /Y ..\..\index.html .
copy /Y ..\..\run.py .
copy /Y ..\..\test.zip .

:: Check if port is provided as a command line argument
if "%~1"=="" (
    set PORT=8005
) else (
    set PORT=%~1
)


:: Replace "127.0.0.1:8005" with "127.0.0.1:%PORT%" in index.html using PowerShell
powershell -Command "(Get-Content -Raw -Path 'index.html').Replace('127.0.0.1:8005', '127.0.0.1:%PORT%') | Set-Content -Path 'index.html'"

start /B python run.py -p %PORT%
cd ..
