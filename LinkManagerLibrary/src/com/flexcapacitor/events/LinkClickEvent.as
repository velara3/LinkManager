


package com.flexcapacitor.events {

	import flash.events.Event;

	public class LinkClickEvent extends Event {
		
		public static const CLICK:String = "click";
		public var hyperlink:String = "";
		public var hyperlinkTarget:String = "_self";
		
		
		public function LinkClickEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, hyperlink:String = "", hyperlinkTarget:String = "") {
			super(type, bubbles, cancelable);
			
			this.hyperlink = hyperlink;
			this.hyperlinkTarget = hyperlinkTarget;
		}
		
		
		// override the inherited clone() method
		override public function clone():Event {
			return new LinkClickEvent(type, bubbles, cancelable, hyperlink, hyperlinkTarget);
		}
	}
}
