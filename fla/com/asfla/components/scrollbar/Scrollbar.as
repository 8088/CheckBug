package com.asfla.components.scrollbar 
{
	import com.asfla.components.interfaces.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.Timer;
	
	/*********************************
	 * AS3.0 asfla_Scrollbar CODE
	 * BY 8088 2011-01-02
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class Scrollbar extends Sprite implements IComponents
	{
		private var _enable:Boolean;
		private var bar_v:Number;
		private var bg_b:Number;
		private var min_h:Number;
		private var _obj_y:Number;
		private var _mask_h:Number;
		
		private var scrollObj:*;
		private var _m:Boolean;
		private var parentObj:InteractiveObject;
		private var timer:Timer;
		
		public var bar:MovieClip;
		public var up:MovieClip;
		public var down:MovieClip;
		public var bg:Sprite;
		public function Scrollbar() 
		{
			bar.visible = false;
			down.y = bg.height;
			bar_v = bg.height - up.height - down.height;
			min_h = bar.height;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(evt:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (enable){
				bar.stage.addEventListener(MouseEvent.MOUSE_UP, barUpHandler);
				bar.stage.addEventListener(Event.MOUSE_LEAVE, barUpHandler);
			}
			bg_b = bg.height / 100;
		}
		private function Open():void {
			up.enable = true;
			down.enable = true;
			bar.enable = true;
			bar.visible = true;
			
			up.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			up.addEventListener(MouseEvent.MOUSE_UP, stopHandler);
			up.addEventListener(MouseEvent.MOUSE_OUT, stopHandler);
			
			down.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			down.addEventListener(MouseEvent.MOUSE_UP, stopHandler);
			down.addEventListener(MouseEvent.MOUSE_OUT, stopHandler);
			
			bar.addEventListener(MouseEvent.MOUSE_DOWN, barDownHandler);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, bgDownHandler);
			if (bar.stage){
				bar.stage.addEventListener(MouseEvent.MOUSE_UP, barUpHandler);
				bar.stage.addEventListener(Event.MOUSE_LEAVE, barUpHandler);
			}
		}
		private function Close():void {
			up.enable = false;
			down.enable = false;
			bar.enable = false;
			bar.visible = false;
			
			up.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			up.removeEventListener(MouseEvent.MOUSE_UP, stopHandler);
			up.removeEventListener(MouseEvent.MOUSE_OUT, stopHandler);
			
			down.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			down.removeEventListener(MouseEvent.MOUSE_UP, stopHandler);
			down.removeEventListener(MouseEvent.MOUSE_OUT, stopHandler);
			
			bar.removeEventListener(MouseEvent.MOUSE_DOWN, barDownHandler);
			bg.removeEventListener(MouseEvent.MOUSE_DOWN, bgDownHandler);
			if (bar.stage) {
				bar.stage.removeEventListener(MouseEvent.MOUSE_UP, barUpHandler);
				bar.stage.removeEventListener(Event.MOUSE_LEAVE, barUpHandler);
				this.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}
			if(parentObj){
				parentObj.removeEventListener(MouseEvent.MOUSE_DOWN, parentDownHandler);
				parentObj = null;
			}
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			if (timer) timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			
		}
		private function mouseDownHandler(evt:MouseEvent):void {
			enterFrameHandler();
			if (!timer) {
				timer = new Timer(300, 1);
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
			}else {
				if(timer.running) timer.stop();
			}
			timer.start();
		}
		private function stopHandler(evt:MouseEvent):void {
			if(timer) timer.stop();
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		private function timerHandler(evt:TimerEvent):void {
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		private function enterFrameHandler(evt:Event=null):void {
			if (this.mouseY < bar.y) {
				if((bar.y-up.height)>1){
					bar.y -=1;
				}else{
					bar.y = up.height;
				}
			}else {
				if(((up.height + bar_v - bar.height)-bar.y)>1){
					bar.y +=1;
				}else{
					bar.y = up.height + bar_v - bar.height;
				}
			}
			onScroll();
		}
		private function barDownHandler(evt:MouseEvent):void {
			var dragRect:Rectangle = new Rectangle(bar.x, up.height, bar.x, bar_v - bar.height);
			bar.startDrag(false, dragRect);
			if (_m) scrollObj.mouseChildren = false;
			scrollObj.addEventListener(Event.ENTER_FRAME, onScroll);
		}
		private function parentDownHandler(evt:MouseEvent):void {
			if(evt.currentTarget==parentObj){
				this.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}else{
				this.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			}
		}
		private function barUpHandler(evt:Event):void {
			scrollObj.removeEventListener(Event.ENTER_FRAME, onScroll);
			if(_m) scrollObj.mouseChildren = true;
			bar.stopDrag();
		}
		private function onScroll(event:Event=null):void{
			scrollObj.y = _obj_y - ((scrollObj.height - _mask_h) * ((bar.y - up.height) / (bar_v - bar.height)));
		}
		//bg down
		private function bgDownHandler(evt:MouseEvent):void {
			if (this.mouseY > bar.y) {
				if((bar_v-this.mouseY)>bar.height){
					bar.y += bar.height;
				}else{
					bar.y = up.height+bar_v-bar.height;
				}
			}else {
				if((bar.y-up.height)>bar.height){
					bar.y -=bar.height;
				}else{
					bar.y = up.height;
				}
			}
			onScroll();
		}
		//mouse wheel
		private function mouseWheel(evt:MouseEvent):void {
			bar.y -= int(evt.delta);
			if((bar.y-up.height)<1){
				bar.y = up.height;
			}else if(((up.height+bar_v-bar.height)- bar.y)<1){
				bar.y = up.height + bar_v - bar.height;
			}
			onScroll();
		}
		//API
		public function scroll(Obj:DisplayObject, _y:Number = 0, _h:Number = 0) {
			if (scrollObj != Obj) {
				var o:DisplayObjectContainer = Obj as DisplayObjectContainer;
				if (o) {
					scrollObj = o;
					_m = scrollObj.mouseChildren;
					
				}else {
					scrollObj = Obj;
				}
			}
			_obj_y = _y;
			if (_h) {
				_mask_h = _h;
			}else {
				_mask_h = bg.height;
			}
			
			if (scrollObj&&scrollObj.height > _mask_h) {
				parentObj = scrollObj.parent;
				parentObj.addEventListener(MouseEvent.MOUSE_DOWN, parentDownHandler);
				var _v:int = bar_v * (_mask_h / scrollObj.height);
				if (_v < min_h) {
					bar.height = min_h;
				}else {
					bar.height = _v;
				}
				if (scrollObj.y <= _obj_y) {
					bar.y = up.height - (bar_v - bar.height) * (scrollObj.y - _obj_y) / (scrollObj.height - _mask_h);
					if (bar.y > (up.height + (bar_v - bar.height))) {
						bar.y = up.height + (bar_v - bar.height);
						scrollObj.y = _obj_y - ((scrollObj.height - _mask_h) * ((bar.y - up.height) / (bar_v - bar.height)));
					}
				}
				enable = true;
			}else {
				enable = false;
			}
		}
		public function set h(_h:Number):void {
			bg.height = _h;
			down.y = bg.height;
			bar_v = bg.height - up.height - down.height;
			if(scrollObj) scroll(scrollObj);
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