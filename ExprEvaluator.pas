unit ExprEvaluator;

interface

uses
  System.SysUtils, System.Variants, System.Math, System.Generics.Collections;

type
  TFuncHandler = reference to function(const Args: array of Variant): Variant;

  TExprEvaluator = class
  private
    FFunctions: TDictionary<string, TFuncHandler>;
    FVariables: TDictionary<string, Variant>;
    FInput: string;
    FPos: Integer;

    function ParseExpression: Variant;
    function ParseIfExpression: Variant;
    function ParseLogical: Variant;
    function ParseRelational: Variant;
    function ParseAdditive: Variant;
    function ParseMultiplicative: Variant;
    function ParseFactor: Variant;
    function ParsePrimary: Variant;
    function ParseString: string;
    function CurrentChar: Char;
    procedure NextChar;
    procedure SkipWhitespace;
    function IsDigit(c: Char): Boolean;
    function IsAlpha(c: Char): Boolean;
    function ParseNumber: string;
    function ParseIdentifier: string;
    function CallFunction(const FuncName: string; Args: TArray<Variant>): Variant;
    function GetVariable(const VarName: string): Variant;
    procedure SetVariable(const VarName: string; Value: Variant);
    function ParseAssignment: Variant;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterFunction(const Name: string; Handler: TFuncHandler);
    function Evaluate(const Expr: string): Variant;
    procedure SetVar(const Name: string; Value: Variant);
    function GetVar(const Name: string): Variant;
  end;

implementation

{ TExprEvaluator }

constructor TExprEvaluator.Create;
begin
  inherited;
  FFunctions := TDictionary<string, TFuncHandler>.Create;
  FVariables := TDictionary<string, Variant>.Create;

  // Register standard functions
  RegisterFunction('sqrt', function(const Args: array of Variant): Variant
    begin
      if Length(Args) <> 1 then
        raise Exception.Create('sqrt requires 1 argument');
      Result := Sqrt(Args[0]);
    end);

  RegisterFunction('logn', function(const Args: array of Variant): Variant
    begin
      if Length(Args) <> 1 then
        raise Exception.Create('logn requires 1 argument');
      Result := Ln(Args[0]);
    end);

  RegisterFunction('log', function(const Args: array of Variant): Variant
    begin
      if Length(Args) <> 1 then
        raise Exception.Create('log requires 1 argument');
      Result := System.Math.Log10(Args[0]);
    end);

  RegisterFunction('ToString', function(const Args: array of Variant): Variant
    begin
      if Length(Args) <> 1 then
        raise Exception.Create('ToString requires 1 argument');
      Result := VarToStr(Args[0]);
    end);
end;

destructor TExprEvaluator.Destroy;
begin
  FFunctions.Free;
  FVariables.Free;
  inherited;
end;

procedure TExprEvaluator.RegisterFunction(const Name: string; Handler: TFuncHandler);
begin
  FFunctions.AddOrSetValue(UpperCase(Name), Handler);
end;

function TExprEvaluator.Evaluate(const Expr: string): Variant;
var
  Exprs: TArray<string>;
  I: Integer;
  OldInput: string;
  OldPos: Integer;
begin
  // Salviamo lo stato attuale
  OldInput := FInput;
  OldPos := FPos;

  // Split by semicolon to support multiple expressions
  Exprs := Expr.Split([';']);
  Result := Unassigned;
  for I := 0 to High(Exprs) do
  begin
    FInput := Trim(Exprs[I]);
    FPos := 1;
    Result := ParseAssignment;
  end;

  // Ripristiniamo lo stato originale
  FInput := OldInput;
  FPos := OldPos;
end;

function TExprEvaluator.ParseAssignment: Variant;
var
  Id: string;
  OldPos: Integer;
begin
  SkipWhitespace;
  if IsAlpha(CurrentChar) then
  begin
    OldPos := FPos;
    Id := ParseIdentifier;
    SkipWhitespace;
    if Copy(FInput, FPos, 2) = ':=' then
    begin
      Inc(FPos, 2); // skip :=
      SkipWhitespace;
      Result := ParseExpression;
      SetVariable(Id, Result);
    end
    else
    begin
      FPos := OldPos; // proper backtrack
      Result := ParseIfExpression;
    end;
  end
  else
    Result := ParseIfExpression;
end;

function TExprEvaluator.ParseIfExpression: Variant;
var
  Condition, ThenValue, ElseValue: Variant;
  IfWord: string;
  OldPos: Integer;
begin
  SkipWhitespace;
  if FPos > Length(FInput) then
  begin
    Result := ParseLogical;
    Exit;
  end;

  // Check if this looks like an IF statement
  if not IsAlpha(CurrentChar) then
  begin
    Result := ParseLogical;
    Exit;
  end;

  OldPos := FPos;
  IfWord := ParseIdentifier;
  if IfWord <> 'IF' then
  begin
    FPos := OldPos; // proper backtrack
    Result := ParseLogical;
    Exit;
  end;

  Condition := ParseLogical;

  SkipWhitespace;
  if ParseIdentifier <> 'THEN' then
    raise Exception.Create('Expected THEN after IF condition');

  ThenValue := ParseIfExpression;

  SkipWhitespace;
  if ParseIdentifier <> 'ELSE' then
    raise Exception.Create('Expected ELSE after THEN');

  ElseValue := ParseIfExpression;

  if Condition then
    Result := ThenValue
  else
    Result := ElseValue;
end;

function TExprEvaluator.CurrentChar: Char;
begin
  if FPos <= Length(FInput) then
    Result := FInput[FPos]
  else
    Result := #0;
end;

procedure TExprEvaluator.NextChar;
begin
  Inc(FPos);
end;

procedure TExprEvaluator.SkipWhitespace;
begin
  while (FPos <= Length(FInput)) and (CharInSet(FInput[FPos], [' ', #9, #10, #13])) do
    Inc(FPos);
end;

function TExprEvaluator.IsDigit(c: Char): Boolean;
begin
  Result := CharInSet(c, ['0'..'9']);
end;

function TExprEvaluator.IsAlpha(c: Char): Boolean;
begin
  Result := CharInSet(c, ['a'..'z', 'A'..'Z', '_']);
end;

function TExprEvaluator.ParseNumber: string;
var
  Start: Integer;
begin
  Start := FPos;
  while (FPos <= Length(FInput)) and (IsDigit(CurrentChar) or (CurrentChar = '.')) do
    NextChar;
  Result := Copy(FInput, Start, FPos - Start);
end;

function TExprEvaluator.ParseIdentifier: string;
var
  Start: Integer;
begin
  Start := FPos;
  while (FPos <= Length(FInput)) and (IsAlpha(CurrentChar) or IsDigit(CurrentChar)) do
    NextChar;
  Result := UpperCase(Copy(FInput, Start, FPos - Start));
end;

function TExprEvaluator.ParseString: string;
var
  Start: Integer;
begin
  NextChar; // skip opening "
  Start := FPos;
  while (FPos <= Length(FInput)) and (CurrentChar <> '"') do
    NextChar;
  if CurrentChar <> '"' then
    raise Exception.Create('Unterminated string');
  Result := Copy(FInput, Start, FPos - Start);
  NextChar; // skip closing "
end;

function TExprEvaluator.ParsePrimary: Variant;
var
  NumStr: string;
  Id: string;
  Args: TArray<Variant>;
begin
  SkipWhitespace;

  if FPos > Length(FInput) then
  begin
    Result := Unassigned;
    Exit;
  end;

  if CurrentChar = '(' then
  begin
    NextChar; // skip '('
    Result := ParseExpression;
    SkipWhitespace;
    if CurrentChar <> ')' then
      raise Exception.Create('Unclosed parenthesis');
    NextChar; // skip ')'
  end
  else if CurrentChar = '"' then
  begin
    Result := ParseString;
  end
  else if IsDigit(CurrentChar) then
  begin
    NumStr := ParseNumber;
    Result := StrToFloat(NumStr, TFormatSettings.Create('en-US'));
  end
  else if IsAlpha(CurrentChar) then
  begin
    Id := ParseIdentifier;
    SkipWhitespace;
    if CurrentChar = '(' then
    begin
      NextChar; // skip '('
      SetLength(Args, 0);
      if CurrentChar <> ')' then
      begin
        repeat
          SetLength(Args, Length(Args) + 1);
          Args[High(Args)] := ParseExpression;
          SkipWhitespace;
          if CurrentChar = ',' then
          begin
            NextChar;
            SkipWhitespace;
          end
          else
            Break;
        until False;
      end;
      if CurrentChar <> ')' then
        raise Exception.Create('Unclosed parenthesis in function call');
      NextChar; // skip ')'
      Result := CallFunction(Id, Args);
    end
    else
    begin
      Result := GetVariable(Id);
    end;
  end
  else
    raise Exception.Create('Unexpected character: ' + QuotedStr(CurrentChar));
end;

function TExprEvaluator.ParseFactor: Variant;
var
  Left: Variant;
  Right: Variant;
begin
  Left := ParsePrimary;
  if VarIsEmpty(Left) or VarIsNull(Left) then
    raise Exception.Create('Expected expression');

  SkipWhitespace;
  while CurrentChar = '^' do
  begin
    NextChar; // skip ^
    Right := ParsePrimary;
    if VarIsEmpty(Right) or VarIsNull(Right) then
      raise Exception.Create('Expected expression after ^');

    Left := System.Math.Power(Left, Right);
    SkipWhitespace;
  end;
  Result := Left;
end;

function TExprEvaluator.ParseMultiplicative: Variant;
var
  Left: Variant;
  Op: Char;
  Right: Variant;
begin
  Left := ParseFactor;
  SkipWhitespace;

  while CharInSet(CurrentChar, ['*', '/', 'm', 'M']) do
  begin
    if CharInSet(CurrentChar, ['m', 'M']) then
    begin
      if (UpperCase(Copy(FInput, FPos, 3)) = 'MOD') and
         ((FPos + 3 > Length(FInput)) or not (IsAlpha(FInput[FPos + 3]) or IsDigit(FInput[FPos + 3]))) then
      begin
        Inc(FPos, 3);
        SkipWhitespace;
        Right := ParseFactor;
        Left := Trunc(Left) mod Trunc(Right);
      end
      else
        Break;
    end
    else
    begin
      Op := CurrentChar;
      NextChar;
      Right := ParseFactor;

      case Op of
        '*': Left := Left * Right;
        '/': Left := Left / Right;
      end;
    end;
    SkipWhitespace;
  end;

  Result := Left;
end;

function TExprEvaluator.ParseAdditive: Variant;
var
  Left: Variant;
  Op: Char;
  Right: Variant;
begin
  Left := ParseMultiplicative;
  SkipWhitespace;

  while CharInSet(CurrentChar, ['+', '-']) do
  begin
    Op := CurrentChar;
    NextChar;
    Right := ParseMultiplicative;

    case Op of
      '+':
        begin
          if VarIsStr(Left) or VarIsStr(Right) then
            Left := VarToStr(Left) + VarToStr(Right)
          else
            Left := Left + Right;
        end;
      '-': Left := Left - Right;
    end;
    SkipWhitespace;
  end;

  Result := Left;
end;

function TExprEvaluator.ParseRelational: Variant;
var
  Left: Variant;
  Right: Variant;
begin
  Left := ParseAdditive;
  SkipWhitespace;

  if CharInSet(CurrentChar, ['<', '>', '=']) then
  begin
    if CurrentChar = '=' then
    begin
      NextChar;
      Right := ParseAdditive;
      Result := Left = Right;
    end
    else if CurrentChar = '<' then
    begin
      NextChar;
      if CurrentChar = '>' then
      begin
        NextChar;
        Right := ParseAdditive;
        Result := Left <> Right;
      end
      else if CurrentChar = '=' then
      begin
        NextChar;
        Right := ParseAdditive;
        Result := Left <= Right;
      end
      else
      begin
        Right := ParseAdditive;
        Result := Left < Right;
      end;
    end
    else if CurrentChar = '>' then
    begin
      NextChar;
      if CurrentChar = '=' then
      begin
        NextChar;
        Right := ParseAdditive;
        Result := Left >= Right;
      end
      else
      begin
        Right := ParseAdditive;
        Result := Left > Right;
      end;
    end;
  end
  else
    Result := Left;
end;

function TExprEvaluator.ParseExpression: Variant;
begin
  Result := ParseIfExpression;
end;

function TExprEvaluator.ParseLogical: Variant;
var
  Left: Variant;
  Right: Variant;
begin
  Left := ParseRelational;
  SkipWhitespace;

  while True do
  begin
    if (UpperCase(Copy(FInput, FPos, 3)) = 'AND') and 
       ((FPos + 3 > Length(FInput)) or not (IsAlpha(FInput[FPos + 3]) or IsDigit(FInput[FPos + 3]))) then
    begin
      Inc(FPos, 3);
      SkipWhitespace;
      Right := ParseRelational;
      Left := Left and Right;
      SkipWhitespace;
    end
    else if (UpperCase(Copy(FInput, FPos, 2)) = 'OR') and
            ((FPos + 2 > Length(FInput)) or not (IsAlpha(FInput[FPos + 2]) or IsDigit(FInput[FPos + 2]))) then
    begin
      Inc(FPos, 2);
      SkipWhitespace;
      Right := ParseRelational;
      Left := Left or Right;
      SkipWhitespace;
    end
    else if (UpperCase(Copy(FInput, FPos, 3)) = 'XOR') and
            ((FPos + 3 > Length(FInput)) or not (IsAlpha(FInput[FPos + 3]) or IsDigit(FInput[FPos + 3]))) then
    begin
      Inc(FPos, 3);
      SkipWhitespace;
      Right := ParseRelational;
      Left := Left xor Right;
      SkipWhitespace;
    end
    else
      Break;
  end;

  Result := Left;
end;

function TExprEvaluator.CallFunction(const FuncName: string; Args: TArray<Variant>): Variant;
var
  Handler: TFuncHandler;
begin
  if not FFunctions.TryGetValue(FuncName, Handler) then
    raise Exception.Create('Unknown function: ' + FuncName);
  Result := Handler(Args);
end;

function TExprEvaluator.GetVariable(const VarName: string): Variant;
var
  UpName: string;
begin
  UpName := UpperCase(VarName);
  if UpName = 'TRUE' then
    Result := True
  else if UpName = 'FALSE' then
    Result := False
  else if (UpName = 'IF') or (UpName = 'THEN') or (UpName = 'ELSE') or 
          (UpName = 'AND') or (UpName = 'OR') or (UpName = 'XOR') or (UpName = 'MOD') then
    raise Exception.Create('Unexpected use of keyword: ' + VarName)
  else if not FVariables.TryGetValue(UpName, Result) then
    raise Exception.Create('Unknown variable: ' + VarName);
end;

procedure TExprEvaluator.SetVariable(const VarName: string; Value: Variant);
begin
  FVariables.AddOrSetValue(UpperCase(VarName), Value);
end;

procedure TExprEvaluator.SetVar(const Name: string; Value: Variant);
begin
  SetVariable(Name, Value);
end;

function TExprEvaluator.GetVar(const Name: string): Variant;
begin
  Result := GetVariable(Name);
end;

end.
