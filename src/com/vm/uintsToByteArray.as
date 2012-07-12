package com.vm
{
	import flash.utils.ByteArray;
	
	public function uintsToByteArray ( data:Vector.<uint> ) : ByteArray
	{
		
		var out:ByteArray = new ByteArray ();
		out.length = data.length;
		
		for ( var i:uint = 0; i < data.length; i ++ )
			out.writeByte ( ( data [ i ] as int ) - 128 );
		
		return out;
		
	};
	
	
	
}