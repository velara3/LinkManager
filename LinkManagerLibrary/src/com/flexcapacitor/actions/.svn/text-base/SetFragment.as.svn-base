




package com.flexcapacitor.actions {
	
	import com.flexcapacitor.vo.LinkInfo;
	
	import mx.core.UIComponent;
	import mx.managers.BrowserManager;
	import mx.utils.URLUtil;

	/** 
	 *  
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]
	
	public class SetFragment extends Action implements IDefaultAction {
		
		public function SetFragment(message:String = "") {
			
		}
		
		/**
		 * Determines if we encode the URL fragment
		 * 
		 * */
		[Bindable]
		public var encodeURL:Boolean = true;
		
		private var _value:String;
		
		[Inspectable(category="General")]
		public function set value(value:String):void {
			// if it's an object convert it to a string
			
			_value = value as String;
		}
		
		/**
		 *  @private
		 */
		public function get value():String {
			return _value;
		}
		
		public var alwaysUpdateFragment:Boolean = false;
		
		override public function apply(parent:UIComponent = null):void {
			var newFragment:String = linkManager.determineFragment(linkInfo);
			var fragment:String = linkManager.getFragment();
			
			
			// if the link was generated from the browser then we shouldn't update the url
			// in other words if the user pressed the back or forward buttons
			// then don't update the url
			// it will mess up and erase the users history
			// NOTE: We still processed the event but we are not going to update the url fragment
			if (linkInfo.browserURLChangeEvent) {
				
				// exiting may be all that is needed
				linkManager.cancelBrowserURLUpdate = false;
				
				linkInfo.determinedFragment = fragment;
				
				// the only time i can think of to modify the url is when dynamic parameters have changed
				// still, it seems best not to modify it if it's a browser change
				// actually, i think it would mess up the history stack
				return;
			}
			
			// set empty strings to nothing instead of null
			if (newFragment==null) {
				newFragment = "";
			}
			
			// don't update the url if it hasn't changed (dont want to add additional history)
			if (newFragment!=fragment || alwaysUpdateFragment) {
				// we should update the browser history class
				
				linkInfo.hasFragmentChanged = true;
				
				linkInfo.determinedFragment = newFragment;
				
				// set the browser fragment
				linkManager.setFragment(newFragment);
			}
		}
		
	}
}