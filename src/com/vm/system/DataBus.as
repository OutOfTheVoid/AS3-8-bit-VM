package com.vm.system
{
	import flash.events.EventDispatcher;
	
	public class DataBus extends EventDispatcher
	{
		
		public static const INTERRUPT_EVENT:String = "CPU_INTERRUPT";
		
		internal var _cpu:Processor;
		
		public function DataBus ()
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
		
		internal function INTERRUPT ( num:uint ) : void
		{
			
			var event:InterruptEvent = new InterruptEvent ( num, _cpu.AL, _cpu.BL, _cpu.FL, _cpu.GL, _cpu.XL, _cpu.YL );
			dispatchEvent ( event );
			return;
			
		}
		
	}
	
}