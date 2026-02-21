# 🧩 Mini Compiler Front-End

This project implements a mini compiler front-end for a simple custom programming language using Lex (Flex) and Yacc (Bison) in C.

The system performs lexical analysis and syntax parsing for structured programs and produces interpreted outputs based on recognized constructs.

It was developed as part of a Compiler Design course to demonstrate core concepts of language processing and parsing.

---

## ✨ Features

- Header inclusion detection  
- Variable declaration and assignment  
- Arithmetic expression evaluation  
- Input and output operations  
- Loop handling (for, while)  
- Conditional execution (if–else)  
- User-defined function recognition  
- Comment detection  
- Syntax validation using grammar rules  

---

## ⚙️ Implementation

- Lexical analysis implemented using Flex  
- Parser and grammar rules implemented using Bison  
- Semantic actions written in C  
- Automated build process via Makefile  

### Key Files

- `fp.l` — lexical rules  
- `fp.y` — grammar and parser definition  
- `lex.yy.c`, `fp.tab.c` — generated source files  
- Executables generated after compilation  

---

## ▶️ How It Works

1. The lexical analyzer scans the input program and generates tokens.  
2. The parser validates syntax based on grammar rules.  
3. Semantic actions execute recognized constructs.  
4. The program outputs results and detected structures.

---

## 🎯 Purpose

This project demonstrates fundamental concepts of compiler construction, including tokenization, parsing, and grammar-driven language processing — foundational ideas relevant to NLP and language modeling research.
