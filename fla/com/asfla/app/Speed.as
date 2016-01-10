package com.asfla.app 
{
	import flash.display.Sprite;
	import flash.events.*;
	
	/*********************************
	 * AS3.0 asfla_Speed CODE
	 * BY 8088 2010-10-07
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class Speed extends Sprite
	{
		
		public function Speed() 
		{
			//var bandwidthTester:BandwidthTest = new BandwidthTest("http://192.168.50.110:8088/2010/flash_website/flash/contact.swf");
			var bandwidthTester:BandwidthTest = new BandwidthTest("http://pica.nipic.com/2008-01-05/200815135657931_2.jpg");
			bandwidthTester.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			bandwidthTester.addEventListener(Event.COMPLETE, bandwidthTestHandler);
			bandwidthTester.test();
		}
		private function ioErrorHandler(evt:IOErrorEvent):void {
			//
			txt.htmlText = "检测到您的电脑无法载入数据！<br/>请检查您的网络...";
		}
		private function bandwidthTestHandler(evt:Event):void {
			var _bandwidth:int = int(evt.target.bandwidth) / 8;
			if (_bandwidth < 100) {
				mc.visible = false;
				txt.x = 15;
				txt.y = 15;
				txt.htmlText = "检测到您的下载速度仅有<font color='#ff0000'>" + _bandwidth + "kb/s</font>, 观看视频可能需要等待较长时间"
			}
		}
		//OVER
	}
	
}