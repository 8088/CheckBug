package com.asfla.utils 
{
	import com.asfla.components.btn.*;
	import flash.display.*;
	import flash.text.TextField;
	import flash.events.*;
	
	/*********************************
	 * AS3.0 asfla_util_Alert CODE
	 * BY 8088 2009-12-18
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	*********************************/
	public class Alert extends Sprite
	{
		public var ttl_txt:TextField;
		public var info_txt:TextField;
		public var bg:Sprite;
		public var btn_close:SimpleButton;
		private var ok_btn:Labelbtn;
		private var close_btn:Basebtn;
		
		private static var _stage:Stage;
		private static var stage_w:Number;
		private static var stage_h:Number;
		
		private const SINGLETON_MSG:String = "Alert 已创建！";
		private static var instance:Alert;
		
		private static var alert_bg:Sprite;
		public function Alert()
		{
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			init();
		}
		protected function init():void {			
            //mouseEnabled = false;
			//mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			btn_close.addEventListener(MouseEvent.MOUSE_UP, closeHandler);
		}
		public static function info(area:DisplayObject, message:String, ttl:String = "弹出信息"):void {
			if (instance == null) {
				instance = new Alert();
				_stage = area.stage as Stage;
				instance.initStage();
				alert_bg = new Sprite();
				drawbg(stage_w, stage_h);
			}
			instance.ttl_txt.htmlText = "<b>"+ttl+"</b>";
			instance.info_txt.htmlText = message;
			
			instance.x = int((stage_w - instance.width) >> 1);
			instance.y = int((stage_h - instance.height) >> 1);
			_stage.addChild(alert_bg);
			_stage.addChild(instance);
			//
		}
		private function initStage():void {
			_stage.align=StageAlign.TOP_LEFT;
			_stage.scaleMode=StageScaleMode.NO_SCALE;
			_stage.quality=StageQuality.HIGH;
			stage_w = _stage.stageWidth;
			stage_h = _stage.stageHeight;
			_stage.addEventListener(Event.RESIZE, instance.resizeHandler);
			_stage.addEventListener(Event.MOUSE_LEAVE, instance.mouseUpHandler);
		}
		private function resizeHandler(evt:Event=null):void {
			stage_w = evt.currentTarget.stageWidth;
			stage_h = evt.currentTarget.stageHeight;
			if (alert_bg) {
				drawbg(stage_w, stage_h);
			}
		}
		private static function drawbg(w:Number = 0, h:Number = 0) {
			alert_bg.graphics.clear();
			alert_bg.graphics.beginFill(0xcccccc, 0.5);
			alert_bg.graphics.drawRect(0, 0, w, h);
			alert_bg.graphics.endFill();
		}
		private function mouseDownHandler(evt:MouseEvent):void {
			instance.startDrag();
		}
		private function mouseUpHandler(evt:Event):void {
			instance.stopDrag();
		}
		private function closeHandler(evt:MouseEvent):void {
			_stage.removeChild(alert_bg);
			_stage.removeChild(instance);
			_stage.removeEventListener(Event.RESIZE, instance.resizeHandler);
			_stage.removeEventListener(Event.MOUSE_LEAVE, instance.mouseUpHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			btn_close.removeEventListener(MouseEvent.MOUSE_UP, closeHandler);
			alert_bg = null;
			instance = null;
		}
		//OVER
	}
	
}