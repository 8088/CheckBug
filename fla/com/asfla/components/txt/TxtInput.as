package com.asfla.components.txt 
{
	import com.asfla.components.scroll.Scrollbar;
	import com.asfla.components.events.ScrollEvent;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	
	import com.asfla.components.interfaces.IComponents;
	/*********************************
	 * AS3.0 asfla_TxtInput CODE
	 * BY 8088 2011-04-22
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	*********************************/
	public class TxtInput extends Sprite implements IComponents
	{
		private var txt_field:TextField;
		private var txt_mask:Shape;
		private var _enable:Boolean;
		private var _line:int;
		private var scrollbar:Scrollbar;
		private const _border:int = 2;
		private var _default_txt:String;
		public var bg:MovieClip;
		public function TxtInput()
		{
			mouseChildren = false;
			tabChildren = false;
			tabEnabled = false;
			var grid:Rectangle = new Rectangle(5, 5, 10, 10);
			bg.scale9Grid = grid;
			bg.stop();
			
			txt_field = new TextField();
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "Verdana";
			txt_field.defaultTextFormat = txtFormat;
			addChild(txt_field);
			
			_default_txt = "";
			initTxt();
		}
		private function initTxt():void {
			txt_field.x = _border;
			txt_field.y = _border-1;
			txt_field.height = bg.height;
			txt_field.width = bg.width - _border * 2;
			txt_field.type = "input";
			txt_field.selectable = true;
			txt_field.mouseWheelEnabled = false;
			txt_field.cacheAsBitmap = true;
		}
		private function focusInHandler(evt:FocusEvent):void {
			if (txt_field.text == _default_txt) {
				txt_field.text = "";
			}
			bg.gotoAndStop("focus_in");
		}
		private function focusOutHandler(evt:FocusEvent):void {
			if (txt_field.text == "") {
				txt_field.text = _default_txt;
			}
			bg.gotoAndStop("focus_out");
		}
		private function changeHandler(evt:Event = null):void {
			if (txt_field.textHeight+5 < bg.height) {
				initTxt();
				if (scrollbar) {
					scrollbar.enable = false;
					removeChild(scrollbar);
					scrollbar = null;
				}
				if (txt_mask) {
					txt_mask.graphics.clear();
					txt_field.mask = null;
					removeChild(txt_mask);
					txt_mask = null;
				}
				return;
			}
			//
			if (!txt_field.multiline) return;
			//多行并可以滚动
			if (!scrollbar) {
				scrollbar = new Scrollbar();
				addChild(scrollbar);
				scrollbar.x = bg.width - scrollbar.width - 1;
				scrollbar.y = 1;
				scrollbar.height = bg.height - 2;
			}
			txt_field.width = scrollbar.x;
			txt_field.wordWrap = true;
			txt_field.height = txt_field.textHeight + 20;
			if (!txt_mask) {
				txt_mask = new Shape();
				txt_mask.graphics.beginFill(0);
				txt_mask.graphics.drawRect(_border, _border, txt_field.width, bg.height - _border * 2);
				txt_mask.graphics.endFill();
				txt_field.mask = txt_mask;
				addChild(txt_mask);
			}
			
			if (txt_field.textHeight > txt_field.height) {
				scrollbar.txtMax = txt_field.maxScrollV;
				scrollbar.line_height = 12;
				scrollbar.addEventListener(ScrollEvent.SCROLL, scroll1Handler);
			}
		}
		private function scroll1Handler(evt:ScrollEvent):void {
			txt_field.scrollV = evt.num;
		}
		private function Open():void {
			mouseChildren = true;
			bg.gotoAndStop("focus_out");
			txt_field.textColor = 0x666666;
			txt_field.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			txt_field.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			txt_field.addEventListener(Event.CHANGE, changeHandler);
		}
		private function Close():void {
			mouseChildren = false;
			bg.gotoAndStop("close");
			txt_field.textColor = 0xCCCCCC;
			txt_field.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			txt_field.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			txt_field.removeEventListener(Event.CHANGE, changeHandler);
		}
		//API
		override public function set height(_h:Number):void {
			bg.height = _h;
			txt_field.height = _h;
			super.height = this.height;
		}
		override public function set width(_w:Number):void {
			bg.width = _w;
			txt_field.width = _w;
			super.width = this.width;
		}
		public function get txt():TextField {
			return txt_field;
		}
		public function set t(str:String) {
			txt_field.text = str;
			changeHandler();
		}
		public function set default_txt(str:String) {
			_default_txt = str;
			if (txt_field.text == "") {
				txt_field.text = _default_txt;
			}
			changeHandler();
		}
		public function get t():String{
			return txt_field.text;
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