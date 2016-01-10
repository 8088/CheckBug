package com.asfla.components.txt.tree
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.system.*;
	import flash.utils.Timer;
	
	import com.asfla.utils.*;
	/*********************************
	 * AS3.0 asfla_Treeview CODE
	 * BY 8088 2010-12-20
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class Treeview extends Sprite
	{
		private var xml_path:String;
		private var stage_h:Number;
		private var stage_w:Number;
		
		private var data_xml:XML;
		private var ul_leng:int;
		private var li_leng:int;
		private var count:int;
		private var pre_ul:Tree;
		private var pre_li:Tree;
		private var tree_end:Boolean;
		public function Treeview()
		{
			Security.allowDomain("*");
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(evt:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (loaderInfo.parameters.xmlPath != null) {
				xml_path = loaderInfo.parameters.xmlPath;
			}else {
				xml_path = "data/tree.xml";
			}
			initStage();
			this.x = 5;
			main();
		}
		private function initStage():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			
			stage.frameRate	= 31;
			stage_h	= stage.stageHeight;
			stage_w	= stage.stageWidth;
			var cr:Copyright = new Copyright(this);
			stage.addEventListener(Event.RESIZE, resizeHander);
			/*var fps:FPS = new FPS();
			addChild(fps);*/
		}
		private function resizeHander(evt:Event):void {
			stage_h	= stage.stageHeight;
			stage_w	= stage.stageWidth;
		}
		
		private function main():void {
			loadData(xml_path, dataLoaded);
		}
		private function dataLoaded(evt:Event):void {
			var loader:URLLoader = URLLoader(evt.target);
			if (loader != null) {
				try {
					data_xml = new XML(loader.data);
					ul_leng = data_xml.ul.length();
					li_leng = data_xml.li.length();
				}catch (error:TypeError) {
					Utils.print("载入数据XML标签有错误！");
					return;
				}
				InitMc();
			} else {
				Utils.print("Load XML error！");
			}
		}
		private function InitMc():void {
			//删除LOADING
			InitTree();
		}
		
		private function InitTree():void {
			if (ul_leng > 0) {
				creatUL();
			}else {
				creatLI();
			}
		}
		private function creatUL():void {
			while (count < ul_leng) {
				if (count == ul_leng - 1 && li_leng == 0) {
					tree_end = true;
				}
				var ul:Tree = new UL(data_xml.ul[count], count, 0, tree_end);
				if (pre_ul) {
					pre_ul.next = ul;
					ul.y = pre_ul.y + pre_ul.height;
				}
				addChild(ul);
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
			}
		}
		private function creatLI():void {
			while (count < li_leng) {
				if (count == li_leng - 1) {
					tree_end = true;
				}
				var li:Tree = new LI(data_xml.li[count], count, 0, tree_end);
				if (pre_li) {
					pre_li.next = li;
					li.y = pre_li.y + pre_li.height;
				}else {
					pre_ul.next = li;
					li.y = pre_ul.y + pre_ul.height;
				}
				addChild(li);
				
				pre_li = li;
				count++;
				if(count%10==0&&count!= li_leng - 1){
					sleep(50, creatLI);
					return;
				}
			}
			//结束
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
		//data loader
		public function loadData(path:String, completeHandler:Function, cache:Boolean = true):void {
			var xml_loader:URLLoader = new URLLoader();
			var xml_path:String;
			if (cache) {
				xml_path = path;
			} else {
				var now:Number = new Date().time;
				xml_path = path + "?r=" + now;
			}
			var xml_request:URLRequest = new URLRequest(xml_path);
			xml_loader.addEventListener(Event.COMPLETE, completeHandler);
            xml_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            xml_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            xml_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			try {
				xml_loader.load(xml_request);
            } catch (error:Error){
				Utils.print("Unable to load requested document.");
            }
		}
		private function httpStatusHandler(evt:HTTPStatusEvent):void {
			var http_status:Number = Number(evt.status);
			if (http_status > 400) {
				var err:String = "HTTP_Status_Error: " + http_status;
				Utils.print(err);
			}
        }
		private function securityErrorHandler(evt:SecurityErrorEvent):void {
			var err:String = "Security_Error: " + evt.toString();
			Utils.print(err);
        }
        private function ioErrorHandler(evt:IOErrorEvent):void {
			var err:String = evt.text;
			Utils.print("IOError: " + err.toString());
        }
		//API
		public function set data(_path:String):void {
			
		}
		
		//OVER
	}
	
}