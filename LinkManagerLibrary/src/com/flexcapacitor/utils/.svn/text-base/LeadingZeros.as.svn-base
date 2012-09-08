/**
 * Class to set the leading zeros to a string or number
 * 
 * Usage:
 * LeadingZeros.padNumber(9, 2); // traces "09"
 * LeadingZeros.padString("9", 9); // traces "09"
 * 
 * Returns - string. returns string because returning Number format will remove the leading zero pad
*/
package com.flexcapacitor.utils {
	
	public class LeadingZeros {
		
		public var useLeadingZeros:Boolean = true;
		private var numberLength:int = 1;
		private var numberString:String = "";
		public static var staticInstance:LeadingZeros = new LeadingZeros();
		
		public function LeadingZeros() {
			
		}
		
		public function padNumber(number:Number, places:Number = 2):String {
			numberString = String(number);
			if (useLeadingZeros) {
				numberLength = numberString.length;
				for (var i:int = numberLength; i < places; i++) {
					numberString = "0" + numberString;
				}
			}
			return numberString;
		}
		
		// if you need something to be 6 places then use LeadingZeros.padString(myString, 6);
		// for example, LeadingZeros.padString("fff", 6); returns "000fff"
		public function padString(number:String, places:Number = 2):String {
			numberString = number;
			if (useLeadingZeros) {
				numberLength = numberString.length;
				for (var i:int = numberLength; i < places; i++) {
					numberString = "0" + numberString;
				}
			}
			return numberString;
		}
	}
}