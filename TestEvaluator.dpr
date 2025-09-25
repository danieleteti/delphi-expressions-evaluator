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
    Assert(Eval.Evaluate('ToInteger("123")') = 123, 'ToInteger("123") should be 123');
    Assert(Eval.Evaluate('ToFloat("123.45")') = 123.45, 'ToFloat("123.45") should be 123.45');
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

procedure TestIfThenElsePrecedence;
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    // Test that arithmetic operations have higher precedence than if-then-else
    // This should be parsed as: if (2 + 3) > 4 then (10 * 2) else (5 + 1)
    Assert(Eval.Evaluate('if 2 + 3 > 4 then 10 * 2 else 5 + 1') = 20, 'if 2 + 3 > 4 then 10 * 2 else 5 + 1 should be 20');

    // Test that logical operations have higher precedence than if-then-else
    // This should be parsed as: if (true and false) then 1 else (2 + 3)
    Assert(Eval.Evaluate('if true and false then 1 else 2 + 3') = 5, 'if true and false then 1 else 2 + 3 should be 5');

    // Test that relational operations have higher precedence than if-then-else
    // This should be parsed as: if (5 > 3) and (2 < 4) then (1 + 1) else 0
    Assert(Eval.Evaluate('if 5 > 3 and 2 < 4 then 1 + 1 else 0') = 2, 'if 5 > 3 and 2 < 4 then 1 + 1 else 0 should be 2');

    // Test nested if-then-else with operators
    // This should be parsed as: if (10 / 2) = 5 then (if (3 * 2) > 5 then 100 else 50) else 0
    Assert(Eval.Evaluate('if 10 / 2 = 5 then if 3 * 2 > 5 then 100 else 50 else 0') = 100, 'Nested if with operators should be 100');

    Writeln('If-Then-Else precedence tests passed.');
  finally
    Eval.Free;
  end;
end;

procedure TestAdvancedCombinations;
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    // Test 1: String conversion with arithmetic and conditionals
    // Convert number to string, concatenate, then convert back and do math
    Assert(Eval.Evaluate('ToInteger(ToString(15) + "5") + 10') = 165, 'String conversion with arithmetic should work');

    // Test 2: Complex conditional with conversions and multiple operators
    // if ToFloat("12.5") > 10 and ToInteger("5") < 10 then sqrt(ToFloat("16.0")) else log(100)
    Assert(Eval.Evaluate('if ToFloat("12.5") > 10 and ToInteger("5") < 10 then sqrt(ToFloat("16.0")) else log(100)') = 4, 'Complex conditional with conversions should return 4');

    // Test 3: Nested functions with conversions and variables
    Eval.Evaluate('x := ToFloat("3.14159"); radius := ToInteger("5")');
    Assert(Abs(Eval.Evaluate('x * radius ^ 2') - 78.53975) < 0.01, 'Pi * r^2 calculation with conversions should work');

    // Test 4: String concatenation with converted numbers and conditionals
    Assert(Eval.Evaluate('"Result: " + ToString(if ToInteger("10") > 5 then 42 else 0)') = 'Result: 42', 'String concatenation with conditional conversion should work');

    // Test 5: Complex logical expression with conversions
    // (ToInteger("1") = 1 and ToFloat("2.0") = 2.0) or (ToString(3) = "3" and false)
    Assert(Eval.Evaluate('(ToInteger("1") = 1 and ToFloat("2.0") = 2.0) or (ToString(3) = "3" and false)') = True, 'Complex logical with conversions should be true');

    // Test 6: Mathematical operations with mixed conversions
    // sqrt(ToFloat("9.0")) + ToInteger("7") * 2 - ToFloat("1.5")
    Assert(Eval.Evaluate('sqrt(ToFloat("9.0")) + ToInteger("7") * 2 - ToFloat("1.5")') = 15.5, 'Mixed mathematical operations with conversions should work');

    // Test 7: Nested if-then-else with conversions and custom functions
    Eval.RegisterFunction('double', function(const Args: array of Variant): Variant
      begin
        if Length(Args) <> 1 then
          raise Exception.Create('double requires 1 argument');
        Result := Args[0] * 2;
      end);

    Assert(Eval.Evaluate('if ToInteger("20") >= 20 then double(ToFloat("7.5")) else ToFloat("0.0")') = 15, 'Nested conditionals with custom functions and conversions should work');

    // Test 8: Complex assignment with multiple conversions and operations
    // temp := if ToFloat("100.0") > 50 then ToString(ToInteger("25") + 5) else "0"; ToInteger(temp) * 2
    Assert(Eval.Evaluate('temp := if ToFloat("100.0") > 50 then ToString(ToInteger("25") + 5) else "0"; ToInteger(temp) * 2') = 60, 'Complex assignment with conversions should work');

    // Test 9: String operations with numeric conversions and conditionals
    // Test string comparison with converted numbers
    Assert(Eval.Evaluate('ToString(ToInteger("42")) = "42" and ToFloat("3.14") > ToInteger("3")') = True, 'String comparison with conversions should work');

    // Test 10: Advanced mathematical expression with all function types
    // logn(sqrt(ToFloat("2.71828") ^ ToInteger("2"))) + log(ToFloat("100.0")) - ToInteger("1")
    Assert(Abs(Eval.Evaluate('logn(sqrt(ToFloat("2.71828") ^ ToInteger("2"))) + log(ToFloat("100.0")) - ToInteger("1")') - 2) < 0.1, 'Advanced math with conversions should work');

    // Test 11: Multiple variable assignments with conversions and operations
    Eval.Evaluate('a := ToInteger("10"); b := ToFloat("3.5"); c := ToString(25)');
    Assert(Eval.Evaluate('if a > 5 and b < 4.0 then ToInteger(c) + a else 0') = 35, 'Multiple variables with conversions should work');

    // Test 12: Complex precedence test with all operators and conversions
    // ToInteger("2") + ToInteger("3") * ToInteger("4") > ToFloat("10.0") and ToString(1) = "1"
    Assert(Eval.Evaluate('ToInteger("2") + ToInteger("3") * ToInteger("4") > ToFloat("10.0") and ToString(1) = "1"') = True, 'Complex precedence with conversions should work');

    Writeln('Advanced combination tests passed.');
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
    TestIfThenElsePrecedence;
    TestAdvancedCombinations;

    Writeln('All tests passed!');
  except
    on E: Exception do
      Writeln('Test failed: ', E.Message);
  end;
  Readln;
end.
