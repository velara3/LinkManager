


/**
 * 
 * 
 * 
 * 
 * */
package com.flexcapacitor.handlers {
	
	import com.flexcapacitor.actions.Action;
	import com.flexcapacitor.events.FragmentHandlerEvent;
	import com.flexcapacitor.vo.LinkInfo;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.UIComponent;
	
	/** 
	 *  Dispatched when the fragment specified matches the current fragment 
	 *
	 *  @eventType com.flexcapacitor.events.FragmentHandlerEvent.FUNCTION
	 */
	[Event(name="callFunction", type="com.flexcapacitor.events.FragmentHandlerEvent")]
	
	/**
	 * 
	 * @author monkeypunch
	 */
	public class FragmentHandler extends Handler implements IHandler {
		

		[Bindable]
		/**
		 * Regular expression pattern 
		 * @default 
		 */
		public var pattern:Object = "";
		
		// when set to true if the hyperlink parameter value is blank then the function or behavior is called 
		[Bindable]
		/**
		 * 
		 * @default 
		 */
		public var isBlank:Boolean;
		
		// when set to true if the hyperlink parameter value is not blank then the function or behavior is called
		[Bindable]
		/**
		 * 
		 * @default 
		 */
		public var isNotBlank:Boolean;
		
		[Bindable]
		/**
		 * 
		 * @default 
		 */
		public var caseSensitive:Boolean = false;
		
		// function to call when conditions in this instance are met
		[Bindable]
		/**
		 * 
		 * @default 
		 */
		public var callFunction:Function;
		
		// behavior to run when conditions in this instance are met
		[Bindable]
		/**
		 * 
		 * @default 
		 */
		public var runAction:Action;
		
		// reference to the hyperlink enabled component that initated this call (if any)
		[Bindable]
		/**
		 * 
		 * @default 
		 */
		public var mouseTarget:*;
		
		// reference to the component repeater item (if component is in a repeater)
		[Bindable]
		/**
		 * 
		 * @default 
		 */
		public var currentItem:*;
		
		// reference to the component repeater item index (if component is in a repeater)
		[Bindable]
		/**
		 * 
		 * @default 
		 */
		public var currentIndex:*;
		
		[Bindable]
		public var parametersMap:String;
		
		/**
		 * Fragment to respond to. Use this instead of the value property
		 * */
		[Bindable]
		public function set fragment(fragmentValue:String):void {
			this.value = fragmentValue;
		}
		
		public function get fragment():String {
			return this.value;
		}
		
		/**
		 * 
		 * @param target
		 */
		public function FragmentHandler(target:IEventDispatcher=null) {
			super(target);
			
			// set defaults
			// set run on every click to true for fragment handlers
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
			dispatchEvent(new FragmentHandlerEvent(FragmentHandlerEvent.FUNCTION, linkInfo.hyperlink, linkInfo));
			
			dispatchEvent(new FragmentHandlerEvent(FragmentHandlerEvent.CHANGE, linkInfo.hyperlink, linkInfo));
			
			runActions();
			
			this.ranOnce = true;
		}
		
	}
}