@echo off
REM ============================================
REM Expression Evaluator REPL Launcher
REM ============================================

echo.
echo ============================================
echo   Starting Expression Evaluator REPL
echo ============================================
echo.

REM Check if executable exists
if not exist ExprREPL.exe (
    echo ERROR: ExprREPL.exe not found!
    echo.
    echo Please compile the project first:
    echo   dcc32 ExprREPL.dpr
    echo.
    pause
    exit /b 1
)

REM Run REPL
ExprREPL.exe

echo.
echo REPL closed.
echo.
