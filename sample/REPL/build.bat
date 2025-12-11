@echo off
REM ============================================
REM Expression Evaluator REPL Build Script
REM ============================================

echo.
echo ============================================
echo   Building Expression Evaluator REPL
echo ============================================
echo.

REM Clean previous build
echo Cleaning previous build...
if exist *.dcu del *.dcu
if exist *.exe del *.exe
if exist *.map del *.map
echo Done.
echo.

REM Build project
echo Compiling ExprREPL.dpr...
dcc32 -B ExprREPL.dpr

REM Check if build succeeded
if errorlevel 1 (
    echo.
    echo ============================================
    echo   BUILD FAILED!
    echo ============================================
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================
echo   BUILD SUCCESSFUL!
echo ============================================
echo.
echo Executable created: ExprREPL.exe
echo.
echo Run the REPL with:
echo   run.bat
echo   or
echo   ExprREPL.exe
echo.

pause
