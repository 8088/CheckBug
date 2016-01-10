package com.asfla.air.checkbug.core 
{
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.events.Event;
	import flash.events.FileListEvent
	/**
	 +------------------------------------------------
	 * AIR LogExport CODE save log html
	 +------------------------------------------------ 
	 * @author 8088 at 2011-08-26
	 * version: 0.1
	 * link: www.asfla.com
	 * mail: flasher.jun@gmail.com
	 +------------------------------------------------
	 */
	public class LogExport 
	{
		private static var b:File;
        private static var o:Output;
        private static var f:File;
        private static var s:FileStream;
        private static var x:XML;
        private static var t:String;
		public static var running:Boolean;
		
		public function LogExport() 
		{
			
		}
		public static function export(output:Output):void {
			running = true;
			o = output;
			f = new File(File.applicationDirectory.nativePath + "/templates/Checkbug Log Template.html");
			if (f.exists){
                s = new FileStream();
                s.open(f, FileMode.READ);
                t = s.readUTFBytes(s.bytesAvailable);
                s.close();
            }
			x = o.getXML();
			var item:*;
			var str:String = "";
			var header:String = "Checkbug Log - " + new Date();
			for each (item in x..log) {
				str = str + ("<div class=\"item\"><div class=\"item-time\">" + item.time + "</div><div class=\"item-type\">" + item.type + "</div><div class=\"item-value\"><span style=\"color:#" + HEX(item.color) + "\" >-> " + item.value + "</span></div></div>\n");
			}
			t = t.split("${com.asfla.Checkbug.logPage::header}").join(header);
			t = t.split("${com.asfla.Checkbug.logPage::output}").join(str);
			b = File.documentsDirectory.resolvePath("Checkbug Log.html");
            b.browseForSave("Save log...");
            b.addEventListener(Event.SELECT, LogExport.gotSelectionForSave);
			b.addEventListener(Event.CANCEL, function(){running = false;});
		}
		private static function gotSelectionForSave(evt:Event) : void
        {
            f = evt.target as File;
            s = new FileStream();
            s.open(f, FileMode.UPDATE);
            s.truncate();
            s.writeUTFBytes(t);
            s.close();
			running = false;
        }
		public static function HEX(color:uint):String
        {
            var red:String;
            var blue:String;
            var greed:String;
            red = uint(color >> 16 & 255).toString(16);
            blue = uint(color >> 8 & 255).toString(16);
            greed = uint(color & 255).toString(16);
            return (red.length == 1 ? ("0" + red) : (red)) + (blue.length == 1 ? ("0" + blue) : (blue)) + (greed.length == 1 ? ("0" + greed) : (greed));
        }

	}
	
}