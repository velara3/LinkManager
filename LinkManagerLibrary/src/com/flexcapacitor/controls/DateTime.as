package com.flexcapacitor.controls
{


	[Event(name="timeChanged", type="com.flexcapacitor.events.TimeChangedEvent")]

	import com.flexcapacitor.events.TimeChangedEvent;
	import com.flexcapacitor.utils.DateComposer;
	import com.flexcapacitor.utils.DateVO;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.binding.utils.*;
	import mx.controls.TextInput;
	import mx.core.UIComponentGlobals;
	import mx.events.FlexEvent;

	public class DateTime extends TextInput {

		public function DateTime() {
			//TODO: implement function
			super();
		    
	        super.editable = false;
	        super.text = "Saturday, December 4, 1975 11:59 PM";
	        
	        //super.setStyle("borderStyle", "solid"); 
			//super.setStyle("backgroundAlpha", 0);
			//super.setStyle("borderThickness", 0);
			
		    addEventListener(FlexEvent.PREINITIALIZE, preinit, false, 0, true);
		    addEventListener(FlexEvent.INITIALIZE, init, false, 0, true);
		    addEventListener(FlexEvent.CREATION_COMPLETE, created, false, 0, true);
		}

		[Bindable]
		[Inspectable(type="Boolean", category="General", name="Use Leading Zeros", defaultValue="true")]
		public var useLeadingZeros:Boolean = true;
		
		[Bindable]
		[Inspectable(type="String", category="General", name="Hour Format", enumeration="12,24")]
		public var hourFormat:String = "12";
		
		private var todaysDate:Date;
		
		private var _textFormat:String = "[d], [m] [dd], [yyyy] [hr]:[mn] [am]";
		private var textFormatChanged:Boolean;
		public var dateComposer:DateComposer;
		
		[Bindable]
		[Inspectable(type="String", category="General", name="Update Interval", enumeration="day,hour,minute,second,one hundredths,ten hundredths,millisecond,none")]
		public var updateInterval:String = "minute";
		public var timer:Timer;
		
		// set default properties here
		public function preinit(e:FlexEvent):void {
			//trace("pre initialize");
			//super.setStyle("backgroundAlpha", 0);
			//super.setStyle("borderThickness", 0);
			
		}
		
		public function init(e:FlexEvent):void {
			//trace("initilize")
			// create new super date
			dateComposer = new DateComposer();
			// set leading zeros in super date
			dateComposer.useLeadingZeros = useLeadingZeros;
			// set text format in super date
			dateComposer.textFormat = textFormat;
			// set zoneOffset
			// replace values in text format
			dateComposer.format();
			
			//trace("dateComposer.formattedText="+dateComposer.formattedText)
			// bind text format output to text field
	        //BindingUtils.bindProperty(dateComposer, "formattedText", this, "text");
	        BindingUtils.bindProperty(this, "text", dateComposer, "formattedText");
			// specify update interval (milliseconds, seconds, minutes, hours, days)
			
			timer = new Timer(1000);
			var delay:Number = getTimeIntervalDelay(updateInterval);
	        timer.addEventListener("timer", updateTime);
		}
		
		public function created(e:FlexEvent):void {
			
			// let user modify return value from countdown object
			if (dateFunction==null) { 
				//dateComposer.dateFunction = dateFunction;
			}
			
			// format
			text = dateComposer.formatDateTime(); 
			
			// format 
			var delay:Number = getTimeIntervalDelay(updateInterval);
			
		    // check if we are in the designer 
		    if ( !UIComponentGlobals.designMode ) {
		    	
		    	// if delay is 0 then do not start timer
			    if (delay) {
			    	timer.delay = delay;
			        timer.start();
			    }
				
			} else {
				//trace("In design View");
				dateComposer.updateDate();
			}
			
		}
		
		public function dateFunction(date:DateVO):DateVO {
			return date;
		}
		
		public function updateTime(event:TimerEvent):void {
			dateComposer.updateDate();
			var eventObj:TimeChangedEvent = new TimeChangedEvent(TimeChangedEvent.TIME_CHANGED, dateComposer.todaysDate);
			dispatchEvent(eventObj);
		}
		
		// get delay in milliseconds
		public function getTimeIntervalDelay(interval:String):Number {
			switch (interval) {
				case "day":
					return 86400000;
				case "hour":
					return 3600000;
				case "minute":
					return 60000;
				case "second":
					return 1000;
				case "one hundredths":
					return 100;
				case "ten hundredths":
					return 10;
				case "millisecond":
					return 1;
				default:
					return 0;
			}
			return _updateInterval[updateInterval];
		}
		
		
		[Bindable(event="textFormatChange")]
		[Inspectable(type="String", category="General", name="Text Format", defaultValue="some text")]
		public function get textFormat ():String {
			return _textFormat;
		}
		
		public function set textFormat (value:String):void {	
			_textFormat = value;
		    textFormatChanged = true;
		
		    invalidateProperties();
		    invalidateSize();
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			//trace("commitProperties")
			/*
			if (textFormatChanged) {
				textFormatChanged = false;
				text_mc.text = _text;
				invalidateDisplayList();
			}
			*/
		}
		
		/**
		 *  @private
		 *  Storage for the monthNames property.
		 */
		private var _monthNames:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		
		/**
		 *  @private
		 */
		private var monthNamesChanged:Boolean = false;
		
		[Bindable("monthNamesChanged")]
		[Inspectable(arrayType="String", defaultValue="January,February,March,April,May,June,July,August,September,October,November,December")]
		
		/**
		 *  Names of the months displayed at the top of the DateChooser control.
		 *  The <code>monthSymbol</code> property is appended to the end of 
		 *  the value specified by the <code>monthNames</code> property, 
		 *  which is useful in languages such as Japanese.
		 *
		 *  @default [ "January", "February", "March", "April", "May", "June", 
		 *  "July", "August", "September", "October", "November", "December" ]
		 *  @tiptext The name of the months displayed in the DateChooser
		 */
		public function get monthNames():Array
		{
			return _monthNames;
		}
		
		/**
		 *  @private
		 */
		public function set monthNames(value:Array):void
		{
		    _monthNames = value;
		    monthNamesChanged = true;
		
		    invalidateProperties();
		    invalidateSize();
		}
		/**
		 *  @private
		 *  Storage for the dayNames property.
		 */
		private var _dayNames:Array = ["Sunday","Monday","Tuesday","Wednesday","Tuesday","Friday","Saturday"];
		
		/**
		 *  @private
		 */
		private var dayNamesChanged:Boolean = false;
		
		[Bindable("dayNamesChanged")]
		[Inspectable(arrayType="String", defaultValue="Sunday,Monday,Tuesday,Wednesday,Tuesday,Friday,Saturday")]
		
		/**
		 *  The weekday names for DateChooser control.
		 *  Changing this property changes the day labels
		 *  of the DateChooser control.
		 *  Sunday is the first day (at index 0).
		 *  The rest of the week names follow in the normal order.
		 *
		 *  @default [ "S", "M", "T", "W", "T", "F", "S" ].
		 *  @helpid 3607
		 *  @tiptext The names of days of week in a DateChooser
		 */
		public function get dayNames():Array
		{
		  	return _dayNames;
		}
		
		/**
		 *  @private
		 */
		public function set dayNames(value:Array):void
		{
		    _dayNames = value;
		    dayNamesChanged = true;
		
		    invalidateProperties();
		}
		
		public function getDayName(index:int):String {
			
			return _dayNames[index];
			
		}
		
		public function getDay(date:Date):String {
			
			return String(date.getDay());
			
		}
	}
}