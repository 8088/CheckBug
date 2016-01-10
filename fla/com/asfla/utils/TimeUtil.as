package com.asfla.utils 
{
	
	/*********************************
	 * AS3.0 asfla_util_TimeUtil CODE
	 * BY 8088 2010-12-16
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	*********************************/
	public class TimeUtil 
	{
		
		public static function parseTime(value:String):Number 
		{
			var time:Number = 0;
			var a:Array = value.split(":");
			
			if (a.length > 1) 
			{
				// Clock format, e.g. "hh:mm:ss"
				time = a[0] * 3600;
				time += a[1] * 60;
				time += Number(a[2]);
			}
			else 
			{
				// Offset time format, e.g. "1h", "8m", "10s"
				var mul:int = 0;
				
				switch (value.charAt(value.length-1)) 
				{
					case 'h':
						mul = 3600;
						break;
					case 'm':
						mul = 60;
						break;
					case 's':
						mul = 1;
						break;
				}
				
				if (mul) 
				{
					time = Number(value.substr(0, value.length-1)) * mul;
				}
				else 
				{
					time = Number(value);
				}
			}
			
			return time;
		}
		public static function formatAsTimeCode(sec:Number):String 
		{
			var h:Number = Math.floor(sec / 3600);
			h = isNaN(h) ? 0 : h;
			
			var m:Number = Math.floor((sec % 3600) / 60);
			m = isNaN(m) ? 0 : m;
			
			var s:Number = Math.floor((sec % 3600) % 60);
			s = isNaN(s) ? 0 : s;
			
			return (h == 0 ? "" : (h < 10 ? "0" + h.toString() + ":" : h.toString() + ":")) +
					(m < 10 ? "0" + m.toString() : m.toString()) + ":" + 
					(s < 10 ? "0" + s.toString() : s.toString());
		}
		//OVER
	}
	
}