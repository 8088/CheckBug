package com.asfla.components.radiobtn 
{
	import com.asfla.components.interfaces.IComponents;
	import flash.display.*;
	import flash.events.*;
	/*********************************
	 * AS3.0 asfla_Radiobtn CODE
	 * BY 8088 2010-10-25
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class Radiobtn extends Sprite implements IComponents
	{
		private var _check:Boolean;
		private var _enable:Boolean;
		public function Radiobtn() 
		{
			this.mouseChildren = false;
			icon.visible = false;
			icon.gotoAndStop("close");
			bg.gotoAndStop("close");
		}
		private function mouseOverHandler(evt:MouseEvent):void {
			bg.gotoAndStop("over");
		}
		private function mouseOutHandler(evt:MouseEvent):void {
			bg.gotoAndStop("out");
		}
		private function mouseDownHandler(evt:MouseEvent):void {
			if (icon.visible) {
				icon.visible = false;
			}else {
				icon.visible = true;
			}
			dispatchEvent(new Event("CHECK"));
		}
		private function Open(evt:MouseEvent = null):void {
			bg.gotoAndStop("out");
			icon.gotoAndStop("out");
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		private function Close():void {
			bg.gotoAndStop("close");
			icon.gotoAndStop("close");
			this.buttonMode = false;
			
			this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		//API
		public function get check():Boolean {
			return this._check;
		}
		public function set check(b:Boolean):void {
			this._check = b;
			if (_check) {
				icon.visible = true;
			}else {
				icon.visible = false;
			}
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