package com.asm
{
	
	internal class Architechture 
	{
		
		private static const _NOP:Opcode = new Opcode ( 0, true, new <String> [] );
		private static const _STR:Opcode = new Opcode ( 1, true, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _STM:Opcode = new Opcode ( 2, true, new <String> [ Args.ADDRESS, Args.CONSTANT ] );
		private static const _RLA:Opcode = new Opcode ( 3, true, new <String> [] );
		private static const _DRA:Opcode = new Opcode ( 4, true, new <String> [] );
		private static const _JPC:Opcode = new Opcode ( 5, true, new <String> [ Args.ADDRESS ] );
		private static const _JPR:Opcode = new Opcode ( 6, true, new <String> [ Args.REGISTER ] );
		private static const _JNZ:Opcode = new Opcode ( 7, true, new <String> [ Args.ADDRESS, Args.REGISTER ] );
		private static const _INC8:Opcode = new Opcode ( 8, true, new <String> [ Args.REGISTER ] );
		private static const _DEC8:Opcode = new Opcode ( 9, true, new <String> [ Args.REGISTER ] );
		private static const _ADDC8:Opcode = new Opcode ( 10, true, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _SUBC8:Opcode = new Opcode ( 11, true, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _MULC8:Opcode = new Opcode ( 12, true, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _DIVC8:Opcode = new Opcode ( 13, true, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _ADDR8:Opcode = new Opcode ( 14, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _SUBR8:Opcode = new Opcode ( 15, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _MULR8:Opcode = new Opcode ( 16, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _DIVR8:Opcode = new Opcode ( 17, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _PUSHC8:Opcode = new Opcode ( 18, true, new <String> [ Args.CONSTANT ] );
		private static const _PUSHR8:Opcode = new Opcode ( 19, true, new <String> [ Args.REGISTER ] );
		private static const _POP8:Opcode = new Opcode ( 20, true, new <String> [ Args.REGISTER ] );
		private static const _SMR:Opcode = new Opcode ( 21, true, new <String> [ Args.ADDRESS, Args.REGISTER ] );
		private static const _SRM:Opcode = new Opcode ( 22, true, new <String> [ Args.REGISTER, Args.ADDRESS ] );
		private static const _INT:Opcode = new Opcode ( 23, true, new <String> [ Args.CONSTANT ] );
		private static const _CLI:Opcode = new Opcode ( 24, true, new <String> [] );
		private static const _SEI:Opcode = new Opcode ( 25, true, new <String> [ Args.ADDRESS ] );
		private static const _RTI:Opcode = new Opcode ( 26, true, new <String> [ Args.CONSTANT ] );
		private static const _ANDC8:Opcode = new Opcode ( 27, true, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _ORC8:Opcode = new Opcode ( 28, true, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _XORC8:Opcode = new Opcode ( 29, true, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _ANDR8:Opcode = new Opcode ( 30, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _ORR8:Opcode = new Opcode ( 31, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _XORR8:Opcode = new Opcode ( 32, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _NOT8:Opcode = new Opcode ( 33, true, new <String> [ Args.REGISTER ] );
		private static const _CPR8:Opcode = new Opcode ( 34, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _ACTR:Opcode = new Opcode ( 35, true, new <String> [ Args.REGISTER, Args.DOUBLE_REGISTER ] );
		private static const _ACFR:Opcode = new Opcode ( 36, true, new <String> [ Args.DOUBLE_REGISTER, Args.REGISTER ] );
		private static const _BSLC8:Opcode = new Opcode ( 37, true, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _BSRC8:Opcode = new Opcode ( 38, true, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _BSLR8:Opcode = new Opcode ( 39, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _BSRR8:Opcode = new Opcode ( 40, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _JIF:Opcode = new Opcode ( 41, true, new <String> [ Args.CONSTANT, Args.ADDRESS ] );
		private static const _RTLC8:Opcode = new Opcode ( 42, true, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _RTRC8:Opcode = new Opcode ( 43, true, new <String> [ Args.REGISTER, Args.CONSTANT ] );
		private static const _RTLR8:Opcode = new Opcode ( 44, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _RTRR8:Opcode = new Opcode ( 45, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _JNF:Opcode = new Opcode ( 46, true, new <String> [ Args.CONSTANT, Args.ADDRESS ] );
		private static const _JZ:Opcode = new Opcode ( 47, true, new <String> [ Args.ADDRESS, Args.REGISTER ] );
		private static const _STDR:Opcode = new Opcode ( 48, false, new <String> [ Args.DOUBLE_REGISTER, Args.CONSTANT ] );
		private static const _INC16:Opcode = new Opcode ( 49, false, new <String> [ Args.DOUBLE_REGISTER, Args.CONSTANT ] );
		private static const _DEC16:Opcode = new Opcode ( 50, false, new <String> [ Args.DOUBLE_REGISTER, Args.CONSTANT ] );
		private static const _ADD16C:Opcode = new Opcode ( 51, false, new <String> [ Args.DOUBLE_REGISTER, Args.CONSTANT ] );
		private static const _SUB16C:Opcode = new Opcode ( 52, false, new <String> [ Args.DOUBLE_REGISTER, Args.CONSTANT ] );
		private static const _MUL16C:Opcode = new Opcode ( 53, false, new <String> [ Args.DOUBLE_REGISTER, Args.CONSTANT ] );
		private static const _DIV16C:Opcode = new Opcode ( 54, false, new <String> [ Args.DOUBLE_REGISTER, Args.CONSTANT ] );
		private static const _ADD16R:Opcode = new Opcode ( 55, false, new <String> [ Args.DOUBLE_REGISTER, Args.DOUBLE_REGISTER ] );
		private static const _SUB16R:Opcode = new Opcode ( 56, false, new <String> [ Args.DOUBLE_REGISTER, Args.DOUBLE_REGISTER ] );
		private static const _MUL16R:Opcode = new Opcode ( 57, false, new <String> [ Args.DOUBLE_REGISTER, Args.DOUBLE_REGISTER ] );
		private static const _DIV16R:Opcode = new Opcode ( 58, false, new <String> [ Args.DOUBLE_REGISTER, Args.DOUBLE_REGISTER ] );
		private static const _PUSH16C:Opcode = new Opcode ( 59, false, new <String> [ Args.CONSTANT ] );
		private static const _PUSH16R:Opcode = new Opcode ( 60, false, new <String> [ Args.DOUBLE_REGISTER ] );
		private static const _POP16:Opcode = new Opcode ( 61, false, new <String> [ Args.DOUBLE_REGISTER ] );
		private static const _SWP8:Opcode = new Opcode ( 62, true, new <String> [ Args.REGISTER, Args.REGISTER ] );
		private static const _SWP16:Opcode = new Opcode ( 63, false, new <String> [ Args.DOUBLE_REGISTER, Args.DOUBLE_REGISTER ] );
		private static const _CPR16:Opcode = new Opcode ( 64, false, new <String> [ Args.DOUBLE_REGISTER, Args.DOUBLE_REGISTER ] );
		
		private static const NOP:Instruction = new Instruction ( "NOP", new <Opcode> [ _NOP ] );
		private static const MOV:Instruction = new Instruction ( "MOV", new <Opcode> [ _STR, _STM, _SMR, _SRM, _ACTR, _ACFR, _CPR8, _STDR, _CPR16 ] );
		private static const RLA:Instruction = new Instruction ( "RLA", new <Opcode> [ _RLA ] );
		private static const DRA:Instruction = new Instruction ( "DRA", new <Opcode> [ _DRA ] );
		private static const JMP:Instruction = new Instruction ( "JMP", new <Opcode> [ _JPC, _JPR ] );
		private static const JNZ:Instruction = new Instruction ( "JNZ", new <Opcode> [ _JNZ ] );
		private static const INC:Instruction = new Instruction ( "INC", new <Opcode> [ _INC8 ] );
		private static const DEC:Instruction = new Instruction ( "DEC", new <Opcode> [ _DEC8 ] );
		private static const ADD:Instruction = new Instruction ( "ADD", new <Opcode> [ _ADDC8, _ADDR8, _ADD16C, _ADD16R ] );
		private static const SUB:Instruction = new Instruction ( "SUB", new <Opcode> [ _SUBC8, _SUBR8, _SUB16C, _SUB16R ] );
		private static const MUL:Instruction = new Instruction ( "MUL", new <Opcode> [ _MULC8, _MULR8, _MUL16C, _MUL16R ] );
		private static const DIV:Instruction = new Instruction ( "DIV", new <Opcode> [ _DIVC8, _DIVR8, _DIV16C, _DIV16R ] );
		private static const PUSH:Instruction = new Instruction ( "PUSH", new <Opcode> [ _PUSHC8, _PUSHR8, _PUSH16C, _PUSH16R ] );
		private static const POP:Instruction = new Instruction ( "POP", new <Opcode> [ _POP8, _POP16 ] );
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
		private static const JIF:Instruction = new Instruction ( "JIF", new <Opcode> [ _JIF ] );
		private static const RTL:Instruction = new Instruction ( "RTL", new <Opcode> [ _RTLC8, _RTLR8 ] );
		private static const RTR:Instruction = new Instruction ( "RTR", new <Opcode> [ _RTRC8, _RTRR8 ] );
		private static const JNF:Instruction = new Instruction ( "JIF", new <Opcode> [ _JNF ] );
		private static const JZ:Instruction = new Instruction ( "JZ", new <Opcode> [ _JZ ] );
		private static const SWP:Instruction = new Instruction ( "SWP", new <Opcode> [ _SWP8, _SWP16 ] );
		
		public static const OPCODE_SET:Vector.<Opcode> = new <Opcode> [ _NOP, _STR, _STM, _RLA, _DRA, _JPC, _JPR, _JNZ, _INC8, _DEC8, _ADDC8, _SUBC8, _MULC8, _DIVC8, _ADDR8, _SUBR8, _MULR8, _DIVR8, _PUSHC8, _PUSHR8, _POP8, _SMR, _SRM, _INT, _CLI, _SEI, _RTI, _ANDC8, _ORC8, _XORC8, _ANDR8, _ORR8, _XORR8, _NOT8, _CPR8, _ACTR, _ACFR, _BSLC8, _BSRC8, _BSLR8, _BSRR8, _JIF, _RTLC8, _RTRC8, _RTLR8, _RTRR8, _JNF, _JZ, _STDR, _INC16, _DEC16, _ADD16C, _SUB16C, _MUL16C, _DIV16C, _ADD16R, _SUB16R, _MUL16R, _DIV16R, _PUSH16C, _PUSH16R, _POP16, _SWP8, _SWP16, _CPR16 ];
		public static const INSTRUCTION_SET:Vector.<Instruction> = new <Instruction> [ NOP, MOV, RLA, DRA, JMP, JNZ, INC, DEC, ADD, SUB, MUL, DIV, PUSH, POP, INT, CLI, SEI, RTI, AND, OR, XOR, NOT, BSL, BSR, JIF, RTL, RTR, JNF, JZ, SWP ];
		
		private static const AX:Register = new Register ( "AX", 0 );
		private static const BX:Register = new Register ( "BX", 1 );
		private static const CX:Register = new Register ( "CX", 2 );
		private static const DX:Register = new Register ( "DX", 3 );
		private static const MX:Register = new Register ( "MX", 4 );
		private static const NX:Register = new Register ( "NX", 5 );
		private static const IWl:Register = new Register ( "IW-", 6 );
		private static const IWb:Register = new Register ( "IW+", 7 );
		private static const IXl:Register = new Register ( "IX-", 8 );
		private static const IXb:Register = new Register ( "IX+", 9 );
		private static const IYl:Register = new Register ( "IY-", 10 );
		private static const IYb:Register = new Register ( "IY+", 11 );
		private static const IZl:Register = new Register ( "IZ-", 12 );
		private static const IZb:Register = new Register ( "IZ+", 13 );
		private static const IAl:Register = new Register ( "IA-", 14 );
		private static const IAb:Register = new Register ( "IA+", 15 );
		private static const AL:Register = new Register ( "AL", 16 );
		private static const BL:Register = new Register ( "BL", 17 );
		private static const FL:Register = new Register ( "FL", 18 );
		private static const GL:Register = new Register ( "GL", 19 );
		private static const XLl:Register = new Register ( "XL-", 20 );
		private static const XLb:Register = new Register ( "XL+", 21 );
		private static const YLl:Register = new Register ( "YL-", 22 );
		private static const YLb:Register = new Register ( "YL+", 23 );
		
		public static const REGSITERS:Vector.<Register> = new <Register> [ AX, BX, CX, DX, MX, NX, IWl, IWb, IXl, IXb, IYl, IYb, IZl, IZb, IAl, IAb, AL, BL, FL, GL, XLl, XLb, YLl, YLb ];
		
	}
	
}