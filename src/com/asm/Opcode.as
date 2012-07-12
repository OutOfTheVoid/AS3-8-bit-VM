package com.asm
{
	
	internal class opcode
	{
		
		public var code:uint;
		public var arguments:Vector.<String>
		
		
		public function opcode ( code:uint, arguments:Vector.<String> )
		{
			
			this.code = code;
			this.arguments = arguments;
			
		}
		
	}
	
}