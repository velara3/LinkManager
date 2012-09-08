



package com.flexcapacitor.handlers {

	import com.flexcapacitor.actions.Action;
	import com.flexcapacitor.events.ParameterHandlerEvent;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.UIComponent;

	import com.flexcapacitor.vo.LinkInfo;
	
	/** 
	 *  Dispatched when a parameter is found usually for the current state
	 *
	 *  @eventType com.flexcapacitor.events.ParameterHandlerEvent.FUNCTION
	 */
	[Event(name="callFunction", type="com.flexcapacitor.events.ParameterHandlerEvent")]
	
	public class ParameterHandler extends Handler implements IHandler {
		
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
		
		public function ParameterHandler(target:IEventDispatcher=null) {
			super(target);
			
			// set defaults
			// set run on every click to true for parameter handlers
			_runOnEveryClick = true;
			scrollToTop = true;
			runAtStartup = true;
		}
		
		// runs the code in this class
		override public function run():void {
			
			if (linkInfo.mouseTarget && Object(linkInfo.mouseTarget).hasOwnProperty("repeater") && 
				Object(linkInfo.mouseTarget)["repeater"] != null) {
				currentItem = UIComponent(linkInfo.mouseTarget).getRepeaterItem();
				currentIndex = UIComponent(linkInfo.mouseTarget).repeaterIndex;
			}
			else {
				currentItem = new Object();
				currentIndex = -1;
			}
			
			// i think we should dispatch an event so that we can write code in the handler function
			dispatchEvent(new ParameterHandlerEvent(ParameterHandlerEvent.FUNCTION, linkInfo.hyperlink, linkInfo));
			
			dispatchEvent(new ParameterHandlerEvent(ParameterHandlerEvent.CHANGE, linkInfo.hyperlink, linkInfo));
			
			runActions();
			
			this.ranOnce = true;
		}
		
	}
}