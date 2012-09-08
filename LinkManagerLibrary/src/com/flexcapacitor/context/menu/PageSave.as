




package com.flexcapacitor.context.menu {
	
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	
	import mx.core.Application;
	
	
	public class PageSave extends MenuItem implements IMenuItem  {
		
		public var fileReference:FileReference = new FileReference();
		public var request:URLRequest = new URLRequest();
		
		public function PageSave() {
			
			// set defaults
			caption = "Save Page As...";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			var url:String = ExternalInterface.call('eval',"document.location.href");
			url = application.url;
			if (hyperlink!=null && hyperlink!="") {
				url = hyperlink;
			}
        	request = new URLRequest(url);
			fileReference.download(request);
		}
	}
}