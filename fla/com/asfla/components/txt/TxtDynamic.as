package com.asfla.components.txt 
{
	import com.asfla.components.interfaces.IComponents;
	import com.asfla.components.scroll.Scrollbar;
	import com.asfla.components.events.ScrollEvent;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	/**
	 +------------------------------------------------
	 * AS3.0 TxtDynamic CODE scrollbar & txt
	 +------------------------------------------------ 
	 * @author 8088 at 2011-07-21
	 * version: 1.0
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class TxtDynamic extends Sprite implements IComponents
	{
		private var txt_field:TextField;
		private var _enable:Boolean;
		private var _line:int;
		private var scrollbar:Scrollbar;
		private var _default_txt:String;
		private var _w:uint = 100;
		private var _h:uint = 100;
		private var _line_height:int = 12;//默认滚动行高是12象素
		private var _scroll_max:Boolean;

		public function TxtDynamic() 
		{
			
			tabChildren = false;
			tabEnabled = false;
			
			txt_field = new TextField();
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Verdana";
			txt_field.defaultTextFormat = txtFormat;
			addChild(txt_field);
			
			scrollbar = new Scrollbar();
			scrollbar.line_height = _line_height;
			addChild(scrollbar)
			
			_default_txt = "";
			initTxt();
		}
		private function initTxt():void {
			txt_field.width = _w;
			txt_field.height = _h;
			txt_field.type = "dynamic";
			txt_field.multiline = true;
			txt_field.wordWrap = true;
			txt_field.selectable = true;
			txt_field.mouseWheelEnabled = false;
			txt_field.tabEnabled = false;
			txt_field.cacheAsBitmap = true;
		}
		function scrollHandler(evt:ScrollEvent):void {
			txt_field.scrollV = evt.num;
		}
		private function overHandler(evt:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_WHEEL, scrollbar.mouseWheel);
		}
		private function outHandler(evt:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_WHEEL, scrollbar.mouseWheel);
		}
		private function Open():void {
			mouseChildren = true;
			txt_field.textColor = 0x666666;
			
			scrollbar.addEventListener(ScrollEvent.SCROLL, scrollHandler);
			addEventListener(MouseEvent.ROLL_OVER, overHandler);
			addEventListener(MouseEvent.ROLL_OUT, outHandler);
			change();
		}
		private function Close():void {
			mouseChildren = false;
			txt_field.textColor = 0xCCCCCC;
			scrollbar.removeEventListener(ScrollEvent.SCROLL, scrollHandler);
			scrollbar.txtMax = 0;
		}
		private function change():void {
			txt_field.textHeight;
			scrollbar.txtMax = txt_field.maxScrollV;
			if (_scroll_max) scrollbar.scroll = scrollbar.scrollMax;
		}
		//API
		override public function set height(_h:Number):void {
			txt_field.height = _h;
			if (scrollbar) {
				scrollbar.height = _h;
				change();
			}
			super.height = this.height;
		}
		override public function set width(_w:Number):void {
			txt_field.width = _w;
			if (scrollbar) {
				scrollbar.x = _w;
				change();
			}
			super.width = this.width;
		}
		public function get txt():TextField {
			return txt_field;
		}
		public function set default_txt(str:String) {
			_default_txt = str;
			if (txt_field.text == "") {
				txt_field.text = _default_txt;
			}
		}
		public function get text():String{
			return txt_field.text;
		}
		public function set text(str:String) {
			txt_field.text = str;
			change();
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
		public function set scroll_max(b:Boolean):void {
			_scroll_max = b;
			if(b) scrollbar.scroll = scrollbar.scrollMax;
		}
		public function appendText(str:String):void {
			txt_field.appendText(str);
			change();
		}
		//OVER
	}
	
}