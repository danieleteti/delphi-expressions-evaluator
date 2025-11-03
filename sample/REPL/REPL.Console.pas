// ***************************************************************************
//
// REPL Console Output Module
// Handles all console I/O operations
//
// Copyright (c) 2024-2025 Daniele Teti (www.danieleteti.it)
// https://github.com/danieleteti/delphi-expressions-evaluator
//
// Licensed under the Apache License, Version 2.0
//
// ***************************************************************************

unit REPL.Console;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Generics.Collections;

type
  /// <summary>
  /// ANSI color codes for cross-platform color support
  /// </summary>
  TConsoleColor = (
    ccDefault,
    ccBlack,
    ccRed,
    ccGreen,
    ccYellow,
    ccBlue,
    ccMagenta,
    ccCyan,
    ccWhite,
    ccBrightRed,
    ccBrightGreen,
    ccBrightYellow,
    ccBrightBlue,
    ccBrightMagenta,
    ccBrightCyan,
    ccBrightWhite
  );

  /// <summary>
  /// Console output manager for REPL
  /// </summary>
  TConsoleManager = class
  private
    const
      PROMPT = '>>> ';
      SEPARATOR = '------------------';
    procedure SetColor(Color: TConsoleColor);
    procedure ResetColor;
    procedure ColorWrite(const Text: string; Color: TConsoleColor);
    procedure ColorWriteln(const Text: string; Color: TConsoleColor);
  public
    procedure ShowWelcome;
    procedure ShowHelp;
    procedure ShowVariables(const Variables: TDictionary<string, Variant>);
    procedure ShowFunctions;
    procedure ShowHistory(const History: TList<string>);
    procedure ShowResult(const Value: Variant);
    procedure ShowError(const ErrorMsg: string);
    procedure ClearScreen;
    function ReadInput: string;
  end;

implementation

{ TConsoleManager }

procedure TConsoleManager.SetColor(Color: TConsoleColor);
const
  ANSI_COLORS: array[TConsoleColor] of string = (
    #27'[0m',     // ccDefault - Reset
    #27'[30m',    // ccBlack
    #27'[31m',    // ccRed
    #27'[32m',    // ccGreen
    #27'[33m',    // ccYellow
    #27'[34m',    // ccBlue
    #27'[35m',    // ccMagenta
    #27'[36m',    // ccCyan
    #27'[37m',    // ccWhite
    #27'[91m',    // ccBrightRed
    #27'[92m',    // ccBrightGreen
    #27'[93m',    // ccBrightYellow
    #27'[94m',    // ccBrightBlue
    #27'[95m',    // ccBrightMagenta
    #27'[96m',    // ccBrightCyan
    #27'[97m'     // ccBrightWhite
  );
begin
  Write(ANSI_COLORS[Color]);
end;

procedure TConsoleManager.ResetColor;
begin
  Write(#27'[0m');
end;

procedure TConsoleManager.ColorWrite(const Text: string; Color: TConsoleColor);
begin
  SetColor(Color);
  Write(Text);
  ResetColor;
end;

procedure TConsoleManager.ColorWriteln(const Text: string; Color: TConsoleColor);
begin
  SetColor(Color);
  Writeln(Text);
  ResetColor;
end;

procedure TConsoleManager.ShowWelcome;
begin
  ColorWriteln('==============================================================', ccBrightCyan);
  ColorWriteln('   Delphi Expression Evaluator REPL v1.0', ccBrightYellow);
  ColorWriteln('   Interactive Expression Interpreter', ccBrightWhite);
  ColorWriteln('   Copyright (c) 2024-2025 Daniele Teti', ccCyan);
  ColorWriteln('   www.danieleteti.it', ccCyan);
  ColorWriteln('==============================================================', ccBrightCyan);
  Writeln;
  ColorWrite('Type ', ccWhite);
  ColorWrite('"help"', ccBrightGreen);
  ColorWrite(' for available commands or ', ccWhite);
  ColorWrite('"exit"', ccBrightGreen);
  ColorWriteln(' to quit.', ccWhite);
  Writeln;
end;

procedure TConsoleManager.ShowHelp;
begin
  Writeln;
  ColorWriteln('Available Commands:', ccBrightYellow);
  ColorWriteln(SEPARATOR, ccCyan);
  ColorWrite('  help', ccBrightGreen);
  Writeln('      - Show this help message');
  ColorWrite('  vars', ccBrightGreen);
  Writeln('      - List all defined variables');
  ColorWrite('  funcs', ccBrightGreen);
  Writeln('     - List all available functions');
  ColorWrite('  history', ccBrightGreen);
  Writeln('   - Show command history');
  ColorWrite('  clear', ccBrightGreen);
  Writeln('     - Clear the screen');
  ColorWrite('  exit', ccBrightGreen);
  Writeln('      - Exit the REPL');
  Writeln;

  ColorWriteln('Operators:', ccBrightYellow);
  ColorWriteln(SEPARATOR, ccCyan);
  Writeln('  Arithmetic: +, -, *, /, div, mod, ^');
  Writeln('  Comparison: =, <>, <, <=, >, >=');
  Writeln('  Logical:    and, or, xor');
  Writeln('  Assignment: :=  (e.g., x := 42)');
  Writeln;

  ColorWriteln('Mathematical Functions:', ccBrightYellow);
  ColorWriteln(SEPARATOR, ccCyan);
  Writeln('  sqrt(x)           - Square root');
  Writeln('  log(x)            - Logarithm base 10');
  Writeln('  logn(x)           - Natural logarithm');
  Writeln('  round(x, digits)  - Round to specified digits');
  Writeln('  Min(x, y, ...)    - Minimum value (2+ args)');
  Writeln('  Max(x, y, ...)    - Maximum value (2+ args)');
  Writeln;

  ColorWriteln('String Functions:', ccBrightYellow);
  ColorWriteln(SEPARATOR, ccCyan);
  Writeln('  ToString(x)              - Convert to string');
  Writeln('  ToInteger(s)             - Convert string to integer');
  Writeln('  ToFloat(s)               - Convert string to float');
  Writeln('  contains(needle, hay)    - Check if string contains substring');
  Writeln('  Length(s)                - String length');
  Writeln('  Upper(s), Lower(s)       - Case conversion');
  Writeln('  Trim(s)                  - Remove whitespace');
  Writeln('  Left(s,n), Right(s,n)    - Extract characters');
  Writeln('  Substr(s,pos,len)        - Extract substring');
  Writeln('  IndexOf(s, sub)          - Find substring position');
  Writeln('  Replace(s, old, new)     - Replace substring');
  Writeln('  Sort(x, y, ...)          - Sort values (2+ args)');
  Writeln;

  ColorWriteln('Date/Time Functions:', ccBrightYellow);
  ColorWriteln(SEPARATOR, ccCyan);
  Writeln('  Now()                    - Current date and time');
  Writeln('  Today()                  - Current date');
  Writeln('  Year(date), Month(date), Day(date)');
  Writeln('  ParseDate("YYYY-MM-DD")  - Parse date string');
  Writeln('  FormatDate(date, fmt)    - Format date');
  Writeln('  DateAdd(date, days)      - Add days to date');
  Writeln('  DateDiff(date1, date2)   - Difference in days');
  Writeln;

  ColorWriteln('Examples:', ccBrightYellow);
  ColorWriteln(SEPARATOR, ccCyan);
  Writeln('  >>> x := 10');
  Writeln('  >>> y := 20');
  Writeln('  >>> x + y');
  Writeln('  30');
  Writeln;
  Writeln('  >>> name := "World"');
  Writeln('  >>> "Hello, " + name');
  Writeln('  Hello, World');
  Writeln;
  Writeln('  >>> if x > 5 then "big" else "small"');
  Writeln('  big');
  Writeln;
  Writeln('  >>> Min(10, 5, 8, 3)');
  Writeln('  3');
  Writeln;
end;

procedure TConsoleManager.ShowVariables(const Variables: TDictionary<string, Variant>);
var
  Pair: TPair<string, Variant>;
begin
  Writeln;
  if Variables.Count = 0 then
  begin
    ColorWriteln('No variables defined.', ccYellow);
  end
  else
  begin
    ColorWriteln('Defined Variables:', ccBrightYellow);
    ColorWriteln(SEPARATOR, ccCyan);
    for Pair in Variables do
    begin
      ColorWrite('  ' + Pair.Key, ccBrightGreen);
      Write(' = ');
      if VarIsStr(Pair.Value) then
        ColorWriteln('"' + VarToStr(Pair.Value) + '"', ccBrightCyan)
      else
        ColorWriteln(VarToStr(Pair.Value), ccBrightWhite);
    end;
  end;
  Writeln;
end;

procedure TConsoleManager.ShowFunctions;
begin
  Writeln;
  ColorWriteln('Built-in Functions:', ccBrightYellow);
  ColorWriteln(SEPARATOR, ccCyan);
  Writeln;
  ColorWriteln('Mathematical:', ccBrightCyan);
  Writeln('  sqrt, log, logn, round, Min, Max');
  Writeln;
  ColorWriteln('Type Conversion:', ccBrightCyan);
  Writeln('  ToString, ToInteger, ToFloat');
  Writeln;
  ColorWriteln('String Manipulation:', ccBrightCyan);
  Writeln('  contains, Length, Upper, Lower, Trim');
  Writeln('  Left, Right, Substr, IndexOf, Replace, Sort');
  Writeln;
  ColorWriteln('Date/Time:', ccBrightCyan);
  Writeln('  Now, Today, Year, Month, Day');
  Writeln('  ParseDate, FormatDate, DateAdd, DateDiff');
  Writeln;
  ColorWrite('Type ', ccWhite);
  ColorWrite('"help"', ccBrightGreen);
  ColorWriteln(' for detailed information on each function.', ccWhite);
  Writeln;
end;

procedure TConsoleManager.ShowHistory(const History: TList<string>);
var
  I: Integer;
begin
  Writeln;
  if History.Count = 0 then
  begin
    ColorWriteln('No command history.', ccYellow);
  end
  else
  begin
    ColorWriteln('Command History:', ccBrightYellow);
    ColorWriteln(SEPARATOR, ccCyan);
    for I := 0 to History.Count - 1 do
    begin
      ColorWrite('  [' + IntToStr(I + 1) + '] ', ccBrightBlue);
      Writeln(History[I]);
    end;
  end;
  Writeln;
end;

procedure TConsoleManager.ShowResult(const Value: Variant);
begin
  if VarIsStr(Value) then
    ColorWriteln('"' + VarToStr(Value) + '"', ccBrightCyan)
  else if VarIsNumeric(Value) then
    ColorWriteln(VarToStr(Value), ccBrightWhite)
  else if VarType(Value) = varBoolean then
    ColorWriteln(VarToStr(Value), ccBrightYellow)
  else
    Writeln(VarToStr(Value));
end;

procedure TConsoleManager.ShowError(const ErrorMsg: string);
begin
  ColorWrite('Error: ', ccBrightRed);
  ColorWriteln(ErrorMsg, ccRed);
end;

procedure TConsoleManager.ClearScreen;
var
  I: Integer;
begin
  {$IFDEF MSWINDOWS}
  // Windows - simple approach
  for I := 1 to 50 do
    Writeln;
  {$ELSE}
  // Unix-like systems - ANSI escape codes
  Write(#27'[2J'#27'[H');
  {$ENDIF}
end;

function TConsoleManager.ReadInput: string;
begin
  ColorWrite(PROMPT, ccBrightGreen);
  Readln(Result);
  Result := Trim(Result);
end;

end.
