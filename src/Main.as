package
{
	
	import com.asm.assembler;
	import com.vm.dataBus;
	import com.vm.interruptEvent;
	import com.vm.memory;
	import com.vm.processor;
	
	import flash.display.Sprite;
	
	public class Main extends Sprite
	{
		
		private var mem:memory;
		private var bus:dataBus;
		private var cpu:processor;
		private var asm:assembler;
		
		public function Main ()
		{
			
			asm = new assembler ();
			bus = new dataBus ();
			mem = new memory ( 0x10000 );      // Maximum for 16-bit adress space
			cpu = new processor ( mem, bus );
			
			asm.loadASM ( 
				"#ENTRY " +
				"-start " +
				"MOV BX 0x61 " +
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
		
		private function int10 ( I:interruptEvent ) : void
		{
			
			trace ( String.fromCharCode ( I.data ) );
			
		}
		
	}
	
}