package com.asfla.components.scroll 
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import com.asfla.components.interfaces.*;
	import com.asfla.components.events.*;
	import com.asfla.components.btn.Basebtn;
	import com.asfla.components.scroll.ui.Bar;
	import com.asfla.components.scroll.ui.Thumb;
	
	/**
	 +------------------------------------------------
	 * AS3.0 Scrollbar CODE scroll any display object 
	 +------------------------------------------------ 
	 * @author 8088 at 2011-07-21
	 * version: 2.0
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class Scrollbar extends Sprite implements IComponents
	{
		public var min:Basebtn;
		public var max:Basebtn;
		public var bar:Bar;
		public var thumb:Thumb;
		
		private var _enable:Boolean;
		private var _min_thumb:Number;
		private var _fix_thumb:Number;
		private var timer:Timer;
		private var _v:Boolean; //是否垂直
		private var _btn:Basebtn; //确定点的是哪个按钮
		private var _m:Boolean; //记录滚动对象的是否支持鼠标事件。
		private var _n:Number; //滚动对比长度，可设置（默认为Scrollbar长度）。
		private var _b:Number; //
		private var dragRect:Rectangle;
		private var scroll_max:Number;
		private var content_max:Number; 
		private var bar_max:Number;//thumb最大长度
		private var _line_height:int = 1;//默认滚动行高是1象素
		
		public function Scrollbar() 
		{
			if ((bar.height - thumb.height) > 10) {
				_v = true;
			}else {
				_v = false;
			}
			init();
		}
		private function init(evt:Event = null):void {
			//..
			tabChildren = false;
			useHandCursor = false;
			buttonMode = false;
			_n = 0;
			_b = 0;
			_min_thumb = 0;
			scroll_max = 0;
			content_max = 0;
			bar_max = 0;
			thumb.visible = false;
			_min_thumb = thumb.height;
			
			recalculate();
		}
		private function recalculate():void {
			var r_w:Number;
			var r_h:Number;
			if (_v) {
				r_w =  bar.x;
				r_h = Math.round(bar.height - thumb.height);
				scroll_max = r_h;
				_n = this.height;
				bar_max = bar.height;
			}else {
				r_w =  Math.round(bar.width - thumb.width);
				r_h = bar.y;
				scroll_max = r_w;
				_n = this.width;
				bar_max = bar.width;
			}
			_b = content_max / scroll_max;
			
			dragRect = new Rectangle(bar.x, bar.y, r_w, r_h);
		}
		private function Open():void {
			if (min) {
				min.enable = true;
				min.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				min.addEventListener(MouseEvent.MOUSE_UP, stopHandler);
				min.addEventListener(MouseEvent.MOUSE_OUT, stopHandler);
			}
			if (max) {
				max.enable = true;
				max.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				max.addEventListener(MouseEvent.MOUSE_UP, stopHandler);
				max.addEventListener(MouseEvent.MOUSE_OUT, stopHandler);
			}
			
			thumb.enable = true;
			thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDownHandler);
			bar.addEventListener(MouseEvent.MOUSE_DOWN, barDownHandler);
			if (stage){
				stage.addEventListener(MouseEvent.MOUSE_UP, barUpHandler);
				stage.addEventListener(Event.MOUSE_LEAVE, barUpHandler);
			}
		}
		private function Close():void {
			if (min) {
				min.enable = false;
				min.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				min.removeEventListener(MouseEvent.MOUSE_UP, stopHandler);
				min.removeEventListener(MouseEvent.MOUSE_OUT, stopHandler);
			}
			if (max) {
				max.enable = false;
				max.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				max.removeEventListener(MouseEvent.MOUSE_UP, stopHandler);
				max.removeEventListener(MouseEvent.MOUSE_OUT, stopHandler);
			}
			
			thumb.enable = false;
			thumb.visible = false;
			thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDownHandler);
			bar.removeEventListener(MouseEvent.MOUSE_DOWN, barDownHandler);
			if (stage){
				stage.removeEventListener(MouseEvent.MOUSE_UP, barUpHandler);
				stage.removeEventListener(Event.MOUSE_LEAVE, barUpHandler);
			}
			barUpHandler(null);
			stopHandler(null);
		}
		private function mouseDownHandler(evt:MouseEvent):void {
			_btn = evt.target as Basebtn;
			enterFrameHandler();
			
			if (!timer) {
				timer = new Timer(300, 1);
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
			}else {
				if (timer.running) {
					timer.stop();
					this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				}
			}
			timer.start();
		}
		private function stopHandler(evt:MouseEvent):void {
			if (timer)timer.stop();
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		private function timerHandler(evt:TimerEvent):void {
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		private function enterFrameHandler(evt:Event = null):void {
			switch(_btn) {
				case min:
					minHandler();
					break;
				case max:
					maxHandler();
					break;
			}
			dispatchChange();
		}
		private function minHandler(n:Number = 1):void {
			if (_v) {
				if ((thumb.y - bar.y) > n) thumb.y -= n;
				else thumb.y = bar.y;
			}else {
				if ((thumb.x - bar.x) > n) thumb.x -= n;
				else thumb.x = bar.x;
			}
		}
		private function maxHandler(n:Number = 1):void {
			if (_v) {
				if ((bar.y + bar.height - thumb.height - thumb.y) > n) thumb.y += n;
				else thumb.y = bar.y + (bar.height - thumb.height);
			}else {
				if ((bar.x + bar.width - thumb.width - thumb.x) > n) thumb.x += n;
				else thumb.x = bar.x + (bar.width - thumb.width);
			}
		}
		private function thumbDownHandler(evt:MouseEvent):void {
			thumb.startDrag(false, dragRect);
			thumb.addEventListener(Event.ENTER_FRAME, dispatchChange);
		}
		private function barDownHandler(evt:MouseEvent):void {
			if (_v) {
				if (this.mouseY > thumb.y) {
					if ((bar.y + bar.height - (thumb.height+thumb.y)) > thumb.height) thumb.y += thumb.height;
					else thumb.y = bar.y + (bar.height - thumb.height);
				}else {
					if ((thumb.y - bar.y) > thumb.height) thumb.y -= thumb.height;
					else thumb.y = bar.y;
				}
			}else {
				if (this.mouseX > thumb.x) {
					if ((bar.x +bar.width - (thumb.width+thumb.x)) > thumb.width) thumb.x += thumb.width;
					else thumb.x = bar.x + (bar.width - thumb.width);
				}else {
					if ((thumb.x - bar.x) > thumb.width) thumb.x -= thumb.width;
					else thumb.x = bar.x;
				}
			}
			dispatchChange();
		}
		private function barUpHandler(evt:Event):void {
			thumb.removeEventListener(Event.ENTER_FRAME, dispatchChange);
			bar.stopDrag();
		}
		private function dispatchChange(event:Event = null):void {
			var _num:Number;
			if (_v) _num = (thumb.y - bar.y) * _b;
			else _num = (thumb.x - bar.x) * _b;
			dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL, Math.round(_num)));
		}
		//mouse wheel
		public function mouseWheel(evt:MouseEvent):void {
			var _delta:int = int(evt.delta);
			var _n:uint = Math.abs(_delta);
			if (_delta < 0) {
				maxHandler(_line_height);
			}else {
				minHandler(_line_height);
			}
			dispatchChange();
		}
		//recalculateThumb
		private function recalculateThumb():void {
			var thumb_n:Number = bar_max * (n / (n + content_max * _line_height));
			if (_v) {
				if (thumb_n < _min_thumb) thumb.height = _min_thumb;
				else thumb.height = thumb_n;
				
				if (!thumb.visible) {
					if (thumb_n<bar.height){
						thumb.visible = true;
					}else {
						thumb.height = _min_thumb;
						thumb.visible = false;
					}
				}
			}else {
				if (thumb_n < _min_thumb) thumb.width = _min_thumb;
				else thumb.width = thumb_n;
				
				if (!thumb.visible) {
					if (thumb_n<bar.width){
						thumb.visible = true;
					}else {
						thumb.width = _min_thumb;
						thumb.visible = false;
					}
				}
			}
			
		}
		//API
		public function set scroll(_n:Number):void {
			if (_n <= scrollMax) {
				if (_v) thumb.y = _n;
				else thumb.x = _n;
			}
			dispatchChange();
		}
		public function get scrollMax():Number {
			var _max:Number
			if (min) _max = scroll_max + min.height;
			else _max = scroll_max;
			return _max;
		}
		public function set contentMax(_max:Number):void {
			content_max = _max;
			if (content_max <= 0) {
				enable = false;
			}else {
				enable = true;
				recalculateThumb();
				recalculate();
			}
		}
		public function set txtMax(_max:Number):void {
			content_max = _max;
			if (content_max <= 1) {
				enable = false;
			}else {
				enable = true;
				recalculateThumb();
				recalculate();
			}
		}
		public function set line_height(_h:int):void {
			_line_height = _h;
			if (content_max > 1) {
				recalculateThumb();
				recalculate();
			}
		}
		public function set n(_num:Number):void {
			_n = _num;
		}
		public function get n():Number {
			if (max) _n = min.height + max.height +bar.height;
			else _n = bar.height;
			return _n;
		}
		override public function set height(_h:Number):void {
			if (_v) {
				if (max) {
					bar.height = _h - max.height - min.height;
					max.y = _h;
				}
				else {
					bar.height = _h;
				}
				if (content_max >= 1) recalculate();
			}
			super.height = this.height;
		}
		override public function set width(_w:Number):void {
			if (!_v) {
				if (max) {
					bar.width = _w - max.width - min.width;
					max.x = _w;
				}
				else {
					bar.width = _w;
				}
				
				if (content_max >= 1) recalculate();
			}
			super.width = this.width;
		}
		public function get enable():Boolean {
			return this._enable;
		}
		public function set enable(b:Boolean):void {
			if (_enable == b) return;
			_enable = b;
			if (_enable) {
				Open();
			}else {
				Close();
			}
		}
		//OVER
	}
}
/*
 * 添加到场景后再附值
 * addEventListener(MouseEvent.MOUSE_WHEEL, scrollbar.mouseWheel);
 * 
 */