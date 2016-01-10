package com.asfla.components.btn 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import com.asfla.components.interfaces.*;
	
	/*********************************
	 * AS3.0 asfla_Labelbtn CODE
	 * BY 8088 2009-08-26
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class Labelbtn extends Sprite implements IComponents
	{
		public var label_txt:TextField;
		public var bg:MovieClip;
		private var _enable:Boolean;
		public function Labelbtn() 
		{
			mouseChildren = false;
			tabChildren = false;
			tabEnabled = false;
			var grid:Rectangle = new Rectangle(5, 5, 10, 10);
			bg.scale9Grid = grid;
			bg.stop();
            label_txt.textColor = 0x555555;
			label_txt.text = "lable"
			bg.width = int(label_txt.textWidth + 20);
			label_txt.width = bg.width;
		}
		
		private function Over(evt:MouseEvent =null):void {
			bg.gotoAndStop("over");
		}
		private function Out(evt:MouseEvent =null):void {
			bg.gotoAndStop("out");
		}
		private function Down(evt:MouseEvent =null):void {
			bg.gotoAndStop("down");
		}
		private function Open():void {
			bg.gotoAndStop("out");
			label_txt.textColor = 0x939393;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, Over);
			this.addEventListener(MouseEvent.MOUSE_OUT, Out);
			this.addEventListener(MouseEvent.MOUSE_DOWN, Down);
			this.addEventListener(MouseEvent.MOUSE_UP, Over);
		}
		private function Close():void {
			bg.gotoAndStop("close");
			label_txt.textColor = 0x555555;
			this.buttonMode = false;
			this.removeEventListener(MouseEvent.MOUSE_OVER, Over);
			this.removeEventListener(MouseEvent.MOUSE_OUT, Out);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, Down);
			this.removeEventListener(MouseEvent.MOUSE_UP, Over);
		}
		
		//API
		public function set label(str:String):void {
			label_txt.text = str;
			bg.width = label_txt.textWidth + 20;
			label_txt.width = bg.width;
		}
		public function get label():String {
			return label_txt.text as String;
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