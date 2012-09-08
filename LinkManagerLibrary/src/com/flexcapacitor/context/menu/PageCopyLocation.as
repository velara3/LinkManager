




package com.flexcapacitor.context.menu {
	
	
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	import flash.system.System;
	

	public class PageCopyLocation extends MenuItem {
		
	
		public function PageCopyLocation():void {
			super();
			
			caption = "Copy Page Location";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			
			var url:String = ExternalInterface.call('eval',"document.location.href");
			System.setClipboard(url);
		}
	}
}