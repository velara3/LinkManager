




package com.flexcapacitor.context.menu {
	
	
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	

	public class PageForward extends MenuItem {
		
	
		public function PageForward() {
			super();
			
			caption = "Next";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			// forwardButton is a javascript function automatically created by the browser manager class
			// to go back in the browsers history
			ExternalInterface.call('forwardButton');
		}
	}
}