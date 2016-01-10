package com.asfla.components.btn 
{
	import com.asfla.components.interfaces.IComponents;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/*********************************
	 * AS3.0 asfla_Basebtn CODE
	 * BY 8088 2009-08-26
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class Basebtn extends MovieClip implements IComponents
	{
		private var _enable:Boolean;
		public function Basebtn() 
		{
			mouseChildren = false;
			stop();
		}
		public function Over(evt:MouseEvent =null):void {
			gotoAndStop("over");
		}
		private function Out(evt:MouseEvent =null):void {
			gotoAndStop("out");
		}
		public function Open():void {
			gotoAndStop("out");
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_OVER, Over);
			addEventListener(MouseEvent.MOUSE_OUT, Out);
			addEventListener(MouseEvent.MOUSE_DOWN, Down);
			addEventListener(MouseEvent.MOUSE_UP, Over);
		}
		public function Close():void {
			this.gotoAndStop("close");
			this.buttonMode = false;
			this.removeEventListener(MouseEvent.MOUSE_OVER, Over);
			this.removeEventListener(MouseEvent.MOUSE_OUT, Out);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, Down);
			this.removeEventListener(MouseEvent.MOUSE_UP, Over);
		}
		public function Down(evt:MouseEvent =null):void {
			this.gotoAndStop("down");
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
		//OVER
	}
	
}