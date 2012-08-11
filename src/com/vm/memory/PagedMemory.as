package com.vm.memory
{
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class PagedMemory
	{
		
		private var data:ByteArray;
		private var size:uint;
		private var size_paged:uint;
		private var pageBegin:uint;
		private var pageEnd:uint;
		private var page:uint;
		private var pages:uint;
		
		public function PagedMemory ( SizePaged:uint = 65536, PageBegin:uint = 3, PageSize:uint = 1024, Pages:uint = 64 )
		{
			
			size = SizePaged + PageSize * ( Pages - 1 );
			size_paged = SizePaged;
			pageBegin = PageBegin;
			pageEnd = PageBegin + PageSize - 1;
			page = 0;
			pages = Pages;
			
			data = new ByteArray ();
			data.endian = Endian.LITTLE_ENDIAN;
			data.length = size;
			
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
		
		private final function resolvePosition ( address:uint ) : uint
		{
			
			if ( address < pageBegin )
				return address;
			return address + ( pageEnd - pageBegin + 1 ) * ( ( page < pages ) ? page : pages );
			
		};
		
		public final function read ( address:uint ) : uint
		{
			
			if ( address < size_paged )
			{
				
				data.position = resolvePosition ( address );
				return data.readByte () + 128;
				
			}
			return 0;
			
		};
		
		public final function write ( address:uint, value:uint ) : void
		{
			
			if ( address < size_paged && value < 256 )
			{
				
				data.position = resolvePosition ( address );
				data.writeByte ( ( value as int ) - 128 );
				
			}
			
		};
		
		public final function writeFile ( address:uint, file:ByteArray, paging:Boolean = false, pageLoop:Boolean = true, page:uint = 0 ) : void
		{
			
			if ( paging && address + file.length >= pageBegin )
			{
				
				if ( pageLoop )
				{
					
					this.page = page;
					file.position = 0;
					
					for ( var n:uint = 0; n < file.length; n ++ )
					{
						
						if ( n > pageEnd )
							page ++;
						
						data.position = ( page < pages ) ? resolvePosition ( ( address - pageBegin ) % ( pageEnd - pageBegin + ) + pageBegin ) : resolvePosition ( address );
						
						
					}
					
				}
				else
				{
					
					this.page = page;
					file.position = 0;
					
					for ( var n:uint = 0; n < file.length; n ++ )
					{
						
						data.position = resolvePosition ( n + address );
						data.writeByte ( file.readByte () );
						
					}
					
				}
				
			}
			else
			{
				
				if ( file.length + address < size )
				{
					
					data.position = address;
					file.position = 0;
					
					for ( var i:uint = 0; i < file.length; i ++ )
						data.writeByte ( file.readByte () );
					
				}
				
			}
			
		};
		
	}
	
}