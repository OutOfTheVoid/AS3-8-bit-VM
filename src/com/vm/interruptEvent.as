package com.vm
{
	import flash.events.Event;
	
	public class interruptEvent extends Event
	{
		
		public var data:uint;
		
		public function interruptEvent ( num:uint, data:uint )
		{
			
			super ( "CPU_INTERRUPT" + num.toString ( 16 ) );
			this.data = data;
			
		}
		
	}
	
}