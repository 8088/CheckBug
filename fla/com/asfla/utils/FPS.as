package com.asfla.utils
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;
	/*********************************
	 * AS3.0 asfla_util_FPS CODE
	 * BY 8088 2009-12-15
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	*********************************/
    public class FPS extends Sprite
    {
        private var currentY:int;
        private var diagramTimer:int;
        private var tfTimer:int;
        private var mem:TextField;
        private var diagram:BitmapData;
        private var skins:int = -1;
        private var fps:TextField;
        private var tfDelay:int = 0;
        private var skinsChanged:int = 0;
        static private const maxMemory:uint = 4.1943e+007;
        static private const diagramWidth:uint = 60;
        static private const tfDelayMax:int = 10;
        static private var instance:FPS;
        static private const diagramHeight:uint = 40;

        public function FPS()
        {
            this.addEventListener(Event.ADDED_TO_STAGE, run);
        }

		private function run(ev:Event):void{
			var bmp:Bitmap;
            fps = new TextField();
            mem = new TextField();
			
            if (instance == null)
            {
                mouseEnabled = false;
                mouseChildren = false;
                fps.defaultTextFormat = new TextFormat("Tahoma", 10, 0xff0000);
                fps.autoSize = TextFieldAutoSize.LEFT;
                fps.text = "FPS: " + Number(stage.frameRate).toFixed(2);
                fps.selectable = false;
                fps.x = -diagramWidth - 2;
                addChild(fps);
                mem.defaultTextFormat = new TextFormat("Tahoma", 10, 13421568);
                mem.autoSize = TextFieldAutoSize.LEFT;
                mem.text = "MEM: " + bytesToString(System.totalMemory);
                mem.selectable = false;
                mem.x = -diagramWidth - 2;
                mem.y = 10;
                addChild(mem);
                currentY = 20;
                diagram = new BitmapData(diagramWidth, diagramHeight, true, 553648127);
                bmp = new Bitmap(diagram);
                bmp.y = currentY + 4;
                bmp.x = -diagramWidth;
                addChildAt(bmp, 0);
                addEventListener(Event.ENTER_FRAME, onEnterFrame);
                this.stage.addEventListener(Event.RESIZE, onResize);
                onResize();
                diagramTimer = getTimer();
                tfTimer = getTimer();
            }
            else
            {
            }// end else if
            return;
		}
        private function bytesToString(param1:uint) : String
        {
            var str:String;
            if (param1 < 1024)
            {
                str = String(param1) + "b";
            }
            else if (param1 < 10240)
            {
                str = Number(param1 / 1024).toFixed(2) + "kb";
            }
            else if (param1 < 102400)
            {
                str = Number(param1 / 1024).toFixed(1) + "kb";
            }
            else if (param1 < 1048576)
            {
                str = Math.round(param1 / 1024) + "kb";
            }
            else if (param1 < 10485760)
            {
                str = Number(param1 / 1048576).toFixed(2) + "mb";
            }
            else if (param1 < 104857600)
            {
                str = Number(param1 / 1048576).toFixed(1) + "mb";
            }
            else
            {
                str = Math.round(param1 / 1048576) + "mb";
            }// end else if
            return str;
        }

        private function onEnterFrame(param1:Event) : void
        {
            tfDelay++;
            if (tfDelay >= tfDelayMax)
            {
                tfDelay = 0;
                fps.text = "FPS: " + Number(1000 * tfDelayMax / (getTimer() - tfTimer)).toFixed(2);
                tfTimer = getTimer();
            }// end if
            var frame_rate:* = 1000 / (getTimer() - diagramTimer);
            var _rate:* = frame_rate > stage.frameRate ? (1) : (frame_rate / stage.frameRate);
            diagramTimer = getTimer();
            diagram.scroll(1, 0);
            diagram.fillRect(new Rectangle(0, 0, 1, diagram.height), 553648127);
            diagram.setPixel32(0, diagramHeight * (1 - _rate), 4291611852);
            mem.text = "MEM: " + bytesToString(System.totalMemory);
            var varb:* = skins == 0 ? (0) : (skinsChanged / skins);
            diagram.setPixel32(0, diagramHeight * (1 - varb), 4294927872);
            var num_memory:* = System.totalMemory / maxMemory;
            diagram.setPixel32(0, diagramHeight * (1 - num_memory), 4291611648);
            return;
        }

        private function onResize(param1:Event = null) : void
        {
            var obj:* = parent.globalToLocal(new Point(stage.stageWidth - 2, -3));
            x = obj.x;
            y = obj.y;
            return;
        }
    }
}
