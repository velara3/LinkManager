

/**
 * This class lets you set the state options for the link manager class
 * 
 * */
package com.flexcapacitor.vo {
	
	import mx.states.State;
	
	
	public class StateOption {
		
		// reference to state place in curly brackets
		public var state:State;
		
		// name of state - case sensitive
		public var stateName:String = "";
		
		// name of state to display in the browser title bar 
		public var displayName:String = "";
		
		// option to show or not show the display or state name in the browser title bar 
		public var showDisplayName:Boolean = true;
		
		// scroll to top of page when entering this state
		public var scrollToTopOnStateChange:Boolean = true;
		
		public function StateOption() {
			
		}

	}
}