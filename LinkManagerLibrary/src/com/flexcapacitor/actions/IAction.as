




package com.flexcapacitor.actions {
	import mx.core.UIComponent;

	public interface IAction {
		
/*		// Name of interaction
		function set title(value:String):void
		function get title():String
		
		// This is a dynamic title to display in the applied interactions panel 
		// When an interaction is applied these tokens would be replaced by the property values
		function set dynamicTitle(value:String):void
		function get dynamicTitle():String*/
		
		// must have apply method
		function apply(parent:UIComponent = null):void
			
		// target property
		//function set target(object:Object):void
		//function get target():Object

	}
}