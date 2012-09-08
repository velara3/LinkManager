/* 	bugs 
	fixed - when scrolling up or down...
	
	features
	added - when pressing up or down...
	
	editable="false"
	borderStyle="none"
	text="1 day 23 hours 59 minutes 59 seconds" 
	backgroundAlpha="0"
	*/

package com.flexcapacitor.controls {
	import com.flexcapacitor.events.CountdownCompleteEvent;
	import com.flexcapacitor.events.TimeChangedEvent;
	import com.flexcapacitor.utils.CountdownVO;
	import com.flexcapacitor.utils.DateComposer;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.binding.utils.*;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	[Event(name="timeChanged", type="com.flexcapacitor.events.TimeChangedEvent")]
	[Event(name="countdownComplete", type="com.flexcapacitor.events.CountdownCompleteEvent")]
	[Event(name="timeFormatChanged", type="flase.events.Event")]

	/**
	 *  The Countdown component lets you set a date and countdown to a date or countup from a date
	 */
	public class Countdown extends TextInput {
	
		[Bindable]
	    [Inspectable(type="Boolean", category="General", name="Use Leading Zeros", defaultValue="true")]
		public var useLeadingZeros:Boolean = true;
		
		[Bindable]
	    [Inspectable(type="Boolean", category="General", name="Delay Start", defaultValue="false")]
		public var delayStart:Boolean = false;
		
		public var todaysDate:Date = new Date();
		private var _targetDate:Date = new Date();
		private var _targetDateString:String = "";
		
		private var _runtimeText:String = "[d] days [h] hours [m] mins [s] secs";
		private var runtimeTextChanged:Boolean;
		public var dateComposer:DateComposer;
		
		[Bindable]
	    [Inspectable(type="String", category="General", name="Update Interval", enumeration="day,hour,minute,second,one hundredths,ten hundredths,millisecond,none,custom")]
		public var updateInterval:String = "minute";[Bindable]
	    [Inspectable(type="String", category="General", name="Update Interval Custom Time in Milliseconds")]
		public var updateIntervalTime:int = 1000;
		public var timer:Timer;
		
		private var _timerHours:int = 0;
		private var _timerMinutes:int = 0;
		private var _timerSeconds:int = 0;
		private var _timerMilliseconds:int = 0;
		

		public function Countdown():void {
			//TODO: implement function
			super();
	    
		    // set new default values
		    this.editable = false;
		   	this.setStyle("borderStyle", "none");
		    this.setStyle("backgroundAlpha", 0);
		    this.text = "1 day 23 hours 59 minutes 59 seconds";

			// create new super date
			dateComposer = new DateComposer();
			// set leading zeros in super date
			dateComposer.useLeadingZeros = useLeadingZeros;
			// set text format in super date
			dateComposer.textFormat = runtimeText;
			// set zoneOffset - not implemented
			// get target date to countdown until
			dateComposer.targetDate = _targetDate;
			// enable count up
			dateComposer.countup = countUp;
			
			// todays date is set in dateComposer
			//dateComposer.targetDate = todaysDate;
			
			//trace("dateComposer.formattedText="+dateComposer.formattedText)
			// bind text format output to text field
	        //BindingUtils.bindProperty(dateComposer, "formattedText", this, "text");
	        BindingUtils.bindProperty(super, "text", dateComposer, "formattedText");
			// specify update interval (milliseconds, seconds, minutes, hours, days)
			
			timer = new Timer(1000);
	        timer.addEventListener("timer", updateTime, false, 0, true);
	        
	        addEventListener(FlexEvent.CREATION_COMPLETE, created, false, 0, true);
		}
		
		public function created(event:FlexEvent):void {
			// let user modify return value from countdown object
			if (dateFunction==null) { 
				//dateComposer.dateFunction = dateFunction;
			}
			
			// get target date to countdown until
			dateComposer.targetDate = _targetDate;
			
			// format countdown
			text = dateComposer.formatCountdown();
			
			var delay:Number = getInterval(updateInterval);
			
	        // if delay is 0 then do not start timer
	        if (delay) {
	        	timer.delay = delay;
	        	if (!delayStart) {
		        	timer.start();
		        }
		    }
		}
		
		public function start():void {
			timer.start();
		}
		
		public function stop():void {
			timer.stop();
		}
		
		public function setTimer(hours:int=0, min:int=0, sec:int=0, ms:int=0):void {
			_timerHours = hours;
			_timerMinutes = min;
			_timerSeconds = sec;
			_timerMilliseconds = ms;
			dateComposer.addTime(dateComposer.targetDate,hours,min,sec,ms);
		}
		
		public function dateFunction(countdown:CountdownVO):CountdownVO {
			return countdown;
		}
		
		public function updateTime(event:TimerEvent):void {
			dateComposer.updateCountdown();
			var eventObj:TimeChangedEvent;
			var eventObj2:CountdownCompleteEvent;
			if (dateComposer.countdown.difference==0) {
				eventObj2 = new CountdownCompleteEvent(CountdownCompleteEvent.COUNTDOWN_COMPLETE, dateComposer.targetDate);
				dispatchEvent(eventObj2);
				timer.stop();
			}
			else {
				eventObj = new TimeChangedEvent(TimeChangedEvent.TIME_CHANGED, dateComposer.todaysDate);
				dispatchEvent(eventObj);
			}
		}
	
		public function getInterval(interval:String):Number {
			var number:Number = Number(interval);
			// let people specify the ms count they want
			if (!isNaN(number) && number > 0) {
				return number;
			}
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
				case "custom":
					return updateIntervalTime;
				default:
					return 0;
			}
			return _updateInterval[updateInterval];
		}
		
		private var _countUp:Boolean = false;
		
		[Bindable(event="countUpChange")]
	    [Inspectable(type="Boolean", category="General", name="Count Up", defaultValue="false")]
		public function get countUp():Boolean {
			return _countUp;
		}
		
		public function set countUp(value:Boolean):void {
			_countUp = value;
	        runtimeTextChanged = true;
	
			dateComposer.countup = countUp;
			
	        invalidateProperties();
	        invalidateSize();
		}
				
		[Bindable(event="runtimeTextChange")]
	    [Inspectable(type="String", category="General", name="Text Format", defaultValue="some text")]
		public function get runtimeText():String {
			return _runtimeText;
		}
		
		public function set runtimeText(value:String):void {
			_runtimeText = value;
	        runtimeTextChanged = true;
	
	        invalidateProperties();
	        invalidateSize();
		}
		
		[Bindable]
		[Inspectable(type="String", category="General", name="Target Date")]
		public function get targetDate():String {
			return _targetDateString;
		}
		
		public function set targetDate(value:String):void {
			_targetDateString = value;
			_targetDate = new Date(value);
			//_targetDateString = _targetDateString;
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			//dateComposer.inspectTextFormat(dateComposer.runtimeText);
			//trace("commitProperties")
			/*
			if (runtimeTextChanged) {
				runtimeTextChanged = false;
				text_mc.text = _text;
				invalidateDisplayList();
			}
			*/
		}
	}
}