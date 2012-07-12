package com.asm
{
	
	internal class architechture 
	{
		
		private static const _NOP:opcode = new opcode ( 0, new <String> [] );
		private static const _STR:opcode = new opcode ( 1, new <String> [ args.REGISTER, args.CONSTANT ] );
		private static const _STM:opcode = new opcode ( 2, new <String> [ args.ADDRESS, args.CONSTANT ] );
		private static const _RLA:opcode = new opcode ( 3, new <String> [] );
		private static const _DRA:opcode = new opcode ( 4, new <String> [] );
		private static const _JPC:opcode = new opcode ( 5, new <String> [ args.ADDRESS ] );
		private static const _JPR:opcode = new opcode ( 6, new <String> [ args.REGISTER ] );
		private static const _JNZ:opcode = new opcode ( 7, new <String> [ args.ADDRESS, args.REGISTER ] );
		private static const _INC8:opcode = new opcode ( 8, new <String> [ args.REGISTER ] );
		private static const _DEC8:opcode = new opcode ( 9, new <String> [ args.REGISTER ] );
		private static const _ADDC8:opcode = new opcode ( 10, new <String> [ args.REGISTER, args.CONSTANT ] );
		private static const _SUBC8:opcode = new opcode ( 11, new <String> [ args.REGISTER, args.CONSTANT ] );
		private static const _MULC8:opcode = new opcode ( 12, new <String> [ args.REGISTER, args.CONSTANT ] );
		private static const _DIVC8:opcode = new opcode ( 13, new <String> [ args.REGISTER, args.CONSTANT ] );
		private static const _ADDR8:opcode = new opcode ( 14, new <String> [ args.REGISTER, args.REGISTER ] );
		private static const _SUBR8:opcode = new opcode ( 15, new <String> [ args.REGISTER, args.REGISTER ] );
		private static const _MULR8:opcode = new opcode ( 16, new <String> [ args.REGISTER, args.REGISTER ] );
		private static const _DIVR8:opcode = new opcode ( 17, new <String> [ args.REGISTER, args.REGISTER ] );
		private static const _PUSHC:opcode = new opcode ( 18, new <String> [ args.CONSTANT ] );
		private static const _PUSHR:opcode = new opcode ( 19, new <String> [ args.REGISTER ] );
		private static const _POP:opcode = new opcode ( 20, new <String> [ args.REGISTER ] );
		private static const _SMR:opcode = new opcode ( 21, new <String> [ args.ADDRESS, args.REGISTER ] );
		private static const _SRM:opcode = new opcode ( 22, new <String> [ args.REGISTER, args.ADDRESS ] );
		private static const _INT:opcode = new opcode ( 23, new <String> [ args.CONSTANT, args.DOUBLE_REGISTER ] );
		private static const _CLI:opcode = new opcode ( 24, new <String> [] );
		private static const _SEI:opcode = new opcode ( 25, new <String> [ args.ADDRESS ] );
		private static const _RTI:opcode = new opcode ( 26, new <String> [ args.CONSTANT ] );
		private static const _ANDC8:opcode = new opcode ( 27, new <String> [ args.REGISTER, args.CONSTANT ] );
		private static const _ORC8:opcode = new opcode ( 28, new <String> [ args.REGISTER, args.CONSTANT ] );
		private static const _XORC8:opcode = new opcode ( 29, new <String> [ args.REGISTER, args.CONSTANT ] );
		private static const _ANDR8:opcode = new opcode ( 30, new <String> [ args.REGISTER, args.REGISTER ] );
		private static const _ORR8:opcode = new opcode ( 31, new <String> [ args.REGISTER, args.REGISTER ] );
		private static const _XORR8:opcode = new opcode ( 32, new <String> [ args.REGISTER, args.REGISTER ] );
		private static const _NOT8:opcode = new opcode ( 33, new <String> [ args.REGISTER ] );
		private static const _CPR:opcode = new opcode ( 34, new <String> [ args.REGISTER, args.REGISTER ] );
		private static const _ACTR:opcode = new opcode ( 35, new <String> [ args.REGISTER, args.DOUBLE_REGISTER ] );
		private static const _ACFR:opcode = new opcode ( 36, new <String> [ args.DOUBLE_REGISTER, args.REGISTER ] );
		
		private static const NOP:instruction = new instruction ( "NOP", new <opcode> [ _NOP ] );
		private static const MOV:instruction = new instruction ( "MOV", new <opcode> [ _STR, _STM, _SMR, _SRM, _ACTR, _ACFR, _CPR ] );
		private static const RLA:instruction = new instruction ( "RLA", new <opcode> [ _RLA ] );
		private static const DRA:instruction = new instruction ( "DRA", new <opcode> [ _DRA ] );
		private static const JMP:instruction = new instruction ( "JMP", new <opcode> [ _JPC, _JPR ] );
		private static const JNZ:instruction = new instruction ( "JNZ", new <opcode> [ _JNZ ] );
		private static const INC:instruction = new instruction ( "INC", new <opcode> [ _INC8 ] );
		private static const DEC:instruction = new instruction ( "DEC", new <opcode> [ _DEC8 ] );
		private static const ADD:instruction = new instruction ( "ADD", new <opcode> [ _ADDC8, _ADDR8 ] );
		private static const SUB:instruction = new instruction ( "SUB", new <opcode> [ _SUBC8, _SUBR8 ] );
		private static const MUL:instruction = new instruction ( "MUL", new <opcode> [ _MULC8, _MULR8 ] );
		private static const DIV:instruction = new instruction ( "DIV", new <opcode> [ _DIVC8, _DIVR8 ] );
		private static const PUSH:instruction = new instruction ( "PUSH", new <opcode> [ _PUSHC, _PUSHR ] );
		private static const POP:instruction = new instruction ( "POP", new <opcode> [ _POP ] );
		private static const INT:instruction = new instruction ( "INT", new <opcode> [ _INT ] );
		private static const CLI:instruction = new instruction ( "CLI", new <opcode> [ _CLI ] );
		private static const SEI:instruction = new instruction ( "SEI", new <opcode> [ _SEI ] );
		private static const RTI:instruction = new instruction ( "RTI", new <opcode> [ _RTI ] );
		private static const AND:instruction = new instruction ( "AND", new <opcode> [ _ANDC8, _ANDR8 ] );
		private static const OR:instruction = new instruction ( "OR", new <opcode> [ _ORC8, _ORR8 ] );
		private static const XOR:instruction = new instruction ( "XOR", new <opcode> [ _XORC8, _XORR8 ] );
		private static const NOT:instruction = new instruction ( "NOT", new <opcode> [ _NOT8 ] );
		
		public static const OPCODE_SET:Vector.<opcode> = new <opcode> [ _NOP, _STR, _STM, _RLA, _DRA, _JPC, _JPR, _JNZ, _INC8, _DEC8, _ADDC8, _SUBC8, _MULC8, _DIVC8, _ADDR8, _SUBR8, _MULR8, _DIVR8, _PUSHC, _PUSHR, _POP, _SMR, _SRM, _INT, _CLI, _SEI, _RTI, _ANDC8, _ORC8, _XORC8, _ANDR8, _ORR8, _XORR8, _NOT8, _CPR, _ACTR, _ACFR ];
		public static const INSTRUCTION_SET:Vector.<instruction> = new <instruction> [ NOP, MOV, RLA, DRA, JMP, JNZ, INC, DEC, ADD, SUB, MUL, DIV, PUSH, POP, INT, CLI, SEI, RTI, AND, OR, XOR, NOT ];
		
		private static const AX:register = new register ( "AX", 0 );
		private static const BX:register = new register ( "BX", 1 );
		private static const CX:register = new register ( "CX", 2 );
		private static const DX:register = new register ( "DX", 3 );
		private static const MX:register = new register ( "MX", 4 );
		private static const NX:register = new register ( "NX", 5 );
		private static const IXl:register = new register ( "IX-", 6 );
		private static const IXb:register = new register ( "IX+", 7 );
		private static const IYl:register = new register ( "IY-", 8 );
		private static const IYb:register = new register ( "IY+", 9 );
		private static const IAl:register = new register ( "IA-", 10 );
		private static const IAb:register = new register ( "IA+", 11 );
		
		public static const REGSITERS:Vector.<register> = new <register> [ AX, BX, CX, DX, MX, NX, IXl, IXb, IYl, IYb, IAl, IAb ];
		
	}
	
}