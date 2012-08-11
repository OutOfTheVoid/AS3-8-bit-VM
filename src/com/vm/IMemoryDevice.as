package com.vm
{
	
	import flash.utils.ByteArray;
	
	public interface IMemoryDevice
	{
		
		function read ( address:uint ) : uint;
		function write ( address:uint, value:uint ) : void;
		function get length () : uint;
		
	}
	
}