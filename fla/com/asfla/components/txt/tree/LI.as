package com.asfla.components.txt.tree 
{
	import flash.events.*;
	import flash.net.*;
	import flash.external.ExternalInterface;
	/*********************************
	 * AS3.0 asfla_Treeview CODE
	 * BY 8088 2010-12-20
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class LI extends Tree
	{
		
		public function LI(xml:XML, i:int, l:int, end:Boolean)
		{
			super(xml, i, l, end);
			initLI();
		}
		public function initLI():void {
			txt_btn.addEventListener(MouseEvent.CLICK, liDownHandler);
		}
		private function liDownHandler(evt:MouseEvent):void {
			trace("第" + (level + 1) + "级目录第" + (id + 1) + "个文件。");
			navigateToURL(new URLRequest(data_xml.url), "_blank");
		}
		//OVER
	}
	
}