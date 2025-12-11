# Delphi Expression Evaluator

[![Delphi](https://img.shields.io/badge/Delphi-10+-red.svg)](https://www.embarcadero.com/products/delphi)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-36%20Passing-green.svg)](unittest/)

A powerful runtime expression evaluator for Delphi. Parse and evaluate mathematical formulas, logical conditions, string operations, and custom functions at runtime.

**For complete documentation, examples, and API reference, visit: [danieleteti.it/delphiexprevaluator](https://www.danieleteti.it/delphiexprevaluator)**

## Features

- **Mathematical Operations**: `+`, `-`, `*`, `/`, `^`, `mod`, `div` with full precedence
- **Logical Operators**: `and`, `or`, `xor`, `not` with **short-circuit evaluation**
- **Pattern Matching**: `LIKE` operator with `*` and `?` wildcards
- **String Functions**: `contains()`, `Length()`, `Upper()`, `Lower()`, `Trim()`, `Replace()`, and more
- **Date Functions**: `Now()`, `Today()`, `ParseDate()`, `FormatDate()`, `DateAdd()`, `DateDiff()`
- **Aggregation**: `Min()`, `Max()`, `Sort()` with variable arguments
- **Variables**: Runtime variable assignment and retrieval
- **Custom Functions**: Register your own functions with lambda syntax
- **Interface-based API**: Automatic memory management, zero leaks

## Quick Start

```delphi
uses ExprEvaluator;

var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Arithmetic
  Result := Eval.Evaluate('2 + 3 * 4');           // 14
  Result := Eval.Evaluate('power(2, 10)');        // 1024

  // Variables
  Eval.SetVar('price', 100);
  Eval.SetVar('qty', 5);
  Result := Eval.Evaluate('price * qty');         // 500

  // Conditionals
  Result := Eval.Evaluate('if price > 50 then "expensive" else "cheap"');

  // Pattern matching
  Result := Eval.Evaluate('"report.pdf" like "*.pdf"');  // True

  // Short-circuit evaluation
  Result := Eval.Evaluate('false and ExpensiveFunc()');  // ExpensiveFunc NOT called!
end;
```

## Short-Circuit Evaluation

The evaluator implements true short-circuit evaluation:

```delphi
// AND: if left is false, right is NOT evaluated
Eval.Evaluate('false and SideEffectFunction()');  // Function never called

// OR: if left is true, right is NOT evaluated
Eval.Evaluate('true or SideEffectFunction()');    // Function never called
```

## LIKE Pattern Matching

SQL-style pattern matching with wildcards:

```delphi
// * matches zero or more characters
Eval.Evaluate('"hello.txt" like "*.txt"');        // True
Eval.Evaluate('"document.pdf" like "doc*"');      // True

// ? matches exactly one character
Eval.Evaluate('"file1.txt" like "file?.txt"');    // True

// Combined patterns
Eval.Evaluate('"backup_2024_01.zip" like "*_????_??.*"'); // True
```

## Custom Functions

```delphi
Eval.RegisterFunction('cube', function(const Args: array of Variant): Variant
  begin
    Result := Power(Args[0], 3);
  end);

Eval.Evaluate('cube(3)');  // 27
```

## Installation

1. Download or clone from [GitHub](https://github.com/danieleteti/delphi-expressions-evaluator)
2. Add the source folder to your Library Path
3. Add `uses ExprEvaluator;` to your unit

## Documentation

**Full documentation with all functions, operators, and examples:**

**[danieleteti.it/delphiexprevaluator](https://www.danieleteti.it/delphiexprevaluator)**

## Requirements

- Delphi 10 Seattle or later
- No external dependencies

## License

Apache 2.0 - Free for commercial and personal use.

## Support

- **Documentation**: [danieleteti.it/delphiexprevaluator](https://www.danieleteti.it/delphiexprevaluator)
- **Issues**: [GitHub Issues](https://github.com/danieleteti/delphi-expressions-evaluator/issues)
- **Community**: [Facebook Group](https://www.facebook.com/groups/delphimvcframework)
