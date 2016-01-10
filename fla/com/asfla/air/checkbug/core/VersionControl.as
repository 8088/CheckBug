package com.asfla.air.checkbug.core 
{
	import air.net.*;
	import com.asfla.air.net.FileDownload;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.desktop.*;
	import com.asfla.air.checkbug.events.CheckBugEvent;
	import com.codeazur.utils.*;
	
	/**
	 +------------------------------------------------
	 * AIR VersionControl CODE version control
	 +------------------------------------------------ 
	 * @author 8088 at 2011-08-30
	 * version: 0.1
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class VersionControl extends EventDispatcher
	{
		private var monitor:URLMonitor;
		private var config:Config;
		private var fileData:ByteArray
		
		public function VersionControl(setter:Config):void
		{
			config = setter;
		}
		public function check():void
		{
			if (new Date().time - config.last_check > 86400000 * config.interval)
            {
                if (config.loaded_latest_version) 
				{
					dispatchEvent(new CheckBugEvent(CheckBugEvent.HAS_NEW_VERSION));
				}
				else {
					connetServer();
				}
            }
			else {
				if (config.local_version != config.loaded_latest_version)
				{
					connetServer();
				}
			}
		}
		private function connetServer():void
		{
			var req:URLRequest = new URLRequest(config.url);
			req.method = "HEAD";
			monitor = new URLMonitor(req);
			monitor.addEventListener(StatusEvent.STATUS, connectStatus);
			monitor.start();
		}
		private function connectStatus(evt:StatusEvent):void
        {
            if (monitor.available)
            {
               compareVersions();
            }
        }
		private function compareVersions():void
		{
            var req:URLRequest = new URLRequest(config.url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadedHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(req);
        }
		private function ioErrorHandler(evt:IOErrorEvent):void {
			dispatchEvent(new CheckBugEvent(CheckBugEvent.STATUS_CHANGE, "<font color='#900000'>unable to update!</font>"));
		}
		private function loadedHandler(evt:Event):void
		{
			var loader:URLLoader = URLLoader(evt.target);
			if (loader != null) {
				try {
					var xml:XML = new XML(loader.data);
					xml.ignoreWhitespace = true;
					trace(xml);
					var reload:Boolean;
					var remote_version:String = String(xml..latest);
					config.last_check = new Date().time;
					
					if (config.local_version != remote_version)
					{
						if (config.latest_version != remote_version)
						{
							config.latest_version = remote_version;
							config.save();
							reload = true;
						}
						else {
							reload = false;
						}
						var file_down:FileDownload = new FileDownload(config.air, reload);
						file_down.addEventListener(Event.COMPLETE, fileLoadedHandler);
						file_down.start();
					}
					
				}catch (error:TypeError) {
					dispatchEvent(new CheckBugEvent(CheckBugEvent.STATUS_CHANGE, "<font color='#900000'>update.xml tag's error!</font>"));
					return;
				}
			}
			
        }
		private function fileLoadedHandler(evt:Event):void
		{
			config.loaded_latest_version = true;
			config.save();
		}
		//OVER
	}
	
}