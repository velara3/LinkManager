



package com.flexcapacitor.handlers {

	import com.flexcapacitor.actions.Action;
	import com.flexcapacitor.events.EventHandlerEvent;
	import com.flexcapacitor.events.ParameterHandlerEvent;
	import com.flexcapacitor.vo.LinkInfo;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.Application;
	import mx.core.FlexVersion;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.StateChangeEvent;
	
	/** 
	 *  Dispatched when a parameter is found usually for the current state
	 *
	 *  @eventType com.flexcapacitor.events.EventHandlerEvent.FUNCTION
	 */
	[Event(name="callFunction", type="com.flexcapacitor.events.EventHandlerEvent")]
	
	public class EventHandler extends Handler implements IHandler {
		
		private var _parameter:String = "";
		
		// parameter to handle
		[Bindable]
		public function set parameter(value:String):void {
			_parameter = value;
		}
		
		public function get parameter():String {
			return _parameter;
		}
		
		// optional - compares if hyperlink parameter value is equal to value set in this property - case insensitive
		[Bindable]
		public var equals:String = "";
		
		// when set to true if the hyperlink parameter value is blank then the function or behavior is called 
		[Bindable]
		public var isBlank:Boolean;
		
		// when set to true if the hyperlink parameter value is not blank then the function or behavior is called
		[Bindable]
		public var isNotBlank:Boolean;
		
		[Bindable]
		public var caseSensitive:Boolean = false;
		
		// function to call when conditions in this instance are met
		[Bindable]
		public var callFunction:Function;
		
		// behavior to run when conditions in this instance are met
		[Bindable]
		public var runAction:Action;
		
		// reference to the hyperlink enabled component that initated this call (if any)
		[Bindable]
		public var mouseTarget:*;
		
		// reference to the component repeater item (if component is in a repeater)
		[Bindable]
		public var currentItem:*;
		
		// reference to the component repeater item index (if component is in a repeater)
		[Bindable]
		public var currentIndex:*;
		
		// component or class that event exists on
		[Bindable]
		public var target:*;
		
		// name of event on target component or class
		[Bindable]
		public var eventName:String = "";
		
		public function EventHandler(target:IEventDispatcher=null) {
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
			
			if (linkInfo.mouseTarget && Object(linkInfo.mouseTarget).hasOwnProperty("repeaterIndex")) {
				currentItem = UIComponent(linkInfo.mouseTarget).getRepeaterItem();
				currentIndex = UIComponent(linkInfo.mouseTarget).repeaterIndex;
			}
			
			// i think we should dispatch an event so that we can write code in the handler function
			dispatchEvent(new EventHandlerEvent(EventHandlerEvent.FUNCTION, linkInfo.hyperlink, linkInfo));
			
			dispatchEvent(new EventHandlerEvent(EventHandlerEvent.CHANGE, linkInfo.hyperlink, linkInfo));
			
			runActions();
			
			this.ranOnce = true;
		}
		
	}
}