




package com.flexcapacitor.events {
	
	import com.flexcapacitor.vo.LinkInfo;
	
	import flash.events.Event;
	
	public class FragmentHandlerEvent extends Event {
		
		public static const CHANGE:String = "change";
		public static const FUNCTION:String = "callFunction";
		public var hyperlink:String = "";
		public var linkInfo:LinkInfo;
		public var mouseTarget:*;
		public var value:String = "";
		
		public function FragmentHandlerEvent(type:String, hyperlink:String, linkInfo:LinkInfo) {
			super(type);
			
			this.hyperlink = hyperlink;
			this.linkInfo = linkInfo;
			if (linkInfo.mouseTarget) {
				this.mouseTarget = linkInfo.mouseTarget;
			}
		}
		
		// override the inherited clone() method
		override public function clone():Event {
			return new FragmentHandlerEvent(type, hyperlink, linkInfo);
		}
	}
}
