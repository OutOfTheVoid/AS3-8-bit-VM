package com.vm.system
{
	import flash.events.Event;
	
	public class InterruptEvent extends Event
	{
		
		public var A:uint;
		public var B:uint;
		public var F:uint;
		public var G:uint;
		public var X:uint;
		public var Y:uint;
		
		public function InterruptEvent ( num:uint, a:uint, b:uint, f:uint, g:uint, x:uint, y:uint )
		{
			
			super ( "CPU_INTERRUPT" + num.toString ( 16 ) );
			
			A = a;
			B = b;
			F = f;
			G = g;
			X = x;
			Y = y;
			
		}
		
	}
	
}