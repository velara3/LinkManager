



package com.flexcapacitor.handlers {

	import flash.events.IEventDispatcher;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.StateChangeEvent;
	
	/**
	 * Adds an event listener on the target component for the specified event
	 * Whenever the target dispatches the event the actions in the actions array are called
	 * */
	public class BehaviorHandler extends InteractionHandler implements IHandler {
		
		private var _target:*;

		[Bindable]
		public function get target():* {
			return _target;
		}

		/**
		 * Component or class that contains the event we listen for
		 * */
		public function set target(value:*):void {
			_target = value;
			
			if (value) {
				
				// add event handler - the same handler is only added once
				if (value && Object(value).hasOwnProperty("addEventListener")) {
					value.addEventListener(eventName, eventHandler, false, 0, true);
				}
			}
		}

		
		// name of event on target component or class
		[Bindable]
		public var eventName:String = "";
		
		public function BehaviorHandler(target:IEventDispatcher=null) {
			super(target);
			
			// set run on every click to true for parameter handlers
			_runOnEveryClick = false;
			
			// add event handler
			if (target && Object(target).hasOwnProperty("addEventListener")) {
				target.addEventListener(eventName, eventHandler, false, 0, true);
			}
			else {
				application.addEventListener(FlexEvent.CREATION_COMPLETE, applicationCreated, false, 0, true);
			}
		}
		
		public function applicationCreated(event:FlexEvent):void {
			application.removeEventListener(FlexEvent.CREATION_COMPLETE, applicationCreated);
			
			// add event handler
			if (target && Object(target).hasOwnProperty("addEventListener")) {
				target.addEventListener(eventName, eventHandler, false, 0, true);
			}
			else {
				// can't find object
				// it might not be created yet, life for example a different state
				// should we throw an error or listen to state changes and wait until it is created?
				// or should we require all objects to be created at startup using creationPolicy="all"?
				application.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, applicationStateChange, false, 0, true);
			}
		}
		
		public function applicationStateChange(event:StateChangeEvent):void {
			if (target && Object(target).hasOwnProperty("addEventListener")) {
				target.addEventListener(event, eventHandler, false, 0, true);
				application.removeEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, applicationStateChange);
			}
		}
		
		public function eventHandler(event:*):void {
			run();
		}
		
		// runs the code in this class
		override public function run():void {
			
			runActions();
			
			ranOnce = true;
		}
		
	}
}