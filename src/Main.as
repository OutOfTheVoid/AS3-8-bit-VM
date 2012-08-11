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
		private var pmem:PagedMemory;
		private var bus:DataBus;
		private var cpu:Processor;
		private var asm:Assembler;
		
		public function Main ()
		{
			
			asm = new Assembler ();
			bus = new DataBus ();
			//mem = new Memory ( 0x10000 );      // Maximum for 16-bit adress space
			pmem = new PagedMemory ( 0x10000, 1024, 1024, 255 ); // again full 16-bit adress space, but with 255 extra sets of 1,024 bytes. ( 326,145 bytes total )
			cpu = new Processor ( pmem, bus );
			
			asm.loadASM ( 
				"[0x61:sw] " +
				"#ENTRY " +
				"-start " +
				"MOV BX .sw " +
				"-setax " +
				"MOV AX 10 " +
				"-decax " +
				"DEC AX " +
				"JNZ $decax AX " +
				"INT 10 BX!CX " +
				"INC BX " +
				"SUB BX 0x7B " +
				"JNZ $setax IA- " +
				"JMP $start"
				);
			
			asm.compile ();
			
			//mem.flushZeros ();
			//mem.writeFile ( 0, asm.getBinary () );
			
			pmem.flushZeros ();
			pmem.writeFile ( 0, asm.getBinary (), true, true, 0 );
			
			cpu.reset ( asm.entryAdress );
			
			bus.startListeningForInterrupt ( 10, int10 );
			bus.startListeningForInterrupt ( 2, int2 );
			
			for ( var i:uint = 0; i < 10000; i ++ )
				cpu.step ();
			
		}
		
		private function int10 ( I:InterruptEvent ) : void
		{
			
			trace ( String.fromCharCode ( I.data ) );
			
		}
		
		private function int2 ( I:InterruptEvent ) : void
		{
			
			pmem.page = I.data;
			
		}
		
	}
	
}