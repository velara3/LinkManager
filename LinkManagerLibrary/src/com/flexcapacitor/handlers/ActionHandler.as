




package com.flexcapacitor.handlers {

	import com.flexcapacitor.actions.Action;
	import com.flexcapacitor.events.ActionHandlerEvent;
	import flash.events.IEventDispatcher;
	import com.flexcapacitor.vo.LinkInfo;


/** 
 *  Dispatched when 
 *
 *  @eventType com.flexcapacitor.events.ActionHandlerEvent.CHANGE
 */
[Event(name="change", type="com.flexcapacitor.events.ActionHandlerEvent")]

/** 
 *  Dispatched when a 
 *
 *  @eventType com.flexcapacitor.events.ActionHandlerEvent.FUNCTION
 */
[Event(name="callFunction", type="com.flexcapacitor.events.ActionHandlerEvent")]

	public class ActionHandler extends Handler {
		
		// state or state name to run handler on
		// use states to add multiple states
		public function set state(value:*):void {
			includeInStates = value;
		}
		
		public function get state():* {
			return includeInStates;
		}
		
		// states to run code on
		// array of states or state names
		// same as includeInStates property
		public function set states(value:*):void {
			includeInStates = value;
		}
		
		public function get states():* {
			return includeInStates;
		}
		
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
		
		// behavior to run when conditions in this instance are met
		[Bindable]
		public var runAction:Action;
		
		public function ActionHandler(target:IEventDispatcher=null) {
			super(target);
		}
		
		// runs the code in this class
		override public function run():void {
			
			// run actions
			runActions();
			
			// i think we should dispatch an event so that we can write code in the handler function
			dispatchEvent(new ActionHandlerEvent(ActionHandlerEvent.ACTION, linkInfo.mouseTarget));
			
			
			dispatchEvent(new ActionHandlerEvent(ActionHandlerEvent.CHANGE, linkInfo.mouseTarget));
			
			this.ranOnce = true;
		}
		
	}
}