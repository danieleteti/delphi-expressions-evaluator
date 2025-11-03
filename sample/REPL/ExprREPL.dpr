// ***************************************************************************
//
// Expression Evaluator REPL (Read-Eval-Print Loop)
// Interactive interpreter similar to Python's REPL
//
// Copyright (c) 2024-2025 Daniele Teti (www.danieleteti.it)
//
// https://github.com/danieleteti/delphi-expressions-evaluator
//
// ***************************************************************************
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// ***************************************************************************

program ExprREPL;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  ExprEvaluator in '..\..\ExprEvaluator.pas',
  REPL.Console in 'REPL.Console.pas',
  REPL.Commands in 'REPL.Commands.pas',
  REPL.Engine in 'REPL.Engine.pas';

type
  /// <summary>
  /// Main REPL controller - coordinates all components
  /// </summary>
  TExprREPL = class
  private
    FEngine: TREPLEngine;
    FConsole: TConsoleManager;
    FCommands: TCommandProcessor;
    FRunning: Boolean;
    procedure ProcessCommand(CmdType: TCommandType);
    procedure ProcessExpression(const Expression: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Run;
  end;

{ TExprREPL }

constructor TExprREPL.Create;
begin
  inherited;
  FEngine := TREPLEngine.Create;
  FConsole := TConsoleManager.Create;
  FCommands := TCommandProcessor.Create;
  FRunning := True;
end;

destructor TExprREPL.Destroy;
begin
  FCommands.Free;
  FConsole.Free;
  FEngine.Free;
  inherited;
end;

procedure TExprREPL.ProcessCommand(CmdType: TCommandType);
begin
  case CmdType of
    ctHelp:
      FConsole.ShowHelp;

    ctVars:
      FConsole.ShowVariables(FEngine.GetVariables);

    ctFuncs:
      FConsole.ShowFunctions;

    ctHistory:
      FConsole.ShowHistory(FEngine.GetHistory);

    ctClear:
      begin
        FConsole.ClearScreen;
        FConsole.ShowWelcome;
      end;

    ctExit:
      begin
        FRunning := False;
        Writeln('Goodbye!');
      end;
  end;
end;

procedure TExprREPL.ProcessExpression(const Expression: string);
var
  EvalResult: TEvalResult;
begin
  // Add to history
  FEngine.AddToHistory(Expression);

  // Evaluate
  EvalResult := FEngine.Evaluate(Expression);

  // Show result
  if EvalResult.Success then
    FConsole.ShowResult(EvalResult.Value)
  else
    FConsole.ShowError(EvalResult.ErrorMessage);
end;

procedure TExprREPL.Run;
var
  Input: string;
  CmdType: TCommandType;
begin
  FConsole.ShowWelcome;

  while FRunning do
  begin
    // Read input
    Input := FConsole.ReadInput;

    // Skip empty input
    if Input = '' then
      Continue;

    // Check if it's a command
    CmdType := FCommands.ParseCommand(Input);

    if CmdType <> ctNone then
      ProcessCommand(CmdType)
    else
      ProcessExpression(Input);
  end;
end;

var
  REPL: TExprREPL;

begin
  try
    REPL := TExprREPL.Create;
    try
      REPL.Run;
    finally
      REPL.Free;
    end;
  except
    on E: Exception do
      Writeln('Fatal Error: ', E.ClassName, ': ', E.Message);
  end;
end.
