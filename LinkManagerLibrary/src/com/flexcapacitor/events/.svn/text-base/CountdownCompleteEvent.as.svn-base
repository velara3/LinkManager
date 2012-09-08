package com.flexcapacitor.events
{
	import flash.events.Event;
	
	public class CountdownCompleteEvent extends Event
	{
		public static const COUNTDOWN_COMPLETE:String = "countdownComplete";
		
		// define public variable to hold the date
		public var targetDate:Date;
		
		public function CountdownCompleteEvent(type:String, targetDate:Date = null) {
			// Call the constructor of the superclass.
			super(type);
			
			if (targetDate!=null) {
				// pass in the date
				this.targetDate = targetDate;
			}
			
		}
		
		// override the inherited clone() method
		override public function clone():Event {
			return new CountdownCompleteEvent(type, targetDate);
		}
		
	}
}