


package com.flexcapacitor.context.menu {
	
	import flash.display.MovieClip;
	import flash.events.ContextMenuEvent;
	import flash.events.ErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.profiler.showRedrawRegions;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.core.Application;
	

	public class ImageSave extends MenuItem {
		
		private var fileReference:FileReference = new FileReference();
		private var request:URLRequest = new URLRequest();
		
		public var useBrowserDownloadDialog:Boolean = false;
		public var dynamicNameIndex:int = 1;
		public var dynamicName:String = "image";
		public var dynamicExtension:String = "jpg";
	
		public function ImageSave() {
			super();
			
			caption = "Save Image...";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			var url:String = "";
			var localUrl:String = application.url;
			var possibleName:String = "";
			var newName:String = dynamicName;
			
			// EXTERNAL IMAGE REFERENCED IN TEXT FIELD (NOT TLF TEXTFIELD)
			if (event.mouseTarget is MovieClip) {
				url = event.mouseTarget.loaderInfo.url;
			}
			
			// EXTERNAL IMAGE UICOMPONENT - NON EMBEDDED
			else if (event.mouseTarget is Image && Image(event.mouseTarget).source is String) {
				url = String(Image(event.mouseTarget).source);
			}
			
			// OTHER
			else if (source!="") {
				url = source;
			}
			else {
				url = localUrl.substr(0, localUrl.lastIndexOf("/"));
			}
			
			// if it's a relative URL add the domain
			if (url.indexOf("://")==-1) {
				url = localUrl.substr(0, localUrl.lastIndexOf("/")) + "/" + url;
			}
			else {
				possibleName = url.substr(url.lastIndexOf("/"));
			}
			
	        request = new URLRequest(url);
	        
			if (useBrowserDownloadDialog) {
				navigateToURL(request);
			}
			else {
				try {
					if (possibleName.indexOf(".php")!=-1) {
						newName += (dynamicNameIndex<10) ? String("0" + dynamicNameIndex) : String(dynamicNameIndex);
						newName += "." + dynamicExtension;
						dynamicNameIndex++;
						fileReference.download(request, newName);
					}
					else {
						fileReference.download(request);
					}
				}
				catch(event:ErrorEvent) {
					// Error: Request for resource at http://www.google.com/intl/en_ALL/images/logo.gif by requestor from http://localhost/FlashSite6.swf is denied due to lack of policy file permissions.
					
					// *** Security Sandbox Violation ***
					//	Connection to http://www.google.com/intl/en_ALL/images/logo.gif halted - not permitted from http://localhost/FlashSite6.swf
					// Error #2044: Unhandled SecurityErrorEvent:. text=Error #2048: Security sandbox violation: http://localhost/FlashSite6.swf cannot load data from http://www.google.com/intl/en_ALL/images/logo.gif.
					Alert.show(event.toString(), "ERROR");
				}
			}
		}
	}
}