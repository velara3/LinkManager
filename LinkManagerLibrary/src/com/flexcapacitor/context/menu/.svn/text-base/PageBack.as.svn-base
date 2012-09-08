




package com.flexcapacitor.context.menu {
	
	
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	

	public class PageBack extends MenuItem {
		
	
		public function PageBack() {
			super();
			
			caption = "Previous";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			// backButton is a javascript function automatically created by the browser manager class
			// to go back in the browsers history
			ExternalInterface.call('backButton');
		}
	}
}