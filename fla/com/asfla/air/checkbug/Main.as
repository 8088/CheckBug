package com.asfla.air.checkbug 
{
	import com.asfla.air.checkbug.core.Config;
	import com.asfla.air.checkbug.core.ConnectionProxy;
	import com.asfla.air.checkbug.core.Output;
	import com.asfla.air.checkbug.core.VersionControl;
	import com.asfla.air.checkbug.core.LogExport;
	import com.asfla.air.checkbug.events.CheckBugEvent;
	import com.asfla.air.checkbug.events.OutputEvent;
	import com.asfla.air.checkbug.ui.BG;
	import com.asfla.air.checkbug.ui.Topbtn;
	import com.asfla.air.checkbug.ui.UpdateWindow;
	import com.asfla.components.btn.Basebtn;
	import com.asfla.components.btn.Labelbtn;
	import com.asfla.components.scroll.Scrollbar;
	import com.asfla.components.txt.TxtDynamic;
	import com.asfla.components.txt.TxtInput;
	
	import com.gskinner.motion.*;
	
	import flash.display.*;
	import flash.desktop.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.system.*;
	import flash.utils.*;
	
	
	/**
	 +------------------------------------------------
	 * AIR Checkbug CODE check as3.0 & c++ 
	 +------------------------------------------------ 
	 * @author 8088 at 2011-07-18
	 * version: 0.1
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class Main extends Sprite
	{
		
		private var stage_w:Number;
		private var stage_h:Number;
		private var sys_w:Number;
		private var sys_h:Number;
		private const min_w:Number = 350;
		private const min_h:Number = 400;
		private var version_control:VersionControl;
		private var config:Config;
		private var output:Output;
		private var connctionProxy:ConnectionProxy;
		private var winGtween:GTween;
		
		private var _win:NativeWindow;
		private var _win_rectangle:Rectangle;
		private var _win_fullscreen:Boolean;
		
		private var infoTimer:Timer;
		private var dockImage:BitmapData;
		private var _filter_txt:String = "";
		
		public var info_txt:TextField;
		public var test_txt:TextField;
		public var debug_txt:TxtDynamic;
		public var bg:BG;
		public var clear_btn:Labelbtn;
		public var save_btn:Labelbtn;
		public var filter_txt_input:TxtInput;
		public var top_btn:Topbtn;
		public var min_btn:SimpleButton;
		public var close_btn:SimpleButton;
		public var resize_btn:Sprite;
		public var scrollbar:Scrollbar;
		
		public static const DEFAULT_FRAME_RATE:uint = 24;
		public static const DEFAULT_COLOR:uint = 6710886;
		
		[Embed(source = "../../../../icon/check_bug_16.png", mimeType="image/png")]
		private var icon16:Class;
		[Embed(source = "../../../../icon/check_bug_32.png", mimeType="image/png")]
		private var icon32:Class;
		[Embed(source = "../../../../icon/check_bug_48.png", mimeType="image/png")]
		private var icon48:Class;
		[Embed(source = "../../../../icon/check_bug_128.png", mimeType="image/png")]
		private var icon128:Class;
		
		public function Main() 
		{
			if (stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(evt:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			tabEnabled = false;
			tabChildren = false;
			initStage();
			startAIR();
		}
		private function initStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			
			stage_h	= stage.stageHeight;
			stage_w	= stage.stageWidth;
			
			stage.frameRate	= DEFAULT_FRAME_RATE;
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			
			sys_w = Screen.mainScreen.visibleBounds.width;
			sys_h = Screen.mainScreen.visibleBounds.height;
			
			win = stage.nativeWindow;
			
		}
		private function stageResizeHandler(evt:Event):void
		{
			stage_h	= stage.stageHeight;
			stage_w	= stage.stageWidth;
			//...
			//head btn
			if (close_btn) close_btn.x = stage_w - 24;
			if (min_btn) min_btn.x = close_btn.x - 20;
			if (top_btn) top_btn.x = min_btn.x - 20;
			//bottom btn
			if (clear_btn) clear_btn.y = stage_h -30;
			if (save_btn) save_btn.y = clear_btn.y;
			if (filter_txt_input) filter_txt_input.y = clear_btn.y;
			if (resize_btn)
			{
				resize_btn.x = stage_w - 11;
				resize_btn.y = stage_h - 11;
			}
			//
			if (bg)
			{
				bg.width = stage_w;
				bg.height = stage_h;
			}
			if (info_txt)
			{
				info_txt.y = stage_h - 59;
				info_txt.width = stage_w - 16;
			}
			if (debug_txt)
			{
				debug_txt.width = stage_w - 30;
				debug_txt.height = stage_h - 100;
			}
		}
		private function startAIR():void
		{
			config = new Config();
			config.addEventListener(CheckBugEvent.CONFIG_COMPLETE, initAIR);
			config.addEventListener(CheckBugEvent.STATUS_CHANGE, changeHandler);
			config.local_version = getVersion(NativeApplication.nativeApplication.applicationDescriptor);
		}
		protected function getVersion(appDescriptor:XML):String {
			var ns:Namespace = appDescriptor.namespace();
			return appDescriptor.ns::version[0];
		}
		private function updateHandler(evt:CheckBugEvent):void
		{
			showUpdateWindow();
		}
		private function showUpdateWindow():void
		{
			var win_o:NativeWindowInitOptions = new NativeWindowInitOptions();
			win_o.maximizable = false;
			win_o.minimizable = false;
			win_o.resizable = false;
			win_o.systemChrome = NativeWindowSystemChrome.NONE;
			win_o.transparent = true;
			var win2:NativeWindow = new NativeWindow(win_o);
			var update_win:UpdateWindow = new UpdateWindow(config);
			win2.stage.addChild(update_win);
			win2.stage.align = "TL";
			win2.stage.scaleMode = "noScale";
			win2.bounds = new Rectangle(update_win.height, update_win.height, update_win.width, update_win.height);
			win2.title = "Update available";
			win2.activate();
		}
		private function initAIR(evt:CheckBugEvent):void {
			output = new Output(config);
			connctionProxy = new ConnectionProxy("checkbug", output, config);
			connctionProxy.addEventListener(CheckBugEvent.STATUS_CHANGE, changeHandler);
			connctionProxy.connect();
			
			setupWindows();
			
			version_control = new VersionControl(config);
			version_control.addEventListener(CheckBugEvent.HAS_NEW_VERSION, updateHandler);
			version_control.addEventListener(CheckBugEvent.STATUS_CHANGE, changeHandler);
			version_control.check();
			//checkForFirstRun();
		}
		private function setupWindows():void {
			//注册元件事件
			//head btn
			close_btn.x = stage_w - 24;
			close_btn.y = 7;
			min_btn.x = close_btn.x - 20;
			min_btn.y = 7;
			top_btn.x = min_btn.x - 20;
			top_btn.y = 7;
			top_btn.enable = true;
			top_btn.top = config.top;
			top_btn.addEventListener(MouseEvent.MOUSE_DOWN, winTopHandler);
			min_btn.addEventListener(MouseEvent.CLICK, minHandler);
			close_btn.addEventListener(MouseEvent.CLICK, closeHandler);
			
			
			//debug txt
			debug_txt = new TxtDynamic();
			debug_txt.x = 8;
			debug_txt.y = 36;
			debug_txt.width = 320;
			debug_txt.height = 300;
			debug_txt.enable = true;
			debug_txt.scroll_max = true;
			addChild(debug_txt);
			
			//bottom btn
			clear_btn = new Labelbtn();
			clear_btn.label = "clear";
			clear_btn.x = 8;
			clear_btn.y = stage_h -30;
			clear_btn.enable = true;
			addChild(clear_btn);
			clear_btn.addEventListener(MouseEvent.CLICK, clearHandler);
			
			save_btn = new Labelbtn();
			save_btn.label = "save";
			save_btn.x = clear_btn.x + clear_btn.width + 5;
			save_btn.y = clear_btn.y;
			save_btn.enable = true;
			addChild(save_btn);
			save_btn.addEventListener(MouseEvent.CLICK, saveHandler);
			
			filter_txt_input = new TxtInput();
			filter_txt_input.default_txt = "filter...";
			filter_txt_input.width = 120;
			filter_txt_input.x = save_btn.x + save_btn.width + 6;
			filter_txt_input.y = clear_btn.y;
			filter_txt_input.enable = true;
			addChild(filter_txt_input);
			filter_txt_input.txt.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			filter_txt_input.txt.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			//
			_win_rectangle = new Rectangle((sys_w - min_w) * .5, (sys_h - min_h) * .5, min_w, min_h);
			win.bounds = _win_rectangle;
			win.alwaysInFront = config.top;
			
			bg.addEventListener(MouseEvent.MOUSE_DOWN, startWindowDrag);
			bg.head.addEventListener(MouseEvent.DOUBLE_CLICK, headDoubleClickHandler);
			resize_btn.addEventListener(MouseEvent.MOUSE_DOWN, startWindowResize);
			
			output.addEventListener(OutputEvent.OUTPUT_MESSAGE, outputHandler);
			
			initDock();
		}
		private function initDock():void {
			if(NativeApplication.supportsSystemTrayIcon){
				var dock16:Bitmap = new icon16();
				var dock32:Bitmap = new icon32();
				var dock48:Bitmap = new icon48();
				var dock128:Bitmap = new icon128();
				
				NativeApplication.nativeApplication.icon.bitmaps = 
				[dock16.bitmapData, dock32.bitmapData, dock48.bitmapData, dock128.bitmapData];
				
				//NativeApplication.nativeApplication.autoExit = false;
				SystemTrayIcon(NativeApplication.nativeApplication.icon).tooltip = "Checkbug";
				SystemTrayIcon(NativeApplication.nativeApplication.icon).menu = createSystrayRootMenu();
				SystemTrayIcon(NativeApplication.nativeApplication.icon).addEventListener(MouseEvent.CLICK, undock);
			}
		}
		private function createSystrayRootMenu():NativeMenu {
			var menu:NativeMenu = new NativeMenu();
			var openNativeMenuItem:NativeMenuItem = new NativeMenuItem("Open Checkbug");
			var aboutNativeMenuItem:NativeMenuItem = new NativeMenuItem("About..");
			var exitNativeMenuItem:NativeMenuItem = new NativeMenuItem("Exit");
			openNativeMenuItem.addEventListener(Event.SELECT, undock);
			aboutNativeMenuItem.addEventListener(Event.SELECT, about);
			exitNativeMenuItem.addEventListener(Event.SELECT, closeApp);
			menu.addItem(openNativeMenuItem);
			menu.addItem(aboutNativeMenuItem);
			menu.addItem(new NativeMenuItem("", true));//separator
			menu.addItem(exitNativeMenuItem);
			return menu;
		}
		public function undock(evt:Event):void
		{
			win.visible = true;
			win.restore();
			win.orderToFront();
			if (_win_fullscreen)
			{
				mouseOverHandler(null);
			}
		}
		private function about(evt:Event):void
		{
			navigateToURL(new URLRequest("http://www.asfla.com/air/check_bug/index.html"));
		}
		private function outputHandler(evt:OutputEvent):void {
			setDebug(evt.msg, evt.color);
		}
		private function startWindowDrag(evt:MouseEvent):void {
			win.startMove();
		}
		private function headDoubleClickHandler(evt:MouseEvent):void {
			if (_win_fullscreen) {
				win.bounds = _win_rectangle;
				closeHidden();
			}else {
				_win_rectangle = win.bounds;
				win.width = sys_w * .4;
				win.height = sys_h;
				//win.x = sys_w - win.width;
				win.x = 0;
				win.y = 0;
				
				openHidden();
			}
			_win_fullscreen = !_win_fullscreen;
		}
		private function startWindowResize(evt:MouseEvent):void {
			win.startResize(NativeWindowResize.BOTTOM_RIGHT);
		}
		//btn events
		private function winTopHandler(evt:MouseEvent):void {
			if (top_btn.icon.currentFrame == 1) {
				win.alwaysInFront = false;
			}else {
				win.alwaysInFront = true;
			}
		}
		private function minHandler(evt:MouseEvent):void {
			win.minimize();
		}
		private function closeHandler(evt:MouseEvent):void {
			win.visible = false;
		}
		private function clearHandler(evt:MouseEvent):void {
			debug_txt.text = "";
		}
		private function saveHandler(evt:MouseEvent):void {
			LogExport.export(output);
		}
		private function closeApp(evt:Event):void {
			//Settings.save();
			//dispatchEvent(new Event(Event.CLOSING));
			NativeApplication.nativeApplication.exit();
		}
		private function focusInHandler(evt:FocusEvent):void {
			filter_txt_input.txt.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		private function focusOutHandler(evt:FocusEvent):void {
			filter_txt_input.txt.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		private function keyDownHandler(evt:KeyboardEvent):void {
			if (evt.keyCode == 13) _filter_txt = String(filter_txt_input.txt.text).replace(/(^[　 \t\r\n]*)|([　 \t\r\n]*$)/g, "");
		}
		//hidden handler
		private function closeHidden():void {
			win.removeEventListener(Event.DEACTIVATE, activeHandler);
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
		}
		private function openHidden():void {
			win.addEventListener(Event.DEACTIVATE, activeHandler);
		}
		
		private function activeHandler(evt:Event):void {
			if (!LogExport.running) {
				win.removeEventListener(Event.DEACTIVATE, activeHandler);
				winMove(-1);
				addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			}
		}
		//move
		private function winMove(m:int):void
		{
			var _x:int = (win.width - 2) * m;
			win.x = _x
		}
		private function mouseOverHandler(evt:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			winMove(0);
			win.addEventListener(Event.DEACTIVATE, activeHandler);
		}
		
		
		//status info
		private function changeHandler(evt:CheckBugEvent):void {
			info_txt.htmlText = evt.status;
			if (!infoTimer) {
				infoTimer = new Timer(3000, 1);
				infoTimer.addEventListener(TimerEvent.TIMER, infoTimerHandler);
				infoTimer.start();
			}else {
				if (infoTimer.running) {
					infoTimer.stop();
					infoTimer.start();
				}
			}
		}
		private function infoTimerHandler(evt:TimerEvent):void {
			info_txt.text = "";
		}
		private function filter(str:String):Boolean {
			if (_filter_txt == "") return true;
			if (str.indexOf(_filter_txt) == -1) return false;
			else return true;
		}
		//API
		public function get win():NativeWindow {
			return _win;
		}
		public function set win(w:NativeWindow):void {
			this._win = w;
		}
		public function setDebug(msg:String, color:uint = DEFAULT_COLOR) : void {
			if(filter(msg)){
				var ln:uint = debug_txt.txt.length;
				var txtFormt:TextFormat = new TextFormat();
				txtFormt.color = color;
				debug_txt.appendText("-> " + unescape(msg) + "\n");
				var ln2:uint = debug_txt.txt.length;
				debug_txt.txt.setTextFormat(txtFormt, ln, ln2);
			}
		}
		
		//OVER
	}
	
}