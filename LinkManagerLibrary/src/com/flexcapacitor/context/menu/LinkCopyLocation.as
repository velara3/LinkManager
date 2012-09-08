


package com.flexcapacitor.context.menu {
	
	
	import flash.events.ContextMenuEvent;
	import flash.system.System;
	

	public class LinkCopyLocation extends MenuItem {
		
	
		public function LinkCopyLocation():void {
			super();
			
			caption = "Copy Location...";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			
			//Alert.show(hyperlink);
			System.setClipboard(hyperlink);
		}
	}
}