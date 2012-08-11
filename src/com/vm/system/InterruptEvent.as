package com.vm.system
{
	import flash.events.Event;
	
	public class InterruptEvent extends Event
	{
		
		public var data:uint;
		
		public function InterruptEvent ( num:uint, data:uint )
		{
			
			super ( "CPU_INTERRUPT" + num.toString ( 16 ) );
			this.data = data;
			
		}
		
	}
	
}