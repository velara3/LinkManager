




package com.flexcapacitor.utils {
	import mx.utils.StringUtil;

	// VERSION 1.0
	public class TokenReplace extends StringUtil {

		public function TokenReplace() {
			super();
		}

		public var multiline:Boolean = true;
		public var global:Boolean = true;
		public var extended:Boolean = false;
		public var dotAll:Boolean = false;
		public var caseSensitive:Boolean = true;
		public var emptyString:String = "not found or empty";
		
		public function replace(string:String, propertyClass:Object):String {
			var propertyPattern:RegExp = new RegExp("\\[(\\w*)\]", getFlags());
			var tokenPattern:RegExp = /(\[\w*])/gm;
			var propertyList:Array = string.match(propertyPattern);
			var tokenList:Array = string.match(tokenPattern);
			
			if (tokenList==null || propertyList==null) { return string; }
			var length:int = tokenList.length;
			
			// get the properties we are looking for
	        for (var i:int=0;i<length;i++) {
	        	var property:String = String(propertyList[i]).replace(/\[(\w*)]/gm, "$1");
	        	var token:String = tokenList[i];
	        	var propertyValue:String = "";
	        	
	        	if (propertyClass.hasOwnProperty(property)) {
	        		propertyValue = String(propertyClass[property]).toString();
	            	string = string.replace(token, propertyValue);
	        	}
	        	else if (propertyClass.hasOwnProperty("getStyle")) {
	        		propertyValue = String(propertyClass.getStyle(property)).toString();
	        		if (propertyValue!=null && propertyValue!="undefined") {
	            		string = string.replace(token, propertyValue);
	          		}
	          		else {
	            		string = string.replace(token, emptyString);
	          		}
	          		
	        	}
	        	else {
	            	string = string.replace(token, emptyString);
	        	}
	        }
	        
			return string;
		}
		
		public function getFlags():String {
			var flags:String = "";
			flags += (multiline) ? "m" : "";
			flags += (global) ? "g" : "";
			flags += (extended) ? "x" : "";
			flags += (dotAll) ? "s" : "";
			flags += (!caseSensitive) ? "i" : "";
			return flags;
		}

	}
}