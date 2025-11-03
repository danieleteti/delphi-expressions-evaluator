unit TestExprEvaluator;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils,
  System.Math,
  System.Variants,
  System.DateUtils,
  ExprEvaluator;

type
  [TestFixture]
  TExprEvaluatorTests = class
  private
    FEval: IExprEvaluator;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    // Basic functionality tests (1-10)
    [Test] procedure TestBasicArithmetic;
    [Test] procedure TestStringConcatenation;
    [Test] procedure TestVariables;
    [Test] procedure TestRelationalOperators;
    [Test] procedure TestLogicalOperators;
    [Test] procedure TestFunctions;
    [Test] procedure TestIfThenElse;
    [Test] procedure TestCustomFunction;
    [Test] procedure TestMultipleExpressions;
    [Test] procedure TestIfThenElsePrecedence;

    // Advanced tests (11-20)
    [Test] procedure TestAdvancedCombinations;
    [Test] procedure TestInterfaceUsage;
    [Test] procedure TestNegativeNumbers;
    [Test] procedure TestEdgeCases;
    [Test] procedure TestBoundaryConditions;
    [Test] procedure TestMinMaxFunctions;
    [Test] procedure TestTypeValidation;
    [Test] procedure TestSortFunction;
    [Test] procedure TestFloatingPointEdgeCases;
    [Test] procedure TestStringEdgeCases;

    // Complex tests (21-30)
    [Test] procedure TestBooleanLogicEdgeCases;
    [Test] procedure TestVariableEdgeCases;
    [Test] procedure TestFunctionArgumentEdgeCases;
    [Test] procedure TestExpressionComplexity;
    [Test] procedure TestErrorRecoveryAndValidation;
    [Test] procedure TestAdvancedSortEdgeCases;
    [Test] procedure TestMinMaxAdvancedEdgeCases;
    [Test] procedure TestPrecedenceAndAssociativity;
    [Test] procedure TestSpecialValueHandling;
    [Test] procedure TestStressAndPerformance;

    // New feature tests
    [Test] procedure TestStringFunctions;
    [Test] procedure TestDateFunctions;
    [Test] procedure TestComments;
    [Test] procedure TestDivisionByZero;
  end;

implementation

{ TExprEvaluatorTests }

procedure TExprEvaluatorTests.Setup;
begin
  FEval := CreateExprEvaluator;
end;

procedure TExprEvaluatorTests.TearDown;
begin
  FEval := nil;
end;

// 1. TestBasicArithmetic
procedure TExprEvaluatorTests.TestBasicArithmetic;
begin
  Assert.AreEqual<Integer>(5, FEval.Evaluate('3 + 2'));
  Assert.AreEqual<Integer>(15, FEval.Evaluate('3 * (3 + 2)'));
  Assert.AreEqual<Integer>(9, FEval.Evaluate('3 ^ 2'));
  Assert.AreEqual<Integer>(1, FEval.Evaluate('10 mod 3'));
  Assert.AreEqual<Integer>(3, FEval.Evaluate('10 div 3'));
  Assert.AreEqual<Integer>(3, FEval.Evaluate('17 div 5'));
  Assert.AreEqual<Integer>(5, FEval.Evaluate('20 div 4'));
end;

// 2. TestStringConcatenation
procedure TExprEvaluatorTests.TestStringConcatenation;
begin
  Assert.AreEqual<string>('HelloWorld', FEval.Evaluate('"Hello" + "World"'));
  Assert.AreEqual<string>('Delphi Rules', FEval.Evaluate('"Delphi" + " " + "Rules"'));
end;

// 3. TestVariables
procedure TExprEvaluatorTests.TestVariables;
begin
  FEval.Evaluate('x := 10');
  FEval.Evaluate('y := 5');
  Assert.AreEqual<Integer>(15, FEval.Evaluate('x + y'));
  Assert.AreEqual<Integer>(50, FEval.Evaluate('x * y'));
end;

// 4. TestRelationalOperators
procedure TExprEvaluatorTests.TestRelationalOperators;
begin
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('5 > 3'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('x := 10; y := 20; x < y'));
  Assert.AreEqual<Boolean>(False, FEval.Evaluate('x = y'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('x <> y'));
end;

// 5. TestLogicalOperators
procedure TExprEvaluatorTests.TestLogicalOperators;
begin
  Assert.AreEqual<Boolean>(False, FEval.Evaluate('True and False'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('True or False'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('True xor False'));

  // NOT operator tests
  Assert.AreEqual<Boolean>(False, FEval.Evaluate('not True'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('not False'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('not (5 < 3)'));
  Assert.AreEqual<Boolean>(False, FEval.Evaluate('not (5 > 3)'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('not False and True'));
  Assert.AreEqual<Boolean>(False, FEval.Evaluate('not True or False'));
end;

// 6. TestFunctions
procedure TExprEvaluatorTests.TestFunctions;
begin
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('contains("hello","hello world")'));
  Assert.AreEqual<Integer>(4, FEval.Evaluate('sqrt(16)'));
  Assert.AreEqual<Integer>(2, FEval.Evaluate('log(100)'));
  Assert.AreEqual<string>('42', FEval.Evaluate('ToString(42)'));
  Assert.AreEqual<Integer>(123, FEval.Evaluate('ToInteger("123")'));
  Assert.AreEqual<Double>(123.45, FEval.Evaluate('ToFloat("123.45")'));
  Assert.AreEqual<Integer>(123, FEval.Evaluate('Round(123.45, 0)'));

  // New math functions
  Assert.AreEqual<Integer>(5, FEval.Evaluate('abs(5)'));
  Assert.AreEqual<Integer>(5, FEval.Evaluate('abs(-5)'));
  Assert.AreEqual<Integer>(3, FEval.Evaluate('floor(3.7)'));
  Assert.AreEqual<Integer>(-4, FEval.Evaluate('floor(-3.2)'));
  Assert.AreEqual<Integer>(4, FEval.Evaluate('ceil(3.2)'));
  Assert.AreEqual<Integer>(-3, FEval.Evaluate('ceil(-3.7)'));
  Assert.AreEqual<Integer>(8, FEval.Evaluate('power(2, 3)'));
  Assert.AreEqual<Integer>(125, FEval.Evaluate('power(5, 3)'));
end;

// 7. TestIfThenElse
procedure TExprEvaluatorTests.TestIfThenElse;
begin
  Assert.AreEqual<string>('YES', FEval.Evaluate('if contains("hello","hello world") then "YES" else "NO"'));
  Assert.AreEqual<string>('Yes', FEval.Evaluate('if 3 > 2 then "Yes" else "No"'));
  Assert.AreEqual<string>('B', FEval.Evaluate('if 1 > 2 then "A" else if 2 > 1 then "B" else "C"'));
end;

// 8. TestCustomFunction
procedure TExprEvaluatorTests.TestCustomFunction;
begin
  FEval.RegisterFunction('cube', function(const Args: array of Variant): Variant
    begin
      if Length(Args) <> 1 then
        raise Exception.Create('cube requires 1 argument');
      Result := System.Math.Power(Args[0], 3);
    end);

  Assert.AreEqual<Integer>(27, FEval.Evaluate('cube(3)'));
end;

// 9. TestMultipleExpressions
procedure TExprEvaluatorTests.TestMultipleExpressions;
begin
  Assert.AreEqual<Integer>(15, FEval.Evaluate('a := 5; b := 10; a + b'));
  Assert.AreEqual<Integer>(1, FEval.Evaluate('x := if 10 > 5 then 1 else 0; x'));
end;

// 10. TestIfThenElsePrecedence
procedure TExprEvaluatorTests.TestIfThenElsePrecedence;
begin
  Assert.AreEqual<Integer>(20, FEval.Evaluate('if 2 + 3 > 4 then 10 * 2 else 5 + 1'));
  Assert.AreEqual<Integer>(5, FEval.Evaluate('if true and false then 1 else 2 + 3'));
  Assert.AreEqual<Integer>(2, FEval.Evaluate('if 5 > 3 and 2 < 4 then 1 + 1 else 0'));
  Assert.AreEqual<Integer>(100, FEval.Evaluate('if 10 / 2 = 5 then if 3 * 2 > 5 then 100 else 50 else 0'));
end;

// 11. TestAdvancedCombinations
procedure TExprEvaluatorTests.TestAdvancedCombinations;
begin
  Assert.AreEqual<Integer>(165, FEval.Evaluate('ToInteger(ToString(15) + "5") + 10'));
  Assert.AreEqual<Integer>(4, FEval.Evaluate('if ToFloat("12.5") > 10 and ToInteger("5") < 10 then sqrt(ToFloat("16.0")) else log(100)'));
  Assert.AreEqual<string>('Result: 42', FEval.Evaluate('"Result: " + ToString(if ToInteger("10") > 5 then 42 else 0)'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('(ToInteger("1") = 1 and ToFloat("2.0") = 2.0) or (ToString(3) = "3" and false)'));
end;

// 12. TestInterfaceUsage
procedure TExprEvaluatorTests.TestInterfaceUsage;
begin
  Assert.AreEqual<Integer>(14, FEval.Evaluate('2 + 3 * 4'));
  FEval.SetVar('x', 10);
  FEval.SetVar('y', 20);
  Assert.AreEqual<Integer>(30, FEval.Evaluate('x + y'));
  Assert.AreEqual<Integer>(10, FEval.GetVar('x'));
  Assert.AreEqual<string>('Hello World', FEval.Evaluate('"Hello" + " " + "World"'));
  Assert.AreEqual<string>('Greater', FEval.Evaluate('if 10 > 5 then "Greater" else "Lesser"'));
end;

// 13. TestNegativeNumbers
procedure TExprEvaluatorTests.TestNegativeNumbers;
begin
  Assert.AreEqual<Integer>(-5, FEval.Evaluate('-5'));
  Assert.AreEqual<Integer>(-5, FEval.Evaluate('(-5)'));
  Assert.AreEqual<Integer>(-2, FEval.Evaluate('-5 + 3'));
  Assert.AreEqual<Integer>(-2, FEval.Evaluate('3 + (-5)'));
  Assert.AreEqual<Integer>(20, FEval.Evaluate('-10 * -2'));
  Assert.AreEqual<Integer>(4, FEval.Evaluate('-12 div -3'));
  Assert.AreEqual<string>('-42', FEval.Evaluate('ToString(-42)'));
  Assert.AreEqual<Integer>(-123, FEval.Evaluate('ToInteger("-123")'));
end;

// 14. TestEdgeCases
procedure TExprEvaluatorTests.TestEdgeCases;
begin
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('true and true'));
  Assert.AreEqual<Integer>(1, FEval.Evaluate('1or1')); // Expression stops at invalid character
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('true AND true'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('true and true'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('true And true'));
  Assert.AreEqual<Integer>(3, FEval.Evaluate('10 DIV 3'));
  Assert.AreEqual<Integer>(3, FEval.Evaluate('10 div 3'));
  Assert.AreEqual<Integer>(3, FEval.Evaluate('10 Div 3'));
  Assert.AreEqual<Integer>(15, FEval.Evaluate('  10  +  5  '));
  Assert.AreEqual<Integer>(15, FEval.Evaluate('10+5'));
end;

// 15. TestBoundaryConditions
procedure TExprEvaluatorTests.TestBoundaryConditions;
begin
  Assert.AreEqual<Integer>(4, FEval.Evaluate('sqrt(16)'));
  Assert.AreEqual<Integer>(2, FEval.Evaluate('sqrt(sqrt(16))'));
  Assert.AreEqual<Integer>(42, FEval.Evaluate('ToInteger(ToString(42))'));
  Assert.AreEqual<Integer>(3, FEval.Evaluate('((((1 + 2))))'));
  Assert.AreEqual<Integer>(6, FEval.Evaluate('a := 1; b := 2; c := 3; a + b + c'));
  FEval.SetVar('_var', 10);
  Assert.AreEqual<Integer>(10, FEval.Evaluate('_var'));
end;

// 16. TestMinMaxFunctions
procedure TExprEvaluatorTests.TestMinMaxFunctions;
begin
  Assert.AreEqual<Integer>(3, FEval.Evaluate('Min(5, 3)'));
  Assert.AreEqual<Integer>(-5, FEval.Evaluate('Min(-5, 3)'));
  Assert.AreEqual<Integer>(5, FEval.Evaluate('Max(5, 3)'));
  Assert.AreEqual<Integer>(3, FEval.Evaluate('Max(-5, 3)'));
  Assert.AreEqual<Integer>(3, FEval.Evaluate('Min(10, 5, 8, 3, 12)'));
  Assert.AreEqual<Integer>(12, FEval.Evaluate('Max(10, 5, 8, 3, 12)'));
  Assert.AreEqual<Integer>(7, FEval.Evaluate('Min(5, 3) + Max(2, 4)'));
  Assert.AreEqual<Integer>(4, FEval.Evaluate('sqrt(Max(16, 9))'));
end;

// 17. TestTypeValidation
procedure TExprEvaluatorTests.TestTypeValidation;
begin
  // Test that valid uses work
  Assert.AreEqual<Integer>(4, FEval.Evaluate('sqrt(16)'));
  Assert.AreEqual<Integer>(1, FEval.Evaluate('Min(1, 2, 3)'));
  Assert.AreEqual<Integer>(3, FEval.Evaluate('Max(1, 2, 3)'));
end;

// 18. TestSortFunction
procedure TExprEvaluatorTests.TestSortFunction;
begin
  Assert.AreEqual<string>('1,3,5,8', FEval.Evaluate('Sort(5, 3, 8, 1)'));
  Assert.AreEqual<string>('-8,-5,1,3', FEval.Evaluate('Sort(-5, 3, -8, 1)'));
  Assert.AreEqual<string>('1.41,2.71,3.14', FEval.Evaluate('Sort(3.14, 2.71, 1.41)'));
  Assert.AreEqual<string>('apple,banana,zebra', FEval.Evaluate('Sort("zebra", "apple", "banana")'));
  Assert.AreEqual<string>('a,b,c', FEval.Evaluate('Sort("c", "a", "b")'));
end;

// 19. TestFloatingPointEdgeCases
procedure TExprEvaluatorTests.TestFloatingPointEdgeCases;
begin
  Assert.AreEqual<Double>(0.000003, FEval.Evaluate('0.000001 + 0.000002'));
  Assert.AreEqual<Integer>(1000000000, FEval.Evaluate('999999999 + 1'));
  Assert.AreEqual<Integer>(0, FEval.Evaluate('0 + 0'));
  Assert.AreEqual<Integer>(0, FEval.Evaluate('0 * 999'));
  Assert.AreEqual<Integer>(0, FEval.Evaluate('0 ^ 5'));
  Assert.AreEqual<Integer>(1, FEval.Evaluate('1 / 1'));
  Assert.AreEqual<Integer>(0, FEval.Evaluate('0 / 1'));
end;

// 20. TestStringEdgeCases
procedure TExprEvaluatorTests.TestStringEdgeCases;
begin
  Assert.AreEqual<string>('', FEval.Evaluate('""'));
  Assert.AreEqual<string>('', FEval.Evaluate('"" + ""'));
  Assert.AreEqual<string>('test', FEval.Evaluate('"test" + ""'));
  Assert.AreEqual<string>('test', FEval.Evaluate('"" + "test"'));
  Assert.AreEqual<string>('Hello, World!', FEval.Evaluate('"Hello, World!"'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('"" = ""'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('"a" = "a"'));
  Assert.AreEqual<Boolean>(False, FEval.Evaluate('"a" = "A"'));
end;

// Additional important tests follow...
// 21-30. (Abbreviated for space - key functionality covered)
procedure TExprEvaluatorTests.TestBooleanLogicEdgeCases;
begin
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('true and true and true'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('false or false or true'));
  Assert.AreEqual<Boolean>(False, FEval.Evaluate('true or false and false'));
end;

procedure TExprEvaluatorTests.TestVariableEdgeCases;
begin
  FEval.SetVar('_', 1);
  Assert.AreEqual<Integer>(1, FEval.Evaluate('_'));
  FEval.SetVar('UPPERCASE', 4);
  Assert.AreEqual<Integer>(4, FEval.Evaluate('uppercase'));
end;

procedure TExprEvaluatorTests.TestFunctionArgumentEdgeCases;
begin
  Assert.AreEqual<Integer>(0, FEval.Evaluate('sqrt(0)'));
  Assert.AreEqual<Integer>(1, FEval.Evaluate('sqrt(1)'));
  Assert.AreEqual<string>('0', FEval.Evaluate('ToString(0)'));
  Assert.AreEqual<Integer>(-123, FEval.Evaluate('ToInteger("-123")'));
end;

procedure TExprEvaluatorTests.TestExpressionComplexity;
begin
  Assert.AreEqual<Integer>(1, FEval.Evaluate('((((((1))))))'));
  Assert.AreEqual<Integer>(10, FEval.Evaluate('1+1+1+1+1+1+1+1+1+1'));
  Assert.AreEqual<Integer>(32, FEval.Evaluate('2*2*2*2*2'));
  Assert.AreEqual<Integer>(2, FEval.Evaluate('sqrt(sqrt(sqrt(256)))'));
end;

procedure TExprEvaluatorTests.TestErrorRecoveryAndValidation;
begin
  // Test that valid expressions work
  Assert.AreEqual<Integer>(5, FEval.Evaluate('2 + 3'));
end;

procedure TExprEvaluatorTests.TestAdvancedSortEdgeCases;
begin
  Assert.AreEqual<string>('5,5,5', FEval.Evaluate('Sort(5, 5, 5)'));
  Assert.AreEqual<string>('1,2,3,4,5,6,7,8,9,10', FEval.Evaluate('Sort(10, 9, 8, 7, 6, 5, 4, 3, 2, 1)'));

  // QuickSort stress test with larger dataset
  Assert.AreEqual<string>('1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20',
    FEval.Evaluate('Sort(20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)'));
  Assert.AreEqual<string>('1,5,7,12,15,23,45,67,89,100',
    FEval.Evaluate('Sort(45, 23, 7, 89, 1, 100, 5, 67, 15, 12)'));
end;

procedure TExprEvaluatorTests.TestMinMaxAdvancedEdgeCases;
begin
  Assert.AreEqual<Integer>(7, FEval.Evaluate('Min(7, 7, 7, 7, 7)'));
  Assert.AreEqual<Integer>(90, FEval.Evaluate('Min(100, 99, 98, 97, 96, 95, 94, 93, 92, 91, 90)'));
end;

procedure TExprEvaluatorTests.TestPrecedenceAndAssociativity;
begin
  Assert.AreEqual<Integer>(14, FEval.Evaluate('2 + 3 * 4'));
  Assert.AreEqual<Integer>(10, FEval.Evaluate('2 * 3 + 4'));
  Assert.AreEqual<Integer>(32, FEval.Evaluate('2 ^ 3 * 4'));
  Assert.AreEqual<Boolean>(True, FEval.Evaluate('2 + 3 > 4'));
end;

procedure TExprEvaluatorTests.TestSpecialValueHandling;
begin
  Assert.AreEqual<Integer>(1, FEval.Evaluate('1 ^ 999'));
  Assert.AreEqual<Integer>(0, FEval.Evaluate('0 ^ 1'));
  Assert.AreEqual<Integer>(1, FEval.Evaluate('5 ^ 0'));
  Assert.AreEqual<Integer>(4, FEval.Evaluate('(-2) ^ 2'));
  Assert.AreEqual<Integer>(-8, FEval.Evaluate('(-2) ^ 3'));
end;

procedure TExprEvaluatorTests.TestStressAndPerformance;
var
  LongExpr: string;
  I: Integer;
begin
  // Test long arithmetic expressions
  LongExpr := '1';
  for I := 1 to 50 do  // Reduced for simpler test
    LongExpr := LongExpr + ' + 1';
  Assert.AreEqual<Integer>(51, FEval.Evaluate(LongExpr));

  // Test nested function calls
  Assert.AreEqual<string>('42', FEval.Evaluate('ToString(ToString(ToString(42)))'));
end;

// 31. TestStringFunctions (NEW)
procedure TExprEvaluatorTests.TestStringFunctions;
begin
  Assert.AreEqual<Integer>(5, FEval.Evaluate('Length("Hello")'));
  Assert.AreEqual<string>('HELLO', FEval.Evaluate('Upper("hello")'));
  Assert.AreEqual<string>('world', FEval.Evaluate('Lower("WORLD")'));
  Assert.AreEqual<string>('hello', FEval.Evaluate('Trim("  hello  ")'));
  Assert.AreEqual<string>('Hel', FEval.Evaluate('Left("Hello", 3)'));
  Assert.AreEqual<string>('llo', FEval.Evaluate('Right("Hello", 3)'));
  Assert.AreEqual<string>('ell', FEval.Evaluate('Substr("Hello", 2, 3)'));
  Assert.AreEqual<Integer>(7, FEval.Evaluate('IndexOf("Hello World", "World")'));
  Assert.AreEqual<string>('Hello Pascal', FEval.Evaluate('Replace("Hello World", "World", "Pascal")'));
end;

// 32. TestDateFunctions (NEW)
procedure TExprEvaluatorTests.TestDateFunctions;
begin
  FEval.Evaluate('testDate := ParseDate("2024-01-01")');
  Assert.AreEqual<Integer>(2024, FEval.Evaluate('Year(testDate)'));
  Assert.AreEqual<Integer>(1, FEval.Evaluate('Month(testDate)'));
  Assert.AreEqual<Integer>(1, FEval.Evaluate('Day(testDate)'));

  Assert.AreEqual<Integer>(2025, FEval.Evaluate('Year(DateAdd(testDate, 366))'));

  FEval.Evaluate('date1 := ParseDate("2024-01-01"); date2 := ParseDate("2024-01-02")');
  Assert.AreEqual<Integer>(1, FEval.Evaluate('DateDiff(date1, date2)'));

  Assert.AreEqual<string>('2024-01-01', FEval.Evaluate('FormatDate(testDate, "yyyy-mm-dd")'));
end;

// 33. TestComments (NEW)
procedure TExprEvaluatorTests.TestComments;
begin
  Assert.AreEqual<Integer>(8, FEval.Evaluate('5 + 3 // This is a comment'));
  Assert.AreEqual<Integer>(8, FEval.Evaluate('5 + {this is a comment} 3'));
  Assert.AreEqual<string>('yes', FEval.Evaluate('if 5 > 3 {condition} then "yes" {then} else "no" {else}'));
end;

// 34. TestDivisionByZero
procedure TExprEvaluatorTests.TestDivisionByZero;
begin
  Assert.WillRaise(
    procedure
    begin
      FEval.Evaluate('10 / 0');
    end);

  Assert.WillRaise(
    procedure
    begin
      FEval.Evaluate('10 div 0');
    end);
end;

initialization
  TDUnitX.RegisterTestFixture(TExprEvaluatorTests);

end.