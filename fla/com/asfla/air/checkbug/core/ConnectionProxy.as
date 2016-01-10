package com.asfla.air.checkbug.core 
{
    import com.asfla.air.checkbug.events.*;
    import flash.events.*;
    import flash.net.*;
	
	/**
	 +------------------------------------------------
	 * AIR ConnectionProxy CODE proxy lc connect
	 +------------------------------------------------ 
	 * @author 8088 at 2011-07-20
	 * version: 0.1
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class ConnectionProxy extends EventDispatcher
	{
		public var allowedDomains:Array;
        public var allowedInsecureDomains:Array;
        public var secure:Boolean = true;
		
        private var _connect_id:String;
        private var li_client:Output;
        private var lc:LocalConnection;

        public function ConnectionProxy(id:String, output:Output, config:Config)
        {
            _connect_id = id;
            li_client = output;
			
            lc = new LocalConnection();
			lc.allowInsecureDomain("*");
            lc.allowDomain("*");
            lc.client = li_client;
        }
		//API
        public function get domain():String
        {
            return lc.domain;
        }
		
        public function get connect_id():String
        {
            return _connect_id;
        }
		
        public function connect():void
        {
            try {
                lc.connect(_connect_id);
                dispatchEvent(new CheckBugEvent(CheckBugEvent.STATUS_CHANGE, "ready.."));
            }
			catch (error:ArgumentError) {
                dispatchEvent(new CheckBugEvent(CheckBugEvent.STATUS_CHANGE, "<font color='#900000'>connection failed!</font>"));
            }
        }
		
        public function close():void
        {
            lc.close();
        }
		
	}
}