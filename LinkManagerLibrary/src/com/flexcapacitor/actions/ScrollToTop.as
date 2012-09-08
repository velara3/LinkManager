




package com.flexcapacitor.actions {
	
	import com.flexcapacitor.managers.AnchorManager;
	
	import mx.core.UIComponent;

	/** 
	 *  
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]
	
	public class ScrollToTop extends Action implements IDefaultAction {
		
		
		public function ScrollToTop() {
			
		}
		
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
		
		override public function apply(parent:UIComponent = null):void {
			var anchorManager:AnchorManager = AnchorManager.getInstance();

			// if the hyperlink points to an anchor do nothing
			if (linkInfo.hasAnchor) {
				return;
			}
			else if (handler.scrollToTop) {
				anchorManager.scrollToTop();
			}
		}
		
	}
}