package com.flexcapacitor.events
{
	import flash.events.Event;
	
	public class TimeChangedEvent extends Event
	{
		public static const TIME_CHANGED:String = "timeChanged";
		
		// define public variable to hold the date
		public var date:Date;
		
		public function TimeChangedEvent(type:String, date:Date = null) {
			// Call the constructor of the superclass.
			super(type);
			
			// pass in the date
			this.date = date;
			
		}
		
		// override the inherited clone() method
		override public function clone():Event {
			return new TimeChangedEvent(type, date);
		}
		
	}
}