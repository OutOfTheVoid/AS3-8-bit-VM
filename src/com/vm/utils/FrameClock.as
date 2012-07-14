package com.vm.utils
{
	
	import com.vm.Processor;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class FrameClock
	{
		
		private var stage:Stage;
		private var batch:uint;
		private var altim:uint;
		private var count:uint = 0;
		private var isRun:Boolean = false;
		private var cpu:Processor;
		
		public function FrameClock ( stage:Stage, cpu:Processor, AllocatedTimeMS:uint = 5, BatchSize:uint = 500 )
		{
			
			this.stage = stage;
			altim = AllocatedTimeMS;
			batch = BatchSize;
			this.cpu = cpu;
			
		};
		
		public function start () : void
		{
			
			if ( !isRun )
			{
				
				stage.addEventListener ( Event.ENTER_FRAME, tick_internal );
				isRun = true;
			
			}
			
		};
		
		public function stop () : void
		{
			
			if ( isRun )
			{
				
				isRun = false;
				stage.removeEventListener ( Event.ENTER_FRAME, tick_internal );
			
			}
			
		};
		
		private function tick_internal ( E:Event ) : void
		{
			
			var cTime:uint = getTimer ();
			
			while ( getTimer () - cTime < altim )
				for ( var i:uint = 0; i < batch; i ++ )
				{
					
					count ++;
					cpu.step ();
					
				}
			
		}
		
		public function resetCount () : void
		{
			
			count = 0;
		
		};
		
		public function get tick_count () : uint
		{
			
			return count;
			
		}
		
	}
	
}