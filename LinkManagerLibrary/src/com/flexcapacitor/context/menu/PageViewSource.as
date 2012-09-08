




package com.flexcapacitor.context.menu {
	
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	public class PageViewSource extends MenuItem implements IMenuItem  {
		
		
		public function PageViewSource() {
			super();
			caption = "View Source...";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			// menu.enabled = (hyperlink==null && hyperlink=="") ? false : true;
			if (hyperlink!=null && hyperlink!="") {
				navigateToURL(new URLRequest(hyperlink),'_blank');
			}
		}
	}
}