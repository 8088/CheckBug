package com.asfla.air.checkbug.core 
{
	import com.asfla.air.checkbug.events.OutputEvent;
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.system.*;
	import flash.utils.*;
	
	/**
	 +------------------------------------------------
	 * AIR Output CODE Checkbug tracer
	 +------------------------------------------------ 
	 * @author 8088 at 2011-07-20
	 * version: 0.1
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class Output extends EventDispatcher
	{
		private var _log:Array = new Array();
		private var config:Config;
		public static const DEFAULT_COLOR:uint = 6710886;
		public function Output(setter:Config) 
		{
			config = setter;
		}
        public function saveLog() : void
        {
			var f:File;
            var s:FileStream;
            if (config.save_last_log)
            {
                f = new File(File.applicationDirectory.nativePath + "/data/log.xml");
                if (f.exists)
                {
                    s = new FileStream();
                    s.open(f, FileMode.UPDATE);
                    s.truncate();
                    s.writeUTFBytes(getXML());
                    s.close();
                }
            }
        }
		
        public function debug(_msg:String, _color:uint = DEFAULT_COLOR) : void
        {
            store(OutputEvent.OUTPUT_MESSAGE, {msg:_msg, color:_color});
            dispatchEvent(new OutputEvent(OutputEvent.OUTPUT_MESSAGE, _msg, _color));
        }
		
        public function getXML():XML
        {
            var xml_str:String;
			var xml:XML;
            var log_obj:LogObject;
            xml_str = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n<data>";
            for each (log_obj in log)
            {
                xml_str = xml_str + ("\n\t<log>\n\t\t<type><![CDATA[" + log_obj.type + "]]></type>\n\t\t<time><![CDATA[" + log_obj.time + "]]></time>\n\t\t<color><![CDATA[" + log_obj.color + "]]></color>\n\t\t<value><![CDATA[" + log_obj.value + "]]></value>\n\t</log>");
            }
            xml_str = xml_str + "\n</data>";
			xml = XML(xml_str);
            return xml;
        }
		
        public function getLogAsString() : String
        {
            var _log_str:String;
            var _log_obj:LogObject;
            _log_str = "[Log saved at: " + new Date() + "]";
            if (log.length > 0)
            {
                for each (_log_obj in log)
                {
                    // label
                    if (_log_obj.type != OutputEvent.OUTPUT_MEMORY)
                    {
                        if (_log_obj.type == OutputEvent.OUTPUT_OBJECT)
                        {
                            _log_str = _log_str + ((_log_str == "" ? ("") : ("\n")) + "object");
                        }
                        _log_str = _log_str + ((_log_str == "" ? ("") : ("\n")) + _log_obj.value);
                    }
                }
            }
            else{
                _log_str = "";
            }
            return _log_str;
        }
		
        private function store(type:String, obj:Object):void
        {
            var msg:String = "";
            var bmd:BitmapData;
            var color:uint;
            var log_obj:LogObject;
            var key:*;
            msg = "";
            bmd = null;
            color = DEFAULT_COLOR;
            switch(type){
                case OutputEvent.OUTPUT_MESSAGE:
                    color = obj.color;
                    msg = String(obj.msg);
                    break;
                case OutputEvent.OUTPUT_ERROR:
                    msg = String(obj);
                    break;
                case OutputEvent.OUTPUT_WARNING:
                    msg = String(obj);
                    break;
                case OutputEvent.OUTPUT_OBJECT:
                    for (key in obj)
                    {
                        msg = msg + ((msg == "" ? ("") : ("\n")) + key + ": " + obj[key]);
                    }
                    break;
                case OutputEvent.OUTPUT_MEMORY:
                    msg = String(obj);
                    break;
                case OutputEvent.OUTPUT_BITMAP:
                    msg = "bitmap trace, not logged.";
                    bmd = obj.bmd;
                    break;
                default:
                    msg = "undefined type :" + String(type);
                    break;
            }
            log_obj = new LogObject(type, msg, bmd, color);
            log.push(log_obj);
            return;
        }
		
        public function clear() : void
        {
            log = [];
            System.gc();
            return;
        }
		public function get log():Array {
			return _log;
		}
		public function set log(ary:Array):void {
			_log = ary;
		}
		
        public function save(param1:Event) : void
        {
            saveLog();
            return;
        }
		//OVER
	}
	
}
import flash.display.BitmapData;
class LogObject extends Object {
	
	private var _time:Date;
    private var _type:String = "";
	private var _value:String = "";
	private var _bmd:BitmapData;
	private var _color:uint;
	public static const DEFAULT_COLOR:uint = 6710886;
	
	public function LogObject(type:String, value:String, bmd:BitmapData = null, color:uint = DEFAULT_COLOR):void {
		_time = new Date();
		_type = type;
		_value = value;
		_bmd = bmd;
		_color = color
	}
	
	public function get time():Date {
		return _time;
	}
	
	public function get type():String {
		return _type;
	}
	
	public function get value():String {
		return _value;
	}
	
	public function get bmd():BitmapData {
		return _bmd;
	}
	
	public function get color():uint {
		return _color;
	}
}