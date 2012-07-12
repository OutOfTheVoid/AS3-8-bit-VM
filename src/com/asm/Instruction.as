package com.asm
{
	
	internal class Instruction
	{
		
		public var tag:String;
		public var ops:Vector.<Opcode>;
		
		public function Instruction ( tag:String, ops:Vector.<Opcode> ) 
		{
			
			this.tag = tag;
			this.ops = ops;
			
		}
		
	}
	
}