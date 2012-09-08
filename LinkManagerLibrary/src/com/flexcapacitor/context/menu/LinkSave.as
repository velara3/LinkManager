


package com.flexcapacitor.context.menu {
	
	import flash.events.ContextMenuEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	

	public class LinkSave extends MenuItem {
		
		public var fileReference:FileReference = new FileReference();
		public var request:URLRequest = new URLRequest();
		
		public var useBrowserDownloadDialog:Boolean = true;
	
		public function LinkSave() {
			super();
			caption = "Save Link As...";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
	        request = new URLRequest(hyperlink);
	        
			if (useBrowserDownloadDialog) {
				navigateToURL(request);
			}
			else {
				fileReference.download(request);
			}
		}
	}
}
