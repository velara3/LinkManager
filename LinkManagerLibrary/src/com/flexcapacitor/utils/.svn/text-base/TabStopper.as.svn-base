package com.flexcapacitor.utils {
	
	import flash.events.FocusEvent;
	
	import mx.core.UIComponent;
	import mx.managers.IFocusManagerComponent;

	public class TabStopper extends UIComponent implements IFocusManagerComponent {
		public function TabStopper(isStart:Boolean) {
			super();
			tabIndex = (isStart) ? 1 : int.MAX_VALUE;
		}
		override protected function focusInHandler(event:FocusEvent):void {
			if (!enabled) return;
			trace("tabIndex: " + tabIndex);
			
			var lastComponent:IFocusManagerComponent = focusManager.getNextFocusManagerComponent(!event.shiftKey);
			if (lastComponent) {
				lastComponent.setFocus();
			}
			
			/* var direction:String = (event.shiftKey) ? FocusRequestDirection.FORWARD : FocusRequestDirection.BACKWARD;
			focusManager.moveFocus(direction);
			trace("component = " + lastComponent); */
		}
	}
}