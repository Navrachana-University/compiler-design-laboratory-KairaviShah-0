Project Title: VibeCode – A Compiler for GenZ Slangs

Description:
VibeCode is a custom compiler that interprets a GenZ-inspired programming language using modern slang. Built with Flex (Lex) and Bison (Yacc), it features keywords like VIBECHECK, SLAPS, SENDIT, SPILLTHETEA, SUS, NOCAP, GOAT, etc.

The compiler performs:
- Lexical Analysis using Flex
- Syntax Analysis using Bison
- Code Generation:
  - Three Address Code (tac_output.txt)
  - Assembly-like Code (output.asm)

Supported Features:
- Variable declaration and assignment
- Arithmetic operations
- Conditional logic (SUS / NOCAP)
- Input and Output (SPILLTHETEA / SENDIT)
- Function definitions (SLAPS) and calls (GOAT)
- String and integer handling

Developed By:
- Kairavi Shah (Roll No: 22000916)
- Jeet Rathod (Roll No: 22000944)

Files Included:
- vibecode.l            → Lexical Analyzer
- vibecode.y            → Parser & Code Generator
- vibecode.tab.c/.h     → Bison output files
- lex.yy.c              → Flex output file
- vibecode.exe          → Compiled Executable (Windows)
- test.vc               → Sample input file
- tac_output.txt        → Three Address Code output
- output.asm            → Assembly-like Code output
- README.txt            → Documentation

How to Compile and Run:

Step 1: Install Flex and Bison (if not installed)
    sudo apt install flex bison

Step 2: Compile
    flex vibecode.l
    bison -d vibecode.y
    gcc lex.yy.c vibecode.tab.c -o vibecode

Step 3: Run the compiler
    ./vibecode test.vc

Step 4: View the outputs
    cat tac_output.txt
    cat output.asm

Note:
- Ensure your input file (test.vc) follows correct VibeCode syntax.
- Keep all files in the same directory for smooth execution.
