package com.flexcapacitor.utils
{
	import mx.events.IndexChangedEvent;
	
	public class DateMath {
		public static const DAY:int = 86400000;
		public static const HOUR:int = 3600000;
		public static const MINUTE:int = 60000;
		public static const SECOND:int = 1000;
		public static const ONE_HUNDREDTH:int = 100;
		public static const TEN_HUNDREDTH:int = 10;
		public static const MILLISECOND:int = 1;
		
	    public static function addWeeks(date:Date, weeks:Number):Date {
	        return addDays(date, weeks*7);
	    }
	
	    public static function addDays(date:Date, days:Number):Date {
	        return addHours(date, days*24);
	    }
	
	    public static function addHours(date:Date, hrs:Number):Date {
	        return addMinutes(date, hrs*60);
	    }
	
	    public static function addMinutes(date:Date, mins:Number):Date {
	        return addSeconds(date, mins*60);
	    }
	
	    public static function addSeconds(date:Date, secs:Number):Date {
	        var mSecs:Number = secs * 1000;
	        var sum:Number = mSecs + date.getTime();
	        return new Date(sum);
	    }
	
	    public static function addMilleseconds(date:Date, ms:Number):Date {
	        var sum:Number = ms + date.getTime();
	        return new Date(sum);
	    }
	    
	    //at some point add weeks and days to this
	    public static function addTime(date:Date, days:Number=0, hours:Number=0, minutes:Number=0, seconds:Number=0, milliseconds:Number=0):Date {
	    	var addDays:int = days * DAY;
			var addHours:int = hours * HOUR;
			var addMinutes:int = minutes * MINUTE;
			var addSeconds:int = seconds * SECOND;
			var addMilliseconds:int = milliseconds;
			var sum:int = date.getTime() + addDays + addHours + addMinutes + addSeconds + addMilliseconds;

			return new Date(sum);			
		}
	}
}