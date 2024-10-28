
call build.bat
@echo off
:: Kills all python processes
for /f "tokens=2" %%i in ('tasklist ^| findstr python') do taskkill /F /PID %%i
:: Runs your python script
start  /B  python run.py