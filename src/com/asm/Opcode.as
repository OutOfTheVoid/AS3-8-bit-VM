package com.asm
{
	
	internal class Opcode
	{
		
		public var code:uint;
		public var arguments:Vector.<String>
		public var bitMode8:Boolean;
		
		public function Opcode ( code:uint, bitMode8:Boolean, arguments:Vector.<String> )
		{
			
			this.code = code;
			this.arguments = arguments;
			this.bitMode8 = bitMode8;
			
		}
		
	}
	
}