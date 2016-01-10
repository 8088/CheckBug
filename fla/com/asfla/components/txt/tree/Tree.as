package com.asfla.components.txt.tree 
{
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.events.*;
	import flash.system.LoaderContext;
	
	/*********************************
	 * AS3.0 asfla_Treeview CODE
	 * BY 8088 2010-12-20
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class Tree extends Sprite
	{
		protected var next_tree:Tree;
		protected var up_tree:Tree;
		protected var data_xml:XML;
		protected var _id:int;
		protected var _level:int;
		protected var _end:Boolean;
		protected var txt:TextField;
		protected var txt_btn:Sprite;
		private var ic_w:int = 16;
		private var ic_h:int = 18;
		private var link:TextFormat;
		private var over:TextFormat;
		
		protected static const _h:int = 18;
		protected static const _w:int = 18;
		
		public function Tree(xml:XML, i:int, l:int, end:Boolean)
		{
			data_xml = xml;
			_id = i;
			_level = l;
			_end = end;
			initTree();
		}
		public function initTree():void {
			//TextFormat与StyleSheet有冲突
			/*link = new TextFormat();
			link.underline = false;
			
			over = new TextFormat();
			over.underline = true;*/
			
			creatTxt();
			drawLine();
			showIcon();
			
			//this.addEventListener(MouseEvent.MOUSE_OVER, linkOverHandler);
			//this.addEventListener(MouseEvent.MOUSE_OUT, linkOutHandler);
		}
		private function drawLine():void {
			this.graphics.clear();
			
			var line_style:LineStyle = new LineStyle();
			this.graphics.beginBitmapFill(line_style);
			if (_end) {
				this.graphics.drawRect(_w * level, 0, _w, 10);
			}else {
				this.graphics.drawRect(_w * level, 0, _w, _h);
				if (height > _h) {
					this.graphics.moveTo(_w * level, _h);
					var bmd:BitmapData = new BitmapData(_w, 2);
					bmd.copyPixels(line_style, new Rectangle(0, 0, _w, 2), new Point());
					this.graphics.beginBitmapFill(bmd);
					this.graphics.beginBitmapFill(bmd);
					if (height % 2 == 0) {
						this.graphics.drawRect(_w * level, _h, _w, height - _h);
					}else {
						this.graphics.drawRect(_w * level, _h, _w, height - _h+1);
					}
				}
			}
			
			this.graphics.endFill();
		}
		private function showIcon():void {
			if (String(data_xml.@icon).length >3) {
				loadIcon(String(data_xml.@icon));
			}
		}
		private function loadIcon(path:String):void {
			var lc:LoaderContext = new LoaderContext(true);
			var request:URLRequest = new URLRequest(path);
			var iconLoader:Loader = new Loader();
			iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoadedHandler);
			iconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IoErrorHandler);
			try{
				iconLoader.load(request, lc);
			}catch (err:Error) {
				throw "error";
			}
		}
		private function iconLoadedHandler(evt:Event):void {
			var bmp:Bitmap = Bitmap(evt.target.loader.content);
			bmp.smoothing = true;
			bmp.width = ic_w;
			bmp.height = ic_h;
			bmp.x = _w * (level + 1);
			addChild(bmp);
		}
		private function IoErrorHandler(evt:IOErrorEvent):void {
			//
			if (txt) {
				txt.x = _w * (level + 1);
			}
        }
		//
		private function creatTxt():void {
			txt = new TextField();
			txt.height = _h;
			txt.defaultTextFormat = new TextFormat("Verdana");
			if (String(data_xml.@icon).length <3) {
				ic_w = 0;
			}
			txt.x = _w * (level + 1) + ic_w;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.selectable = false;
			var style:StyleSheet = new StyleSheet();
			var hover:Object = new Object();
				hover.textDecoration = "underline";
				style.setStyle("a:hover", hover);
			if (String(data_xml.@css).length >3) {
				style.parseCSS(data_xml.@css);
			}
			txt.styleSheet = style;
            txt.htmlText = "<a href='#' class='txt'>" + data_xml.@txt +"</a>";
			addChild(txt);
			
			txt_btn = new Sprite();
			txt_btn.buttonMode = true;
			txt_btn.graphics.beginFill(0, 0);
			txt_btn.graphics.drawRect(txt.x, txt.y, txt.width, txt.height);
			txt_btn.graphics.endFill();
			addChild(txt_btn);
		}
		private function linkOverHandler(evt:MouseEvent):void {
			//txt.setTextFormat(over);
		}
		private function linkOutHandler(evt:MouseEvent):void {
			//txt.setTextFormat(link);
		}
		//API
		override public function set y(_y:Number):void {
			
			super.y = _y;
			if (next){
				next.y = this.y + this.height;
			}
			
		}
		override public function set height(_h:Number):void {
			super.height = _h;
			drawLine();
			if (next) {
				next.y = this.y + this.height;
			}
			if (up) {
				up.height = up.height;
			}
		}
		public function set up(_up_tree:Tree):void {
			if (_up_tree!=null) {
				this.up_tree = _up_tree;
			}
		}
		public function get up():Tree {
			return this.up_tree;
		}
		public function set next(_next_tree:Tree):void {
			if (_next_tree!=null) {
				this.next_tree = _next_tree;
			}
		}
		public function get next():Tree {
			return this.next_tree;
		}
		public function set id(_i:int):void {
			this._id = _i;
		}
		public function get id():int {
			return this._id;
		}
		public function set level(_l:int):void {
			this._level = _l;
		}
		public function get level():int {
			return this._level;
		}
		//OVER
	}
	
}