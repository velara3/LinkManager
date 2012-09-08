




/**
 * Find object in array collection
 * 
 * */
package com.flexcapacitor.utils {
	
	public class ArrayUtils {
		
		public static var staticInstance:ArrayUtils = new ArrayUtils();
		
		public function ArrayUtils() {
			
		}
		
		static public function getItemIndexByProperty(array:Object, property:Object, value:String):Number {
			var length:int = array.length;
			
			for (var i:Number = 0; i < length; i++) {
				var object:Object = Object(array[i]);
				if (object[property] == value) {
					return i;
				}
			}
			return -1;
		}
		
		static public function getItemIndex(array:Object, item:Object):Number {
			var length:int = array.length;
			
			for (var i:Number = 0; i < length; i++) {
				var object:Object = Object(array[i]);
				if (object==item) {
					return i;
				}
			}
			return -1;
		}
	}
}
