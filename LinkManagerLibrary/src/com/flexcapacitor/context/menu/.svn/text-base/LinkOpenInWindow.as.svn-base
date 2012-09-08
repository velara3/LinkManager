




package com.flexcapacitor.context.menu {
	
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	public class LinkOpenInWindow extends MenuItem implements IMenuItem  {
		
		
		public function LinkOpenInWindow() {
			super();
			caption = "Open in a New Window";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			menu.enabled = (hyperlink==null && hyperlink=="") ? false : true;
			navigateToURL(new URLRequest(hyperlink),'_blank');
		}
	}
}