




package com.flexcapacitor.context.menu {
	
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	
	
	public class PageSend extends MenuItem implements IMenuItem  {
		
		
		public function PageSend() {
			
			// set defaults
			caption = "Send Page...";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			var url:String = ExternalInterface.call('eval',"document.location.href");
			
			ExternalInterface.call("eval", "document.location='mailto:?&subject="+url+"&body="+url+"'");
		}
	}
}