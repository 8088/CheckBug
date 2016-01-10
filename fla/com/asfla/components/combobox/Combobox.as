package com.asfla.components.combobox 
{
	import com.asfla.components.interfaces.IComponents;
	import flash.events.*;
	import flash.display.*;
	import flash.text.*;
	import flash.geom.*;
	import fl.transitions.Tween;
 	import fl.transitions.easing.*;
	/*********************************
	 * AS3.0 asfla_Combobox CODE
	 * BY 8088 2011-01-02
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class Combobox extends Sprite implements IComponents
	{
		private var _txt_box:Sprite;
		private var _txt_box_mask:Shape;
        //初始数据
        //private var bar_v:Number;
		
		private var _enable:Boolean;
		private var _w:Number = 90;
		private var _txt_ary:Array;
		private var _txt_ttl:String = "--默认值--";
		private var _id:int;
		private var _down:Boolean;
		private var _min_list:int = 8;
		private var txt_w:Number;
		private var txt_h:Number=18;
		public function Combobox() {
			btn.enabled = false;
			bg.stop();
			icon.stop();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(evt:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			bg.width = _w;
			btn.width = _w;
			ttl.width = _w -20;
			icon.x = _w -9;
			txt_w = _w;
			if (enable) {
				//
			}
		}
		//事件
		private function onOver(event:Event):void {
			if(!_down){
				icon.gotoAndStop("over");
				bg.gotoAndStop("over");
			}
		}
		private function onOut(event:Event):void {
			if(!_down){
				icon.gotoAndStop("out");
				bg.gotoAndStop("out");
			}
		}
		
		private function onDown(event:Event):void {
			if (!_txt_ary) return;
			if (!_down) {
				icon.gotoAndStop("down");
				bg.gotoAndStop("down");
				icon.rotation = -90;
				bg.stage.addEventListener(MouseEvent.MOUSE_DOWN, dDown);
				txtShow();
			}else {
				bg.stage.removeEventListener(MouseEvent.MOUSE_DOWN, dDown);
				icon.rotation = 0;
				icon.gotoAndStop("over");
				bg.gotoAndStop("over");
				if (_txt_box) txtDel();
			}
			_down = !_down;
		}
		
		private function dDown(evt:MouseEvent):void {
			if(evt.target!= btn){
				if(_down){
					icon.gotoAndStop("out");
					bg.gotoAndStop("out");
					icon.rotation = 0;
					if (_txt_box) txtDel();
					bg.stage.removeEventListener(MouseEvent.MOUSE_DOWN, dDown);
					_down = false;
				}
			}
		}
		
		private function txtShow() {
			if(_txt_box==null) _txt_box = new Sprite();
			_txt_box.visible = true;
			_txt_box.x=0;
			_txt_box.y = bg.height + 1;
			if(_txt_box_mask==null){
				if (_txt_ary.length > _min_list) {
					_txt_box_mask = new Shape();
					_txt_box_mask.graphics.clear();
					_txt_box_mask.graphics.beginFill(0x000000);
					_txt_box_mask.graphics.drawRect(0, txt_h + 1, _w, (txt_h + 1) * _min_list);
					_txt_box_mask.graphics.endFill();
					this.addChild(_txt_box_mask);
					_txt_box.mask = _txt_box_mask;
				}
			}
			for(var i =0; i<_txt_ary.length;i++){
				var txts = new Combobox_txt()
				txt_h = txts.height;
				txts.bg.width = _w;
				txts.ttl.width = _w;
				txts.id = i;
				txts.y = txts.height*i;
				txts.bg.gotoAndStop(1);
				txts.ttl.text = _txt_ary[i];
				//
				txts.addEventListener(MouseEvent.MOUSE_OVER, txtOver);
				txts.addEventListener(MouseEvent.MOUSE_OUT, txtOut);
				txts.addEventListener(MouseEvent.MOUSE_DOWN, txtDown);
				_txt_box.addChild(txts);
			}
			this.addChild(_txt_box);
			_txt_box.graphics.clear();
			_txt_box.graphics.beginFill(0xffffff);
			_txt_box.graphics.drawRect(0, 0, _txt_box.width, _txt_box.height);
			_txt_box.graphics.endFill();
			if(_txt_box_mask){
				_txt_box.addEventListener(MouseEvent.MOUSE_MOVE,txtMove);
			}
		}
		
		private function txtDel():void {
			if (_txt_box == null) return;
			_txt_box.visible = false;
			if(_txt_box_mask){
				_txt_box.mask = null;
				this.removeChild(_txt_box_mask);
				_txt_box_mask = null;
			}
			
			var n:int = _txt_box.numChildren;
			while (_txt_box.numChildren>0) {
				
				var txts = _txt_box.getChildAt(0) as Combobox_txt;
				//
				if (txts) {
					txts.removeEventListener(MouseEvent.MOUSE_OVER, txtOver);
					txts.removeEventListener(MouseEvent.MOUSE_OUT, txtOut);
					txts.removeEventListener(MouseEvent.MOUSE_DOWN, txtDown);
				}
				_txt_box.removeChildAt(0);
			}
			_txt_box.removeEventListener(Event.ENTER_FRAME,txtEnter);
			_txt_box.removeEventListener(MouseEvent.MOUSE_MOVE,txtMove);
			_txt_box.graphics.clear();
			this.removeChild(_txt_box);
			_txt_box = null;
			
		}
		//文本事件
		private function txtOver(evt:MouseEvent):void {
			evt.target.parent.getChildByName("bg").gotoAndPlay("star");
		}
		private function txtOut(evt:MouseEvent):void {
			evt.target.parent.getChildByName("bg").gotoAndPlay("cur");
		}
		private function txtDown(evt:MouseEvent):void {
			_txt_box.removeEventListener(Event.ENTER_FRAME,txtEnter);
			_txt_ttl = _txt_ary[evt.target.parent.id];
			ttl.text = _txt_ttl;
			_id = evt.target.parent.id;
			if(onShoose!=null) onShoose();
		}
		private function txtMove(event:MouseEvent):void{
			_txt_box.addEventListener(Event.ENTER_FRAME,txtEnter);
		}
		private function txtEnter(evt:Event):void{
			if(this.mouseY >(txt_h*_min_list+btn.height) || this.mouseY<0){
				_txt_box.removeEventListener(Event.ENTER_FRAME,txtEnter);
			}
			var _txt_boxY = btn.height - ((this.mouseY - btn.height) / (txt_h * _min_list)) * (_txt_box.height - (txt_h * _min_list));
			if(this.mouseY<(btn.height+txt_h)){
				_txt_boxY = btn.height;
			}else if(this.mouseY> (txt_h*_min_list)){
				_txt_boxY = btn.height-(_txt_box.height-(txt_h*_min_list));
			}
			_txt_box.y += -(_txt_box.y - _txt_boxY) / (1.2 * (_txt_ary.length / 5));
		}
		
		
		private function Open():void {
			btn.enabled = true;
			icon.gotoAndStop("out");
			bg.gotoAndStop("out");
			ttl.text = _txt_ttl;
			btn.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			btn.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			btn.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		private function Close():void {
			btn.enabled = false;
			icon.gotoAndStop("close");
			bg.gotoAndStop("close");
			ttl.text = "";
			if (_txt_box) txtDel();
			btn.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			btn.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			btn.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}
		//API
		public function get txtAry():Array {
			return _txt_ary;
		}
		public function set txtAry(Ary:Array) {
			_txt_ary = Ary;
			//
		}
		public function get txtTtl():String{
			return _txt_ttl;
		}
		public function set txtTtl(t:String) {
			_txt_ttl = t;
			ttl.text = _txt_ttl;
		}
		public function set w(bg_w:Number):void {
			_w = bg_w;
			bg.width = _w;
			btn.width = _w;
			ttl.width = _w -20;
			icon.x = _w -9;
			txt_w = _w;
		}
		public function set id(i:int):void {
			_id = i;
			if(_txt_ary) txtTtl = _txt_ary[_id];
		}
		public function get id():int {
			return _id;
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
		//动态接口
		public var onShoose:Function;
		//OVER
	}
	
}