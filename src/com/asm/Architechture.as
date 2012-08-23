package com.asm
{
	
	internal class Architechture 
	{
		
		private static const _NOP:Opcode = new Opcode ( 0, new <String> [] );
		private static const _STR:Opcode = new Opcode ( 1, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _STM:Opcode = new Opcode ( 2, new <String> [ Args.ADDRESS, Args.CONSTANT ] );
		private static const _RLA:Opcode = new Opcode ( 3, new <String> [] );
		private static const _DRA:Opcode = new Opcode ( 4, new <String> [] );
		private static const _JPC:Opcode = new Opcode ( 5, new <String> [ Args.ADDRESS ] );
		private static const _JPR:Opcode = new Opcode ( 6, new <String> [ Args.REGISTER ] );
		private static const _JNZ:Opcode = new Opcode ( 7, new <String> [ Args.ADDRESS, Args.REGISTER ] );
		private static const _INC8:Opcode = new Opcode ( 8, new <String> [ Args.REGISTER ] );
		private static const _DEC8:Opcode = new Opcode ( 9, new <String> [ Args.REGISTER ] );
		private static const _ADDC8:Opcode = new Opcode ( 10, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _SUBC8:Opcode = new Opcode ( 11, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _MULC8:Opcode = new Opcode ( 12, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _DIVC8:Opcode = new Opcode ( 13, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _ADDR8:Opcode = new Opcode ( 14, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _SUBR8:Opcode = new Opcode ( 15, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _MULR8:Opcode = new Opcode ( 16, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _DIVR8:Opcode = new Opcode ( 17, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _PUSHC:Opcode = new Opcode ( 18, new <String> [ Args.CONSTANT ] );
		private static const _PUSHR:Opcode = new Opcode ( 19, new <String> [ Args.REGISTER ] );
		private static const _POP:Opcode = new Opcode ( 20, new <String> [ Args.REGISTER ] );
		private static const _SMR:Opcode = new Opcode ( 21, new <String> [ Args.ADDRESS, Args.REGISTER ] );
		private static const _SRM:Opcode = new Opcode ( 22, new <String> [ Args.REGISTER, Args.ADDRESS ] );
		private static const _INT:Opcode = new Opcode ( 23, new <String> [ Args.CONSTANT, Args.DOUBLE_REGISTER ] );
		private static const _CLI:Opcode = new Opcode ( 24, new <String> [] );
		private static const _SEI:Opcode = new Opcode ( 25, new <String> [ Args.ADDRESS ] );
		private static const _RTI:Opcode = new Opcode ( 26, new <String> [ Args.CONSTANT ] );
		private static const _ANDC8:Opcode = new Opcode ( 27, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _ORC8:Opcode = new Opcode ( 28, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _XORC8:Opcode = new Opcode ( 29, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _ANDR8:Opcode = new Opcode ( 30, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _ORR8:Opcode = new Opcode ( 31, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _XORR8:Opcode = new Opcode ( 32, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _NOT8:Opcode = new Opcode ( 33, new <String> [ Args.REGISTER ] );
		private static const _CPR:Opcode = new Opcode ( 34, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _ACTR:Opcode = new Opcode ( 35, new <String> [ Args.REGISTER, Args.DOUBLE_REGISTER ] );
		private static const _ACFR:Opcode = new Opcode ( 36, new <String> [ Args.DOUBLE_REGISTER, Args.REGISTER ] );
		private static const _BSLC8:Opcode = new Opcode ( 37, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _BSRC8:Opcode = new Opcode ( 38, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _BSLR8:Opcode = new Opcode ( 39, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _BSRR8:Opcode = new Opcode ( 40, new <String> [ Args.REGISTER, Args.REGISTER ] );
		
		private static const NOP:Instruction = new Instruction ( "NOP", new <Opcode> [ _NOP ] );
		private static const MOV:Instruction = new Instruction ( "MOV", new <Opcode> [ _STR, _STM, _SMR, _SRM, _ACTR, _ACFR, _CPR ] );
		private static const RLA:Instruction = new Instruction ( "RLA", new <Opcode> [ _RLA ] );
		private static const DRA:Instruction = new Instruction ( "DRA", new <Opcode> [ _DRA ] );
		private static const JMP:Instruction = new Instruction ( "JMP", new <Opcode> [ _JPC, _JPR ] );
		private static const JNZ:Instruction = new Instruction ( "JNZ", new <Opcode> [ _JNZ ] );
		private static const INC:Instruction = new Instruction ( "INC", new <Opcode> [ _INC8 ] );
		private static const DEC:Instruction = new Instruction ( "DEC", new <Opcode> [ _DEC8 ] );
		private static const ADD:Instruction = new Instruction ( "ADD", new <Opcode> [ _ADDC8, _ADDR8 ] );
		private static const SUB:Instruction = new Instruction ( "SUB", new <Opcode> [ _SUBC8, _SUBR8 ] );
		private static const MUL:Instruction = new Instruction ( "MUL", new <Opcode> [ _MULC8, _MULR8 ] );
		private static const DIV:Instruction = new Instruction ( "DIV", new <Opcode> [ _DIVC8, _DIVR8 ] );
		private static const PUSH:Instruction = new Instruction ( "PUSH", new <Opcode> [ _PUSHC, _PUSHR ] );
		private static const POP:Instruction = new Instruction ( "POP", new <Opcode> [ _POP ] );
		private static const INT:Instruction = new Instruction ( "INT", new <Opcode> [ _INT ] );
		private static const CLI:Instruction = new Instruction ( "CLI", new <Opcode> [ _CLI ] );
		private static const SEI:Instruction = new Instruction ( "SEI", new <Opcode> [ _SEI ] );
		private static const RTI:Instruction = new Instruction ( "RTI", new <Opcode> [ _RTI ] );
		private static const AND:Instruction = new Instruction ( "AND", new <Opcode> [ _ANDC8, _ANDR8 ] );
		private static const OR:Instruction = new Instruction ( "OR", new <Opcode> [ _ORC8, _ORR8 ] );
		private static const XOR:Instruction = new Instruction ( "XOR", new <Opcode> [ _XORC8, _XORR8 ] );
		private static const NOT:Instruction = new Instruction ( "NOT", new <Opcode> [ _NOT8 ] );
		private static const BSL:Instruction = new Instruction ( "BSL", new <Opcode> [ _BSLC8, _BSLR8 ] );
		private static const BSR:Instruction = new Instruction ( "BSR", new <Opcode> [ _BSRC8, _BSRR8 ] );
		
		public static const OPCODE_SET:Vector.<Opcode> = new <Opcode> [ _NOP, _STR, _STM, _RLA, _DRA, _JPC, _JPR, _JNZ, _INC8, _DEC8, _ADDC8, _SUBC8, _MULC8, _DIVC8, _ADDR8, _SUBR8, _MULR8, _DIVR8, _PUSHC, _PUSHR, _POP, _SMR, _SRM, _INT, _CLI, _SEI, _RTI, _ANDC8, _ORC8, _XORC8, _ANDR8, _ORR8, _XORR8, _NOT8, _CPR, _ACTR, _ACFR, _BSLC8, _BSRC8, _BSLR8, _BSRR8 ];
		public static const INSTRUCTION_SET:Vector.<Instruction> = new <Instruction> [ NOP, MOV, RLA, DRA, JMP, JNZ, INC, DEC, ADD, SUB, MUL, DIV, PUSH, POP, INT, CLI, SEI, RTI, AND, OR, XOR, NOT, BSL, BSR ];
		
		private static const AX:Register = new Register ( "AX", 0 );
		private static const BX:Register = new Register ( "BX", 1 );
		private static const CX:Register = new Register ( "CX", 2 );
		private static const DX:Register = new Register ( "DX", 3 );
		private static const MX:Register = new Register ( "MX", 4 );
		private static const NX:Register = new Register ( "NX", 5 );
		private static const IXl:Register = new Register ( "IX-", 6 );
		private static const IXb:Register = new Register ( "IX+", 7 );
		private static const IYl:Register = new Register ( "IY-", 8 );
		private static const IYb:Register = new Register ( "IY+", 9 );
		private static const IAl:Register = new Register ( "IA-", 10 );
		private static const IAb:Register = new Register ( "IA+", 11 );
		
		public static const REGSITERS:Vector.<Register> = new <Register> [ AX, BX, CX, DX, MX, NX, IXl, IXb, IYl, IYb, IAl, IAb ];
		
	}
	
}