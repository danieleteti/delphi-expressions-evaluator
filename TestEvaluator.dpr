program TestEvaluator;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  System.Variants,
  ExprEvaluator;

procedure TestBasicArithmetic;
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    Assert(Eval.Evaluate('3 + 2') = 5, '3 + 2 should be 5');
    Assert(Eval.Evaluate('3 * (3 + 2)') = 15, '3 * (3 + 2) should be 15');
    Assert(Eval.Evaluate('3 ^ 2') = 9, '3 ^ 2 should be 9');
    Assert(Eval.Evaluate('10 mod 3') = 1, '10 mod 3 should be 1');
    Writeln('Basic arithmetic tests passed.');
  finally
    Eval.Free;
  end;
end;

procedure TestStringConcatenation;
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    Assert(Eval.Evaluate('"Hello" + "World"') = 'HelloWorld', '"Hello" + "World" should be HelloWorld');
    Assert(Eval.Evaluate('"Delphi" + " " + "Rules"') = 'Delphi Rules', '"Delphi" + " " + "Rules" should be "Delphi Rules"');
    Writeln('String concatenation tests passed.');
  finally
    Eval.Free;
  end;
end;

procedure TestVariables;
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    Eval.Evaluate('x := 10');
    Eval.Evaluate('y := 5');
    Assert(Eval.Evaluate('x + y') = 15, 'x + y should be 15');
    Assert(Eval.Evaluate('x * y') = 50, 'x * y should be 50');
    Writeln('Variable tests passed.');
  finally
    Eval.Free;
  end;
end;

procedure TestRelationalOperators;
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    Assert(Eval.Evaluate('5 > 3') = True, '5 > 3 should be True');
    Assert(Eval.Evaluate('x := 10; y := 20; x < y') = True, 'x < y should be True');
    Assert(Eval.Evaluate('x = y') = False, 'x = y should be False');
    Assert(Eval.Evaluate('x <> y') = True, 'x <> y should be True');
    Writeln('Relational operators tests passed.');
  finally
    Eval.Free;
  end;
end;

procedure TestLogicalOperators;
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    Assert(Eval.Evaluate('True and False') = False, 'True and False should be False');
    Assert(Eval.Evaluate('True or False') = True, 'True or False should be True');
    Assert(Eval.Evaluate('True xor False') = True, 'True xor False should be True');
    Writeln('Logical operators tests passed.');
  finally
    Eval.Free;
  end;
end;

procedure TestFunctions;
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    Assert(Eval.Evaluate('sqrt(16)') = 4, 'sqrt(16) should be 4');
    Assert(Abs(Eval.Evaluate('logn(2.71828)') - 1) < 0.01, 'logn(2.71828) should be ~1');
    Assert(Eval.Evaluate('log(100)') = 2, 'log(100) should be 2');
    Assert(Eval.Evaluate('ToString(42)') = '42', 'ToString(42) should be "42"');
    Writeln('Function tests passed.');
  finally
    Eval.Free;
  end;
end;

procedure TestIfThenElse;
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    Assert(Eval.Evaluate('if 3 > 2 then "Yes" else "No"') = 'Yes', 'if 3 > 2 then "Yes" else "No" should be "Yes"');
    Assert(Eval.Evaluate('if 1 > 2 then "A" else if 2 > 1 then "B" else "C"') = 'B', 'Nested if should return "B"');
    Writeln('If-Then-Else tests passed.');
  finally
    Eval.Free;
  end;
end;

procedure TestCustomFunction;
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    Eval.RegisterFunction('cube', function(const Args: array of Variant): Variant
      begin
        if Length(Args) <> 1 then
          raise Exception.Create('cube requires 1 argument');
        Result := System.Math.Power(Args[0], 3);
      end);

    Assert(Eval.Evaluate('cube(3)') = 27, 'cube(3) should be 27');
    Writeln('Custom function tests passed.');
  finally
    Eval.Free;
  end;
end;

procedure TestMultipleExpressions;
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    Assert(Eval.Evaluate('a := 5; b := 10; a + b') = 15, 'a := 5; b := 10; a + b should be 15');
    Assert(Eval.Evaluate('x := if 10 > 5 then 1 else 0; x') = 1, 'x := if 10 > 5 then 1 else 0; x should be 1');
    Writeln('Multiple expressions tests passed.');
  finally
    Eval.Free;
  end;
end;

begin
  try
    TestBasicArithmetic;
    TestStringConcatenation;
    TestVariables;
    TestRelationalOperators;
    TestLogicalOperators;
    TestFunctions;
    TestIfThenElse;
    TestCustomFunction;
    TestMultipleExpressions;

    Writeln('All tests passed!');
  except
    on E: Exception do
      Writeln('Test failed: ', E.Message);
  end;
  Readln;
end.
