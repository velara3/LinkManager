




package com.flexcapacitor.actions {
	
	import flash.debugger.enterDebugger;
	import flash.events.IEventDispatcher;
	
	import mx.core.UIComponent;

	/** 
	 *  
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]
	
	public class Debug extends Action {
		
		public function Debug(message:String = "") {
			super();
		}
		
		private var _event:String = "result";
		
		[Inspectable(category="General")]
		/**
		 *  The name of the event to listen for
		 */
		public function set event(value:String):void {
			_event = value;
		}
		
		/**
		 *  @private
		 */
		public function get event():String {
			return _event;
		}
		
		
		private var _target:Object;
		
		[Inspectable(category="General")]
		/**
		 *  Component with text property. Optional.
		 */
		public function set target(object:Object):void {
			_target = object;
		}
		
		/**
		 *  @private
		 */
		public function get target():Object {
			return _target;
		}
		
		private var _message:String = "";
		
		[Inspectable(category="General")]
		/**
		 *  Component with text property. Optional.
		 */
		public function set message(value:String):void {
			_message = value;
		}
		
		/**
		 *  @private
		 */
		public function get message():String {
			return _message;
		}
		
		override public function apply(parent:UIComponent = null):void {
			var object:Object = target ? target : parent;
			
			if (target!=null && target.hasOwnProperty("text")) {
				target.text += message + "\n";
			}
			else if (message!="") {
				trace(message);
			}
			
			if (object.hasOwnProperty("addEventListener") && event) {
				IEventDispatcher(object).addEventListener(event, debugEventHandler, false, 0, true);
				
			}
			else {
			
				// step out of this method to start debugging from this point in the actions 
				enterDebugger();
			}
		}
		
		public function debugEventHandler(event:*):void {
			var setDebuggerToCurrentLocationLine:Boolean = true;
			setDebuggerToCurrentLocationLine = false;
			// from here check the event or step out of the method to continue debugging
			enterDebugger();
		}
		
	}
}