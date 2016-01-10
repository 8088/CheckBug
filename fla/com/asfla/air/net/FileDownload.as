package com.asfla.air.net 
{
	import com.asfla.utils.URL;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	/**
	 +------------------------------------------------
	 * AIR FileDownload CODE HTTP file download 
	 +------------------------------------------------ 
	 * @author 8088 at 2011-09-01
	 * version: 1.0
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class FileDownload extends EventDispatcher
	{
		private var _url:String;
		private var _name:String
		private var _range:int;
		private var file:File;
		private var _total:uint;
		private var _start:uint;
        private var _end:uint;
		private var loader:URLLoader;
		private var _delay:uint
		private var _speed:uint;
		private var _load_start_time:uint;
		public function FileDownload(path:String, reload:Boolean = true, range:uint=10000, delay:uint=600000) 
		{
			_url = path;
			_name = new URL(path).name;
			_range = range;
			_total = 0;
			_start = 0;
			_end = 0;
			_delay = delay;
			_speed = _range * 0.01;
			_load_start_time = 0;
			
			file = new File(File.applicationDirectory.nativePath +"/data/" + _name);
			if (reload)
			{
				if (file.exists) file.deleteFile();
			}
			else {
				//..
			}
		}
		private function getTotalSize():void
		{
			var req:URLRequest = new URLRequest(_url);
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(ProgressEvent.PROGRESS, function(evt:ProgressEvent):void {
				_total = loader.bytesTotal;
				loader.close();
				downloadByRange();
			});
			loader.load(req);
		}
		private function downloadByRange():void
		{
			var stream:FileStream = new FileStream();
			if (file.exists)
			{
				stream.open(file, FileMode.READ);
				_start = stream.bytesAvailable;
				stream.close();
			}
			if (_start + _range > _total)
			{
				_end = _total;
			}
			else {
				_end = _start + _range;
			}
			if(_start!=_end) loadData();
		}
		private function loadData():void
		{
			release();
			var req:URLRequest = new URLRequest(_url);
			var header:URLRequestHeader = new URLRequestHeader("Range", "bytes=" + _start + "-" + _end);
			req.requestHeaders.push(header);
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.OPEN, loadOpenHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
			loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.load(req);
		}
		private function release():void
		{
			if (loader)
			{
				loader.close();
				loader.removeEventListener(Event.OPEN, loadOpenHandler);
				loader.removeEventListener(ProgressEvent.PROGRESS, loadProgressHandler);
				loader.removeEventListener(Event.COMPLETE, loadCompleteHandler);
				loader = null;
			}
		}
		private function loadOpenHandler(evt:Event):void
		{
			_load_start_time = getTimer();
		}
		private function loadProgressHandler(evt:ProgressEvent):void
		{
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _start + evt.bytesLoaded, _total));
		}
		private function loadCompleteHandler(evt:Event):void
		{
			var loader:URLLoader = evt.target as URLLoader;
			var bytes:ByteArray = loader.data;
            var stream:FileStream = new FileStream();
			stream.open(file, FileMode.UPDATE);
			stream.position = stream.bytesAvailable;
			stream.writeBytes(bytes, 0, bytes.length);
			stream.close();
			if (_end != _total) {
				if (getTimer() - _load_start_time > _speed)
				{
					delayLoad();
				}
				else {
					downloadByRange();
				}
			}
			else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		private function delayLoad():void
		{
			var timer:Timer = new Timer(_delay, 1);
			timer.addEventListener(TimerEvent.TIMER, function(evt:TimerEvent):void {
				downloadByRange();
			});
			timer.start();
		}
		//API
		public function start():void {
			getTotalSize();
		}
		//OVER
	}
}