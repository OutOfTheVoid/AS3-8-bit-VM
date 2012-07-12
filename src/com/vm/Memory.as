package com.vm
{
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public final class Memory
	{
		
		private var data:ByteArray = new ByteArray ();
		private var size:uint;
		
		public final function Memory ( Size:uint = 65536 ) : void
		{
			
			data.length = Size;
			data.endian = Endian.LITTLE_ENDIAN;
			 
			size = Size;
			
		};
		
		public final function flushZeros () : void
		{
			
			data.position = 0;
			
			var i:uint = 0;
			while ( i < size )
			{
				
				data.writeByte ( -128 );
				i ++;
			
			}
			
		};
		
		public final function read ( address:uint ) : uint
		{
			
			if ( address < size )
			{
				
				data.position = address;
				return data.readByte () + 128;
				
			}
			//else
			return 0;
			
		}
		
		public final function write ( address:uint, value:uint ) : void
		{
			
			if ( address < size && value < 256 )
			{
				
				data.position = address;
				data.writeByte ( ( value as int ) - 128 );
				
			}
			
		};
		
		public final function writeFile ( address:uint, file:ByteArray ) : void
		{
			
			if ( file.length + address < size )
			{
				
				data.position = address;
				file.position = 0;
				
				for ( var i:uint = 0; i < file.length; i ++ )
					data.writeByte ( file.readByte () );
				
			}
			
		};
		
		public final function get length () : uint { return size };
		
	}
	
}