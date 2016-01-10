package com.asfla.air.checkbug.ui 
{
	import com.asfla.components.btn.Basebtn;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 +------------------------------------------------
	 * AIR Topbtn CODE top_btn 
	 +------------------------------------------------ 
	 * @author 8088 at 2011-07-18
	 * version: 0.1
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class Topbtn extends Basebtn
	{
		public var icon:MovieClip;
		private var _top:Boolean;
		public function Topbtn()
		{
			icon.stop();
			
		}
		override public function Down(evt:MouseEvent = null):void {
			this.gotoAndStop("down");
			top = !top;
		}
		//API
		public function set top(t:Boolean):void {
			_top = t;
			if (_top) icon.gotoAndStop(2);
			else icon.gotoAndStop(1);
		}
		public function get top():Boolean {
			return _top;
		}
		//OVER
	}
	
}