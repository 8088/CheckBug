package com.asfla.air.checkbug.core 
{
	import com.asfla.air.checkbug.events.CheckBugEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Endian;
	
	/**
	 +------------------------------------------------
	 * AIR Config CODE Checkbug setter
	 +------------------------------------------------ 
	 * @author 8088 at 2011-07-19
	 * version: 0.1
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class Config extends EventDispatcher
	{
		private var _ttl:String;
		private var _type:String;
		private var _first:Boolean;
		private var _top:Boolean;
		private var _last_check:Number;
		private var _interval:uint;
		private var _upgrade_url:String;
		private var _upgrade_air:String;
		private var _font_family:String;
		private var _font_size:uint;
		private var _save_last_log:Boolean;
		private var _latest_version:String;
		private var _loaded_latest_version:Boolean;
		private var _local_version:String;
		public function Config()
		{
			var request:URLRequest = new URLRequest("data/config.xml");
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadedHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(request);
		}
		private function loadedHandler(evt:Event):void {
			var loader:URLLoader = URLLoader(evt.target);
			if (loader != null) {
				try {
					var xml:XML = new XML(loader.data);
					xml.ignoreWhitespace = true;
					
					_ttl = String(xml..title);
					_type = String(xml..type);
					_first = String(xml..first) == "yes"? (true):(false);
					_top = String(xml..top) == "yes"? (true):(false);
					_last_check = Number(xml..check);
					_interval = uint(xml..interval);
					_upgrade_url = String(xml..url);
					_upgrade_air = String(xml..air);
					_font_family = String(xml..font.name[0]);
					_font_size = uint(xml..font.size[0])
					_save_last_log = String(xml..savelast) == "yes"? (true):(false);
					_latest_version = String(xml..latest);
					_loaded_latest_version = String(xml..loaded) == "yes"? (true):(false);
					
				}catch (error:TypeError) {
					dispatchEvent(new CheckBugEvent(CheckBugEvent.STATUS_CHANGE, "<font color='#900000'>config file tag's error!</font>"));
					return;
				}
				dispatchEvent(new CheckBugEvent(CheckBugEvent.CONFIG_COMPLETE));
			} else {
				trace("menuXML error！");
			}
		}
		private function ioErrorHandler(evt:IOErrorEvent):void {
			dispatchEvent(new CheckBugEvent(CheckBugEvent.STATUS_CHANGE, "<font color='#900000'>unable to load the config file!</font>"));
		}
		//API
		public function build():String {
			var _f:String = first? "yes":"no";
			var _t:String = top? "yes":"no";
			var _save_last:String = save_last_log? "yes":"no";
			var _loaded:String = loaded_latest_version? "yes":"no";
			var _xml:String
			_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n";
			_xml += "<checkbug>\n";
			_xml += "\t<title><![CDATA[" + ttl + "]]></title>\n";
			_xml += "\t<type><![CDATA[" + type + "]]></type>\n";
			_xml += "\t<config>\n";
			_xml += "\t\t<first><![CDATA[" + _f + "]]></first>\n";
			_xml += "\t\t<top><![CDATA[" + _t + "]]></top>\n";
			_xml += "\t\t<upgrade>\n";
			_xml += "\t\t\t<check>" + last_check + "</check>\n";
			_xml += "\t\t\t<interval>" + interval + "</interval>\n";
			_xml += "\t\t\t<url><![CDATA[" + url + "]]></url>\n";
			_xml += "\t\t\t<air><![CDATA[" + air + "]]></air>\n";
			_xml += "\t\t</upgrade>\n";
			_xml += "\t\t<font>\n";
			_xml += "\t\t\t<name><![CDATA[" + font +"]]></name>\n";
			_xml += "\t\t\t<size><![CDATA[" + font_size +"]]></size>\n";
			_xml += "\t\t</font>\n";
			_xml += "\t\t<log>\n";
			_xml += "\t\t\t<savelast><![CDATA[" + _save_last +"]]></savelast>\n";
			_xml += "\t\t</log>\n";
			_xml += "\t</config>\n";
			_xml += "\t<version>\n";
			_xml += "\t\t<latest><![CDATA[" + latest_version + "]]></latest>\n";
			_xml += "\t\t<loaded><![CDATA[" + _loaded + "]]></loaded>\n";
			_xml += "\t</version>\n";
			_xml += "</checkbug>";
			return _xml;
		}
		public function save():Boolean {
			var file:File;
			var s:FileStream;
			try {
				file = new File(File.applicationDirectory.nativePath + "/data/config.xml");
				if (file.exists) {
					s = new FileStream();
					//s.endian = Endian.BIG_ENDIAN;
					s.open(file, FileMode.UPDATE);
					s.truncate();
					s.writeUTFBytes(build());
					s.close();
				}
			}catch (err:Error) {
				return false;
			}
			return true;
		}
		public function get ttl():String
		{
			return _ttl;
		}
		public function get type():String
		{
			return _type;
		}
		public function get first():Boolean
		{
			return _first;
		}
		public function set first(f:Boolean):void
		{
			_first = f;
		}
		public function get top():Boolean
		{
			return _top;
		}
		public function set top(t:Boolean):void
		{
			_top = t;
		}
		public function get last_check():Number
		{
			return _last_check;
		}
		public function set last_check(n:Number):void
		{
			_last_check = n;
		}
		public function get interval():uint
		{
			return _interval;
		}
		public function get url():String
		{
			return _upgrade_url;
		}
		public function get air():String
		{
			return _upgrade_air;
		}
		public function get font():String
		{
			return _font_family;
		}
		public function set font(f:String):void
		{
			_font_family = f;
		}
		public function get font_size():uint
		{
			return _font_size;
		}
		public function set font_size(size:uint)
		{
			_font_size = size;
		}
		public function get save_last_log():Boolean
		{
			return _save_last_log;
		}
		public function set save_last_log(b:Boolean):void
		{
			_save_last_log = b;
		}
		public function get latest_version():String
		{
			return _latest_version;
		}
		public function set latest_version(ver:String):void
		{
			_latest_version = ver;
		}
		public function get loaded_latest_version():Boolean
		{
			return _loaded_latest_version;
		}
		public function set loaded_latest_version(b:Boolean):void
		{
			_loaded_latest_version = b;
		}
		public function get local_version():String
		{
			return _local_version;
		}
		public function set local_version(ver:String):void
		{
			_local_version = ver;
		}
		//OVER
	}
	
}