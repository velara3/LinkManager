




package com.flexcapacitor.utils {
	import flash.trace.Trace;

	
	public class ClassUtils {
		
		public static var staticInstance:ClassUtils = new ClassUtils();
		
		public function ClassUtils() {
			
		}
	
		public function getClassName(object:Object):String {
			var className:String = Object(object).constructor;
			var match:Array = String(className).match(/(\w+)]/);
			if (className.length > 1) {
				return match[1];
			}
			return "";
		}
		
		public function traceOut(object:Object):void {
			trace(getClassName(object));
		}
	}
}