package com.asm
{
	
	internal class Opcode
	{
		
		public var code:uint;
		public var arguments:Vector.<String>
		
		
		public function Opcode ( code:uint, arguments:Vector.<String> )
		{
			
			this.code = code;
			this.arguments = arguments;
			
		}
		
	}
	
}