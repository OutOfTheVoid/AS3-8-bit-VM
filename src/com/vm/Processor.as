package com.vm
{
	
	public final class Processor
	{
		
		private var mem:Memory;
		private var dbs:DataBus;
		
		private var rad:Boolean = false;
		private var ien:Boolean = false; // interrupts enabled
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
		
		private var IX:uint = 0;  // Adressing Registers ( 16-bit )
		private var IY:uint = 0;
		
		private var IA:uint = 0;  // Accumulator Register ( 16-bit )
		
		private var NSINC:uint = 0;
		
		private var ASC:Vector.<Function>;
		
		public final function Processor ( memory:Memory, dataBus:DataBus ) : void
		{
			
			mem = memory;
			dbs = dataBus;
			//                      0    1    2    3    4    5    6    7    8     9     10    11    12    13    14    15    16    17    18     19    20   21   22   23   24   25   26    27     28    29     30     31    32     33   34    35    36
			ASC = new <Function> [ NOP, STR, STM, RLA, DRA, JPC, JPR, JNZ, INC8, DEC8, ADC8, SBC8, MLC8, DVC8, ADR8, SBR8, MLR8, DVR8, PUSHC, PUSHR, POP, SMR, SRM, INT, CLI, SEI, RTI, ANDC8, ORC8, XORC8, ANDR8, ORR8, XORR8, NOT8, CPR, ACTR, ACFR ];
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
			
		}
		
		public final function step () : void
		{
			
			var opc:uint = getByteAt ( ISP );
			
			ASC [ opc ] ();
			
			ISP += NSINC;
			
			if ( ito > 0 )
				ito --;
			
			return;
			
		};
		
		public final function interrupt ( num:uint, data:uint ) : Boolean
		{
			
			if ( readyToInterrupt )
			{
				
				ihs = false;
				STP --;
				setByteAt ( STP, ISP & 0xFF00 );
				STP --;
				setByteAt ( STP, ISP & 0x00FF );
				ISP = IRP;
				STP --;
				setByteAt ( STP, data & 0xFF00 );
				STP --;
				setByteAt ( STP, data & 0x00FF );
				
				return true;
				
			}
			
			return false;
			
		}
		
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
			if ( rad )
				setByteAt ( mad - 0x7FFF + ISP, val );
			else
				setByteAt ( mad, val );
			return;
			
		};
		
		private final function RLA () : void // Relative adressing
		{
			
			rad = true;
			NSINC = 1;
			return;
			
		};
		
		private final function DRA () : void // Direct adressing
		{
			
			rad = false;
			NSINC = 1;
			return;
			
		};
		
		private final function JPC () : void // Jump to constant
		{
			
			var add:int;
			add = getDoubleAt ( ISP + 1 );
			if ( rad )
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
			if ( rad )
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
				if ( rad )
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
			pdc %= 0x10000;
			setReg ( 10, pdc & 0xFF );
			setReg ( 11, ( pdc & 0xFF00 ) >> 8 );
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
			pdc %= 0x10000;
			setReg ( 10, pdc & 0xFF );
			setReg ( 11, ( pdc & 0xFF00 ) >> 8 );
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
			pdc %= 0x10000;
			setReg ( 10, pdc & 0xFF );
			setReg ( 11, ( pdc & 0xFF00 ) >> 8 );
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
			pdc %= 0x10000;
			setReg ( 10, pdc & 0xFF );
			setReg ( 11, ( pdc & 0xFF00 ) >> 8 );
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
			setReg ( 10, val & 0xFF );
			setReg ( 11, ( val & 0xFF00 ) >> 8 );
			NSINC = 3;
			return;
			
		}
		
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
			setReg ( 10, val & 0xFF );
			setReg ( 11, ( val & 0xFF00 ) >> 8 );
			NSINC = 3;
			return;
			
		}
		
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
			setReg ( 10, val & 0xFF );
			setReg ( 11, ( val & 0xFF00 ) >> 8 );
			NSINC = 3;
			return;
			
		}
		
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
			setReg ( 10, val & 0xFF );
			setReg ( 11, ( val & 0xFF00 ) >> 8 );
			NSINC = 3;
			return;
			
		}
		
		private final function PUSHC () : void // pushes a constant byte
		{
			
			var con:uint;
			con = getByteAt ( ISP + 1 );
			STP --;
			setByteAt ( STP, con );
			NSINC = 2;
			return;
			
		};
		
		private final function PUSHR () : void // pushes a Register
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
		
		private final function POP () : void // pops into a Register
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
		
		private final function INT () : void
		{
			
			var inm:uint;
			var reg1:uint;
			var reg2:uint;
			var data:uint;
			inm = getByteAt ( ISP + 1 );
			reg1 = getByteAt ( ISP + 2 );
			reg2 = getByteAt ( ISP + 3 );
			data = getReg ( reg1 ) + ( getReg ( reg2 ) << 8 );
			dbs.INTERRUPT ( inm, data );
			NSINC = 4;
			return;
			
		};
		
		private final function CLI () : void
		{
			
			ien = false;
			NSINC = 1;
			return;
			
		};
		
		private final function SEI () : void
		{
			
			var add:uint;
			add = getDoubleAt ( ISP + 1 );
			IRP = add;
			ien = true;
			NSINC = 3;
			return;
			
		};
		
		private final function RTI () : void
		{
			
			var lah:uint;
			lah = getByteAt ( ISP + 1 );
			ihs = true;
			ito = lah;
			NSINC = 2;
			return;
			
		};
		
		private final function ANDC8 () : void
		{
			
			var reg:uint;
			var con:uint;
			var val:uint;
			reg = getByteAt ( ISP + 1 );
			con = getByteAt ( ISP + 2 );
			val = getReg ( reg ) & con;
			setReg ( 10, val );
			setReg ( 11, 0 );
			NSINC = 3;
			return;
			
		};
		
		private final function ORC8 () : void
		{
			
			var reg:uint;
			var con:uint;
			var val:uint;
			reg = getByteAt ( ISP + 1 );
			con = getByteAt ( ISP + 2 );
			val = getReg ( reg ) | con;
			setReg ( 10, val );
			setReg ( 11, 0 );
			NSINC = 3;
			return;
			
		};
		
		private final function XORC8 () : void
		{
			
			var reg:uint;
			var con:uint;
			var val:uint;
			reg = getByteAt ( ISP + 1 );
			con = getByteAt ( ISP + 2 );
			val = getReg ( reg ) ^ con;
			setReg ( 10, val );
			setReg ( 11, 0 );
			NSINC = 3;
			return;
			
		};
		
		private final function ANDR8 () : void
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 ) & getReg ( reg2 );
			setReg ( 10, val );
			setReg ( 11, 0 );
			NSINC = 3;
			return;
			
		};
		
		private final function ORR8 () : void
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 ) | getReg ( reg2 );
			setReg ( 10, val );
			setReg ( 11, 0 );
			NSINC = 3;
			return;
			
		};
		
		private final function XORR8 () : void
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 ) ^ getReg ( reg2 );
			setReg ( 10, val );
			setReg ( 11, 0 );
			NSINC = 3;
			return;
			
		};
		
		private final function NOT8 () : void
		{
			
			var reg:uint;
			var val:uint;
			reg = getByteAt ( ISP + 1 );
			val = ~ getReg ( reg );
			setReg ( 10, val & 0xFF );
			setReg ( 11, 0 );
			NSINC = 2;
			return;
			
		};
		
		private final function CPR () : void
		{
			
			var reg1:uint;
			var reg2:uint;
			var val:uint;
			reg1 = getByteAt ( ISP + 1 );
			reg2 = getByteAt ( ISP + 2 );
			val = getReg ( reg1 );
			setReg ( reg2, val );
			NSINC = 3;
			return;
			
		};
		
		private final function ACTR () : void
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
		
		private final function ACFR () : void
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
		
		// ---- [ Register functions ] ---- //
		
		private final function setReg ( reg:uint, val:uint ) : void
		{
			
			val = val % 256;
			
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
					IX = ( IX & 0xFF00 ) + val;
					break;
				case 7:
					IX = ( IX & 0xFF ) + ( val << 8 );
					break;
				case 8:
					IY = ( IY & 0xFF00 ) + val;
					break;
				case 9:
					IY = ( IY & 0xFF ) + ( val << 8 );
					break;
				case 10:
					IA = ( IA & 0xFF00 ) + val;
					break;
				case 11:
					IA = ( IA & 0xFF ) + ( val << 8 );
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
					return IX & 0xFF;
					break;
				case 7:
					return ( IX & 0xFF00 ) >> 8;
					break;
				case 8:
					return IY & 0xFF;
					break;
				case 9:
					return ( IY & 0xFF00 ) >> 8;
					break;
				case 10:
					return IA & 0xFF;
					break;
				case 11:
					return ( IA & 0xFF00 ) >> 8;
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
		
		public final function get readyToInterrupt () : Boolean { return ihs && ien && ito == 0 };
		
	}
	
}