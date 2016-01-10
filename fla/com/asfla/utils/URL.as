package com.asfla.utils 
{
	/**
	 +------------------------------------------------
	 * AIR URL CODE resolve url
	 +------------------------------------------------ 
	 * @author 8088 at 2010-12-16
	 * version: 1.0
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class URL 
	{
		private var _rawUrl:String;		// The raw URL string as it was supplied
		
		private var _protocol:String;	// The scheme or protocol, i.e., "http", "ftp", etc.
		private var _rot:String;		// The url root.
		private var _host:String;		// Host name
		private var _port:String;		// The port name. Follows host, such as "http://host.com:80/index.html"
		private var _path:String;		// Path is everything after the host but before any params. For example 
										//	in this URL: "http://host.com:80/foo/bar/index.html?a=1&#38;b=2", path would be "/foo/bar/index.html"									
		private var _query:String;		// The entire query string, everything after the "?" up to the '#', if that exists
		private var _userInfo:String;	// User name : password. For example "http://user:password@host.com:80/foo.php"
		private var _name:String;		// file name
		public function URL(url:String) 
		{
			_rawUrl = url;
			_rot = "";
			_protocol = "";
			_userInfo = "";
			_host = "";
			_port = "";
			_path = "";
			_query = "";
			_name = "";
			if ((_rawUrl != null) && (_rawUrl.length > 0))
			{
				// Strip leading/trailing spaces.
				_rawUrl = _rawUrl.replace(/^\s+|\s+$/g, "");
				
				parseUrl();
			}
		}
		private function parseUrl():void
		{
			if ((_rawUrl == null) || (_rawUrl.length == 0)){
				return;
			}
			if (	_rawUrl.search(/:\//) == -1
				&&	_rawUrl.indexOf(":") != _rawUrl.length - 1
			   ){
				path = _rawUrl;
			}else{
				var oneSlashRegExp:RegExp = /^(rtmp|rtmp[tse]|rtmpte)(:\/[^\/])/i;
	 			var oneSlashResult:Array = _rawUrl.match(oneSlashRegExp);
	 				
				var tempUrl:String = _rawUrl;
					
	 			if (oneSlashResult != null){
	 				tempUrl = _rawUrl.replace(/:\//, "://localhost/");
	 			}
				var pattern:RegExp = /^([a-z+\w\+\.\-]+:\/?\/?)?([^\/?#]*)?(\/[^?#]*)?(\?[^#]*)?(\#.*)?/i;
				var result:Array = tempUrl.match(pattern);
				var hostName:String;
				if (result != null)
				{
					protocol = result[1];
					hostName = result[2];
			        path = result[3];
			        query = result[4];
			        
			        pattern = /^([!-~]+@)?([^\/?#:]*)(:[\d]*)?/i;
			        result = hostName.match(pattern);
			        if (result != null)
			        {
						this.userInfo = result[1];
						this.host = result[2];
						this.port = result[3];
			        }
			 	}
			}
		}
		//API
		public function get rawUrl():String
		{
			return _rawUrl;
		}
		
		public function get protocol():String
		{
			return _protocol;
		}
		public function set protocol(value:String):void
		{
			if (value != null)
			{
				_protocol = value.replace(/:\/?\/?$/, "");
				_protocol = _protocol.toLowerCase();
			}
		}
		
		public function get host():String
		{
			return _host;
		}
		public function set host(value:String):void
		{
			_host = value;
		}
		
		public function get port():String
		{
			return _port;
		}
		public function set port(value:String):void
		{
			if (value != null)
			{
				_port = value.replace(/(:)/, "");
			}
		}
		
		public function get path():String
		{
			return _path;
		}
		public function set path(value:String):void
		{
			if (value != null)
			{
				_path = value.replace(/^\//, "");
			}
		}
		
		public function get query():String
		{
			return _query;
		}
		public function set query(value:String):void
		{
			if (value != null)
			{
				_query = value.replace(/^\?/, "");
			}
		}
		
		public function get userInfo():String
		{
			return _userInfo;
		}
		public function set userInfo(value:String):void 
		{
			if (value != null)
			{
				_userInfo = value.replace(/@$/, "");			
			}
		}
		
		public function toString():String
		{
			return _rawUrl;
		}
		
		public function get absolute():Boolean
		{
			return protocol != "";
		}
		
		public function get extension():String
		{
			var lastDot:int = path.lastIndexOf(".");
			if (lastDot != -1)
			{
				return path.substr(lastDot+1);
			}
			
			return "";
		}
		public function get rot():String {
			var __port:String = "";
			if (port.length > 1) {
				__port = ":"+port
			}
			_rot = protocol+"://"+host+__port+"/"
			return _rot;
		}
		//
		public function getParamValue(param:String):String
		{
			if (_query == null)
			{
				return "";
			}
			
			var pattern:RegExp = new RegExp("[\/?&]*" + param + "=([^&#]*)", "i");
						
			var result:Array = _query.match(pattern);
			var value:String = (result == null) ? "" : result[1];
			
			return value;
		}
		public function get name():String
		{
			_name = path;
			var i:int = _name.lastIndexOf("/");
			_name = _name.slice(i+1);
			return _name;
		}
		//OVER
	}
	
}