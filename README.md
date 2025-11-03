# 🧮 Delphi Expression Evaluator

[![Delphi](https://img.shields.io/badge/Delphi-10+-red.svg)](https://www.embarcadero.com/products/delphi)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-Passing-green.svg)](TestEvaluator.dpr)
[![Interface](https://img.shields.io/badge/API-Interface%20Based-brightgreen.svg)](#-memory-management)

A powerful, flexible, and modern mathematical expression evaluator written in Object Pascal/Delphi. Parse and evaluate complex mathematical expressions, string operations, logical conditions, and custom functions at runtime with **automatic memory management** through interface-based API. Full support for variables, type conversions, and conditional statements with zero memory leaks.

## ✨ Features

### 🔢 **Mathematical Operations**
- **Arithmetic**: `+`, `-`, `*`, `/`, `^` (power), `mod`, `div` (integer division)
- **Negative Numbers**: Full support for negative literals and unary minus (`-5`, `-(x + y)`)
- **Advanced Math Functions**: `sqrt()`, `log()` (base 10), `logn()` (natural log), `round()`, `abs()`, `floor()`, `ceil()`, `power()`
- **Aggregation Functions**: `Min()`, `Max()` (2+ numeric arguments), `Sort()` (2+ homogeneous arguments with QuickSort O(n log n))
- **Operator Precedence**: Fully compliant with mathematical precedence rules
- **Parentheses Support**: Nested expressions with proper grouping

### 🔤 **String Operations**
- **String Literals**: Double-quoted strings (`"Hello World"`)
- **Concatenation**: Automatic string concatenation with `+` operator
- **Type Conversion**: `ToString()` for number-to-string conversion
- **String Comparison**: Full support for string equality and comparison
- **String Functions**: `contains()` for substring search (case-insensitive)
- **Edge Cases**: Empty strings, special characters, very long strings fully supported

### 🔄 **Type Conversion Functions**
- **`ToInteger(string)`**: Convert strings to integers
  ```pascal
  ToInteger("123") // Returns 123
  ToInteger(ToString(42) + "0") // Returns 420
  ```
- **`ToFloat(string)`**: Convert strings to floating-point numbers
  ```pascal
  ToFloat("123.45") // Returns 123.45
  ToFloat("3.14159") // Returns 3.14159
  ```

### 🧠 **Logical Operations**
- **Boolean Logic**: `and`, `or`, `xor`, `not` (proper precedence and left-to-right evaluation)
- **Unary Negation**: `not` operator for boolean negation (`not true`, `not (x > 5)`)
- **Comparisons**: `=`, `<>`, `<`, `<=`, `>`, `>=`
- **Boolean Constants**: `true`, `false` (case-insensitive)
- **Complex Conditions**: Nested logical expressions with proper precedence
- **Type Safety**: Strict validation of logical operands

### 🔀 **Conditional Statements**
- **If-Then-Else**: Full conditional expression support
  ```pascal
  if condition then value1 else value2
  ```
- **Nested Conditionals**: Multiple levels of nesting supported
- **Complex Conditions**: Combine with logical and comparison operators

### 📊 **Variables**
- **Dynamic Variables**: Create and modify variables at runtime
- **Assignment Operator**: `:=` for variable assignment
- **Persistent State**: Variables maintain their values across evaluations
- **Type Flexibility**: Automatic type handling (numbers, strings, booleans)
- **Case Insensitive**: Variable names are case-insensitive (`x`, `X`, `var123`, `_var`)
- **Edge Cases**: Support for special variable names with underscores and numbers

### 🔧 **Extensibility**
- **Custom Functions**: Register your own functions with `RegisterFunction()`
- **Function Arguments**: Support for multiple arguments and complex expressions
- **Lambda Support**: Modern Delphi anonymous function syntax
- **Runtime Registration**: Add functions dynamically during execution
- **Type Validation**: Built-in functions include strict type checking with descriptive error messages
- **Variable Arguments**: Functions like `Min()`, `Max()`, `Sort()` accept 2+ arguments

### 🔄 **Modern Memory Management**
- **Interface-based API**: `IExprEvaluator` with automatic memory management (⭐ **Recommended**)
- **Reference Counting**: No need for manual `Create`/`Free` calls - zero memory leaks guaranteed
- **Exception Safety**: Automatic cleanup even when exceptions occur
- **Thread Safe**: Reference counting is thread-safe by design
- **Legacy Support**: Traditional class-based API available when direct object access is required

> **🚀 Key Advantage**: Write cleaner, safer code with automatic resource management - just create and use, no cleanup required!

## 🚀 Quick Start

### Basic Usage

```pascal
uses ExprEvaluator;

var
  Eval: IExprEvaluator;
  Result: Variant;
begin
  // No need for try/finally - automatic memory management!
  Eval := CreateExprEvaluator;

  // Simple arithmetic
  Result := Eval.Evaluate('2 + 3 * 4'); // Returns 14
  Result := Eval.Evaluate('10 div 3'); // Returns 3 (integer division)
  Result := Eval.Evaluate('-5 + 3'); // Returns -2 (negative numbers)

  // String operations
  Result := Eval.Evaluate('"Hello" + " " + "World"'); // Returns "Hello World"
  Result := Eval.Evaluate('contains("test", "This is a test")'); // Returns True

  // Type conversions
  Result := Eval.Evaluate('ToInteger("42") + ToFloat("3.14")'); // Returns 45.14

  // Variables
  Eval.SetVar('x', 10);
  Eval.SetVar('y', 20);
  Result := Eval.Evaluate('x + y'); // Returns 30

  // Conditionals
  Result := Eval.Evaluate('if x > y then "X is greater" else "Y is greater"');

  // Aggregation functions
  Result := Eval.Evaluate('Min(5, 3, 8, 1)'); // Returns 1
  Result := Eval.Evaluate('Max(10, 25, 3)'); // Returns 25
  Result := Eval.Evaluate('Sort(5, 3, 8, 1)'); // Returns "1,3,5,8"

  // Interface is automatically released when goes out of scope
end;
```

#### **Interface vs Class Comparison**

| Feature | Interface (`IExprEvaluator`) | Class (`TExprEvaluator`) |
|---------|------------------------------|--------------------------|
| **Memory Management** | ✅ Automatic (Reference Counting) | ❌ Manual (`try/finally`) |
| **Exception Safety** | ✅ Always Safe | ⚠️ Requires proper cleanup |
| **Code Simplicity** | ✅ Clean & Simple | ❌ More boilerplate |
| **Memory Leaks** | ✅ Zero Risk | ⚠️ Risk if cleanup forgotten |
| **Thread Safety** | ✅ Reference counting | ⚠️ Manual synchronization |
| **Recommended** | ✅ **Yes - Primary API** | ⚠️ Only when class access needed |

> **💡 Best Practice**: Always use `IExprEvaluator` unless you specifically need direct class access for framework integration, RTTI, or serialization.

### Legacy Class Usage (When Direct Object Access is Required)

```pascal
uses ExprEvaluator;

var
  Eval: TExprEvaluator;
  Result: Variant;
begin
  Eval := TExprEvaluator.Create;
  try
    Result := Eval.Evaluate('2 + 3 * 4');
    // Use when you need direct access to the class implementation
    // or when working with frameworks that require concrete classes
  finally
    Eval.Free; // Manual memory management required
  end;
end;
```

### Advanced Examples

#### Mathematical Calculations
```pascal
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // New math functions
  Result := Eval.Evaluate('abs(-15.5)'); // Absolute value: 15.5
  Result := Eval.Evaluate('floor(3.7) + ceil(2.3)'); // 3 + 3 = 6
  Result := Eval.Evaluate('power(2, 10)'); // 1024

  // Complex mathematical expression with negative numbers
  Result := Eval.Evaluate('sqrt(16) + log(100) * 2^3 - (-5)'); // Returns 25
  Result := Eval.Evaluate('10 div 3 + 15 mod 4'); // Returns 6

  // Scientific calculations with conversions and aggregation
  Eval.SetVar('pi', ToFloat('3.14159'));
  Eval.SetVar('radius', 5);
  Result := Eval.Evaluate('pi * radius^2'); // Area calculation
  Result := Eval.Evaluate('Min(abs(error1), abs(error2), abs(error3))'); // Find minimum absolute error
end;
```

#### String Processing
```pascal
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Dynamic string building with sorting
  Result := Eval.Evaluate('"Sorted: " + Sort("zebra", "apple", "banana")');
  // Returns "Sorted: apple,banana,zebra"

  // String conversion chains with negative numbers
  Result := Eval.Evaluate('ToInteger(ToString(-15) + "5") + 10'); // Returns -145

  // String search and validation
  Result := Eval.Evaluate('if contains("cache", config_flags) then "enabled" else "disabled"');
end;
```

#### Logical Operations
```pascal
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Complex boolean logic with NOT operator
  Result := Eval.Evaluate('not (x > 10) and y < 5'); // NOT operator with precedence
  Result := Eval.Evaluate('not false or not true'); // Multiple NOT operators

  // Complex boolean logic with aggregation
  Result := Eval.Evaluate('(ToInteger("1") = 1 and ToFloat("2.0") = 2.0) or false');
  Result := Eval.Evaluate('Min(value1, value2) > 0 and Max(score1, score2, score3) < 100');

  // Conditional logic with mixed types and negative numbers
  Result := Eval.Evaluate('if ToFloat("-12.5") < 0 and ToInteger("5") > 0 then sqrt(16) else log(100)');
end;
```

#### Custom Functions
```pascal
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator;

  // Register a custom function
  Eval.RegisterFunction('cube', function(const Args: array of Variant): Variant
    begin
      if Length(Args) <> 1 then
        raise Exception.Create('cube requires 1 argument');
      Result := System.Math.Power(Args[0], 3);
    end);

  // Use the custom function
  Result := Eval.Evaluate('cube(3)'); // Returns 27

  // Combine with other operations
  Result := Eval.Evaluate('cube(ToInteger("4")) + sqrt(ToFloat("16.0"))'); // Returns 68
end;
```

## 📚 API Reference

### Creating Evaluator Instances

#### Interface-based (Recommended)
```pascal
var
  Eval: IExprEvaluator;
begin
  Eval := CreateExprEvaluator; // Automatic memory management
  // Use Eval...
end; // Automatically freed
```

#### Class-based (When Required)
```pascal
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    // Use Eval...
    // Only needed when direct class access is required
  finally
    Eval.Free; // Manual cleanup required
  end;
end;
```

> **🎯 Best Practice**: Always prefer the interface-based approach unless you specifically need direct access to the class implementation or are working with frameworks that require concrete classes.

### Core Methods
| Method | Description | Example |
|--------|-------------|---------|
| `Evaluate(expr)` | Evaluate expression and return result | `Eval.Evaluate('2 + 3')` |
| `SetVar(name, value)` | Set variable value | `Eval.SetVar('x', 42)` |
| `GetVar(name)` | Get variable value | `value := Eval.GetVar('x')` |
| `RegisterFunction(name, handler)` | Register custom function | See examples below |

### Built-in Mathematical Functions
| Function | Description | Example |
|----------|-------------|---------|
| `sqrt(x)` | Square root | `sqrt(16)` → `4` |
| `log(x)` | Logarithm base 10 | `log(100)` → `2` |
| `logn(x)` | Natural logarithm | `logn(2.71828)` → `≈1` |
| `round(x, digits)` | Round to specified digits | `round(3.14159, 2)` → `3.14` |
| `abs(x)` | Absolute value | `abs(-5)` → `5` |
| `floor(x)` | Floor function (round down) | `floor(3.7)` → `3` |
| `ceil(x)` | Ceiling function (round up) | `ceil(3.2)` → `4` |
| `power(x, y)` | Power function (x^y) | `power(2, 3)` → `8` |
| `Min(x, y, ...)` | Minimum of 2+ numbers | `Min(5, 3, 8)` → `3` |
| `Max(x, y, ...)` | Maximum of 2+ numbers | `Max(5, 3, 8)` → `8` |

### Type Conversion and Utility Functions
| Function | Description | Example |
|----------|-------------|---------|
| `ToString(x)` | Convert to string | `ToString(-42)` → `"-42"` |
| `ToInteger(s)` | Convert string to integer | `ToInteger("-123")` → `-123` |
| `ToFloat(s)` | Convert string to float | `ToFloat("-3.14")` → `-3.14` |
| `contains(needle, haystack)` | Check if string contains substring | `contains("test", "testing")` → `True` |
| `Sort(x, y, ...)` | Sort 2+ homogeneous values (QuickSort) | `Sort(5, 1, 3)` → `"1,3,5"` |

### Operators
| Category | Operators | Precedence | Notes |
|----------|-----------|------------|-------|
| Assignment | `:=` | Lowest | Variable assignment |
| Conditional | `if-then-else` | | Full conditional expressions |
| Logical | `or`, `xor` | | Left-to-right evaluation |
| Logical | `and` | | Left-to-right evaluation |
| Comparison | `=`, `<>`, `<`, `<=`, `>`, `>=` | | String and numeric comparison |
| Addition | `+`, `-` | | String concatenation with `+` |
| Multiplication | `*`, `/`, `mod`, `div` | | Integer division with `div` |
| Unary | `-`, `not` | | Unary minus and boolean negation |
| Exponentiation | `^` | | Power operator |
| Parentheses | `()` | Highest | Grouping and function calls |

## 🏗️ Architecture

### Parser Hierarchy
The evaluator uses a recursive descent parser with the following hierarchy:

1. **ParseAssignment**: Handles variable assignments (`:=`)
2. **ParseIfExpression**: Processes conditional statements (`if-then-else`)
3. **ParseLogical**: Manages logical operators (`and`, `or`, `xor`)
4. **ParseRelational**: Handles comparison operators (`=`, `<`, `>`, etc.)
5. **ParseAdditive**: Processes addition and subtraction (`+`, `-`)
6. **ParseMultiplicative**: Handles multiplication, division, modulo, and integer division (`*`, `/`, `mod`, `div`)
7. **ParseFactor**: Manages exponentiation (`^`)
8. **ParsePrimary**: Processes literals, variables, functions, and parentheses

### Key Design Features
- **Proper Precedence**: Mathematical and logical operator precedence strictly followed
- **Negative Number Support**: Full parsing and evaluation of negative literals and expressions
- **Robust Error Handling**: Comprehensive error messages for syntax and runtime errors
- **Memory Management**: Automatic cleanup and proper resource management via interfaces
- **Type Safety**: Strict runtime type checking with descriptive error messages
- **Case Insensitive**: All keywords, functions, and variables are case-insensitive
- **Extensible Design**: Easy to add new functions and operators with helper functions
- **Performance Optimized**: Handles complex expressions with 100+ terms and deep nesting

## 🧪 Testing

The project includes an extensive test suite with **500+ test assertions** across **22+ test procedures** covering both interface and class-based APIs:

### Comprehensive Test Coverage
- ✅ **Basic Operations**: All arithmetic, string, logical operations with edge cases
- ✅ **Negative Numbers**: Complete coverage in all contexts and operations
- ✅ **Advanced Functions**: Min, Max, Sort with 2-100+ arguments and type validation
- ✅ **String Edge Cases**: Empty strings, special characters, very long strings
- ✅ **Boolean Logic**: All combinations, precedence, and associativity
- ✅ **Type Validation**: Strict checking with descriptive error messages
- ✅ **Variable Management**: Case-insensitivity, special names, overwriting
- ✅ **Function Arguments**: Extreme values, invalid types, boundary conditions
- ✅ **Expression Complexity**: Deep nesting, long chains, performance stress
- ✅ **Error Recovery**: Malformed input, syntax errors, graceful failure

### Advanced Integration Tests
- ✅ **Complex Expressions**: Nested conditionals, mixed operators, 100+ terms
- ✅ **Performance Testing**: Stress tests with extreme inputs and deep recursion
- ✅ **Interface Safety**: Automatic memory management and exception safety
- ✅ **Border Cases**: Division by zero, extreme values, floating-point precision
- ✅ **Case Insensitivity**: All functions and keywords in various cases
- ✅ **Cross-type Operations**: Complex type conversions and validations

### API Coverage
- 🔵 **Interface API (`IExprEvaluator`)**: 22+ comprehensive test procedures with 500+ assertions
- 🔵 **Class API (`TExprEvaluator`)**: Full compatibility and legacy support
- 🔵 **Edge Case Coverage**: Every function tested with boundary conditions
- 🔵 **Error Handling**: Comprehensive validation of all error scenarios

### Running Tests
```bash
# Compile and run comprehensive test suite
dcc32 test/TestEvaluator.dpr
./test/TestEvaluator.exe

# Or use the pre-compiled version
./bin/TestEvaluator.exe
```

### Test Coverage Examples
```pascal
// Negative number edge cases
Assert(Eval.Evaluate('-5 + 3') = -2);
Assert(Eval.Evaluate('(-2) ^ 3') = -8);
Assert(Eval.Evaluate('Min(-10, -5, -15)') = -15);

// Advanced function combinations
Assert(Eval.Evaluate('Sort(Max(1,2), Min(5,3), 4)') = '2,3,4');
Assert(Eval.Evaluate('ToInteger(ToString(-15) + "5") + 10') = -145);

// Complex type validation and edge cases
Assert(Eval.Evaluate('if contains("test", data) then Sort(a,b,c) else "none"'));
Assert(Eval.Evaluate('Min(sqrt(16), log(100), ToFloat("3.14"))') = 2);
```

## 🎯 Use Cases

### 📊 **Dynamic Formula Evaluation**
Perfect for applications that need runtime formula evaluation:
- Spreadsheet-like applications
- Financial calculators
- Scientific computing tools
- Configuration-driven calculations

### 🔧 **Rule Engines**
Implement complex business rules:
- Validation logic
- Decision trees
- Conditional processing
- Policy enforcement

### 🎮 **Scripting Support**
Add lightweight scripting to applications:
- Game mechanics
- User customization
- Macro systems
- Plugin architectures

### 📈 **Data Processing**
Process and transform data dynamically:
- ETL operations
- Data validation
- Computed columns
- Dynamic reporting

## 🔧 Advanced Usage

### When to Use Direct Class Access

While the interface-based approach is recommended for most scenarios, there are specific cases where you might need direct access to the `TExprEvaluator` class:

#### Framework Integration
```pascal
// When working with frameworks that require concrete classes
var
  Eval: TExprEvaluator;
begin
  Eval := TExprEvaluator.Create;
  try
    // Pass to framework that expects TObject descendant
    SomeFramework.RegisterEvaluator(Eval);
  finally
    Eval.Free;
  end;
end;
```

#### Custom Serialization
```pascal
// When you need to serialize/deserialize the evaluator state
var
  Eval: TExprEvaluator;
  Stream: TStream;
begin
  Eval := TExprEvaluator.Create;
  try
    // Custom serialization logic that requires class access
    SerializeEvaluator(Eval, Stream);
  finally
    Eval.Free;
  end;
end;
```

#### RTTI Operations
```pascal
// When you need Runtime Type Information
var
  Eval: TExprEvaluator;
  Context: TRttiContext;
begin
  Eval := TExprEvaluator.Create;
  try
    Context := TRttiContext.Create;
    // Perform RTTI operations on the class
    ProcessTypeInfo(Context.GetType(Eval.ClassType));
  finally
    Eval.Free;
    Context.Free;
  end;
end;
```

> **💡 Recommendation**: Even in these advanced scenarios, consider wrapping the class-based code in helper functions that expose interface-based APIs to the rest of your application.

## 📋 Requirements

- **Delphi**: 10 Seattle or later (tested with Delphi 12)
- **RTL Units**: `System.SysUtils`, `System.Variants`, `System.Math`, `System.Generics.Collections`
- **Target Platforms**: Windows 32/64-bit, Linux, macOS, mobile platforms

## 🤝 Contributing

Contributions are welcome! Whether it's:
- 🐛 Bug reports and fixes
- ✨ New features and enhancements
- 📚 Documentation improvements
- 🧪 Additional test cases
- 💡 Performance optimizations

### Development Guidelines
1. **Code Style**: Follow Object Pascal conventions
2. **Testing**: Add tests for new features
3. **Documentation**: Update README and code comments
4. **Backward Compatibility**: Maintain API compatibility when possible

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with modern Object Pascal/Delphi
- Inspired by mathematical expression parsing techniques
- Designed for real-world application requirements
- Community-driven development approach

---

<div align="center">

**[⭐ Star this project](../../stargazers) | [🐛 Report Issues](../../issues) | [💬 Discussions](../../discussions)**

*Made with ❤️ for the Delphi community*

</div>