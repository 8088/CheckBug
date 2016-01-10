package com.asfla.app 
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	/*********************************
	 * AS3.0 asfla_BandwidthTest CODE
	 * BY 8088 2010-10-07
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class BandwidthTest extends EventDispatcher
	{
		private var _path:String;
		private var _count:int;
		private var _tests:Array;
		private var _bandwidth:Number;
		private var _start:int;
		
		public function BandwidthTest(p:String) 
		{
			_path = p;
			_count = 0;
			_bandwidth = 0;
			_tests = [];
		}
		public function test():void {
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(_path + "?unique=" + (new Date()).getTime());
			loader.load(request);
			loader.addEventListener(Event.OPEN, openHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		private function openHandler(evt:Event):void {
			_start = getTimer();
		}
		private function completeHandler(evt:Event):void {
			var downloadTime:Number = (getTimer() - _start) / 1000;
			_count++;
			
			var kilobits:Number = evt.target.bytesTotal / 1000 * 8;
			
			var kbps:Number = kilobits / downloadTime;
			trace("带宽：" + int(kbps) + "kp/s");
			_tests.push(kbps);
			if (_count == 1) {
				test();
			}else if (_count == 2) {
				if (Math.abs(_tests[0] - _tests[1]) < 50) {
					dispatchCompleteEvent();
				}else {
					test();
				}
			}else {
				dispatchCompleteEvent();
			}
			
		}
		private function dispatchCompleteEvent():void {
			for (var i = 0; i < _tests.length; i++) {
				_bandwidth += _tests[i];
			}
			_bandwidth /= _count;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function ioErrorHandler(evt:IOErrorEvent):void {
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
        }
		//API
		public function get bandwidth():Number {
			return this._bandwidth;
		}
		//OVER
	}
	
}