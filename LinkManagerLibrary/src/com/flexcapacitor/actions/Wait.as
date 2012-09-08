




package com.flexcapacitor.actions {
	
	import com.flexcapacitor.handlers.Handler;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.Application;
	import mx.core.UIComponent;

	/** 
	 *  Wait until event on target occurs
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]
	
	public class Wait extends Action {
		
		
		public function Wait(target:Object = null, event:String = null, faultEvent:Object = null) {
			// 
		}
		
		override public function apply(parent:UIComponent = null):void {
			
		}
		
	}
}