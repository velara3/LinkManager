




package com.flexcapacitor.actions {
	
	import com.flexcapacitor.managers.AnchorManager;
	import com.flexcapacitor.managers.LinkManager;
	import com.flexcapacitor.utils.ArrayUtils;
	import com.flexcapacitor.vo.LinkInfo;
	
	import mx.core.UIComponent;
	import mx.utils.ArrayUtil;
	
	/** 
	 *  
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]
	
	public class ScrollToAnchor extends Action implements IDefaultAction {
		
		
		public function ScrollToAnchor() {
			
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
			var linkManager:LinkManager = LinkManager.getInstance();
			
			// scroll to anchor
			if (linkInfo.isAnchor) {
				// scroll to an anchorName, name, id or vertical position
				anchorManager.scrollToAnchor(linkInfo.anchorName);
				handler.exitActions = true;
			}
		}
		
	}

}