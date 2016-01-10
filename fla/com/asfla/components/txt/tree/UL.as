package com.asfla.components.txt.tree 
{
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.Timer;
	/*********************************
	 * AS3.0 asfla_Treeview CODE
	 * BY 8088 2010-12-20
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class UL extends Tree
	{
		private var icon_ul:IconUL;
		private var _open:Boolean;
		
		private var ul_leng:int;
		private var li_leng:int;
		private var count:int;
		private var pre_ul:Tree;
		private var pre_li:Tree;
		private var tree_end:Boolean;
		private var list:Sprite;
		public function UL(xml:XML, i:int, l:int, end:Boolean)
		{
			super(xml, i, l, end);
			ul_leng = data_xml.ul.length();
			li_leng = data_xml.li.length();
			initUL();
		}
		public function initUL():void {
			icon_ul = new IconUL();
			icon_ul.x = 3+_w * level;
			icon_ul.y = 5;
			icon_ul.buttonMode = true;
			addChild(icon_ul);
			//Open 是同步的
			icon_ul.addEventListener(MouseEvent.MOUSE_DOWN, ulDownHandler);
			txt_btn.addEventListener(MouseEvent.CLICK, ulDownHandler);
		}
		private function ulDownHandler(evt:MouseEvent):void {
			if (_open) {
				icon_ul.gotoAndStop(1);
				Close();
			}else {
				icon_ul.gotoAndStop(2);
				Open();
			}
			_open = !_open;
		}
		//API
		public function Close():void {
			removeChild(list);
			drawLine()
			height = _h;
		}
		private function drawLine():void {
			this.graphics.clear();
			
			var line_style:LineStyle = new LineStyle();
			this.graphics.beginBitmapFill(line_style);
			if (_end) {
				this.graphics.drawRect(_w * level, 0, _w, 10);
			}else {
				this.graphics.drawRect(_w * level, 0, _w, _h);
			}
			
			this.graphics.endFill();
		}
		public function Open():void {
			if (list) {
				addChild(list);
				height = this.height;
			}else {
				list = new Sprite();
				list.y = _h;
				
				if (ul_leng > 0) {
					creatUL();
				}else {
					creatLI();
				}
			}
			
		}
		private function creatUL():void {
			while (count < ul_leng) {
				if (count == ul_leng - 1 && li_leng == 0) {
					tree_end = true;
				}
				var ul:Tree = new UL(data_xml.ul[count], count, (level+1), tree_end);
				ul.up = this;
				if (pre_ul) {
					pre_ul.next = ul;
					ul.y = pre_ul.y + pre_ul.height;
				}
				list.addChild(ul);
				pre_ul = ul;
				count++;
				if(count%10==0&&count!= ul_leng - 1){
					sleep(50, creatUL);
					return;
				}
			}
			count = 0;
			
			if (li_leng > 0) {
				sleep(100, creatLI);
			}else {
				//结束
				addChild(list);
				height = this.height;
			}
		}
		private function creatLI():void {
			while (count < li_leng) {
				if (count == li_leng - 1) {
					tree_end = true;
				}
				var li:Tree = new LI(data_xml.li[count], count, (level + 1), tree_end);
				li.up = this;
				if (pre_li) {
					pre_li.next = li;
					li.y = pre_li.y + pre_li.height;
				}else if(pre_ul){
					pre_ul.next = li;
					li.y = pre_ul.y + pre_ul.height;
				}
				list.addChild(li);
				
				pre_li = li;
				count++;
				if(count%10==0&&count!= li_leng - 1){
					sleep(50, creatLI);
					return;
				}
			}
			//结束
			addChild(list);
			height = this.height;
		}
		function sleep(t:int, f:Function):void{
			var timer:Timer = new Timer(t,1);
			timer.addEventListener(TimerEvent.TIMER, function(){
								   timer.stop();
								   timer = null;
								   f();
								   });
			timer.start();
		}
		//OVER
	}
	
}