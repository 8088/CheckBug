package com.asfla.debug{

	import flash.system.Security;
	import flash.external.*;
	import flash.system.*;
	/*********************************
	 * AS3.0 asfla_util_Console CODE
	 * BY 8088 2009-12-15
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	*********************************/
	public class Console {

		// used by the object dump
		public static var od_count = 0;
		public static var tab_string = "";

		public function Console() { }	
		
		public static function log(...args):void
		{
			var logString = (args.length > 1) ? args.join(" : ") : args[0];
			Console.send("console.log" , logString);
		}
		
		public static function info(o:*):void
		{
			Console.send("console.info" , o);
		}
		
		public static function error(o:*):void
		{
			Console.send("console.error" , o);
		}
		
		public static function warn(o:*):void
		{
			Console.send("console.warn" , o);
		}
		
		public static function dump(o:*):void
		{
			Console.send("console.dir" , o);
		}
		
		public static function send(typeString:String , o:*=""):void
		{
			switch (Capabilities.playerType)
			{
	            case "PlugIn":
	            case "ActiveX":

	                try {
						ExternalInterface.call(typeString, o);
					} catch (e:Error) {}

	                break;
				default :
					if(typeString == "console.dir") Console.objectDump(o);
					else trace(o);
	        }
		}
		
		public static function objectDump(o:*):void
		{
			var obj:Object = o as Object;
			for (var prop:String in obj)
			{
				var tab = Console.getTabString();
				trace(tab+"   • "+prop+" : "+obj[prop]);
				if(o[prop] is Object) {
					od_count++;
					Console.objectDump(obj[prop]);
					od_count--;
				}
			}
		}
		public static function getTabString():String
		{
			var str:String = "";
			for (var i:int = 0; i<od_count; i++) str += "\t";

			return str
		}
	}
}