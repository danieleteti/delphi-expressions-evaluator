// ***************************************************************************
//
// REPL Command Processor Module
// Handles command recognition and dispatch
//
// Copyright (c) 2024-2025 Daniele Teti (www.danieleteti.it)
// https://github.com/danieleteti/delphi-expressions-evaluator
//
// Licensed under the Apache License, Version 2.0
//
// ***************************************************************************

unit REPL.Commands;

interface

uses
  System.SysUtils,
  System.Generics.Collections;

type
  /// <summary>
  /// Command types supported by REPL
  /// </summary>
  TCommandType = (
    ctNone,          // Not a command, evaluate as expression
    ctHelp,          // Show help
    ctVars,          // Show variables
    ctFuncs,         // Show functions
    ctHistory,       // Show history
    ctClear,         // Clear screen
    ctExit           // Exit REPL
  );

  /// <summary>
  /// Command parser and recognizer
  /// </summary>
  TCommandProcessor = class
  private
    FCommandMap: TDictionary<string, TCommandType>;
    procedure InitializeCommands;
  public
    constructor Create;
    destructor Destroy; override;
    function ParseCommand(const Input: string): TCommandType;
    function IsCommand(const Input: string): Boolean;
  end;

implementation

{ TCommandProcessor }

constructor TCommandProcessor.Create;
begin
  inherited;
  FCommandMap := TDictionary<string, TCommandType>.Create;
  InitializeCommands;
end;

destructor TCommandProcessor.Destroy;
begin
  FCommandMap.Free;
  inherited;
end;

procedure TCommandProcessor.InitializeCommands;
begin
  FCommandMap.Add('help', ctHelp);
  FCommandMap.Add('vars', ctVars);
  FCommandMap.Add('funcs', ctFuncs);
  FCommandMap.Add('functions', ctFuncs);
  FCommandMap.Add('history', ctHistory);
  FCommandMap.Add('clear', ctClear);
  FCommandMap.Add('cls', ctClear);
  FCommandMap.Add('exit', ctExit);
  FCommandMap.Add('quit', ctExit);
end;

function TCommandProcessor.ParseCommand(const Input: string): TCommandType;
var
  Cmd: string;
begin
  Cmd := LowerCase(Trim(Input));

  if Cmd = '' then
    Exit(ctNone);

  if not FCommandMap.TryGetValue(Cmd, Result) then
    Result := ctNone;
end;

function TCommandProcessor.IsCommand(const Input: string): Boolean;
begin
  Result := ParseCommand(Input) <> ctNone;
end;

end.
