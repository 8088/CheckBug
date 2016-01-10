package com.asfla.utils 
{
	
	/*********************************
	 * AS3.0 asfla_util_Color CODE
	 * BY 8088 2009-09-14
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class Color
	{
		/** 
		 * color1是浅色,color2是深色,实现渐变 
		 * steps是指在多大的区域中渐变, 
		 */
		public static function generateTransitionalColor( color1:uint, color2:uint, steps:int):Array{  
			if( steps < 3 ){ 
				return [];  
			}
			var color1RGB:Array = retrieveRGBComponent(color1);
			var color2RGB:Array = retrieveRGBComponent(color2); 
			var colors:Array = [];  
			colors.push( color1 );
			
			var redDiff:Number = color2RGB[0] - color1RGB[0];  
			var greenDiff:Number = color2RGB[1] - color1RGB[1];  
			var blueDiff:Number = color2RGB[2] - color1RGB[2];  
			for( var i:int = 1; i < steps - 1; i++){  
				var tmpRGB:Array = [color1RGB[0] + redDiff * i / steps,  
											color1RGB[1] + greenDiff * i / steps,  
											color1RGB[2] + blueDiff * i / steps  
											];
				colors.push(generateFromRGBComponent(tmpRGB));
		   }  
		   colors.push( color2 );  
		   
		   return colors;  
		}
		public static function retrieveRGBComponent( color:uint ):Array{  
            var r:Number = color >> 16;  
            var g:Number = (color >> 8) & 0xff;  
            var b:Number = color & 0xff;  
            return [r, g, b];  
        }
		public static function generateFromRGBComponent( rgb:Array ):int{  
            if( rgb == null || rgb.length != 3 || rgb[0] < 0 || rgb[0] > 255 || rgb[1] < 0 || rgb[1] > 255 || rgb[2] < 0 || rgb[2] > 255 ){
                return 0xFFFFFF;
			}
                return rgb[0] << 16 | rgb[1] << 8 | rgb[2];  
        }
		//OVER
	}
}