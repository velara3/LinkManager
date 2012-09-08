/**
 * 
 * This needs to be implemented in the Flash Player or the browsers
 * 
 * 
 * */
package com.flexcapacitor.context.menu {
	
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	public class LinkOpenInTab extends MenuItem implements IMenuItem  {
		
		
		public function LinkOpenInTab() {
			super();
			caption = "Open in a New Tab";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			menu.enabled = (hyperlink==null && hyperlink=="") ? false : true;
			// NOTE! This doesnt work
			// We need support for opening a window in a tab from either the browser(s)
			// or Flash Player
			navigateToURL(new URLRequest(hyperlink),'_blank');
		}
	}
}