package com.asfla.utils{
	import flash.ui.*;
	import flash.display.*;
	import flash.net.*;
	import flash.events.ContextMenuEvent;
	/*********************************
	 * AS3.0 asfla_util_Copyright CODE
	 * BY 8088 2008-08-08
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class Copyright {
		private var myName:String="Power by 8088";
		private var myUrl:String="http://www.asfla.com/";
		private var target:InteractiveObject;
		public function Copyright(target:InteractiveObject){
			this.target=target;
			this.removeAndAddItem();
		}
		private function removeAndAddItem():void{
			var myContextMenu = new ContextMenu();
			var item:ContextMenuItem=new ContextMenuItem(myName);
			myContextMenu.hideBuiltInItems();
			myContextMenu.customItems.push(item);
			target.contextMenu=myContextMenu;
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, itemSelectHandler);
		}
		private function itemSelectHandler(e:ContextMenuEvent):void {
			navigateToURL(new URLRequest(myUrl),"_blank");
		}
	}
}