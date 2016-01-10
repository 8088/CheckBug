package com.asfla.utils {
	import flash.display.*;
	import flash.events.*;
	/*********************************
	 * AS3.0 asfla_util_FluidObject CODE
	 * BY 8088 2009-09-14
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class FluidObject {
		protected var _param:Object;
		protected var _target:DisplayObject; 
		protected var _stage:Stage;
		public function FluidObject(target:DisplayObject, paramObj:Object) {
			_target = target;
			_param = paramObj;
			_stage = target.stage;
			_stage.addEventListener(Event.RESIZE, onStageResize);
			this.reposition(); 
		}
		protected function reposition():void {
			var stageW = _stage.stageWidth;
			var stageH = _stage.stageHeight;
			_target.x = (stageW * _param.x) + _param.offsetX;
			_target.y = (stageH * _param.y) + _param.offsetY; 
		}
		protected function onStageResize(e):void {
			this.reposition();
		}
		public function set param(value:Object):void {
			_param = value;
			this.reposition();
		}
		//OVER
	}
}
/*
var title = new Title();
addChild(title);
var titleParam = {
		x:0,
		y:0,
		offsetX:0,
		offsetY:0
		}
new FluidObject(title,titleParam);*/
