# 🎯 Expression Evaluator REPL

An interactive REPL (Read-Eval-Print Loop) for the Delphi Expression Evaluator, similar to the Python interpreter.

## 🚀 Quick Start

```bash
# Compile
dcc32 ExprREPL.dpr

# Run
ExprREPL.exe
```

Or use:
```bash
build.bat    # Compile
run.bat      # Run
```

## 📖 Commands

| Command | Description |
|---------|-------------|
| `help` | Show complete help |
| `vars` | List defined variables |
| `funcs` | List available functions |
| `history` | Show command history |
| `clear` | Clear the screen |
| `exit` | Exit the REPL |

## 💡 Examples

```
>>> 2 + 2
4

>>> x := 10
10

>>> y := 20
20

>>> x + y
30

>>> name := "World"
"World"

>>> "Hello, " + name
"Hello, World"

>>> if x > 5 then "big" else "small"
"big"

>>> Min(10, 5, 8, 3)
3

>>> sqrt(16)
4

>>> vars
Defined Variables:
------------------
  X = 10
  Y = 20
  NAME = "World"
```

## 📦 Files

```
sample/REPL/
├── ExprREPL.dpr         # Main program
├── REPL.Engine.pas      # Evaluation engine
├── REPL.Commands.pas    # Command parser
├── REPL.Console.pas     # Console I/O
├── build.bat            # Build script
├── run.bat              # Run script
└── README.md            # This file
```

## 🎨 Features

- ✅ **Full REPL**: Interactive Read-Eval-Print Loop
- ✅ **Persistent Variables**: Save and reuse variables
- ✅ **Error Handling**: Continues after errors
- ✅ **Command History**: Tracks executed commands
- ✅ **Integrated Help**: Complete inline documentation
- ✅ **ANSI Colors**: Colored output (Windows/Linux/macOS)

## 🔧 Requirements

- Delphi 10+
- Windows, Linux or macOS

---

**Copyright (c) 2024-2025 Daniele Teti (www.danieleteti.it)**
