// ***************************************************************************
//
// REPL Engine Module
// Core REPL evaluation and state management
//
// Copyright (c) 2024-2025 Daniele Teti (www.danieleteti.it)
// https://github.com/danieleteti/delphi-expressions-evaluator
//
// Licensed under the Apache License, Version 2.0
//
// ***************************************************************************

unit REPL.Engine;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Generics.Collections,
  ExprEvaluator;

type
  /// <summary>
  /// Result of expression evaluation
  /// </summary>
  TEvalResult = record
    Success: Boolean;
    Value: Variant;
    ErrorMessage: string;
    IsAssignment: Boolean;
    VariableName: string;
  end;

  /// <summary>
  /// REPL evaluation engine
  /// </summary>
  TREPLEngine = class
  private
    FEvaluator: IExprEvaluator;
    FVariables: TDictionary<string, Variant>;
    FHistory: TList<string>;
    function ExtractAssignmentInfo(const Input: string; out VarName: string): Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// Evaluate an expression
    /// </summary>
    function Evaluate(const Expression: string): TEvalResult;

    /// <summary>
    /// Get all defined variables
    /// </summary>
    function GetVariables: TDictionary<string, Variant>;

    /// <summary>
    /// Get command history
    /// </summary>
    function GetHistory: TList<string>;

    /// <summary>
    /// Add expression to history
    /// </summary>
    procedure AddToHistory(const Expression: string);

    /// <summary>
    /// Clear history
    /// </summary>
    procedure ClearHistory;
  end;

implementation

{ TREPLEngine }

constructor TREPLEngine.Create;
begin
  inherited;
  FEvaluator := CreateExprEvaluator;
  FVariables := TDictionary<string, Variant>.Create;
  FHistory := TList<string>.Create;
end;

destructor TREPLEngine.Destroy;
begin
  FHistory.Free;
  FVariables.Free;
  inherited;
end;

function TREPLEngine.ExtractAssignmentInfo(const Input: string; out VarName: string): Boolean;
var
  AssignPos: Integer;
begin
  AssignPos := Pos(':=', Input);
  Result := AssignPos > 0;

  if Result then
  begin
    VarName := UpperCase(Trim(Copy(Input, 1, AssignPos - 1)));
  end;
end;

function TREPLEngine.Evaluate(const Expression: string): TEvalResult;
var
  VarName: string;
begin
  // Initialize result
  Result.Success := False;
  Result.Value := Unassigned;
  Result.ErrorMessage := '';
  Result.IsAssignment := False;
  Result.VariableName := '';

  try
    // Evaluate the expression
    Result.Value := FEvaluator.Evaluate(Expression);
    Result.Success := True;

    // Check if this was an assignment
    Result.IsAssignment := ExtractAssignmentInfo(Expression, VarName);
    if Result.IsAssignment then
    begin
      Result.VariableName := VarName;
      // Store variable for tracking
      FVariables.AddOrSetValue(VarName, Result.Value);
    end;

  except
    on E: Exception do
    begin
      Result.Success := False;
      Result.ErrorMessage := E.Message;
    end;
  end;
end;

function TREPLEngine.GetVariables: TDictionary<string, Variant>;
begin
  Result := FVariables;
end;

function TREPLEngine.GetHistory: TList<string>;
begin
  Result := FHistory;
end;

procedure TREPLEngine.AddToHistory(const Expression: string);
begin
  FHistory.Add(Expression);
end;

procedure TREPLEngine.ClearHistory;
begin
  FHistory.Clear;
end;

end.
