package com.asfla.utils{
	import flash.text.*;
    import flash.utils.*;
	import flash.net.*;
	import flash.external.ExternalInterface;

	/*********************************
	 * AS3.0 asfla_util_Util CODE
	 * BY 8088 2009-09-14
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
    public class Utils extends Object{
		
        public static const NAME:String = "Utils";
        public static const TIME_EXT:String = "dt";
        public static const BLOCK_SIZE:uint = 4 << 1;
        public static const session:String = new Date().valueOf().toString();
        public static const DELTA:uint = 2.65444e+009;
        public static const SPLITER:String = "||";
        public static const FINAL_SUM:uint = 3.33757e+009;
        private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
        public static var BASE64_KEY:String = "kioe257ds";
        public static var showDebug:Boolean = true;
        public static const BLOCK_SIZE_TWICE:uint = 4 << 1 << 1;
        public static const ENCRYPT_ROUNDS:uint = 32;
        public static const BLOCK_SIZE_HALF:uint = 4 << 1 >> 1;
        public static const tf:TextField = new TextField();

        public static function encodeBase64(param1:String, param2:String = null):String{
            if (!param2){
                param2 = BASE64_KEY;
            }
            var byte_ary:* = new ByteArray();
            byte_ary.writeUTFBytes(param1);
            byte_ary.position = 0;
            var byte_ary2:* = new ByteArray();
            new ByteArray().length = byte_ary.length;
            byte_ary2.position = 0;
            var byte_ary3:* = new ByteArray();
            new ByteArray().writeUTFBytes(param2);
            byte_ary3.position = 0;
            var _num:Number = 0;
            while (_num++ < byte_ary.length){
                byte_ary2[_num] = byte_ary[_num] + byte_ary3[_num % byte_ary3.length];
            }
            byte_ary2.position = 0;
            return ByteArrayToString(byte_ary2);
        }
        private static function deal100(param1:String) : String
        {
            param1 = param1.replace(/%25/g, "%");
            if (param1.indexOf("%25") >= 0)
            {
                return deal100(param1);
            }// end if
            return param1;
        }
        public static function processNumber(param1:Number, param2:Number, param3:Number = -1):String{
            var str:String ="";
            if (param3 > 0){
                if (param3 < 10){
                    str = str + "0";
                }
                str = str + (param3.toString() + ":");
            }
            if (param1 < 10){
                str = str + "0";
            }
            str = str + param1.toString();
            str = str + ":";
            if (param2 < 10){
                str = str + "0";
            }
            str = str + param2.toString();
            return str;
        }
        public static function print(param1:Object, param2:Object = null, param3:int = -1):void{
            var obj:Object;
            if (param3 < 0 ? (showDebug) : (true)){
                debug(param1.toString());
            }
            if (typeof(param1) == "string") {
				CONFIG::FLASH_SHOWLOG{
					trace(param1);
					if (ExternalInterface.available) {
						ExternalInterface.call("ShowLog", "[SWF LOG] "+param1);
					}
				}
                return;
            }
            if (param2){
                trace(param2 + ":" + param1[param2]);
                return;
            }
            for (obj in param1){
                trace(obj + ":" + param1[obj]);
            }
            return;
        }
        public static function decodeGBK(param1:String):String{
            var byte_ary:* = new ByteArray();
            param1 = unescape(param1);
            var _int:int = 0;
            while (_int < param1.length){
                byte_ary.writeByte(param1.charCodeAt(_int));
                _int++;
            }
            byte_ary.position = 0;
            return byte_ary.readMultiByte(byte_ary.length, "gbk");
        }
        public static function addHttp(param1:String):String{
            var par1:* = param1;
            var str:* = par1.indexOf("http://") >= 0 ? ("") : ("http://");
            return str + par1;
        }
		 public static function StringToByteArray(param1:String):ByteArray{
            var _loc_6:uint;
            var _loc_7:uint;
            var _loc_2:* = new ByteArray();
            var _loc_3:* = new Array(4);
            var _loc_4:* = new Array(3);
            var _loc_5:uint;
            while (_loc_5 < param1.length){
                _loc_6 = 0;
                while (_loc_6++ < 4 && _loc_5 + _loc_6 < param1.length){
                    _loc_3[_loc_6] = BASE64_CHARS.indexOf(param1.charAt(_loc_5 + _loc_6));
                }
                _loc_4[0] = (_loc_3[0] << 2) + ((_loc_3[1] & 48) >> 4);
                _loc_4[1] = ((_loc_3[1] & 15) << 4) + ((_loc_3[2] & 60) >> 2);
                _loc_4[2] = ((_loc_3[2] & 3) << 6) + _loc_3[3];
                _loc_7 = 0;
                while (_loc_7++ < _loc_4.length){
                    if (_loc_3[_loc_7 + 1] == 64){
                        break;
                    }
                    _loc_2.writeByte(_loc_4[_loc_7]);
                }
                _loc_5 = _loc_5 + 4;
            }
            _loc_2.position = 0;
            return _loc_2;
        }
        public static function ByteArrayToString(param1:ByteArray) : String
        {
            var _loc_3:Array;
            var _loc_5:uint;
            var _loc_6:uint;
            var _loc_7:uint;
            var _loc_2:String;
            var _loc_4:* = new Array(4);
            param1.position = 0;
            while (param1.bytesAvailable > 0){
                _loc_3 = new Array();
                _loc_5 = 0;
                while (_loc_5++ < 3 && param1.bytesAvailable > 0){
                    _loc_3[_loc_5] = param1.readUnsignedByte();
                }
                _loc_4[0] = (_loc_3[0] & 252) >> 2;
                _loc_4[1] = (_loc_3[0] & 3) << 4 | _loc_3[1] >> 4;
                _loc_4[2] = (_loc_3[1] & 15) << 2 | _loc_3[2] >> 6;
                _loc_4[3] = _loc_3[2] & 63;
                _loc_6 = _loc_3.length;
                while (_loc_6++ < 3){
                    _loc_4[_loc_6 + 1] = 64;
                }
                _loc_7 = 0;
                while (_loc_7++ < _loc_4.length){
                    _loc_2 = _loc_2 + BASE64_CHARS.charAt(_loc_4[_loc_7]);
                }
            }
            return _loc_2;
        }
        public static function notify(param1:String, param2:Object = null):void{
            var obj:* = new Object();
            obj[param1] = param2;
            print(obj);
            return;
        }
        public static function getRandomAndTime():String{
            var time:* = new Date().valueOf();
            return time.toString() + Math.random();
        }

        

        public static function debug(param1:String) : void
        {
            tf.appendText(param1 + "\r\t \n\n");
            return;
        }// end function

        public static function getMillFromSec(param1:Number) : int
        {
            return int(param1 * 1000);
        }// end function

        

        public static function decodeBase64(param1:String):String{
            var byte_ary:* = new ByteArray();
            byte_ary = StringToByteArray(param1);
            byte_ary.position = 0;
            var byte_ary2:* = new ByteArray();
            byte_ary2.length = byte_ary.length;
            byte_ary2.position = 0;
            var byte_ary3:* = new ByteArray();
            new ByteArray().writeUTFBytes(BASE64_KEY);
            byte_ary3.position = 0;
            var num:Number =0;
            while (num++ < byte_ary.length){
                byte_ary2[num] = byte_ary[num] - byte_ary3[num % byte_ary3.length];
            }
            byte_ary2.position = 0;
            return byte_ary2.readUTFBytes(byte_ary2.bytesAvailable);
        }
        public static function getTimeUTC():String{
            return new Date().toUTCString();
        }
        public static function $check(param1:String):Boolean{
            if (param1 && param1.length > 0){
                param1 = param1.replace(/(^\s*)|(\s*$)/g, "");
            }
            if (param1 != null) {
				
            }
            return param1 != "";
        }
        public static function DES(param1:String) : String{
            return "";
        }
		public static function urlencodeGB2312(param1:String):String{
            var _int:int;
            var str:String;
            var byte_ary:* = new ByteArray();
            byte_ary.writeMultiByte(param1, "gb2312");
            while (_int < byte_ary.length){
                str = str + escape(String.fromCharCode(byte_ary[_int]));
                _int++;
            }
            return str;
        }
        public static function urlencodeBIG5(param1:String) : String
        {
            var _int:int =0;
            var str:String ="";
            var byte_ary:* = new ByteArray();
            byte_ary.writeMultiByte(param1, "big5");
            while (_int < byte_ary.length){
                str = str + escape(String.fromCharCode(byte_ary[_int]));
                _int++;
            }
            return str;
        }
		public static function urlencodeUTF8(param1:String):String{
            var _int:int;
            var str:String;
            var byteArray:* = new ByteArray();
            byteArray.writeMultiByte(param1, "utf-8");
            while (_int < byteArray.length){
                str = str + escape(String.fromCharCode(byteArray[_int]));
                _int++;
            }
            return deal100(str);
        }
        public static function urlencodeGBK(param1:String) : String{
            var _int:int;
            var str:String;
            var byte_ary:* = new ByteArray();
            byte_ary.writeMultiByte(param1, "gbk");
            while (_int < byte_ary.length){
                str = str + escape(String.fromCharCode(byte_ary[_int]));
                _int++;
            }
            return str;
        }
		public static function alert(msg:Object) {
			var url:String = "javascript:alert(\"trace:" + msg + "\")";
			navigateToURL(new URLRequest(url), "_self");
		}
       //OVER
    }
	
}