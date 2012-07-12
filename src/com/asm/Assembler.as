package com.asm
{
	
	import com.asm.architechture;
	
	import flash.utils.ByteArray;
	
	public class assembler
	{
		
		private var asm:String;
		private var blocks:Vector.<String> = new Vector.<String> ();
		private var ind:uint;
		private var labels:Object;
		private var variables:Object;
		private var bin:ByteArray;
		private var binReady:Boolean = false;
		private var entryPoint:uint = 0;
		
		public function assembler ()
		{	
		};
		
		//Copy in the code
		public function loadASM ( asm:String ) : void
		{
			
			this.asm = asm;
		
		}
		
		//Compiles the program. Returns false if compilation failed.
		public function compile () : Boolean  
		{
			
			removeComments ();
			spaceSeperatedBlocks ();
			
			if ( !verify () )
			{
				
				return false;
			
			}
			
			try
			{
				
				idRefs ();
				build ();
			
			}
			catch ( err:* )
			{
				
				binReady = false;
				return false;
			
			}
			
			binReady = true;
			
			bin.position = 0;
			return true;
			
		}
		
		//Builds the binary
		private final function build () : void
		{
			
			var radMode:Boolean = false;
			var byte:uint = 0;
			var blk:String;
			var opnum:uint;
			var op:opcode;
			var vdat:uint;
			var vsz:uint;
			var oargs:Vector.<String>;
			
			entryPoint = 0;
			
			bin = new ByteArray ();
			bin.position = 0;
			
			for ( var i:uint = 0; i < blocks.length; i ++ )
			{
				
				blk = blocks [ i ];
				
				if ( blockIsAssertion ( blk ) )  // Catch assertions
				{
					
					if ( blk == "#ABSADDR" )
						radMode = false;
					if ( blk == "#RELADDR" )
						radMode = true;
					if ( blk == "#ENTRY" )
						entryPoint = byte;
					
				}
				
				if ( blockIsInstruction ( blk ) ) // Instruction decoding
				{
					
					var io:uint = 1;
					var qoff:uint = 1;
					
					oargs = new Vector.<String> ();
					
					// get a list of the argument typyes
					while ( io + i < blocks.length )
					{
						
						if ( ! isArg ( blocks [ i + io ] ) )
							break;
						
						oargs.push ( getArgType ( blocks [ i + io ] ) );
						io ++
						
					}
					
					// using said list and the tag, figure out the appropriate operation
					opnum = solveIstruction ( blk, oargs );
					op = architechture.OPCODE_SET [ opnum ];
					
					// write the opcode
					bin.position = byte;
					bin.writeByte ( ( op.code as int ) - 128 );
					
					// write arguments according to the defined opcode pattern
					for ( var on:uint = 0; on < op.arguments.length; on ++ )
					{
						
						switch ( op.arguments [ on ] )
						{
							
							// Adress argument
							case args.ADDRESS:
								
								// Refrence 
								if ( blockIsRefrence ( blocks [ i + on + 1 ] ) )
								{
									
									vdat = labels [ blocks [ i + on + 1 ].slice ( 1 ) ];
									
									if ( radMode )
										vdat = vdat - byte + 0x7FFF;
									
									bin.writeByte ( ( ( vdat & 0x00FF ) as int ) - 128 );
									bin.writeByte ( ( ( ( vdat & 0xFF00 ) as int ) >> 8 ) - 128 );
									
								}
								// Hard coded
								else
								{
										
									vdat = getConstantValue ( blocks [ i + on + 1 ] );
									
									if ( radMode )
										vdat = vdat - byte + 0x7FFF;
									
									bin.writeByte ( ( ( vdat & 0x00FF ) as int ) - 128 );
									bin.writeByte ( ( ( ( vdat & 0xFF00 ) as int ) >> 8 ) - 128 );
									
								}
								
								qoff += 2;
								
								break;
								// Constant argument
							case args.CONSTANT:
								
								vdat = getConstantValue ( blocks [ i + on + 1 ] );
								
								bin.writeByte ( ( vdat as int ) - 128 );
								qoff ++;
							
								break;
								// Register argument
							case args.REGISTER:
								
								bin.writeByte ( ( regNum ( blocks [ i + on + 1 ] ) as int ) - 128 );
								qoff ++;
								
								break;
								// Register pair argument
							case args.DOUBLE_REGISTER:
								
								var arth:Array = seperateDoubleRegister ( blocks [ i + on + 1 ] );
								bin.writeByte ( ( regNum ( arth [ 0 ] ) as int ) - 128 );
								bin.writeByte ( ( regNum ( arth [ 1 ] ) as int ) - 128 );
								qoff += 2;
								
								break;
							
						}
						
					}
					
					byte += qoff;
					qoff = 0;
					
				}
				// Data block
				else if ( blockIsData ( blk ) )
				{
					
					vdat = getVariableValue ( blk );
					vsz = sizeOfNum ( vdat );
					bin.position = byte;
					
					switch ( vsz )
					{
						
						case 1:
							
							bin.writeByte ( ( vdat as int ) -128 );
							byte ++;
							
							break;
						
						case 2:
							
							bin.writeByte ( ( ( vdat & 0x00FF ) as int ) -128 );
							bin.writeByte ( ( ( ( vdat & 0x00FF00 ) >> 8 ) as int ) -128 );
							byte += 2;
							
							break;
						
						case 3:
							
							bin.writeByte ( ( ( vdat & 0x0000FF ) as int ) -128 );
							bin.writeByte ( ( ( ( vdat & 0x00FF00 ) >> 8 ) as int ) -128 );
							bin.writeByte ( ( ( ( vdat & 0xFF0000 ) >> 16 ) as int ) -128 );
							byte += 3;
							
							break;
						
						case 4:
							
							bin.writeByte ( ( ( vdat & 0x000000FF ) as int ) -128 );
							bin.writeByte ( ( ( ( vdat & 0x00FF0000 ) >> 8 ) as int ) -128 );
							bin.writeByte ( ( ( ( vdat & 0xFF000000 ) >> 16 ) as int ) -128 );
							bin.writeByte ( ( ( ( vdat & 0xFF000000 ) >> 24 ) as int ) -128 );
							byte += 4;
							
							break;
						
					}
					
				}
				
			}
			
			bin.length = byte;
			
		};
		
		//searches out all the lavels and variables
		private final function idRefs () : void
		{
			
			labels = new Object ();
			variables = new Object ();
			var blk:String;
			var byte:uint = 0;
			
			for ( var i:uint = 0; i < blocks.length; i ++ )
			{
				
				blk = blocks [ i ];
				
				if ( blockIsData ( blk ) )
				{
					
					var tag:String = getVariableName ( blk );
					if ( tag != "" )
						variables [ tag ] = byte;
					byte += sizeOfNum ( getVariableValue ( blk ) );
					
				}
				else if ( blockIsConstant ( blk ) )
				{
					
					var num:uint = getConstantValue ( blk );
					byte += sizeOfNum ( num );
					
				}
				else if ( blockIsRefrence ( blk ) || blockIsDoubleRegister ( blk ) )
					byte += 2;
				else if ( blockIsLabel ( blk ) )
				{
					
					var name:String = getLabelName ( blk );
					labels [ name ] = byte;
					
				}
				else if ( ! blockIsAssertion ( blk ) )
					byte ++;
				
			}
			
		};
		
		//Solves for the appropriat operation based on the tag and arguments
		private final function solveIstruction ( Itag:String, argTypes:Vector.<String> ):uint
		{
			
			var i:instruction;
			for ( var n:uint = 0; n < architechture.INSTRUCTION_SET.length; n ++ )
			{
				if ( architechture.INSTRUCTION_SET [ n ].tag == Itag.toLocaleUpperCase () )
					i = architechture.INSTRUCTION_SET [ n ];
			}
			
			if ( i.ops.length == 1 )
				return i.ops [ 0 ].code;
			
			var oargs:Vector.<String>;
			
			for ( var k:uint = 0; k < i.ops.length; k ++ )
			{
				
				oargs = i.ops [ k ].arguments;
				if ( argTypes.length == oargs.length )
					for ( var t:uint = 0; t < oargs.length; t ++ )
					{
						
						if ( argTypes [ t ] == oargs [ t ] )
						{
							if ( t == oargs.length - 1 )
								return i.ops [ k ].code;
						}
						else
							break;
						
					}
				
			}
			
			return 0;
			
		}
		
		//returns the numerical value of a register based on it's tag
		private final function regNum ( block:String ) : uint
		{
			
			for ( var i:uint = 0; i < architechture.REGSITERS.length; i ++ )
			{
				
				if ( block == architechture.REGSITERS [ i ].tag )
					return architechture.REGSITERS [ i ].num;
			
			}
			
			return 0;
		
		}
		
		//Determines of a block is a valid argument type
		private final function isArg ( block:String ) : Boolean
		{
			
			if ( blockIsData ( block ) )
				return false;
			
			if ( blockIsLabel ( block ) )
				return false;
			
			if ( blockIsConstant ( block ) )
				if ( sizeOfNum ( getConstantValue ( block ) ) > 2 )
					return false;
			
			if ( blockIsAssertion ( block ) )
				return false;
			
			if ( blockIsInstruction ( block ) )
				return false;
			
			return true;
			
		}
		
		//Figures out the argument type
		private final function getArgType ( block:String ) : String
		{
			
			if ( blockIsRegister ( block ) )
				return args.REGISTER;
			
			if ( blockIsDoubleRegister ( block ) )
				return args.DOUBLE_REGISTER;
			
			if ( blockIsRefrence ( block ) )
				return args.ADDRESS; 
			
			if ( blockIsConstant ( block ) )
			{
				
				if ( block.charAt ( 0 ) == '!' )
					return args.ADDRESS;
				
				return args.CONSTANT;
			
			}
			
			return "ARG_ERROR";
			
		};
		
		//Returns the name of a variable
		private final function getVariableName ( block:String ) : String
		{
			
			var cname:String = "";
			var inName:Boolean = false;
			
			for ( var i:uint = 0; i < block.length; i ++ )
			{
				
				if ( block.charAt ( i ) == ']' )
					return cname;
				
				if ( inName )
					cname = cname.concat ( block.charAt ( i ) );
				
				if ( block.charAt ( i ) == ':' )
					inName = true;
				
			}
			
			return "";
			
		}
		
		//Returns ( initial ) the value of a variable
		private final function getVariableValue ( block:String ) : uint
		{
			
			var numString:String = "";
			
			for ( var i:uint = 1; i < block.length; i ++ )
			{
				
				if ( block.charAt ( i ) == ']' || block.charAt ( i ) == ':' )
					return uint ( numString );
				
				numString = numString.concat ( block.charAt ( i ) );
				
			}
			
			return 0;
			
		};
		
		//Returns the value of a constant
		private final function getConstantValue ( block:String ) : uint
		{
			
			if ( block.charAt ( 0 ) == '!' )
				block = block.slice ( 1 )
			
			return uint ( block );
		
		};
		
		//Returns the name of a label
		private final function getLabelName ( block:String ) : String
		{
			
			return block.slice ( 1 );
		
		};
		
		//Returns the number of bytes a number will take up
		private final function sizeOfNum ( num:uint ) : uint
		{
			
			if ( num & 0xFF000000 )
				return 4;
			
			if ( num & 0x00FF0000 )
				return 3;
			
			if ( num & 0x0000FF00 )
				return 2;
			
			return 1;
			
		};
		
		//Seperates a double register into it's components.
		private final function seperateDoubleRegister ( block:String ) : Array
		{
			
			return block.split ( "!" );
		
		};
		
		//does a quick check to make sure all the blocks are valid. ( helps to prevent from parsing errors )
		private final function verify () : Boolean
		{
			
			var cbl:String;
			
			for ( var i:uint = 0; i < blocks.length; i ++ )
			{
				
				cbl = blocks [ i ];
				if ( ! ( blockIsLabel ( cbl ) || blockIsInstruction ( cbl ) || blockIsData ( cbl ) || blockIsRegister ( cbl ) || blockIsConstant ( cbl ) || blockIsRefrence ( cbl ) || blockIsAssertion ( cbl ) || blockIsDoubleRegister ( cbl ) ) )
					return false;
				
			}
			
			return true;
			
		};
		
		//Tests if a block of code is a compiler assertion
		private final function blockIsAssertion ( block:String ) : Boolean
		{
			
			block = block.toLocaleUpperCase ();
			
			if ( block == "#ABSADDR" )
				return true;
			if ( block == "#RELADDR" )
				return true;
			if ( block == "#ENTRY" )
				return true;
			
			return false;
		
		};
		
		//Tests if a block is a refrence statement
		private final function blockIsRefrence ( block:String ) : Boolean
		{
			
			return block.charAt ( 0 ) == "$";
		
		};
		
		//Tests to see if a block is a a constant
		private final function blockIsConstant ( block:String ) : Boolean
		{
			
			if ( block.charAt ( 0 ) == '!' )
				block = block.slice ( 1 );
			
			if ( uint ( block ).toString ( 10 ) == block )
				return true;
			
			if ( "0x" + uint ( block ).toString ( 16 ) == block.toLocaleLowerCase () )
				return true;
			
			return false;
			
		};
		
		//Tests to see if a block is a label
		private final function blockIsLabel ( block:String ) : Boolean
		{
			
			return block.charAt ( 0 ) == '-';
		
		};
		
		//Tests to see if a block is an instruction
		private final function blockIsInstruction ( block:String ) : Boolean
		{
			
			for ( var i:uint = 0; i < architechture.INSTRUCTION_SET.length; i ++ )
				if ( block.toLocaleUpperCase() == architechture.INSTRUCTION_SET [ i ].tag )
					return true;
			
			return false;
		
		};
		
		//Checks to see if a block is a data chunk/variable
		private final function blockIsData ( block:String ) : Boolean
		{
			
			return block.charAt ( 0 ) == '[' && block.charAt ( block.length - 1 ) == ']';
		
		};
		
		//Checks if a block is a register
		private final function blockIsRegister ( block:String ) : Boolean
		{
			
			for ( var i:uint = 0; i < architechture.REGSITERS.length; i ++ )
				if ( block == architechture.REGSITERS [ i ].tag )
					return true;
			
			return false;
		
		};
		
		//Tests to see if a block is a double register
		private final function blockIsDoubleRegister ( block:String ) : Boolean
		{
			
			var ba:Array = block.split ( "!" );
			
			if ( ba.length == 2 )
				return blockIsRegister ( ba [ 0 ] ) && blockIsRegister ( ba [ 1 ] );
			
			return false;
		
		};
		
		//Seperates code out into blocks by whitespace
		private final function spaceSeperatedBlocks () : void
		{
			
			var qar:Array
			
			asm = asm.replace( /[ \n\t\r]+/g, " " );
			qar = asm.split ( " " );
			
			blocks.length = qar.length;
			for ( var i:uint = 0; i < qar.length; i ++ )
			{
				
				if ( qar [ i ].replace( /[ \n\t\r]+/g, "" ) != "" )
					blocks [ i ] = qar [ i ];
				else
					blocks.length --;
			
			}
			
		};
		
		private final function removeComments () : void
		{
			
			var incm:Boolean;
			var sind:uint;
			var indx:uint = 0;
			
			while ( indx < asm.length )
			{
				
				if ( indx >= asm.length - 3 )
				{
					
					if ( incm )
						asm = asm.slice ( 0, sind );
					return;
				
				}
				
				if ( incm && ( asm.charAt ( indx ) == '\n' || asm.charAt ( indx ) == '\r' ) )
				{
					
					incm = false;
					asm = asm.slice ( 0, sind ) + asm.slice ( indx );
					indx = sind;
				
				}
				else if ( asm.charAt ( indx ) == ';' )
				{
					
					sind = indx;
					incm = true;
				
				}
				
				indx ++;
				
			}
			
		};
		
		//Returns the binary file after compiled
		public final function getBinary () : ByteArray
		{
			
			return bin;
		
		};
		
		public final function get binaryIsReady () : Boolean
		{
			
			return binReady;
			
		};
		
		public final function get entryAdress () : uint
		{
			
			return entryPoint;
			
		}
		
	}
	
}