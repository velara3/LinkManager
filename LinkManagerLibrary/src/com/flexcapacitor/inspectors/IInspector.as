


package com.flexcapacitor.inspectors {
	
	public interface IInspector {
	
		/**
		 * Called when the Element Inspector is closed
		 * Used to clean up any references
		 * */
		function close():void;
		
		/**
		 * This property is set when the target is changed
		 * */
		function set target(value:*):void;
	}
}