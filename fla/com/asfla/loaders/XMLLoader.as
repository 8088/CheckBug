package com.asfla.loaders 
{
	import flash.net.*;
    import flash.display.*;
    import flash.events.*;
	import com.asfla.loaders.*;
	
	/*********************************
	 * AS3.0 asfla_loader CODE
	 * BY 8088 2009-11-13
	 * MSN:flasher.jun@hotmail.com
	 * Blog:www.asfla.com
	**********************************/
	public class XMLLoader extends EventDispatcher{
        private var xml:XML;
        private var xmlURLRequest:URLRequest;
        private var xmlURLLoader:URLLoader;
        
        private var _data:XML;
    
        public function XMLLoader(path:String){
            xmlURLLoader = new URLLoader();
            xmlURLRequest = new URLRequest(path);
			
			configureXmlListeners(xmlURLLoader);
			try {
                xmlURLLoader.load(xmlURLRequest);
            } catch (error:Error){
                trace("Unable to load requested document.");
            }           
        }		
		private function configureXmlListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, xmlLoaded);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
		private function deleteXmlListeners(dispatcher:IEventDispatcher):void {
            dispatcher.removeEventListener(Event.COMPLETE, xmlLoaded);
            dispatcher.removeEventListener(Event.OPEN, openHandler);
            dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
		 private function openHandler(event:Event):void {
			dispatchEvent(new LoadEvent(LoadEvent.OPEN));
            //trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
			dispatchEvent(new LoadEvent(LoadEvent.PROGRESS));
            //trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
			dispatchEvent(new LoadEvent(LoadEvent.SECURITY_ERROR));
            //trace("securityErrorHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
			dispatchEvent(new LoadEvent(LoadEvent.HTTP_STATUS));
            //trace("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
			dispatchEvent(new LoadEvent(LoadEvent.IO_ERROR));
            //trace("ioErrorHandler: " + event);
        }
		private function xmlLoaded(evt:Event):void {
			try {				
				_data = new XML(evt.target.data);
				dispatchEvent(new LoadEvent(LoadEvent.COMPLETE));
			}catch (error) {
				trace("no parsing");
			}
        }
		public function get data():XML{
			return _data as XML;
		}
		//OVER
    }	
}