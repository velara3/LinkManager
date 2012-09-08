
package com.flexcapacitor.context.menu {
	
	
	import flash.display.MovieClip;
	import flash.events.ContextMenuEvent;
	import flash.system.System;
	
	import mx.controls.Image;
	import mx.core.Application;
	

	public class ImageCopyLocation extends MenuItem {
		
	
		public function ImageCopyLocation():void {
			super();
			
			caption = "Copy Image Location...";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			
			// may need to add support for 
			// - embedded images
			// - remote images (already have an absolute path)
			
			var url:String = "";
			var localUrl:String = application.url;
			
			// IMAGE
			if (event.mouseTarget is MovieClip) {
				url = event.mouseTarget.loaderInfo.url;
			}
			else if (event.mouseTarget is Image) {
				url = String(Image(event.mouseTarget).source);
			}
			else {
				url = localUrl.substr(0, localUrl.lastIndexOf("/"));
			}
			
			if (url.indexOf("://")==-1) {
				url = localUrl.substr(0, localUrl.lastIndexOf("/")) + "/" + url;
			}
			
			System.setClipboard(url);
		}
	}
}