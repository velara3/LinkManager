




package com.flexcapacitor.utils {
	
	
	public class InheritanceLookup {
		
		
		public function InheritanceLookup() {
			
			
		}
		
		/**
		 * Get's the first value that's not the "notSetValue" (almost always null) in the list of arguments
		 * For example, if you are looking for the property "enabled" on a button or its container then
		 * you would use checkInheritance("enabled", null, button1, container1);
		 * where null would be 
		 * Note: I'm not sure how to check if a property has been explicitly set except to not set the 
		 * default value. so i'm using 
		 * public var enabled:Boolean; 
		 * instead of
		 * public var enabled:Boolean = true;     
		 * */
		public static function checkInheritance(propertyName:String, notSetValue:*, ...objects):* {
			var length:int = objects.length;
			var value:*;
			
			for (var i:int=0;i<length;i++) {
				
				var object:Object = objects[i];
				
				if (object.hasOwnProperty(propertyName) && object[propertyName]!=null) {
					value = object[propertyName];
					return value;
				}
			}
			
			return notSetValue;
			
		}
	}
}