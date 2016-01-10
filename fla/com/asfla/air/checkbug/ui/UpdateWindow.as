package com.asfla.air.checkbug.ui
{
	import com.asfla.air.checkbug.core.Config;
	import com.asfla.components.btn.Labelbtn;
	import flash.desktop.Updater;
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.net.*;
	
	/**
	 +------------------------------------------------
	 * AIR UpdateWindow CODE update ui
	 +------------------------------------------------ 
	 * @author 8088 at 2011-07-18
	 * version: 0.1
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class UpdateWindow extends Sprite
	{
		public var bg:Sprite;
		public var min_btn:SimpleButton;
		public var close_btn:SimpleButton;
		public var yes_btn:Labelbtn;
		public var no_btn:Labelbtn;
		private var config:Config;
		public function UpdateWindow(setter:Config) 
		{
			config = setter;
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			tabEnabled = false;
			tabChildren = false;
			initStage();
			
			min_btn.addEventListener(MouseEvent.CLICK, minHandler);
			close_btn.addEventListener(MouseEvent.CLICK, closeHandler);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, startWindowDrag);
			
			yes_btn = new Labelbtn();
			yes_btn.label = "yes";
			yes_btn.x = 290;
			yes_btn.y = 115;
			yes_btn.enable = true;
			addChild(yes_btn);
			yes_btn.addEventListener(MouseEvent.CLICK, yesHandler);
			
			no_btn = new Labelbtn();
			no_btn.label = "no";
			no_btn.x = 250;
			no_btn.y = 115;
			no_btn.enable = true;
			addChild(no_btn);
			no_btn.addEventListener(MouseEvent.CLICK, closeHandler);
		}
		private function startWindowDrag(evt:MouseEvent):void {
			stage.nativeWindow.startMove();
		}
		private function initStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		private function closeHandler(evt:MouseEvent):void
		{
			stage.nativeWindow.close();
		}
		private function minHandler(evt:MouseEvent):void
		{
			stage.nativeWindow.minimize();
		}
		private function yesHandler(evt:MouseEvent):void
		{
			if(Updater.isSupported){
				var updater:Updater = new Updater();
				var airFile:File = File.applicationStorageDirectory.resolvePath(File.applicationDirectory.nativePath +"/data/Checkbug.air");
				var version:String = config.latest_version;
				updater.update(airFile, version);
			}
		}
		//OVER
	}
}