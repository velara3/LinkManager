




package com.flexcapacitor.events {
	
	import flash.events.Event;

	public class ActionHandlerEvent extends Event {
		
		public static const CHANGE:String = "change";
		public static const EVENT:String = "event";
		public static const ACTION:String = "action";
		public var targetComponent:*;
		
		public function ActionHandlerEvent(type:String, target:*) {
			super(type);
			this.targetComponent = target;
		}
		
		// override the inherited clone() method
		override public function clone():Event {
			return new ActionHandlerEvent(type, targetComponent);
		}
	}
}
