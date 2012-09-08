




package com.flexcapacitor.context.menu {
	
	import flash.events.ContextMenuEvent;
	import flash.external.ExternalInterface;
	

	public class LinkSend extends MenuItem {
		
	
		public function LinkSend() {
			super();
			caption = "Send Link...";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			ExternalInterface.call("eval", "document.location='mailto:?&subject="+hyperlink+"&body="+hyperlink+"'");
		}
	}
}