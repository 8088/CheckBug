package com.asfla.air.checkbug.events 
{
	import flash.events.Event;
	
	/**
	 +------------------------------------------------
	 * AIR CheckBugEvent CODE CheckBug events
	 +------------------------------------------------ 
	 * @author 8088 at 2011-07-18
	 * version: 0.1
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class CheckBugEvent extends Event 
	{
		private var _status:String;
		
		public static const HAS_NEW_VERSION:String = "has_new_version";
		public static const CONFIG_COMPLETE:String = "config_complete";
		public static const STATUS_CHANGE:String = "status_change";
		
		public function CheckBugEvent(type:String, status:String="", bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_status = status;
		} 
		
		public override function clone():Event 
		{ 
			return new CheckBugEvent(type, status, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{
			return formatToString("CheckBugEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get status():String {
			if (_status) return _status;
			else return "";
		}
		
	}
	
}