package com.asfla.utils 
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.*;
	
	/*********************************
	 * AS3.0 asfla_util_ToolTip CODE
	 * BY 8088 2009-12-15
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	*********************************/
	public class ToolTip extends Sprite
	{
		private static var instance:ToolTip;
		private var label:TextField;
		private var area:DisplayObject;
		private static var _stage:Stage;
		private static var stage_w:Number;
		private static var stage_h:Number;
		private var _t_c:uint;
		private var _b_c:uint;
		public function ToolTip(text_color:uint = 0x666666, bg_color:uint = 0xffffff) {
			_t_c = text_color;
			_b_c = bg_color
			label = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.selectable = false;
            label.multiline = true;
            label.wordWrap = false;
            label.defaultTextFormat = new TextFormat("宋体", 12, _t_c);
            label.text = "提示信息";
			label.width = label.textWidth;
			label.height = label.textHeight;
            label.x = 5;
            label.y = 2;
            addChild(label);
			redraw();
            visible = false;
            mouseEnabled = false;
			mouseChildren = false;
        }
		private function redraw(mouse_x:Number = 0, mouse_y:Number = 0) {
			var w:Number = 10 + label.width;
			var h:Number = 4 + label.height;
			var _x:Number = 0;
			var _y:Number = 0;
			var f:Number = 5;
			var dot_up:Number = 0;
			var dot_y:Number = 0;
			
			if (mouse_x < stage_w / 2) {
				_x = -8;
			}else {
				_x = - w+8;
			}
			if (mouse_y < stage_h / 2) {
				_y = 20 + 8;
				dot_y = 20 + 8;
				dot_up = -1;
			}else {
				_y = - 20-8;
				dot_y = -8;
				dot_up = 1;
			}
			label.x = _x+f;
            label.y = _y+2;
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0.3);
			
			this.graphics.drawRoundRect(_x+3, _y+3, w, h, f, f);
			this.graphics.moveTo(0, dot_y+3);
			this.graphics.lineTo(3, dot_y+3+5*dot_up);
			this.graphics.lineTo(6, dot_y+3);
			this.graphics.lineTo(0, dot_y+3);
			this.graphics.endFill();
			this.graphics.beginFill(_b_c);
			this.graphics.drawRoundRect(_x, _y, w, h, f, f);
			this.graphics.moveTo(-3, dot_y);
			this.graphics.lineTo(0, dot_y+5*dot_up);
			this.graphics.lineTo(3, dot_y);
			this.graphics.lineTo(-3, dot_y);
			this.graphics.endFill();
		}
		public static function register(area:DisplayObject, message:String):void {
			if (instance == null) {
				instance = new ToolTip();
				area.stage.addChild(instance);
				_stage = area.stage as Stage;
				instance.initStage();
			}
			var ap:AccessibilityProperties = new AccessibilityProperties();
			ap.description = message;
			area.accessibilityProperties = ap;
			area.addEventListener(MouseEvent.MOUSE_OVER, instance.handler);
		}
		public static function unregister(area:DisplayObject):void {
			if (instance != null) {
				area.removeEventListener(MouseEvent.MOUSE_OVER, instance.handler);
			}
		}
		public static function clear():void {
			_stage.removeChild(instance);
			instance = null;
		}
		public static function installation(area:DisplayObject, text_color:uint, bg_color:uint):ToolTip {
			if (instance == null) {
				instance = new ToolTip(text_color, bg_color);
				area.stage.addChild(instance);
				_stage = area.stage as Stage;
				instance.initStage();
			}
			return instance as ToolTip;
		}
		public function info(_info:String):void {
			label.htmlText = _info;
			if (label.textWidth > 180) {
				label.wordWrap = true;
				label.width = 180;
			}else {
				label.wordWrap = false;
			}
			label.width = label.textWidth;
			label.height = label.textHeight;
			redraw();
			
		}
		
		public function show(area:DisplayObject):void {
			this.area = area;
			this.area.addEventListener(MouseEvent.MOUSE_OUT, this.handler);
			this.area.addEventListener(MouseEvent.MOUSE_MOVE, this.handler);
			label.text = area.accessibilityProperties.description;
			label.width = label.textWidth+5;
			redraw(area.x,area.y);
		}
		public function hide():void {
			this.area.removeEventListener(MouseEvent.MOUSE_OUT, this.handler);
			this.area.removeEventListener(MouseEvent.MOUSE_MOVE, this.handler);
			this.area = null;
			visible = false;
		}
		public function move(point:Point):void {
			this.x = point.x;
			this.y = point.y;
			if(!visible){
				visible = true;
			}
		}
		private function initStage():void {
			_stage.align=StageAlign.TOP_LEFT;
			_stage.scaleMode=StageScaleMode.NO_SCALE;
			_stage.quality=StageQuality.HIGH;
			stage_w = _stage.stageWidth;
			stage_h = _stage.stageHeight;
			_stage.addEventListener(Event.RESIZE, instance.resizeHandler);
		}
		private function resizeHandler(evt:Event=null):void {
			stage_w = evt.currentTarget.stageWidth;
			stage_h = evt.currentTarget.stageHeight;
		}
		private function handler(evt:MouseEvent):void {
			switch(evt.type) {
				case MouseEvent.MOUSE_OUT:
					this.hide();
					break;
				case MouseEvent.MOUSE_MOVE:
					this.move(new Point(evt.stageX, evt.stageY));
					break;
				case MouseEvent.MOUSE_OVER:
					this.show(evt.target as DisplayObject);
					this.move(new Point(evt.stageX, evt.stageY));
					break;
			}
		}
		//OVER
	}
	
}