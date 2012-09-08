
/**
 * This class lets you watch properties and optionally append them to the url fragment as the you move through the states 
 * You are required to set the parameterName, propertyName and target (if the target is not the application)
 * 
 * 
 * */
package com.flexcapacitor.vo {
	
	import com.flexcapacitor.utils.ApplicationUtils;
	
	import mx.core.Application;
	
	
	public class ParameterProperty {
		
		// class that contains the property to watch
		// if the property is on the application then enter "this" or leave blank
		public var target:Object;
		
		// name of property to watch
		// set the target to the class that contains the property
		public var propertyName:String = "";
		
		// name of parameter on the url
		// for example, #myParameterName=10;
		// the parameter would be "myParameterName"
		public var parameterName:String = "";
		
		// state or states that parameter should be added to the url
		// we should have a include list or exclude list
		public var includeInStates:Object = "";
		
		// state or states that parameter should be added to the url
		// we should have a include list or exclude list
		public var excludeFromStates:Object = "";
		
		// should the parameter be added if its empty or null
		// set this to true to include it if its empty or null
		public var includeIfPropertyIsEmpty:Boolean = false;
		
		// include in states based on this state
		// i can't determine if this should be enabled or disabled by default
		// setting to true for posterity (am i saying what i think i'm saying?)
		public var includeInSubStates:Boolean = true;
		
		
		public function ParameterProperty() {
			
		}

	}
}