package com.vm.system
{
	import com.vm.memory.IMemoryDevice;
	
	public final class Processor
	{
		
		private var mem:IMemoryDevice;
		private var dbs:DataBus;
		
		private var ihs:Boolean = true;  // interrupt handler satisfied
		private var ito:uint = 0;        // interrupt time out
		
		private var IRP:uint = 0; // Interrupt handler pointer
		private var ISP:uint = 0; // Instruction pointer
		
		private var STP:uint = 0; // Stack pointer
		
		private var AX:uint = 0;  // General purpose Registers ( 8-bit )
		private var BX:uint = 0;
		private var CX:uint = 0;
		private var DX:uint = 0;
		private var MX:uint = 0;
		private var NX:uint = 0;
		
		private var IW:uint = 0;  // Adressing Registers ( 16-bit )
		private var IX:uint = 0;  
		private var IY:uint = 0;
		private var IZ:uint = 0;
		
		internal var AL:uint = 0;  // Interrupt registers ( 8-bit )
		internal var BL:uint = 0;
		internal var FL:uint = 0;
		internal var GL:uint = 0;
		
		internal var XL:uint = 0;  // Interrupt registers ( 16-bit )
		internal var YL:uint = 0;
		
		private var IA:uint = 0;  // Accumulator Register ( 16-bit )
		
		private var CF:Boolean = false; // Carry flag
		private var NF:Boolean = false; // Interrupt flag
		private var ZF:Boolean = false; // Zero flag
		private var AF:Boolean = false; // Adressing flagd
		
		private var NSINC:uint = 0;
		
		private var ASC:Vector.<Function>;
		
		public final function Processor ( memory:IMemoryDevice, dataBus:DataBus ) : void
		{
			
			mem = memory;
			dbs = dataBus;
			dbs._cpu = this;
			//                      0    1    2    3    4    5    6    7    8     9     10    11    12    13    14    15    16    17     18      19     20   21   22   23   24   25   26    27     28    29     30     31    32     33   34    35    36    37     38     39     40    41    42     43     44     45    46   47   48    49     50      51      52      53      54      55      56      57      58      59       60      61     62     63     64
			ASC = new <Function> [ NOP, STR, STM, RLA, DRA, JPC, JPR, JNZ, INC8, DEC8, ADC8, SBC8, MLC8, DVC8, ADR8, SBR8, MLR8, DVR8, PUSHC8, PUSHR8, POP8, SMR, SRM, INT, CLI, SEI, RTI, ANDC8, ORC8, XORC8, ANDR8, ORR8, XORR8, NOT8, CPR8, ACTR, ACFR, BSLC8, BSRC8, BSLR8, BSRR8, JIF, RTLC8, RTRC8, RTLR8, RTRR8, JNF, JZ, STDR, INC16, DEC16, ADD16C, SUB16C, MUL16C, DIV16C, ADD16R, SUB16R, MUL16R, DIV16R, PUSH16C, PUSH16R, POP16, SWP8, SWP16, CPR16 ];
			STP = mem.length - 1;
			
			return;
			
		};
		
		public final function reset ( Entry:uint ) : void
		{
			
			AX = 0;
			BX = 0;
			CX = 0;
			DX = 0;
			MX = 0;
			NX = 0;
			IX = 0;
			IY = 0;
			IA = 0;
			
			ISP = Entry;
			
		};
		
		public final function step () : void
		{
			
			var opc:uint = getByteAt ( ISP );
			
			ASC [ opc ] ();
			
			ISP += NSINC;
			
			if ( ito > 0 )
				ito --;
			
			return;
			
		};
		
		public final function interrupt ( num:uint, A:int, B:int, F:int, G:int, X:int, Y:int ) : Boolean
		{
			
			if ( readyToInterrupt )
			{
				
				ihs = false;
				
				STP --;
				setByteAt ( STP, ( ISP & 0xFF00 ) >> 8 );
				STP --;
				setByteAt ( STP, ISP & 0x00FF );
				
				ISP = IRP;
				
				if ( A >= 0 )
					AL = ( A & 0xFF );
				if ( B >= 0 )
					BL = ( B & 0xFF );
				if ( F >= 0 )
					FL = ( F & 0xFF );
				if ( G >= 0 )
					GL = ( G & 0xFF );
				
				if ( X >= 0 )
					XL = ( X & 0xFFFF );
				if ( Y >= 0 )
					YL = ( Y & 0xFFFF );
				
				return true;
				
			}
			
			return false;
			
		};
		
		// ---- [   Execution functions   ] ---- //
		
		private final function NOP () : void // No operation
		{
			
			NSINC = 1;
			return;
			
		};
		
		private final function STR () : void // Set Register
		{
			
			var reg:uint;
			var val:uint;
			reg = getByteAt ( ISP + 1 );
			val = getByteAt ( ISP + 2 );
			setReg ( reg, val );
			NSINC = 3;
			return;
			
		};
		
		private final function STM () : void // Set Memory
		{
			
			var mad:int;
			var val:uint;
			mad = getDoubleAt ( ISP + 1 );
			val = getByteAt ( ISP + 3 );
			NSINC = 4;
			if ( AF )
				setByteAt ( mad - 0x7FFF + ISP, val );
			else
				setByteAt ( mad, val );
			return;
			
		};
		
		private final function RLA () : void // Relative adressing
		{
			
			AF = true;
			NSINC = 1;
			return;
			
		};
		
		private final function DRA () : void // Direct adressing
		{
			
			AF = false;
			NSINC = 1;
			return;
			
		};
		
		private final function JPC () : void // Jump to constant
		{
			
			var add:int;
			add = getDoubleAt ( ISP + 1 );
			if ( AF )
				ISP += add - 0x7FFF;
			else
				ISP = add;
			NSINC = 0;
			return;
			
		};
		
		private final function JPR () : void // Jump to address in Register
		{
			
			var reg1:uint;
			var reg2:uint;
			var add:int;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			add = getReg ( reg1 ) + ( getReg ( reg2 ) << 8 );
			if ( AF )
				ISP += add - 0x7FFF;
			else
				ISP = add;
			NSINC = 0;
			return;
			
		};
		
		private final function JNZ () : void // Jump if not zero
		{
			
			var reg:uint;
			var evl:uint;
			var add:int;
			add = getDoubleAt ( ISP + 1 );
			reg = getByteAt ( ISP + 3 );
			evl = getReg ( reg );
			if ( evl != 0 )
			{
				if ( AF )
					ISP += add - 0x7FFF;
				else
					ISP = add;
				NSINC = 0;
				return;
			}
			NSINC = 4;
			return;
			
		};
		
		private final function INC8 () : void // Increments Registers
		{
			
			var reg:uint;
			var vui:uint;
			reg = getByteAt ( ISP + 1 );
			vui = getReg ( reg );
			vui ++;
			setReg ( reg, vui );
			NSINC = 2;
			return;
			
		};
		
		private final function DEC8 () : void // Increments Registers
		{
			
			var reg:uint;
			var vui:uint;
			reg = getByteAt ( ISP + 1 );
			vui = getReg ( reg );
			vui --;
			setReg ( reg, vui );
			NSINC = 2;
			return;
			
		};
		
		private final function ADC8 () : void // Adds together an 8 bit Register and constant
		{
			
			var reg:uint;
			var con:uint;
			var pdc:uint;
			reg = getByteAt ( ISP + 1 );
			con = getByteAt ( ISP + 2 );
			pdc = getReg ( reg ) + con;
			setReg ( 14, pdc & 0xFF );
			setReg ( 15, ( pdc & 0xFF00 ) >> 8 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function SBC8 () : void // Subtracts a constant from an 8-bit Register
		{
			
			var reg:uint;
			var con:uint;
			var pdc:uint;
			reg = getByteAt ( ISP + 1 );
			con = getByteAt ( ISP + 2 );
			pdc = getReg ( reg ) - con;
			pdc = pdc & 0xFFFF;
			setReg ( 14, pdc & 0xFF );
			setReg ( 15, ( pdc & 0xFF00 ) >> 8 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function MLC8 () : void // Multiplies a constant and an 8-bit Register
		{
			
			var reg:uint;
			var con:uint;
			var pdc:uint;
			reg = getByteAt ( ISP + 1 );
			con = getByteAt ( ISP + 2 );
			pdc = getReg ( reg ) * con;
			pdc = pdc & 0xFFFF;
			setReg ( 14, pdc & 0xFF );
			setReg ( 15, ( pdc & 0xFF00 ) >> 8 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function DVC8 () : void // Divides an 8-bit Register by a constant
		{
			
			var reg:uint;
			var con:uint;
			var pdc:uint;
			reg = getByteAt ( ISP + 1 );
			con = getByteAt ( ISP + 2 );
			pdc = getReg ( reg ) / con;
			pdc = pdc & 0xFFFF;
			setReg ( 14, pdc & 0xFF );
			setReg ( 15, ( pdc & 0xFF00 ) >> 8 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function ADR8 () : void // Adds two 8-bit Registers
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 );
			val += getReg ( reg2 );
			val %= 0x10000;
			setReg ( 14, val & 0xFF );
			setReg ( 15, ( val & 0xFF00 ) >> 8 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function SBR8 () : void // Subtracts one 8-bit Register from another
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 );
			val -= getReg ( reg2 );
			val %= 0x10000;
			setReg ( 14, val & 0xFF );
			setReg ( 15, ( val & 0xFF00 ) >> 8 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function MLR8 () : void // Multiplies two 8-bit Registers
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 );
			val *= getReg ( reg2 );
			val %= 0x10000;
			setReg ( 14, val & 0xFF );
			setReg ( 15, ( val & 0xFF00 ) >> 8 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function DVR8 () : void // Divides one 8-bit Register by another
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 );
			val /= getReg ( reg2 );
			val %= 0x10000;
			setReg ( 14, val & 0xFF );
			setReg ( 15, ( val & 0xFF00 ) >> 8 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function PUSHC8 () : void // pushes a constant byte
		{
			
			var con:uint;
			con = getByteAt ( ISP + 1 );
			STP --;
			setByteAt ( STP, con );
			NSINC = 2;
			return;
			
		};
		
		private final function PUSHR8 () : void // pushes a Register
		{
			
			var reg:uint;
			var val:uint;
			reg = getByteAt ( ISP + 1 );
			val = getReg ( reg );
			STP --;
			setByteAt ( STP, val );
			NSINC = 2;
			return;
			
		};
		
		private final function POP8 () : void // pops into a Register
		{
			
			var reg:uint;
			var val:uint;
			reg = getByteAt ( ISP + 1 );
			val = getByteAt ( STP );
			setReg ( reg, val );
			STP ++;
			NSINC = 2;
			return;
			
		};
		
		private final function SMR () : void // Sets a Memory pocket to a Register
		{
			
			var add:uint;
			var reg:uint;
			var val:uint;
			add = getDoubleAt ( ISP + 1 );
			reg = getByteAt ( ISP + 3 );
			val = getReg ( reg );
			setByteAt ( add, val );
			NSINC = 4;
			return;
			
		};
		
		private final function SRM () : void // Sets a Register to a Memory pocket
		{
			
			var reg:uint;
			var add:uint;
			var val:uint;
			add = getDoubleAt ( ISP + 2 );
			reg = getByteAt ( ISP + 1 );
			val = getByteAt ( add );
			setReg ( reg, val );
			NSINC = 4;
			return;
			
		};
		
		private final function INT () : void //  Call interrupt
		{
			
			var inm:uint;
			inm = getByteAt ( ISP + 1 );
			dbs.INTERRUPT ( inm );
			NSINC = 2;
			return;
			
		};
		
		private final function CLI () : void //  Clear interrupt flag
		{
			
			NF = false;
			NSINC = 1;
			return;
			
		};
		
		private final function SEI () : void //  Set interrupt flag with handler address
		{
			
			var add:uint;
			add = getDoubleAt ( ISP + 1 );
			IRP = add;
			NF = true;
			NSINC = 3;
			return;
			
		};
		
		private final function RTI () : void //  Return from interrupt
		{
			
			var lah:uint;
			lah = getByteAt ( ISP + 1 );
			ihs = true;
			ito = lah;
			NSINC = 2;
			return;
			
		};
		
		private final function ANDC8 () : void // bitwise and with a constant ( 8-bit )
		{
			
			var reg:uint;
			var con:uint;
			var val:uint;
			reg = getByteAt ( ISP + 1 );
			con = getByteAt ( ISP + 2 );
			val = getReg ( reg ) & con;
			setReg ( 14, val );
			setReg ( 15, 0 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function ORC8 () : void // bitwise or with a constant ( 8-bit )
		{
			
			var reg:uint;
			var con:uint;
			var val:uint;
			reg = getByteAt ( ISP + 1 );
			con = getByteAt ( ISP + 2 );
			val = getReg ( reg ) | con;
			setReg ( 14, val );
			setReg ( 15, 0 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function XORC8 () : void // bitwise exclusive or with a constant ( 8-bit )
		{
			
			var reg:uint;
			var con:uint;
			var val:uint;
			reg = getByteAt ( ISP + 1 );
			con = getByteAt ( ISP + 2 );
			val = getReg ( reg ) ^ con;
			setReg ( 14, val );
			setReg ( 15, 0 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function ANDR8 () : void // bitwise and with a register ( 8-bit )
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 ) & getReg ( reg2 );
			setReg ( 14, val );
			setReg ( 15, 0 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function ORR8 () : void // bitwise or with a register ( 8-bit )
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 ) | getReg ( reg2 );
			setReg ( 14, val );
			setReg ( 15, 0 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function XORR8 () : void // bitwise or with a register ( 8-bit )
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 ) ^ getReg ( reg2 );
			setReg ( 14, val );
			setReg ( 15, 0 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function NOT8 () : void // bitwise not ( 8-bit )
		{
			
			var reg:uint;
			var val:uint;
			reg = getByteAt ( ISP + 1 );
			val = ~ getReg ( reg );
			setReg ( 14, val & 0xFF );
			setReg ( 15, 0 );
			setFlagsFromAccumulator ()
			NSINC = 2;
			return;
			
		};
		
		private final function CPR8 () : void // copy register ( 8-bit )
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 2 );
			reg2 = getByteAt ( ISP + 1 );
			val = getReg ( reg1 );
			setReg ( reg2, val );
			NSINC = 3;
			return;
			
		};
		
		private final function ACTR () : void // address copy to register ( 8-bit )
		{
			
			var sreg:uint;
			var lreg:uint;
			var reg:uint;
			var add:uint;
			reg = getByteAt ( ISP + 1 );
			sreg = getByteAt ( ISP + 2 );
			lreg = getByteAt ( ISP + 3 );
			add = getReg ( sreg ) + ( getReg ( lreg ) << 8 );
			setReg ( reg, getByteAt ( add ) );
			NSINC = 4;
			return;
			
		};
		
		private final function ACFR () : void // address copy to register ( 8-bit )
		{
			
			var sreg:uint;
			var lreg:uint;
			var reg:uint;
			var add:uint;
			reg = getByteAt ( ISP + 3 );
			sreg = getByteAt ( ISP + 1 );
			lreg = getByteAt ( ISP + 2 );
			add = getReg ( sreg ) + ( getReg ( lreg ) << 8 );
			setByteAt ( add, getReg ( reg ) );
			NSINC = 4;
			return;
			
		};
		
		private final function BSLC8 () : void
		{
			
			var vreg:uint;
			var snum:uint;
			var reg:uint;
			vreg = getByteAt ( ISP + 1 );
			snum = getByteAt ( ISP + 2 );
			reg = getReg ( vreg );
			reg = reg << snum;
			setReg ( 14, reg );
			setReg ( 15, reg >> 8 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function BSRC8 () : void
		{
			
			var vreg:uint;
			var snum:uint;
			var reg:uint;
			vreg = getByteAt ( ISP + 1 );
			snum = getByteAt ( ISP + 2 );
			reg = getReg ( vreg );
			reg = reg >> snum;
			setReg ( 14, reg );
			setReg ( 15, 0 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function BSLR8 () : void
		{
			
			var vreg:uint;
			var vreg2:uint;
			var reg:uint;
			var reg2:uint;
			vreg = getByteAt ( ISP + 1 );
			vreg2 = getByteAt ( ISP + 2 );
			reg = getReg ( vreg );
			reg2 = getReg ( vreg2 );
			reg = reg << reg2;
			setReg ( 14, reg );
			setReg ( 15, reg >> 8 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function BSRR8 () : void
		{
			
			var vreg:uint;
			var vreg2:uint;
			var reg:uint;
			var reg2:uint;
			vreg = getByteAt ( ISP + 1 );
			vreg2 = getByteAt ( ISP + 2 );
			reg = getReg ( vreg );
			reg2 = getReg ( vreg2 );
			reg = reg >> reg2;
			setReg ( 14, reg );
			setReg ( 15, reg >> 8 );
			setFlagsFromAccumulator ()
			NSINC = 3;
			return;
			
		};
		
		private final function JIF () : void
		{
			
			var flg:uint;
			var add:uint;
			add = getDoubleAt ( ISP + 1 );
			flg = getByteAt ( ISP + 3 );
			if ( getFlag ( flg ) )
			{
				
				if ( AF )
					ISP += add - 0x7FFF;
				else
					ISP = add;
			
			}
			
		};
		
		private final function RTLC8 () : void
		{
			
			var vreg:uint;
			var sval:uint;
			var reg:uint;
			var uh:uint;
			vreg = getByteAt ( ISP + 1 );
			sval = getByteAt ( ISP + 2 );
			reg - getReg ( vreg );
			sval = sval & 0x7;
			reg = reg << sval;
			uh = reg & 0xFF00;
			uh = uh >> 8;
			reg = reg | uh;
			setReg ( 14, reg );
			setReg ( 15, 0 );
			setFlagsFromAccumulator ();
			NSINC = 3;
			return;
			
		};
		
		private final function RTRC8 () : void
		{
			
			var vreg:uint;
			var sval:uint;
			var reg:uint;
			var uh:uint;
			vreg = getByteAt ( ISP + 1 );
			sval = getByteAt ( ISP + 2 );
			reg - getReg ( vreg );
			sval = sval & 0x7;
			reg << ( 8 - sval );
			uh = reg & 0xFF00;
			uh >> 8;
			reg = reg | uh;
			setReg ( 14, reg );
			setReg ( 15, 0 );
			setFlagsFromAccumulator ();
			NSINC = 3;
			return;
			
		};
		
		private final function RTLR8 () : void
		{
			
			var vreg:uint;
			var vreg2:uint;
			var reg:uint;
			var reg2:uint;
			var uh:uint;
			vreg = getByteAt ( ISP + 1 );
			vreg2 = getByteAt ( ISP + 2 );
			reg = getReg ( vreg );
			reg2 = getReg ( vreg2 );
			reg2 = reg2 & 0x7;
			reg = reg << reg2;
			uh = reg & 0xFF00;
			uh = uh >> 8;
			reg = reg | uh;
			setReg ( 14, reg );
			setReg ( 15, 0 );
			setFlagsFromAccumulator ();
			NSINC = 3;
			return;
			
		};
		
		private final function RTRR8 () : void
		{
			
			var vreg:uint;
			var vreg2:uint;
			var reg:uint;
			var reg2:uint;
			var uh:uint;
			vreg = getByteAt ( ISP + 1 );
			vreg2 = getByteAt ( ISP + 2 );
			reg = getReg ( vreg );
			reg2 = getReg ( vreg2 );
			reg2 = reg2 & 0x7;
			reg = reg << ( 8 - reg2 );
			uh = reg & 0xFF00;
			uh = uh >> 8;
			reg = reg | uh;
			setReg ( 14, reg );
			setReg ( 15, 0 );
			setFlagsFromAccumulator ();
			NSINC = 3;
			return;
			
		};
		
		private final function JNF () : void
		{
			
			var flg:uint;
			var add:uint;
			add = getDoubleAt ( ISP + 1 );
			flg = getByteAt ( ISP + 3 );
			if ( getFlag ( flg ) )
			{
				
				if ( AF )
					ISP += add - 0x7FFF;
				else
					ISP = add;
				
			}
			
		};
		
		private final function JZ () : void // Jump if zero
		{
			
			var reg:uint;
			var evl:uint;
			var add:int;
			add = getDoubleAt ( ISP + 1 );
			reg = getByteAt ( ISP + 3 );
			evl = getReg ( reg );
			if ( evl == 0 )
			{
				if ( AF )
					ISP += add - 0x7FFF;
				else
					ISP = add;
				NSINC = 0;
				return;
			}
			NSINC = 4;
			return;
			
		};
		
		private final function STDR () : void
		{
			
			var reg1:uint;
			var reg2:uint; //upper
			var valp:uint;
			var valm:uint; //upper
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			valp = getByteAt ( ISP + 3 );
			valm = getByteAt ( ISP + 4 );
			setReg ( reg1, valp );
			setReg ( reg2, valm );
			NSINC = 5;
			return;
			
		};
		
		private final function INC16 () : void
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 ) + getReg ( reg2 ) << 8;
			val ++;
			setReg ( reg1, val & 0xFF );
			setReg ( reg2, ( val & 0xFF00 ) >> 8 );
			NSINC = 3;
			return;
			
		};
		
		private final function DEC16 () : void
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 ) + getReg ( reg2 ) << 8;
			val --;
			setReg ( reg1, val & 0xFF );
			setReg ( reg2, ( val & 0xFF00 ) >> 8 );
			NSINC = 3;
			return;
			
		};
		
		private final function ADD16C () : void
		{
			
			var regl:uint;
			var regh:uint;
			var cons:uint;
			var val:uint = 0;
			regl = getByteAt ( ISP + 1 );
			regh = getByteAt ( ISP + 2 );
			cons = getDoubleAt ( ISP + 3 );
			val += getReg ( regl );
			val += getReg ( regh ) << 8;
			val += cons;
			setReg ( 14, val & 0xFF );
			setReg ( 15, ( val >> 8 ) & 0xFF );
			NSINC = 5;
			return;
			
		};
		
		private final function SUB16C () : void
		{
			
			var regl:uint;
			var regh:uint;
			var cons:uint;
			var val:uint = 0;
			regl = getByteAt ( ISP + 1 );
			regh = getByteAt ( ISP + 2 );
			cons = getDoubleAt ( ISP + 3 );
			val += getReg ( regl );
			val += getReg ( regh ) << 8;
			val -= cons;
			setReg ( 14, val & 0xFF );
			setReg ( 15, ( val >> 8 ) & 0xFF );
			NSINC = 5;
			return;
			
		};
		
		private final function MUL16C () : void
		{
			
			var regl:uint;
			var regh:uint;
			var cons:uint;
			var val:uint = 0;
			regl = getByteAt ( ISP + 1 );
			regh = getByteAt ( ISP + 2 );
			cons = getDoubleAt ( ISP + 3 );
			val += getReg ( regl );
			val += getReg ( regh ) << 8;
			val = val * cons;
			setReg ( 14, val & 0xFF );
			setReg ( 15, ( val >> 8 ) & 0xFF );
			NSINC = 5;
			return;
			
		};
		
		private final function DIV16C () : void
		{
			
			var regl:uint;
			var regh:uint;
			var cons:uint;
			var val:uint = 0;
			regl = getByteAt ( ISP + 1 );
			regh = getByteAt ( ISP + 2 );
			cons = getDoubleAt ( ISP + 3 );
			val += getReg ( regl );
			val += getReg ( regh ) << 8;
			val = val / cons;
			setReg ( 14, val & 0xFF );
			setReg ( 15, ( val >> 8 ) & 0xFF );
			NSINC = 5;
			return;
			
		};
		
		private final function ADD16R () : void
		{
			
			 var reg1l:uint;
			 var reg2l:uint;
			 var reg1h:uint;
			 var reg2h:uint;
			 var val:uint = 0;
			 reg1l = getByteAt ( ISP + 1 );
			 reg1h = getByteAt ( ISP + 2 );
			 reg2l = getByteAt ( ISP + 3 );
			 reg2h = getByteAt ( ISP + 4 );
			 val += getReg ( reg1l );
			 val += getReg ( reg1h ) << 8;
			 val += getReg ( reg2l );
			 val += getReg ( reg2h ) << 8;
			 setReg ( 14, val & 0xFF );
			 setReg ( 15, ( val >> 8 ) & 0xFF );
			 NSINC = 5;
			 return;
			
		};
		
		private final function SUB16R () : void
		{
			
			var reg1l:uint;
			var reg2l:uint;
			var reg1h:uint;
			var reg2h:uint;
			var val:uint = 0;
			reg1l = getByteAt ( ISP + 1 );
			reg1h = getByteAt ( ISP + 2 );
			reg2l = getByteAt ( ISP + 3 );
			reg2h = getByteAt ( ISP + 4 );
			val += getReg ( reg1l );
			val += getReg ( reg1h ) << 8;
			val -= getReg ( reg2l );
			val -= getReg ( reg2h ) << 8;
			setReg ( 14, val & 0xFF );
			setReg ( 15, ( val >> 8 ) & 0xFF );
			NSINC = 5;
			return;
			
		};
		
		private final function MUL16R () : void
		{
			
			var reg1l:uint;
			var reg2l:uint;
			var reg1h:uint;
			var reg2h:uint;
			var val:uint = 0;
			var val2:uint = 0;
			reg1l = getByteAt ( ISP + 1 );
			reg1h = getByteAt ( ISP + 2 );
			reg2l = getByteAt ( ISP + 3 );
			reg2h = getByteAt ( ISP + 4 );
			val += getReg ( reg1l );
			val += getReg ( reg1h ) << 8;
			val2 += getReg ( reg2l );
			val2 += getReg ( reg2h ) << 8;
			val = val * val2;
			setReg ( 14, val & 0xFF );
			setReg ( 15, ( val >> 8 ) & 0xFF );
			NSINC = 5;
			return;
			
		};
		
		private final function DIV16R () : void
		{
			
			var reg1l:uint;
			var reg2l:uint;
			var reg1h:uint;
			var reg2h:uint;
			var val:uint = 0;
			var val2:uint = 0;
			reg1l = getByteAt ( ISP + 1 );
			reg1h = getByteAt ( ISP + 2 );
			reg2l = getByteAt ( ISP + 3 );
			reg2h = getByteAt ( ISP + 4 );
			val += getReg ( reg1l );
			val += getReg ( reg1h ) << 8;
			val2 += getReg ( reg2l );
			val2 += getReg ( reg2h ) << 8;
			val = val / val2;
			setReg ( 14, val & 0xFF );
			setReg ( 15, ( val >> 8 ) & 0xFF );
			NSINC = 5;
			return;
			
		};
		
		private final function PUSH16C () : void
		{
			
			var vall:uint;
			var valh:uint;
			vall = getByteAt ( ISP + 1 );
			valh = getByteAt ( ISP + 2 );
			STP --;
			setByteAt ( STP, valh );
			STP --;
			setByteAt ( STP, vall );
			NSINC = 3;
			return;
			
		};
		
		private final function PUSH16R () : void
		{
			
			var reg1:uint;
			var reg2:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			STP --;
			setByteAt ( STP, getReg ( reg2 ) );
			STP --;
			setByteAt ( STP, getReg ( reg1 ) );
			NSINC = 3;
			return;
			
		};
		
		private final function POP16 () : void
		{
			
			var reg1:uint;
			var reg2:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			setReg ( reg1, getByteAt ( STP ) );
			STP ++;
			setReg ( reg2, getByteAt ( STP ) );
			STP ++;
			NSINC = 3;
			return;
			
		};
		
		private final function SWP8 () : void
		{
			
			var reg1:uint;
			var reg2:uint;
			var tvl:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			tvl = getReg ( reg2 );
			setReg ( reg2, getReg ( reg1 ) );
			setReg ( reg1, tvl );
			NSINC = 3;
			return;
			
		};
		
		private final function SWP16 () : void
		{
			
			var reg1l:uint;
			var reg2l:uint;
			var reg1h:uint;
			var reg2h:uint;
			var tvll:uint;
			var tvlh:uint;
			reg1l = getByteAt ( ISP + 1 );
			reg1h = getByteAt ( ISP + 2 );
			reg2l = getByteAt ( ISP + 3 );
			reg2h = getByteAt ( ISP + 4 );
			tvll = getReg ( reg2l );
			tvlh = getReg ( reg2h );
			setReg ( reg2l, getReg ( reg1l ) );
			setReg ( reg2h, getReg ( reg1h ) );
			setReg ( reg1l, tvll );
			setReg ( reg1h, tvlh );
			NSINC = 5;
			return;
			
		};
		
		private final function CPR16 () : void
		{
			
			var reg1l:uint;
			var reg2l:uint;
			var reg1h:uint;
			var reg2h:uint;
			reg1l = getByteAt ( ISP + 1 );
			reg1h = getByteAt ( ISP + 2 );
			reg2l = getByteAt ( ISP + 3 );
			reg2h = getByteAt ( ISP + 4 );
			setReg ( reg1l, getReg ( reg2l ) );
			setReg ( reg1h, getReg ( reg2h ) );
			NSINC = 5;
			return;
			
		}
		
		// ---- [ Flag functions ] ---- //
		
		private final function setFlagsFromAccumulator () : void
		{
			
			ZF = ( getReg ( 10 ) == 0 && getReg ( 11 ) == 0 );
			CF = ( getReg ( 11 ) != 0 );
			
		}
		
		private final function getFlag ( flag:uint ) : Boolean
		{
			
			switch ( flag )
			{
				
				case 0:
					return CF;
				case 1:
					return NF;
				case 2:
					return ZF;
				case 3:
					return AF;
				default:
					break;
				
			}
			
			return false;
			
		}
		
		// ---- [ Register functions ] ---- //
		
		private final function setReg ( reg:uint, val:uint ) : void
		{
			
			val = val & 0xFF;
			
			switch ( reg )
			{
				
				case 0:
					AX = val;
					break;
				case 1:
					BX = val;
					break;
				case 2:
					CX = val;
					break;
				case 3:
					DX = val;
					break;
				case 4:
					MX = val;
					break;
				case 5:
					NX = val;
					break;
				case 6:
					IW = ( IX & 0xFF00 ) + val;
					break;
				case 7:
					IW = ( IX & 0xFF ) + ( val << 8 );
					break;
				case 8:
					IX = ( IX & 0xFF00 ) + val;
					break;
				case 9:
					IX = ( IX & 0xFF ) + ( val << 8 );
					break;
				case 10:
					IY = ( IY & 0xFF00 ) + val;
					break;
				case 11:
					IY = ( IY & 0xFF ) + ( val << 8 );
					break;
				case 12:
					IZ = ( IZ & 0xFF00 ) + val;
					break;
				case 13:
					IZ = ( IZ & 0xFF ) + ( val << 8 );
					break;
				case 14:
					IA = ( IA & 0xFF00 ) + val;
					break;
				case 15:
					IA = ( IA & 0xFF ) + ( val << 8 );
					break;
				case 16:
					AL = val;
					break;
				case 17:
					BL = val;
					break;
				case 18:
					FL = val;
					break;
				case 19:
					GL = val;
					break;
				case 20:
					XL = ( XL & 0xFF00 ) + val;
					break;
				case 21:
					XL = ( XL & 0xFF ) + ( val << 8 );
					break;
				case 22:
					YL = ( YL & 0xFF00 ) + val;
					break;
				case 23:
					YL = ( YL & 0xFF ) + ( val << 8 );
					break;
				default:
					break;
				
			}
			
			return;
			
		};
		
		private final function getReg ( reg:uint ) : uint
		{
			
			switch ( reg )
			{
				
				case 0:
					return AX;
					break;
				case 1:
					return BX;
					break;
				case 2:
					return CX;
					break;
				case 3:
					return DX;
					break;
				case 4:
					return MX;
					break;
				case 5:
					return NX;
					break;
				case 6:
					return IW & 0xFF;
					break;
				case 7:
					return ( IW & 0xFF00 ) >> 8;
					break;
				case 8:
					return IX & 0xFF;
					break;
				case 9:
					return ( IX & 0xFF00 ) >> 8;
					break;
				case 10:
					return IY & 0xFF;
					break;
				case 11:
					return ( IY & 0xFF00 ) >> 8;
					break;
				case 12:
					return IZ & 0xFF;
					break;
				case 13:
					return ( IZ & 0xFF00 ) >> 8;
					break;
				case 14:
					return IA & 0xFF;
					break;
				case 15:
					return ( IA & 0xFF00 ) >> 8;
					break;
				case 16:
					return AL;
					break;
				case 17:
					return BL;
					break;
				case 18:
					return FL;
					break;
				case 19:
					return GL;
					break;
				case 20:
					return XL & 0xFF;
					break;
				case 21:
					return ( XL & 0xFF00 ) >> 8;
					break;
				case 22:
					return YL & 0xFF;
					break;
				case 23:
					return ( YL & 0xFF00 ) >> 8;
					break;
				default:
					return 0;
					break;
				
			}
			
			return 0;
			
		};
		
		// ---- [ Memory access functions ] ---- //
		
		private final function getByteAt ( addr:uint ) : uint
		{
			
			return mem.read ( addr );
		
		};
		
		private final function getDoubleAt ( addr:uint ) : uint
		{
			
			return mem.read ( addr ) + ( mem.read ( addr + 1 ) << 8 );
			
		};
		
		private final function setByteAt ( addr:uint, val:uint ) : void
		{
			
			mem.write ( addr, val );
			return;
			
		};
		
		private final function setDoubleAt ( addr:uint, val:uint ) : void
		{
			
			mem.write ( addr, val & 255 );
			mem.write ( addr + 1, ( val & 0xFF00 ) >> 8 );
			return;
			
		};
		
		public final function get readyToInterrupt () : Boolean { return ihs && NF && ito == 0 };
		
	}
	
}