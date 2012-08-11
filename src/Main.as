package
{
	
	import com.asm.Assembler;
	import com.vm.system.DataBus;
	import com.vm.system.InterruptEvent;
	import com.vm.memory.Memory;
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
			
			mem.flushZeros ();
			mem.writeFile ( 0, asm.getBinary () );
			
			cpu.reset ( asm.entryAdress );
			
			bus.startListeningForInterrupt ( 10, int10 );
			
			for ( var i:uint = 0; i < 10000; i ++ )
				cpu.step ();
			
		}
		
		private function int10 ( I:InterruptEvent ) : void
		{
			
			trace ( String.fromCharCode ( I.data ) );
			
		}
		
	}
	
}