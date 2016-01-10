package 
{
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.external.ExternalInterface;
	import flash.utils.getTimer;
	import org.flashdevelop.utils.FlashConnect;
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
		public static const VERSION		:String = '0.5';
		
		public static var ignoreStatus		:Boolean = true;
		public static var secure			:Boolean = false;
		public static var secureDomain		:String	 = '*';
		public static var allowLog			:Boolean = true;
		public static var allowAdvancedTrace:Boolean = true;
		
		private static const DOMAIN			:String = 'com.asfla.Checkbug';
		private static const TYPE			:String = 'app';
		private static const CONNECTION		:String = 'checkbug';
		private static const LOG_OPERATION	:String = 'debug';
		public static const DEFAULT_COLOR	:uint 	= 6710886;
		
		public static var RED			:uint = 0xCC0000;
		public static var GREEN			:uint = 0x00CC00;
		public static var BLUE			:uint = 0x6666CC;
		public static var PINK			:uint = 0xCC00CC;
		public static var YELLOW		:uint = 0xCCCC00;
		public static var LIGHT_BLUE	:uint = 0x00CCCC;
		
		private static var lc				:LocalConnection = new LocalConnection();
		private static var hasEventListeners:Boolean 		 = false;
		
		/**
		 * 使用示例：
		 * Debug.log("year={}, month={}, day={}", 2014, 9, 5); // [SWF LOG] year=2014 month=9 day=5
		 * Debug.log(Object); // [SWF LOG] a:"aa", b:"bb", ..
		 * Debug.log(Array); // [SWF LOG] 0, 1, 2, ..
		 * Debug.log("test", 0xFF6600, "SKIN"); // [SKIN LOG] test
		 * Debug.log("test1", "test2", 0xFF6600, "test3", "CORE"); // [CORE LOG] test1 test2 test3
		 */
		public static function log(any:*, ...args):Boolean
		{
			var _msg:String;
			var _color:uint;
			var _logo:String = "SWF";
			
			//
			if (any.toString() === "[object Object]")
			{
				var _str:String = "";
				for (var key:* in any)
				{
					if (_str.length>1) _str += ",";
					_str += key + ":" + any[key];
				}
				_msg = _str;
			}
			else {
				_msg = any.toString();
			}
			
			//
			if (args != null)
			{
				var placehoder:String = "{}";
				var pIndex:int = 0;
				var argIndex:int = 0;
				var arg:String = null;
				
				while ((pIndex = _msg.indexOf(placehoder, pIndex)) != -1 && args.length > 0)
				{
					arg = String(args.shift());
					_msg = _msg.substring(0, pIndex) + arg + _msg.substring(pIndex + 2);
					pIndex += arg.length;
				}
				
				var i:int;
				
				while (i<args.length)
				{
					var _type:String = typeof(args[i]);
					if (_type === "number" && args[i].toString(16).length == 6)
					{
						_color = args[i];
						i++;
						continue;
					}
					
					if (_type==="string"&&args[i].length<=5) 
					{
						var re:RegExp = new RegExp("^[0-9A-Z]+$");
						if (re.test(args[i]))
						{
							_logo = args[i];
							i++;
							continue;
						}
					}
					
					_msg += " " + args[i].toString();
					i++;
				}
				
			}
			
			_msg = "[" + _logo + " LOG" + (Global.getInstance().logAdvancedTrace?wrapMessage():"") + "] " + _msg;
			
			if (Global.getInstance().logOutput == "console")
			{
				if (ExternalInterface.available) {
					try
					{
						ExternalInterface.call("console.log", _msg);
					}
					catch (e:Error) {
						//ignore..
					}
				}
			}
			else if (Global.getInstance().logOutput == "flashdevelop") {
				FlashConnect.trace(_msg);
			}
			return send(_msg, _color);
		}
		
		private static function wrapMessage(allowAdvancedTrace:Boolean = true):String
		{
			var date:Date = new Date();
			var time:String = String("00" + date.hours).substr(-2) + ":" + 
							  String("00" + date.minutes).substr(-2) + ":" + 
							  String("00" + date.seconds).substr(-2) + "." + 
							  String("000" + date.milliseconds).substr(-3);
			var str:String = " ->" + getTimer() + " " + time;
			
			var stack:String;
			if(allowAdvancedTrace){
				try{
					throw new Error();
				}catch(err:Error){
					stack = err.getStackTrace();
				}
			}
			
			if(stack){
				stack = stack.split("\t").join("");
				var lines:Array = stack.split("\n").slice(4);
				var className:String = "";
				var method:String = "";
				var file:String = "";
				var lineNumber:String = "";
				
				for(var i:int = 0; i < 1; i++){
					var line:String = String(lines[i]).substring(3);
					var methodIndex:int = line.indexOf("/");
					var bracketIndex:int = line.indexOf("[");
					var endIndex:int;
					
					endIndex = methodIndex >= 0 ? methodIndex : bracketIndex != -1 ? bracketIndex : line.length;
					className = getClassType(line.substring(0, endIndex));
					if (methodIndex != line.length && methodIndex != bracketIndex) {
						endIndex = bracketIndex != -1 ? bracketIndex : line.length;
						method = line.substring(methodIndex + 1, endIndex - 2);
					}
					if(methodIndex == -1){
						method = "$iinit";
					}
					if (bracketIndex != -1 && bracketIndex != line.length) {
						file = line.substring(bracketIndex + 1, line.lastIndexOf(":"));
						lineNumber = line.substring(line.lastIndexOf(":") + 1, line.length - 1);
					}
				}
				
				str += " " + className + "." + method;
				if(lineNumber) str += ":" + lineNumber;
			}
			
			return str;
		}
		
		private static function getClassType(type:String):String
		{
			if (type.indexOf("::") != -1) {
				type = type.substring(type.indexOf("::") + 2, type.length);
			}
			
			if (type.indexOf("::") != -1) {
				var part1:String = type.substring(0, type.indexOf("<") + 1);
				var part2:String = type.substring(type.indexOf("::") + 2, type.length);
				type = part1 + part2;
			}
			
			type = type.replace("()", "").replace("MethodClosure", "Function").replace(/\$$/, "");
			
			return type;
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