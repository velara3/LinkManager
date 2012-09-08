




package com.flexcapacitor.events {
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class InspectorPropertyEvent extends Event {
		
		public static const PROPERTY_CHANGE:String = "propertyChange";
		
		public var targetItem:Object;
		public var property:Object;
		public var newValue:Object;
		public var oldValue:Object;
		
		public function InspectorPropertyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, target:Object = null) {
			super(type, bubbles, cancelable);
			
			targetItem = target;
		}
		
		
		// override the inherited clone() method
		override public function clone():Event {
			return new InspectorPropertyEvent(type, bubbles, cancelable, targetItem);
		}
	}
}
