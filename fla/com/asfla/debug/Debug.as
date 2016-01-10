package com.asfla.debug
{
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.external.ExternalInterface;
	/**
	 +------------------------------------------------
	 * AIR Debug CODE as3.0 debug 
	 +------------------------------------------------ 
	 * @author 8088 at 2011-07-18
	 * version: 0.1
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class Debug {
		
		public static const NAME		:String = 'Debug';
		public static const VERSION		:String = '0.1';
		
		public static var ignoreStatus		:Boolean = true;
		public static var secure			:Boolean = false;
		public static var secureDomain		:String	 = '*';
		public static var allowLog			:Boolean = true;
		
		private static const DOMAIN			:String = 'com.asfla.Checkbug';
		private static const TYPE			:String = 'app';
		private static const CONNECTION		:String = 'checkbug';
		private static const LOG_OPERATION	:String = 'debug';
		private static const ERROR_LOG		:String = 'Parameter out of range!';
		private static const ERROR_COLOR	:uint 	= 16711680;
		public static const DEFAULT_COLOR	:uint 	= 6710886;
		
		private static var lc				:LocalConnection = new LocalConnection();
		private static var hasEventListeners:Boolean 		 = false;
		
		public static function log (msg:Object, color:uint = DEFAULT_COLOR) :Boolean
		{
			var _msg:String;
			if (typeof(msg) == "string")
			{
				_msg = String(msg);
			}
			else {
				if(msg)
				{
					_msg = msg.toString();
				}
				else {
					log("null", ERROR_COLOR);
					return false;
				}
			}
			_msg = "[SWF LOG] " + _msg;
			CONFIG::FLASH_SHOWLOG{
				trace(_msg);
				if (ExternalInterface.available) {
					ExternalInterface.call("ShowLog", _msg);
				}
			}
			return send(_msg, color);
		}
		private static function send(value:*, prop:* ):Boolean
		{
			if (!secure) lc.allowInsecureDomain('*');
			else 		lc.allowDomain(secureDomain);
			if (!hasEventListeners) {
				if ( ignoreStatus ) lc.addEventListener(StatusEvent.STATUS, ignore);
				else 				lc.addEventListener(StatusEvent.STATUS, status);
				hasEventListeners = true;
			}
			if(allowLog){
				try {
					lc.send ( TYPE + '#' + DOMAIN + ':' + CONNECTION , LOG_OPERATION, value, prop );
					return true;
				} catch (e:*) {
					lc.send ( TYPE + '#' + DOMAIN + ':' + CONNECTION , LOG_OPERATION, ERROR_LOG, ERROR_COLOR );
					return false;
				}
			}
			return false;
		}
		
		private static function status(e:StatusEvent):void
		{
			trace( 'Checkbug status:\n' + e.toString() );
		}
		
		private static function ignore(e:StatusEvent):void { }
		
	}
	
}