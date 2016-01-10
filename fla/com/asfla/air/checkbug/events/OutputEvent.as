package com.asfla.air.checkbug.events 
{
	import flash.events.Event;
	
	/**
	 +------------------------------------------------
	 * AIR OutputEvent CODE  Output events
	 +------------------------------------------------ 
	 * @author 8088 at 2011-07-20
	 * version: 0.1
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class OutputEvent extends Event 
	{
		private var _color:uint;
        private var _msg:String;
        public static const OUTPUT_MEMORY:String = "output_memory";
        public static const OUTPUT_MESSAGE:String = "output_message";
        public static const OUTPUT_ERROR:String = "output_error";
        public static const OUTPUT_BITMAP:String = "output_bitmap";
        public static const OUTPUT_CLEAR:String = "output_clear";
        public static const OUTPUT_WARNING:String = "output_warning";
        public static const OUTPUT_OBJECT:String = "output_object";
		public function OutputEvent(type:String, msg:String = null, color:uint = 16711422)
		{ 
			super(type);
			_msg = msg;
			_color = color;
		} 
		
		public override function clone():Event 
		{ 
			return new OutputEvent(type, msg, color);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("OutputEvent", "type", "msg", "color"); 
		}
		
		public function get msg():String {
			return _msg;
		}
		
		public function get color():uint {
			return _color;
		}
	}
	
}