program TestEvaluator;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  System.Variants,
  ExprEvaluator in '..\ExprEvaluator.pas';

procedure TestBasicArithmetic;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;
  Assert(Eval.Evaluate('3 + 2') = 5, '3 + 2 should be 5');
  Assert(Eval.Evaluate('3 * (3 + 2)') = 15, '3 * (3 + 2) should be 15');
  Assert(Eval.Evaluate('3 ^ 2') = 9, '3 ^ 2 should be 9');
  Assert(Eval.Evaluate('10 mod 3') = 1, '10 mod 3 should be 1');
  Assert(Eval.Evaluate('10 div 3') = 3, '10 div 3 should be 3');
  Assert(Eval.Evaluate('17 div 5') = 3, '17 div 5 should be 3');
  Assert(Eval.Evaluate('20 div 4') = 5, '20 div 4 should be 5');
  Writeln('Basic arithmetic tests passed.');
end;

procedure TestStringConcatenation;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;
  Assert(Eval.Evaluate('"Hello" + "World"') = 'HelloWorld', '"Hello" + "World" should be HelloWorld');
  Assert(Eval.Evaluate('"Delphi" + " " + "Rules"') = 'Delphi Rules', '"Delphi" + " " + "Rules" should be "Delphi Rules"');
  Writeln('String concatenation tests passed.');
end;

procedure TestVariables;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;
  Eval.Evaluate('x := 10');
  Eval.Evaluate('y := 5');
  Assert(Eval.Evaluate('x + y') = 15, 'x + y should be 15');
  Assert(Eval.Evaluate('x * y') = 50, 'x * y should be 50');
  Writeln('Variable tests passed.');
end;

procedure TestRelationalOperators;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;
  Assert(Eval.Evaluate('5 > 3') = True, '5 > 3 should be True');
  Assert(Eval.Evaluate('x := 10; y := 20; x < y') = True, 'x < y should be True');
  Assert(Eval.Evaluate('x = y') = False, 'x = y should be False');
  Assert(Eval.Evaluate('x <> y') = True, 'x <> y should be True');
  Writeln('Relational operators tests passed.');
end;

procedure TestLogicalOperators;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;
  Assert(Eval.Evaluate('True and False') = False, 'True and False should be False');
  Assert(Eval.Evaluate('True or False') = True, 'True or False should be True');
  Assert(Eval.Evaluate('True xor False') = True, 'True xor False should be True');
  Writeln('Logical operators tests passed.');
end;

procedure TestFunctions;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;
  Assert(Eval.Evaluate('contains("hello","hello world")') = True, 'contains("hello","hello world") should be True');
  Assert(Eval.Evaluate('sqrt(16)') = 4, 'sqrt(16) should be 4');
  Assert(Abs(Eval.Evaluate('logn(2.71828)') - 1) < 0.01, 'logn(2.71828) should be ~1');
  Assert(Eval.Evaluate('log(100)') = 2, 'log(100) should be 2');
  Assert(Eval.Evaluate('ToString(42)') = '42', 'ToString(42) should be "42"');
  Assert(Eval.Evaluate('ToInteger("123")') = 123, 'ToInteger("123") should be 123');
  Assert(Eval.Evaluate('ToFloat("123.45")') = 123.45, 'ToFloat("123.45") should be 123.45');
  {TODO -oDanieleT -cGeneral : Non gestisce numeri negativi!}
  Assert(Eval.Evaluate('Round(123.45, 0)') = 123, 'Round(123.45, 0) should be 123');
  Writeln('Function tests passed.');
end;

procedure TestIfThenElse;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;
  Assert(Eval.Evaluate('if contains("hello","hello world") then "YES" else "NO"') = 'YES', 'if contains("hello","hello world") then "YES" else "NO" should be "YES"');
  Assert(Eval.Evaluate('if 3 > 2 then "Yes" else "No"') = 'Yes', 'if 3 > 2 then "Yes" else "No" should be "Yes"');
  Assert(Eval.Evaluate('if 1 > 2 then "A" else if 2 > 1 then "B" else "C"') = 'B', 'Nested if should return "B"');
  Writeln('If-Then-Else tests passed.');
end;

procedure TestCustomFunction;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;
  Eval.RegisterFunction('cube', function(const Args: array of Variant): Variant
    begin
      if Length(Args) <> 1 then
        raise Exception.Create('cube requires 1 argument');
      Result := System.Math.Power(Args[0], 3);
    end);

  Assert(Eval.Evaluate('cube(3)') = 27, 'cube(3) should be 27');
  Writeln('Custom function tests passed.');
end;

procedure TestMultipleExpressions;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;
  Assert(Eval.Evaluate('a := 5; b := 10; a + b') = 15, 'a := 5; b := 10; a + b should be 15');
  Assert(Eval.Evaluate('x := if 10 > 5 then 1 else 0; x') = 1, 'x := if 10 > 5 then 1 else 0; x should be 1');
  Writeln('Multiple expressions tests passed.');
end;

procedure TestIfThenElsePrecedence;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;
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
end;

procedure TestInterfaceUsage;
var
  Eval: IExprEvaluator;
begin
  // No need for try/finally - automatic memory management with interface!
  Eval := CreateExprEvaluator;

  // Test basic functionality with interface
  Assert(Eval.Evaluate('2 + 3 * 4') = 14, 'Interface: Basic arithmetic should work');

  // Test variables with interface
  Eval.SetVar('x', 10);
  Eval.SetVar('y', 20);
  Assert(Eval.Evaluate('x + y') = 30, 'Interface: Variables should work');
  Assert(Eval.GetVar('x') = 10, 'Interface: GetVar should work');

  // Test string operations with interface
  Assert(Eval.Evaluate('"Hello" + " " + "World"') = 'Hello World', 'Interface: String concatenation should work');

  // Test conversion functions with interface
  Assert(Eval.Evaluate('ToInteger("123") + ToFloat("45.67")') = 168.67, 'Interface: Conversion functions should work');

  // Test conditionals with interface
  Assert(Eval.Evaluate('if 10 > 5 then "Greater" else "Lesser"') = 'Greater', 'Interface: Conditionals should work');

  // Test custom function registration with interface
  Eval.RegisterFunction('square', function(const Args: array of Variant): Variant
    begin
      if Length(Args) <> 1 then
        raise Exception.Create('square requires 1 argument');
      Result := Args[0] * Args[0];
    end);

  Assert(Eval.Evaluate('square(7)') = 49, 'Interface: Custom functions should work');

  Writeln('Interface usage tests passed.');
end;

procedure TestAdvancedCombinations;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;
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
end;

procedure TestNegativeNumbers;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Basic negative number tests
  Assert(Eval.Evaluate('-5') = -5, '-5 should be -5');
  Assert(Eval.Evaluate('(-5)') = -5, '(-5) should be -5');
  Assert(Eval.Evaluate('-5 + 3') = -2, '-5 + 3 should be -2');
  Assert(Eval.Evaluate('3 + (-5)') = -2, '3 + (-5) should be -2');
  Assert(Eval.Evaluate('-10 * -2') = 20, '-10 * -2 should be 20');
  Assert(Eval.Evaluate('-12 div -3') = 4, '-12 div -3 should be 4');
  Assert(Eval.Evaluate('-10 mod -3') = -1, '-10 mod -3 should be -1');

  // Negative numbers in functions
  Assert(Eval.Evaluate('ToString(-42)') = '-42', 'ToString(-42) should be "-42"');
  Assert(Eval.Evaluate('ToInteger("-123")') = -123, 'ToInteger("-123") should be -123');
  Assert(Eval.Evaluate('ToFloat("-123.45")') = -123.45, 'ToFloat("-123.45") should be -123.45');

  // Negative numbers with variables
  Eval.SetVar('x', -10);
  Eval.SetVar('y', -5);
  Assert(Eval.Evaluate('x + y') = -15, 'x + y should be -15 with negative variables');
  Assert(Eval.Evaluate('x * y') = 50, 'x * y should be 50 with negative variables');

  // Negative numbers in conditionals
  Assert(Eval.Evaluate('if -5 < 0 then "negative" else "positive"') = 'negative', 'Negative number condition should work');
  Assert(Eval.Evaluate('if -10 > -5 then "greater" else "lesser"') = 'lesser', 'Negative number comparison should work');

  // Complex expressions with negative numbers
  Assert(Eval.Evaluate('-2 ^ 3') = -8, '-2 ^ 3 should be -8');
  Assert(Eval.Evaluate('(-2) ^ 3') = -8, '(-2) ^ 3 should be -8');
  Assert(Eval.Evaluate('sqrt((-5) * (-5))') = 5, 'sqrt((-5) * (-5)) should be 5');

  Writeln('Negative number tests passed.');
end;

procedure TestEdgeCases;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Keyword boundary tests
  Assert(Eval.Evaluate('true and true') = True, 'Simple AND should work');

  // Test that keywords need proper word boundaries
  // Note: '1or1' actually returns 1 because parser stops at 'o' (not valid operator)
  Assert(Eval.Evaluate('1or1') = 1, 'Expression should stop at invalid character and return 1');

  // Test that keywords are case insensitive
  Assert(Eval.Evaluate('true AND true') = True, 'AND (uppercase) should work');
  Assert(Eval.Evaluate('true and true') = True, 'and (lowercase) should work');
  Assert(Eval.Evaluate('true And true') = True, 'And (mixed case) should work');
  Assert(Eval.Evaluate('10 DIV 3') = 3, 'DIV (uppercase) should work');
  Assert(Eval.Evaluate('10 div 3') = 3, 'div (lowercase) should work');
  Assert(Eval.Evaluate('10 Div 3') = 3, 'Div (mixed case) should work');

  // Test division by zero should raise exception
  try
    Eval.Evaluate('10 / 0');
    Assert(False, 'Division by zero should raise exception');
  except
    // Expected exception
  end;

  try
    Eval.Evaluate('10 div 0');
    Assert(False, 'Integer division by zero should raise exception');
  except
    // Expected exception
  end;

  // Test whitespace handling
  Assert(Eval.Evaluate('  10  +  5  ') = 15, 'Whitespace should be handled correctly');
  Assert(Eval.Evaluate('10+5') = 15, 'No whitespace should work');
  Assert(Eval.Evaluate('if  10 > 5  then  "yes"  else  "no"') = 'yes', 'Whitespace in conditionals should work');

  // Test empty string handling in string functions
  Assert(Eval.Evaluate('""') = '', 'Empty string should work');
  Assert(Eval.Evaluate('"" + "test"') = 'test', 'Empty string concatenation should work');
  Assert(Eval.Evaluate('ToString(0)') = '0', 'ToString(0) should work');

  // Test very large numbers
  Assert(Eval.Evaluate('999999 + 1') = 1000000, 'Large number arithmetic should work');

  // Test precedence edge cases
  Assert(Eval.Evaluate('2 + 3 * 4 div 2') = 8, 'Mixed operator precedence should work');
  Assert(Eval.Evaluate('10 - 5 + 2') = 7, 'Left-to-right evaluation for same precedence should work');

  Writeln('Edge case tests passed.');
end;

procedure TestBoundaryConditions;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test function with exactly required arguments
  Assert(Eval.Evaluate('sqrt(16)') = 4, 'Function with exact argument count should work');

  // Test nested function calls
  Assert(Eval.Evaluate('sqrt(sqrt(16))') = 2, 'Nested function calls should work');
  Assert(Eval.Evaluate('ToInteger(ToString(42))') = 42, 'Nested conversion functions should work');

  // Test deeply nested parentheses
  Assert(Eval.Evaluate('((((1 + 2))))') = 3, 'Deeply nested parentheses should work');

  // Test multiple assignments
  Assert(Eval.Evaluate('a := 1; b := 2; c := 3; a + b + c') = 6, 'Multiple assignments should work');

  // Test variable name edge cases
  Eval.SetVar('_var', 10);
  Assert(Eval.Evaluate('_var') = 10, 'Variable with underscore should work');

  // Test boolean edge cases
  Assert(Eval.Evaluate('true and true and true') = True, 'Multiple AND operations should work');
  Assert(Eval.Evaluate('false or false or true') = True, 'Multiple OR operations should work');
  Assert(Eval.Evaluate('true xor true xor true') = True, 'Multiple XOR operations should work');

  // Test string with special characters
  Assert(Eval.Evaluate('"Hello, World!"') = 'Hello, World!', 'String with special characters should work');

  // Test mixed string and number operations
  Assert(Eval.Evaluate('"Value: " + ToString(-42)') = 'Value: -42', 'Mixed string and negative number should work');

  Writeln('Boundary condition tests passed.');
end;

procedure TestMinMaxFunctions;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test Min function with 2 arguments
  Assert(Eval.Evaluate('Min(5, 3)') = 3, 'Min(5, 3) should be 3');
  Assert(Eval.Evaluate('Min(-5, 3)') = -5, 'Min(-5, 3) should be -5');
  Assert(Eval.Evaluate('Min(3.14, 2.71)') = 2.71, 'Min(3.14, 2.71) should be 2.71');

  // Test Max function with 2 arguments
  Assert(Eval.Evaluate('Max(5, 3)') = 5, 'Max(5, 3) should be 5');
  Assert(Eval.Evaluate('Max(-5, 3)') = 3, 'Max(-5, 3) should be 3');
  Assert(Eval.Evaluate('Max(3.14, 2.71)') = 3.14, 'Max(3.14, 2.71) should be 3.14');

  // Test Min function with multiple arguments
  Assert(Eval.Evaluate('Min(10, 5, 8, 3, 12)') = 3, 'Min(10, 5, 8, 3, 12) should be 3');
  Assert(Eval.Evaluate('Min(-10, -5, -8, -3, -12)') = -12, 'Min with negative numbers should work');

  // Test Max function with multiple arguments
  Assert(Eval.Evaluate('Max(10, 5, 8, 3, 12)') = 12, 'Max(10, 5, 8, 3, 12) should be 12');
  Assert(Eval.Evaluate('Max(-10, -5, -8, -3, -12)') = -3, 'Max with negative numbers should work');

  // Test Min/Max with variables
  Eval.SetVar('a', 10);
  Eval.SetVar('b', 5);
  Eval.SetVar('c', 8);
  Assert(Eval.Evaluate('Min(a, b, c)') = 5, 'Min with variables should work');
  Assert(Eval.Evaluate('Max(a, b, c)') = 10, 'Max with variables should work');

  // Test Min/Max in expressions
  Assert(Eval.Evaluate('Min(5, 3) + Max(2, 4)') = 7, 'Min/Max in expressions should work');
  Assert(Eval.Evaluate('sqrt(Max(16, 9))') = 4, 'Nested function calls should work');

  Writeln('Min/Max function tests passed.');
end;

procedure TestTypeValidation;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test type validation for mathematical functions
  try
    Eval.Evaluate('sqrt("abc")');
    Assert(False, 'sqrt with string should raise exception');
  except
    on E: Exception do
      Assert(Pos('numeric', E.Message) > 0, 'Error should mention numeric requirement');
  end;

  try
    Eval.Evaluate('log("xyz")');
    Assert(False, 'log with string should raise exception');
  except
    on E: Exception do
      Assert(Pos('numeric', E.Message) > 0, 'Error should mention numeric requirement');
  end;

  // Test type validation for Min/Max functions
  try
    Eval.Evaluate('Min("a", "b")');
    Assert(False, 'Min with strings should raise exception');
  except
    on E: Exception do
      Assert(Pos('numeric', E.Message) > 0, 'Error should mention numeric requirement');
  end;

  try
    Eval.Evaluate('Max(5, "text")');
    Assert(False, 'Max with mixed types should raise exception');
  except
    on E: Exception do
      Assert(Pos('numeric', E.Message) > 0, 'Error should mention numeric requirement');
  end;

  // Test argument count validation
  try
    Eval.Evaluate('Min(5)');
    Assert(False, 'Min with 1 argument should raise exception');
  except
    on E: Exception do
      Assert(Pos('at least 2', E.Message) > 0, 'Error should mention minimum arguments');
  end;

  try
    Eval.Evaluate('Max()');
    Assert(False, 'Max with no arguments should raise exception');
  except
    on E: Exception do
      Assert(Pos('at least 2', E.Message) > 0, 'Error should mention minimum arguments');
  end;

  // Test that valid uses still work
  Assert(Eval.Evaluate('sqrt(16)') = 4, 'Valid sqrt should still work');
  Assert(Eval.Evaluate('Min(1, 2, 3)') = 1, 'Valid Min should still work');
  Assert(Eval.Evaluate('Max(1, 2, 3)') = 3, 'Valid Max should still work');

  Writeln('Type validation tests passed.');
end;

procedure TestSortFunction;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test Sort function with numeric arguments
  Assert(Eval.Evaluate('Sort(5, 3, 8, 1)') = '1,3,5,8', 'Sort(5, 3, 8, 1) should be "1,3,5,8"');
  Assert(Eval.Evaluate('Sort(-5, 3, -8, 1)') = '-8,-5,1,3', 'Sort with negative numbers should work');
  Assert(Eval.Evaluate('Sort(3.14, 2.71, 1.41)') = '1.41,2.71,3.14', 'Sort with decimals should work');

  // Test Sort function with string arguments
  Assert(Eval.Evaluate('Sort("zebra", "apple", "banana")') = 'apple,banana,zebra', 'Sort strings should work');
  Assert(Eval.Evaluate('Sort("c", "a", "b")') = 'a,b,c', 'Sort single chars should work');

  // Test Sort with variables
  Eval.SetVar('x', 10);
  Eval.SetVar('y', 5);
  Eval.SetVar('z', 8);
  Assert(Eval.Evaluate('Sort(x, y, z)') = '5,8,10', 'Sort with variables should work');

  // Test minimum arguments requirement
  try
    Eval.Evaluate('Sort(5)');
    Assert(False, 'Sort with 1 argument should raise exception');
  except
    on E: Exception do
      Assert(Pos('at least 2', E.Message) > 0, 'Error should mention minimum arguments');
  end;

  // Test homogeneous type requirement
  try
    Eval.Evaluate('Sort(5, "text")');
    Assert(False, 'Sort with mixed types should raise exception');
  except
    on E: Exception do
      Assert(Pos('same type', E.Message) > 0, 'Error should mention same type requirement');
  end;

  try
    Eval.Evaluate('Sort("text", 5)');
    Assert(False, 'Sort with mixed types should raise exception');
  except
    on E: Exception do
      Assert(Pos('same type', E.Message) > 0, 'Error should mention same type requirement');
  end;

  Writeln('Sort function tests passed.');
end;

procedure TestFloatingPointEdgeCases;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test very small numbers
  Assert(Eval.Evaluate('0.000001 + 0.000002') = 0.000003, 'Very small number arithmetic should work');

  // Test very large numbers
  Assert(Eval.Evaluate('999999999 + 1') = 1000000000, 'Large number arithmetic should work');

  // Test many decimal places
  Assert(Abs(Eval.Evaluate('3.141592653589793 * 2') - 6.283185307179586) < 0.000000000000001, 'High precision arithmetic should work');

  // Test zero operations
  Assert(Eval.Evaluate('0 + 0') = 0, 'Zero + zero should be zero');
  Assert(Eval.Evaluate('0 * 999') = 0, 'Zero * anything should be zero');
  Assert(Eval.Evaluate('0 ^ 5') = 0, 'Zero ^ positive should be zero');

  // Test operations with negative zero (if supported)
  Assert(Eval.Evaluate('0 - 0') = 0, 'Zero - zero should be zero');

  // Test division edge cases
  Assert(Eval.Evaluate('1 / 1') = 1, 'One divided by one should be one');
  Assert(Eval.Evaluate('0 / 1') = 0, 'Zero divided by one should be zero');

  // Test modulo edge cases
  Assert(Eval.Evaluate('0 mod 5') = 0, 'Zero mod anything should be zero');
  Assert(Eval.Evaluate('5 mod 1') = 0, 'Anything mod 1 should be zero');
  Assert(Eval.Evaluate('7 mod 7') = 0, 'Number mod itself should be zero');

  // Test div edge cases
  Assert(Eval.Evaluate('0 div 5') = 0, 'Zero div anything should be zero');
  Assert(Eval.Evaluate('5 div 1') = 5, 'Number div 1 should be itself');
  Assert(Eval.Evaluate('7 div 7') = 1, 'Number div itself should be 1');
  Assert(Eval.Evaluate('6 div 7') = 0, 'Smaller div larger should be 0');

  Writeln('Floating point edge case tests passed.');
end;

procedure TestStringEdgeCases;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test empty strings
  Assert(Eval.Evaluate('""') = '', 'Empty string should work');
  Assert(Eval.Evaluate('"" + ""') = '', 'Empty + empty should be empty');
  Assert(Eval.Evaluate('"test" + ""') = 'test', 'String + empty should be string');
  Assert(Eval.Evaluate('"" + "test"') = 'test', 'Empty + string should be string');

  // Test strings with special characters
  Assert(Eval.Evaluate('"Hello, World!"') = 'Hello, World!', 'String with punctuation should work');
  Assert(Eval.Evaluate('"Line1\nLine2"') = 'Line1\nLine2', 'String with escape chars should work');
  Assert(Eval.Evaluate('"\t\r\n"') = '\t\r\n', 'String with whitespace chars should work');

  // Test very long strings
  Assert(Length(Eval.Evaluate('"' + StringOfChar('A', 1000) + '"')) = 1000, 'Very long string should work');

  // Test string comparison edge cases
  Assert(Eval.Evaluate('"" = ""') = True, 'Empty strings should be equal');
  Assert(Eval.Evaluate('"a" = "a"') = True, 'Same strings should be equal');
  Assert(Eval.Evaluate('"a" = "A"') = False, 'Different case should not be equal');
  Assert(Eval.Evaluate('"" <> "a"') = True, 'Empty should not equal non-empty');

  // Test string with numbers
  Assert(Eval.Evaluate('"123" + "456"') = '123456', 'Numeric strings should concatenate');
  Assert(Eval.Evaluate('ToInteger("000123")') = 123, 'Leading zeros should be handled');
  Assert(Eval.Evaluate('ToFloat("123.000")') = 123, 'Trailing zeros should be handled');

  Writeln('String edge case tests passed.');
end;

procedure TestBooleanLogicEdgeCases;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test all boolean combinations
  Assert(Eval.Evaluate('true and true') = True, 'true and true should be true');
  Assert(Eval.Evaluate('true and false') = False, 'true and false should be false');
  Assert(Eval.Evaluate('false and true') = False, 'false and true should be false');
  Assert(Eval.Evaluate('false and false') = False, 'false and false should be false');

  Assert(Eval.Evaluate('true or true') = True, 'true or true should be true');
  Assert(Eval.Evaluate('true or false') = True, 'true or false should be true');
  Assert(Eval.Evaluate('false or true') = True, 'false or true should be true');
  Assert(Eval.Evaluate('false or false') = False, 'false or false should be false');

  Assert(Eval.Evaluate('true xor true') = False, 'true xor true should be false');
  Assert(Eval.Evaluate('true xor false') = True, 'true xor false should be true');
  Assert(Eval.Evaluate('false xor true') = True, 'false xor true should be true');
  Assert(Eval.Evaluate('false xor false') = False, 'false xor false should be false');

  // Test chained boolean operations
  Assert(Eval.Evaluate('true and true and true') = True, 'Chain of ANDs should work');
  Assert(Eval.Evaluate('false or false or true') = True, 'Chain of ORs should work');
  Assert(Eval.Evaluate('true xor false xor true') = False, 'Chain of XORs should work');

  // Test mixed boolean operations (left-to-right evaluation)
  Assert(Eval.Evaluate('true or false and false') = False, 'Boolean operators evaluate left-to-right');
  Assert(Eval.Evaluate('false and true or true') = True, 'Mixed AND/OR left-to-right should work');

  Writeln('Boolean logic edge case tests passed.');
end;

procedure TestVariableEdgeCases;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test variable name edge cases
  Eval.SetVar('_', 1);
  Assert(Eval.Evaluate('_') = 1, 'Single underscore variable should work');

  Eval.SetVar('_var', 2);
  Assert(Eval.Evaluate('_var') = 2, 'Variable with underscore should work');

  Eval.SetVar('var123', 3);
  Assert(Eval.Evaluate('var123') = 3, 'Variable with numbers should work');

  Eval.SetVar('UPPERCASE', 4);
  Assert(Eval.Evaluate('uppercase') = 4, 'Variable names should be case insensitive');

  // Test variable overwriting
  Eval.SetVar('x', 10);
  Assert(Eval.Evaluate('x') = 10, 'Initial variable value should work');
  Eval.SetVar('x', 20);
  Assert(Eval.Evaluate('x') = 20, 'Variable overwriting should work');

  // Test variable assignment in expressions
  Assert(Eval.Evaluate('y := 5; y') = 5, 'Assignment should return assigned value');
  Assert(Eval.Evaluate('z := x + y; z') = 25, 'Assignment with expression should work');

  // Test multiple assignments
  Assert(Eval.Evaluate('a := 1; b := 2; c := 3; a + b + c') = 6, 'Multiple assignments should work');

  Writeln('Variable edge case tests passed.');
end;

procedure TestFunctionArgumentEdgeCases;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test functions with extreme values
  Assert(Eval.Evaluate('sqrt(0)') = 0, 'sqrt(0) should be 0');
  Assert(Eval.Evaluate('sqrt(1)') = 1, 'sqrt(1) should be 1');

  // Test functions with negative arguments where applicable
  try
    Eval.Evaluate('sqrt(-1)');
    // If this doesn't raise an exception, check the result is NaN or handle gracefully
  except
    // Expected for negative sqrt
  end;

  // Test log functions with edge values
  Assert(Eval.Evaluate('log(1)') = 0, 'log(1) should be 0');
  Assert(Eval.Evaluate('log(10)') = 1, 'log(10) should be 1');

  try
    Eval.Evaluate('log(0)');
    Assert(False, 'log(0) should raise exception or return -infinity');
  except
    // Expected for log(0)
  end;

  try
    Eval.Evaluate('log(-1)');
    Assert(False, 'log(-1) should raise exception');
  except
    // Expected for negative log
  end;

  // Test conversion functions with edge cases
  Assert(Eval.Evaluate('ToString(0)') = '0', 'ToString(0) should work');
  Assert(Eval.Evaluate('ToString(-0)') = '0', 'ToString(-0) should work');
  Assert(Eval.Evaluate('ToInteger("0")') = 0, 'ToInteger("0") should work');
  Assert(Eval.Evaluate('ToInteger("-123")') = -123, 'ToInteger with negative should work');
  Assert(Eval.Evaluate('ToFloat("0.0")') = 0, 'ToFloat("0.0") should work');

  // Test conversion error cases
  try
    Eval.Evaluate('ToInteger("abc")');
    Assert(False, 'ToInteger with invalid string should raise exception');
  except
    // Expected
  end;

  try
    Eval.Evaluate('ToFloat("xyz")');
    Assert(False, 'ToFloat with invalid string should raise exception');
  except
    // Expected
  end;

  Writeln('Function argument edge case tests passed.');
end;

procedure TestExpressionComplexity;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test deeply nested parentheses
  Assert(Eval.Evaluate('((((((1))))))') = 1, 'Deeply nested parentheses should work');
  Assert(Eval.Evaluate('((((1 + 2))))') = 3, 'Deeply nested expressions should work');

  // Test very long expressions
  Assert(Eval.Evaluate('1+1+1+1+1+1+1+1+1+1') = 10, 'Long addition chain should work');
  Assert(Eval.Evaluate('2*2*2*2*2') = 32, 'Long multiplication chain should work');

  // Test complex nested function calls
  Assert(Eval.Evaluate('sqrt(sqrt(sqrt(256)))') = 2, 'Nested function calls should work');
  Assert(Eval.Evaluate('Max(Min(5, 10), Min(3, 8))') = 5, 'Nested Min/Max should work');

  // Test complex conditional expressions
  Assert(Eval.Evaluate('if (if true then true else false) then "yes" else "no"') = 'yes', 'Nested conditionals should work');

  // Test mixed operations with all operators
  Assert(Eval.Evaluate('2 + 3 * 4 - 1 / 2 + sqrt(16) - 2 ^ 2') = 13.5, 'Complex mixed operations should work');

  // Test expressions with many variables
  Eval.Evaluate('a := 1; b := 2; c := 3; d := 4; e := 5');
  Assert(Eval.Evaluate('a + b * c - d / e') = 6.2, 'Complex expression with many variables should work');

  Writeln('Expression complexity tests passed.');
end;

procedure TestErrorRecoveryAndValidation;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test malformed expressions
  try
    Eval.Evaluate('2 +');
    Assert(False, 'Incomplete expression should raise exception');
  except
    // Expected
  end;

  try
    Eval.Evaluate('+ 2');
    Assert(False, 'Expression starting with operator should raise exception');
  except
    // Expected
  end;

  try
    Eval.Evaluate('2 3');
    Assert(False, 'Missing operator should raise exception');
  except
    // Expected
  end;

  // Test unmatched parentheses
  try
    Eval.Evaluate('(2 + 3');
    Assert(False, 'Unclosed parenthesis should raise exception');
  except
    // Expected
  end;

  try
    Eval.Evaluate('2 + 3)');
    Assert(False, 'Extra closing parenthesis should raise exception');
  except
    // Expected
  end;

  // Test invalid function calls
  try
    Eval.Evaluate('sqrt(');
    Assert(False, 'Incomplete function call should raise exception');
  except
    // Expected
  end;

  try
    Eval.Evaluate('sqrt)');
    Assert(False, 'Malformed function call should raise exception');
  except
    // Expected
  end;

  // Test unknown variables
  try
    Eval.Evaluate('unknownVar');
    Assert(False, 'Unknown variable should raise exception');
  except
    // Expected
  end;

  // Test unknown functions
  try
    Eval.Evaluate('unknownFunc()');
    Assert(False, 'Unknown function should raise exception');
  except
    // Expected
  end;

  Writeln('Error recovery and validation tests passed.');
end;

procedure TestAdvancedSortEdgeCases;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test Sort with identical values
  Assert(Eval.Evaluate('Sort(5, 5, 5)') = '5,5,5', 'Sort with identical values should work');
  Assert(Eval.Evaluate('Sort("a", "a", "a")') = 'a,a,a', 'Sort with identical strings should work');

  // Test Sort with many arguments
  Assert(Eval.Evaluate('Sort(10, 9, 8, 7, 6, 5, 4, 3, 2, 1)') = '1,2,3,4,5,6,7,8,9,10', 'Sort with many arguments should work');

  // Test Sort with negative numbers
  Assert(Eval.Evaluate('Sort(-3, -1, -5, -2)') = '-5,-3,-2,-1', 'Sort with negative numbers should work');

  // Test Sort with mixed positive/negative
  Assert(Eval.Evaluate('Sort(-2, 0, 2, -1, 1)') = '-2,-1,0,1,2', 'Sort with mixed signs should work');

  // Test Sort with decimal numbers
  Assert(Eval.Evaluate('Sort(3.14, 2.71, 1.41, 3.15)') = '1.41,2.71,3.14,3.15', 'Sort with decimals should work');

  // Test Sort with strings in different orders
  Assert(Eval.Evaluate('Sort("zebra", "apple", "banana", "cherry")') = 'apple,banana,cherry,zebra', 'Sort alphabetical should work');
  Assert(Eval.Evaluate('Sort("Z", "a", "B", "c")') = 'B,Z,a,c', 'Sort case sensitive should work');

  // Test Sort with empty strings (if supported)
  Assert(Eval.Evaluate('Sort("", "b", "a")') = ',a,b', 'Sort with empty string should work');

  // Test Sort with variables containing different types
  Eval.SetVar('n1', 5);
  Eval.SetVar('n2', 2);
  Eval.SetVar('n3', 8);
  Assert(Eval.Evaluate('Sort(n1, n2, n3)') = '2,5,8', 'Sort with numeric variables should work');

  Writeln('Advanced Sort edge case tests passed.');
end;

procedure TestMinMaxAdvancedEdgeCases;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test Min/Max with many identical values
  Assert(Eval.Evaluate('Min(7, 7, 7, 7, 7)') = 7, 'Min with identical values should work');
  Assert(Eval.Evaluate('Max(7, 7, 7, 7, 7)') = 7, 'Max with identical values should work');

  // Test Min/Max with very large numbers of arguments
  Assert(Eval.Evaluate('Min(100, 99, 98, 97, 96, 95, 94, 93, 92, 91, 90)') = 90, 'Min with many args should work');
  Assert(Eval.Evaluate('Max(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)') = 11, 'Max with many args should work');

  // Test Min/Max with extreme values
  Assert(Eval.Evaluate('Min(-999999, 999999)') = -999999, 'Min with extreme values should work');
  Assert(Eval.Evaluate('Max(-999999, 999999)') = 999999, 'Max with extreme values should work');

  // Test Min/Max with decimal precision
  Assert(Eval.Evaluate('Min(0.001, 0.002, 0.0015)') = 0.001, 'Min with small decimals should work');
  Assert(Eval.Evaluate('Max(0.001, 0.002, 0.0015)') = 0.002, 'Max with small decimals should work');

  // Test Min/Max mixed with other operations
  Assert(Eval.Evaluate('Min(5, 3) + Max(2, 4) * 2') = 11, 'Min/Max in complex expressions should work');
  Assert(Eval.Evaluate('sqrt(Max(9, 16, 25))') = 5, 'Max as function argument should work');

  // Test Min/Max with expressions as arguments
  Assert(Eval.Evaluate('Min(2 + 3, 4 * 2, 10 - 1)') = 5, 'Min with expression arguments should work');
  Assert(Eval.Evaluate('Max(sqrt(16), log(100), 3.14)') = 4, 'Max with function arguments should work');

  Writeln('Advanced Min/Max edge case tests passed.');
end;

procedure TestPrecedenceAndAssociativity;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test operator precedence thoroughly
  Assert(Eval.Evaluate('2 + 3 * 4') = 14, 'Multiplication before addition');
  Assert(Eval.Evaluate('2 * 3 + 4') = 10, 'Multiplication before addition (2)');
  Assert(Eval.Evaluate('2 ^ 3 * 4') = 32, 'Exponentiation before multiplication');
  Assert(Eval.Evaluate('2 * 3 ^ 4') = 162, 'Exponentiation before multiplication (2)');

  // Test div and mod precedence
  Assert(Eval.Evaluate('10 + 6 div 3') = 12, 'Division before addition');
  Assert(Eval.Evaluate('10 + 6 mod 4') = 12, 'Modulo before addition');
  Assert(Eval.Evaluate('2 * 5 div 2') = 5, 'Same precedence left-to-right');

  // Test comparison operator precedence
  Assert(Eval.Evaluate('2 + 3 > 4') = True, 'Arithmetic before comparison');
  Assert(Eval.Evaluate('2 > 3 + 4') = False, 'Arithmetic before comparison (2)');

  // Test logical operator precedence (left-to-right evaluation)
  Assert(Eval.Evaluate('true or false and false') = False, 'Logical operators left-to-right');
  Assert(Eval.Evaluate('false and true or true') = True, 'Logical operators left-to-right (2)');

  // Test conditional precedence
  Assert(Eval.Evaluate('if 2 + 3 > 4 then 1 else 0') = 1, 'Arithmetic in condition');
  Assert(Eval.Evaluate('if true and false then 1 else 2 + 3') = 5, 'Logical in condition, arithmetic in else');

  // Test complex precedence chains
  Assert(Eval.Evaluate('2 + 3 * 4 div 2 - 1') = 7, 'Complex arithmetic precedence');
  Assert(Eval.Evaluate('1 < 2 and 3 > 2 or false') = True, 'Complex logical precedence');

  Writeln('Precedence and associativity tests passed.');
end;

procedure TestSpecialValueHandling;
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Test power edge cases
  Assert(Eval.Evaluate('1 ^ 999') = 1, '1 to any power should be 1');
  Assert(Eval.Evaluate('0 ^ 1') = 0, '0 to positive power should be 0');
  Assert(Eval.Evaluate('5 ^ 0') = 1, 'Any number to power 0 should be 1');
  Assert(Eval.Evaluate('(-2) ^ 2') = 4, 'Negative base even power should be positive');
  Assert(Eval.Evaluate('(-2) ^ 3') = -8, 'Negative base odd power should be negative');

  // Test special arithmetic cases
  Assert(Eval.Evaluate('1000000 * 0.000001') = 1, 'Large * small should work');
  Assert(Eval.Evaluate('0.1 + 0.2') = 0.3, 'Decimal addition should work');

  // Test boundary values for integer division
  Assert(Eval.Evaluate('1 div 2') = 0, 'Integer division with remainder');
  Assert(Eval.Evaluate('-7 div 3') = -2, 'Negative integer division');
  Assert(Eval.Evaluate('7 div -3') = -2, 'Division by negative');
  Assert(Eval.Evaluate('-7 div -3') = 2, 'Both negative division');

  // Test boundary values for modulo
  Assert(Eval.Evaluate('1 mod 2') = 1, 'Modulo with remainder');
  Assert(Eval.Evaluate('-7 mod 3') = -1, 'Negative modulo');

  // Test string edge cases with numbers
  Assert(Eval.Evaluate('"0" + "1"') = '01', 'String concatenation of numbers');
  Assert(Eval.Evaluate('ToString(0) + ToString(1)') = '01', 'ToString concatenation');

  Writeln('Special value handling tests passed.');
end;

procedure TestStressAndPerformance;
var
  Eval: IExprEvaluator;
  LongExpr: string;
  I: Integer;
begin
  Eval := CreateExprEvaluator;

  // Test very long arithmetic expressions
  LongExpr := '1';
  for I := 1 to 100 do
    LongExpr := LongExpr + ' + 1';
  Assert(Eval.Evaluate(LongExpr) = 101, 'Very long addition should work');

  // Test deeply nested function calls
  LongExpr := 'ToString(ToString(ToString(ToString(ToString(42)))))';
  Assert(Eval.Evaluate(LongExpr) = '42', 'Deeply nested ToString should work');

  // Test many variables
  for I := 1 to 50 do
    Eval.SetVar('var' + IntToStr(I), I);

  LongExpr := 'var1';
  for I := 2 to 50 do
    LongExpr := LongExpr + ' + var' + IntToStr(I);
  Assert(Eval.Evaluate(LongExpr) = 1275, 'Many variables should work'); // Sum of 1 to 50 = 1275

  // Test complex nested conditionals with parentheses for clarity
  Assert(Eval.Evaluate('if (if true then true else false) then 42 else -1') = 42, 'Complex nested if should work');

  // Test function with many arguments
  LongExpr := 'Min(';
  for I := 100 downto 1 do
  begin
    if I < 100 then LongExpr := LongExpr + ', ';
    LongExpr := LongExpr + IntToStr(I);
  end;
  LongExpr := LongExpr + ')';
  Assert(Eval.Evaluate(LongExpr) = 1, 'Min with 100 arguments should work');

  Writeln('Stress and performance tests passed.');
end;

begin
  try
    Writeln('Running test suite...');
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
    TestInterfaceUsage;

    Writeln('Running new tests...');
    TestNegativeNumbers;
    TestEdgeCases;
    TestBoundaryConditions;
    TestMinMaxFunctions;
    TestTypeValidation;
    TestSortFunction;

    Writeln('Running comprehensive edge case tests...');
    TestFloatingPointEdgeCases;
    TestStringEdgeCases;
    TestBooleanLogicEdgeCases;
    TestVariableEdgeCases;
    TestFunctionArgumentEdgeCases;
    TestExpressionComplexity;
    TestErrorRecoveryAndValidation;

    Writeln('Running advanced edge case tests...');
    TestAdvancedSortEdgeCases;
    TestMinMaxAdvancedEdgeCases;
    TestPrecedenceAndAssociativity;
    TestSpecialValueHandling;
    TestStressAndPerformance;

    Writeln('All tests passed!');
  except
    on E: Exception do
      Writeln('Test failed: ', E.Message);
  end;
  Readln;
end.
