package
{
	
	import com.asm.Assembler;
	import com.vm.memory.Memory;
	import com.vm.memory.PagedMemory;
	import com.vm.system.DataBus;
	import com.vm.system.InterruptEvent;
	import com.vm.system.Processor;
	
	import flash.display.Sprite;
	
	public class Main extends Sprite
	{
		
		private var mem:Memory;
		private var bus:DataBus;
		private var cpu:Processor;
		private var asm:Assembler;
		
		public function Main ()
		{
			
			asm = new Assembler ();
			bus = new DataBus ();
			mem = new Memory ( 0x10000 );      // Maximum for 16-bit adress space
			cpu = new Processor ( mem, bus );
			
			asm.loadASM ( 
				"MOV IA-!IA+ 1000 " +
				"ADD IA-!IA+ 200 " +
				"MOV AL!BL IA-!IA+ " +
				"INT 8 " +
				"-gh " +
				"JMP $gh " +
				"-inthandle " +
				"CLI " +
				"PUSH AX " +
				"PUSH IA- " +
				"PUSH IA+ " +
				"MOV AX AL " +
				""
				);
			
			trace ( asm.compile () );
			
			mem.flushZeros ();
			mem.writeFile ( 0, asm.getBinary () );
			
			cpu.reset ( asm.entryAdress );
			
			bus.startListeningForInterrupt ( 10, int10 );
			bus.startListeningForInterrupt ( 9, int9 );
			bus.startListeningForInterrupt ( 8, int8 );
			
			for ( var i:uint = 0; i < 10000; i ++ )
				cpu.step ();
			
		}
		
		private function int10 ( I:InterruptEvent ) : void
		{
			
			trace ( String.fromCharCode ( I.A | ( I.B << 8 ) ) );
			
		}
		
		private function int9 ( I:InterruptEvent ) : void
		{
			
			trace ( I.A.toString ( 2 ) );
			
		}
		
		private function int8 ( I:InterruptEvent ) : void
		{
			
			trace ( ( I.A + ( I.B << 8 ) ).toString ( 10 ) );
			
		}
		
	}
	
}