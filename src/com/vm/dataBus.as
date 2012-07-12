package com.vm
{
	import flash.events.EventDispatcher;
	
	public class dataBus extends EventDispatcher
	{
		
		public static const INTERRUPT_EVENT:String = "CPU_INTERRUPT";
		
		public function dataBus ()
		{
			
		}
		
		public final function startListeningForInterrupt ( interrupt:uint, func:Function ) : void
		{
			
			var intr:String;
			intr = INTERRUPT_EVENT + interrupt.toString ( 16 );
			addEventListener ( intr, func );
			
		}
		
		public final function stopListeningForInterrupt ( interrupt:uint, func:Function ) : void
		{
			
			var intr:String;
			intr = INTERRUPT_EVENT + interrupt.toString ( 16 );
			removeEventListener ( intr, func );
			
		}
		
		internal function INTERRUPT ( num:uint, busData:uint ) : void
		{
			
			var event:interruptEvent = new interruptEvent ( num, busData );
			dispatchEvent ( event );
			return;
			
		}
		
	}
	
}