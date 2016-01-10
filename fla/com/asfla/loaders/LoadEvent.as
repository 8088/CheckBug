package com.asfla.loaders 
{
	import flash.events.*;
	
	/*********************************
	 * AS3.0 asfla_loader CODE
	 * BY 8088 2009-11-13
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class LoadEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const OPEN:String = "open";
		public static const PROGRESS:String = "progress";
		public static const SECURITY_ERROR:String = "security_error";
		public static const HTTP_STATUS:String = "http_status";
		public static const IO_ERROR:String = "io_error";
		public static const ERROR:String = "error";
		
		public var name:String;
        public var errors:Array;
        
		public function LoadEvent(name:String, bubbles:Boolean=true, cancelable:Boolean=false ){
			super(name, bubbles, cancelable);		
			this.name = name;
		}
        		
		override public function toString():String{
            return super.toString();
		}
		
	}
	
}