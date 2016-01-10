package com.asfla.components.events 
{
	import flash.events.Event;
	
	/**
	 +------------------------------------------------
	 * AS3.0 ScrollEvent CODE Scrollbar event 
	 +------------------------------------------------ 
	 * @author 8088 at 2011-07-22
	 * version: 1.0
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class ScrollEvent extends Event 
	{
		public static const SCROLL:String = "scroll";
		private var _num:Number;
		public function ScrollEvent(type:String, num:Number, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_num = num;
		} 
		
		public override function clone():Event 
		{ 
			return new ScrollEvent(type, _num, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ScrollEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get num():Number {
			return _num;
		}
	}
	
}