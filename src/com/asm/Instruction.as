package com.asm
{
	
	internal class instruction
	{
		
		public var tag:String;
		public var ops:Vector.<opcode>;
		
		public function instruction ( tag:String, ops:Vector.<opcode> ) 
		{
			
			this.tag = tag;
			this.ops = ops;
			
		}
		
	}
	
}