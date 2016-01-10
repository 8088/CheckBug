package com.asfla.components.scroll.ui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author 8088
	 */
	public class Thumb extends Sprite
	{
		private var _enable:Boolean;
		public var icon:Sprite;
		public var bg:MovieClip;
		public function Thumb()
		{
			mouseChildren = false;
			tabChildren = false;
			useHandCursor = false;
			
			bg.stop();
		}
		private function Over(evt:MouseEvent):void {
			bg.gotoAndStop("over");
		}
		private function Out(evt:MouseEvent):void {
			bg.gotoAndStop("out");
		}
		private function Down(evt:MouseEvent):void {
			bg.gotoAndStop("down");
		}
		private function Open():void {
			bg.gotoAndStop("out");
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, Over);
			this.addEventListener(MouseEvent.MOUSE_OUT, Out);
			this.addEventListener(MouseEvent.MOUSE_DOWN, Down);
			this.addEventListener(MouseEvent.MOUSE_UP, Over);
		}
		private function Close():void {
			bg.gotoAndStop("close");
			this.buttonMode = false;
			this.removeEventListener(MouseEvent.MOUSE_OVER, Over);
			this.removeEventListener(MouseEvent.MOUSE_OUT, Out);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, Down);
			this.removeEventListener(MouseEvent.MOUSE_UP, Over);
		}
		//API
		override public function set height(_h:Number):void {
			bg.height = _h;
			if (icon) {
				icon.y = Math.round((bg.height-icon.height)*.5)
			}
			super.height = _h;
		}
		override public function set width(_w:Number):void {
			bg.width = _w;
			if (icon) {
				icon.x = int(bg.width*.5)
			}
			super.width = _w;
		}
		public function get enable():Boolean {
			return this._enable;
		}
		public function set enable(b:Boolean):void {
			this._enable = b;
			if (_enable) {
				Open();
			}else {
				Close();
			}
		}
		
	}
	
}