package com.asfla.utils 
{
	
	/*********************************
	 * AS3.0 asfla_util_Version CODE
	 * BY 8088 2010-12-16
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	*********************************/
	public class Version 
	{
		private static const _major:String = "1";
		private static const _minor:String = "0";
		
		private static const FIELD_SEPARATOR:String = ".";
		public static function get version():String
		{
			return _major + FIELD_SEPARATOR + _minor;
		}
		public static function get FLASH_10_1():Boolean
		{
			CONFIG::FLASH_10_1
			{
				return true;
			}
			return false;
		}
	}
	
}