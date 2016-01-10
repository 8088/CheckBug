package
{
	import flash.external.ExternalInterface;
	/*********************************
	 * AS3.0 asfla_util_Cookie CODE
	 * BY 8088 2010-03-17
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class Cookie{
		embedJS();
		/**
		* 绑定js
		*/
		private static function embedJS():void {
			var str:String = "";
			//设置cookie
			str += 'function setCookie_(name, value, expires, security) {' +
			'    var str = name + "=" + escape(value);' +
			'    if (expires != null) str += ";expires=" + new Date(expires).toGMTString() + "";' +
			'    if (security == true) str += ";secure";' +
			'    document.cookie = str;' +
			'}';
			//获取cookie
			str += 'function getCookie_(name) {' +
			'    var arr = document.cookie.match(new RegExp(";?" +name + "=([^;]*)"));' +
			'    if(arr != null) return unescape(arr[1]); ' +
			'    return null;' +
			'}';
			str += 'function deleteCookie_(name) {' +
			'    var d = new Date();' +
			'    d.setTime(d.getTime() – 1);' +
			'    var value = getCookie_(name);' +
			'    if(value != null) {' +
			'        alert(document.cookie);document.cookie = name + "=" + escape(value) + ";expire=" + d.toGMTString();' +
			'    }' +
			'}';
			if (ExternalInterface.available) {
				ExternalInterface.call("eval", str);
			}
		}
		/**
		* 设置cookie
		*
		* @param name            cookie名称
		* @param value            cookie值
		* @param expires        cookie过期时间
		* @param security        是否加密
		*
		*/
		public static function setCookie(name:String, value:String, expires:Date = null, security:Boolean = false):void {
			if (ExternalInterface.available) {
				ExternalInterface.call("setCookie_", name, value, expires ? expires.time : expires, security);
			}
		}
		/**
		* 获取cookie值
		*
		* @param name
		* @return
		*
		*/
		public static function getCookie(name:String):String {
			if (ExternalInterface.available) {
				return ExternalInterface.call("getCookie_", name);
			}
			return null;
		}
		/**
		* 删除cookie
		*
		* @param name
		*
		*/
		public static function deleteCookie(name:String):void {
			if (ExternalInterface.available) {
				ExternalInterface.call("deleteCookie_", name);
			}
		}
	}
}