




package com.flexcapacitor.context.menu {
	
	
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	
	import mx.core.Application;
	

	public class PageBookmark extends MenuItem {
		
	
		public function PageBookmark() {
			super();
			
			caption = "Bookmark this Page";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			var url:String = ExternalInterface.call('eval',"document.location.href");
			var title:String = (application.pageTitle!=null) ? application.pageTitle : ExternalInterface.call("eval","window.document.title");
			ExternalInterface.call("fcBookmark", title, url);
		}
	}
}