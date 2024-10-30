@echo off
:: Check if the export directory exists and delete it if so
if exist .builds\export rd /s /q .builds\export
mkdir .builds\export

:: Copy files from the source directory to the export directory
copy /Y ..\..\..\spx\tutorial\05-Animation\.builds\web\* .builds\export
del /Q .builds\export\gdspx.wasm

:: Set up environment variables for Go build
setlocal
set GOOS=js
set GOARCH=wasm

:: Build Go project
go build -tags canvas -o .builds\export\gdspx.wasm main.go
endlocal

:: Kill all Python processes
for /f "tokens=2" %%i in ('tasklist ^| findstr python') do taskkill /F /PID %%i

:: Prepare files and run Python script
cd .builds\export
copy /Y ..\..\index.html .
copy /Y ..\..\run.py .
copy /Y ..\..\test.zip .

:: Check if port is provided as a command line argument
if "%~1"=="" (
    set PORT=8005
) else (
    set PORT=%~1
)

start /B python run.py -p %PORT%
cd ..
