




package com.flexcapacitor.context.menu {
	
	
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	

	public class PageReload extends MenuItem {
		
	
		public function PageReload() {
			super();
			
			caption = "Reload";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			ExternalInterface.call('eval',"document.location.reload(true)");
		}
	}
}