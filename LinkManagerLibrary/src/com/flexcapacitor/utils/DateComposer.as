/**
 * Class that replaces tokens in strings with date and time values. Also is used for countdown and countup. 
 * Check out the countdown property.  
 * 
 * Usage:
 *  // Formatting a date
	// create new date composer
	var dateComposer:DateComposer = new DateComposer();
	// set leading zeros in date - boolean
	dateComposer.useLeadingZeros = true;
	// set text format in date - default "[d], [m] [dd], [yyyy] [hr]:[mn] [am]"
	dateComposer.text = "Todays date is [d], [m] [dd], [yyyy]";
	// get formatted text out of date composer
	trace(dateComposer.text); // "Todays date is Friday, Jan 1, 2008";
	
	// get updated time
	dateComposer.updateDate();
	// trace text value
	trace(dateComposer.text); // "Todays date is Saturday, Jan 2, 2008";

 * Usage 2:
 *  // Creating a countdown
	// create new date composer
	var dateComposer:DateComposer = new DateComposer();
	// set leading zeros in date - boolean
	dateComposer.useLeadingZeros = true;
	// set text format in date - "[hr] hours [mn] minutes [ss] seconds"
	dateComposer.text = "Todays date is [d], [m] [dd], [yyyy]";
	// get formatted text out of date composer
	trace(dateComposer.text); // "Todays date is Friday, Jan 1, 2008";
	
	// get updated time
	dateComposer.updateDate();
	// trace text value
	trace(dateComposer.text); // "Todays date is Saturday, Jan 2, 2008";

 * 
 * 
 **/
package com.flexcapacitor.utils
{
	import mx.events.IndexChangedEvent;
	

	public class DateComposer 
	{
		// todays date
		[Bindable]
		public var todaysDate:Date;
		
		[Bindable]
		// target date - used for figuring out date difference 
		public var targetDate:Date;
		
		[Bindable]
		// target date - used for countdown
		public var countDownDate:Date;
		
		[Bindable]
		// countdown object - has lots of useful properties
		public var countdown:CountdownVO = new CountdownVO();
		
		[Bindable]
		// time object - has lots of useful properties
		public var time:TimeVO = new TimeVO();
		
		[Bindable]
		// date object - has lots of useful properties
		public var date:DateVO = new DateVO();
		
		[Bindable]
		// difference of dates in numbers
		public var dateDiff:Number = 0;
		
		[Bindable]
		// count up option - how many hrs min sec past date
		public var countup:Boolean;
		
		[Bindable]
		// count down past target date flag
		public var elapsedTarget:Boolean;
		
		private var countdownFormatChanged:Boolean = true;
		private var dateTimeFormatChanged:Boolean = true;
		
		// class used to format leading zeros
		public var LeadingZerosClass:LeadingZeros = new LeadingZeros();
		
		[Bindable]
		public var useLeadingZeros:Boolean = true;
		
		[Bindable]
		// specifies standard or military time
		public var hourFormat:String = "12";
		
		// we set these properties to save cpu cycles
		// if the text format doesn't have the token then we dont check for it
		private var hasDayOfMonth:Boolean;
		private var hasDayName:Boolean;
		private var hasDay:Boolean;
		private var hasMonth:Boolean;
		private var hasMonthName:Boolean;
		private var hasYear:Boolean;
		private var hasFullYear:Boolean;
		private var hasHour:Boolean;
		private var hasMinute:Boolean;
		private var hasSecond:Boolean;
		private var hasMillisecond:Boolean;
		private var hasAMPM:Boolean;
		
		// count down only
		private var hasTotalDays:Boolean;
		private var hasTotalHours:Boolean;
		private var hasTotalMinutes:Boolean;
		private var hasTotalSeconds:Boolean;
		private var hasTotalMilliseconds:Boolean;
		private var hasTotalDifference:Boolean;
		
		private var _textFormat:String = "[d], [m] [dd], [yyyy] [hr]:[mn] [pm]";
		private var _countdownTextFormat:String = "[d]day [m]min [s]sec [ms]ms";

		private var _monthNames:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		private var _shortMonthNames:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
		
		public static const DAY:int = 86400000;
		public static const HOUR:int = 3600000;
		public static const MINUTE:int = 60000;
		public static const SECOND:int = 1000;
		public static const ONE_HUNDREDTH:int = 100;
		public static const TEN_HUNDREDTH:int = 10;
		public static const MILLISECOND:int = 1;
	    
	    // text string that has been replaced with date values 
		[Bindable]
		public var formattedText:String;
		
		public function DateComposer(date:Date = null):void {
			// set todays date if not passed in constructor 
			if (date == null) {
				todaysDate = new Date();
				targetDate = new Date();
			}
			// set the month and day dates 
			monthNames = _monthNames;
			dayNames = _dayNames;
		}
		
		public function get textFormat ():String {	
			return _textFormat;
		}
		
		// set the string that contains tokens to be replaced with date or time
		// example, "Today's Date: [d], [m] [dd], [yyyy] [hr]:[mn] [am]"
		public function set textFormat (value:String):void {
			_textFormat = value;
		}
		
		// the original text before any tokens have been replaced 
		public var explicitText:String = "";
		
		// text after tokens have been replaced 
		public var _text:String = "";
		
		[Bindable]
		public function get text():String {	
			return _text;
		}
		
		// set the string that contains tokens to be replaced with date or time
		// for example, "Today's Date: [d], [m] [dd], [yyyy] [hr]:[mn] [am]"
		public function set text(value:String):void {
			explicitText = value;
			inspectTextFormat(explicitText);
			_text = replaceTokens(value);
		}
		
		/**
		 * Checks for date tokens in the text format string.
		 * We do this to save cpu cycles when we later update the formatted text.
		 **/
		public function inspectTextFormat(text:String):void {
			// if the token is the first character then the 
			// index is 0 or false so we add +1 to indicate true
			// we could move this test to a function 
			hasDayOfMonth = Boolean(text.indexOf("[dd]")+1);
			hasDayName = Boolean(text.indexOf("[d]")+1);
			hasDay = Boolean(text.indexOf("[d]")+1);
			hasMonth = Boolean(text.indexOf("[mm]")+1);
			hasMonthName = Boolean(text.indexOf("[m]")+1);
			hasYear = Boolean(text.indexOf("[yy]")+1);
			hasFullYear = Boolean(text.indexOf("[yyyy]")+1);
			hasHour = Boolean(text.indexOf("[hr]")+1);
			hasMinute = Boolean(text.indexOf("[mn]")+1);
			hasSecond = Boolean(text.indexOf("[ss]")+1);
			hasMillisecond = Boolean(text.indexOf("[ms]")+1);
			hasAMPM = Boolean(text.indexOf("[am]")+1 || text.indexOf("[pm]")+1);
			dateTimeFormatChanged = false;
		}

		// Checks for countdown tokens in the text format string.
		// We do this to save cpu cycles when we later update the formatted text.
		public function inspectCountdownFormat(text:String):void {
			hasTotalDays = Boolean(text.indexOf("[td]")+1);
			hasTotalHours = Boolean(text.indexOf("[th]")+1);
			hasTotalMinutes = Boolean(text.indexOf("[tm]")+1);
			hasTotalSeconds = Boolean(text.indexOf("[ts]")+1);
			hasTotalMilliseconds = Boolean(text.indexOf("[tms]")+1);
			hasTotalDifference = Boolean(text.indexOf("[diff]")+1);
			
			hasDay = Boolean(text.indexOf("[d]")+1);
			hasHour = Boolean(text.indexOf("[h]")+1);
			hasMinute = Boolean(text.indexOf("[m]")+1);
			hasSecond = Boolean(text.indexOf("[s]")+1);
			hasMillisecond = Boolean(text.indexOf("[ms]")+1);
			//trace("running inspect countdown text - " + new Date().getTime());
			countdownFormatChanged = false;
		}
		
		// replace any date or time tokens in the text
		public function format():void {
			var dateOutput:String = textFormat;
			
			// save cpu cycles. :)
			// check if the token exists before searching for 
			if (hasDayName) {
				dateOutput = dateOutput.replace("[d]", getDayName(todaysDate));
			}
			if (hasDayOfMonth) {
				dateOutput = dateOutput.replace("[dd]", getDayOfMonth(todaysDate));
			}
			if (hasMonthName) {
				dateOutput = dateOutput.replace("[m]", getMonthName(todaysDate));
			}
			if (hasMonth) {
				dateOutput = dateOutput.replace("[mm]", getMonth(todaysDate));
			}
			if (hasYear) {
				dateOutput = dateOutput.replace("[yy]", getYear(todaysDate));
			}
			if (hasFullYear) {
				dateOutput = dateOutput.replace("[yyyy]", getFullYear(todaysDate));
			}
			if (hasHour) {
				dateOutput = dateOutput.replace("[hr]", getHours(todaysDate, hourFormat));
			}
			if (hasMinute) {
				dateOutput = dateOutput.replace("[mn]", getMinutes(todaysDate, useLeadingZeros));
			}
			if (hasSecond) {
				dateOutput = dateOutput.replace("[ss]", getSeconds(todaysDate, useLeadingZeros));
			}
			if (hasMillisecond) {
				dateOutput = dateOutput.replace("[ms]", getMilliseconds(todaysDate, useLeadingZeros));
			}
			if (hasAMPM) {
				dateOutput = dateOutput.replace("[am]", getAMPM(todaysDate));
				dateOutput = dateOutput.replace("[pm]", getAMPM(todaysDate));
			}
			
			//trace("dateOutput="+dateOutput)
			formattedText = dateOutput;
			_text = dateOutput;
			
		}
		
		// used to let the user make changes to the date object before it is returned
		public function dateFunction (date:DateVO):DateVO {
			return date;
		}
		
		// used to let the user make changes to the countdown object before it is returned
		public function countdownFunction (countdown:CountdownVO):CountdownVO {
			return countdown;
		}
		
		// updates and reformats the date tokens
		public function updateDate(date:Date = null):void {
			if (date==null) {
				todaysDate = new Date();
			}
			format();
		}
		
		// updates and reformats the time tokens
		public function updateTime(date:Date = null):void {
			if (date==null) {
				todaysDate = new Date();
			}
			format();
		}
		
		// updates and reformats the countdown tokens
		public function updateCountdown(date:Date = null):void {
			if (date==null) {
				todaysDate = new Date();
			}
			formatCountdown();
		}
		
		// replace the date and time tokens and return a string 
		public function formatText(text:String, useLeadingZeros:Boolean = true):String {
			if (dateTimeFormatChanged) {
				inspectTextFormat(text);
			}
			
			// take the string and replace with time values - return DateVO
			date = getDateVO(todaysDate, useLeadingZeros);
			// let user mess with the return values
			date = dateFunction(date);
			
			// to update use updateTime or updateDate
			formattedText = replaceTokens(text);
			
			return formattedText;	
		}
		
		// used for date time
		public function formatDateTime():String {
			if (dateTimeFormatChanged) {
				inspectTextFormat(text);
			}
			
			// take the string and replace with time values - return DateVO
			date = getDateVO(todaysDate, useLeadingZeros);
			// let user mess with the return values
			date = dateFunction(date);
			
			// to update use updateTime or updateDate
			formattedText = replaceTokens(text);
			
			return formattedText;
		}
		
		// used for date time
		public function replaceTokens(text:String):String {
			var dateOutput:String = text;
			
			// search and replace only known tokens. saves cpu cycles
			if (hasDayName) {
				dateOutput = dateOutput.replace("[d]", date.dayOfWeekName);
			}
			if (hasDayOfMonth) {
				dateOutput = dateOutput.replace("[dd]", date.dayOfMonth);
			}
			if (hasMonthName) {
				dateOutput = dateOutput.replace("[m]", date.monthName);
			}
			if (hasMonth) {
				dateOutput = dateOutput.replace("[mm]", date.monthNumber);
			}
			if (hasYear) {
				dateOutput = dateOutput.replace("[yy]", date.yearNumberShort);
			}
			if (hasFullYear) {
				dateOutput = dateOutput.replace("[yyyy]", date.yearNumber);
			}
			if (hasHour) {
				dateOutput = dateOutput.replace("[hr]", date.hours);
			}
			if (hasMinute) {
				dateOutput = dateOutput.replace("[mn]", date.minutes);
			}
			if (hasSecond) {
				dateOutput = dateOutput.replace("[ss]", date.seconds);
			}
			if (hasMillisecond) {
				dateOutput = dateOutput.replace("[ms]", date.milliseconds);
			}
			if (hasAMPM) {
				dateOutput = dateOutput.replace("[am]", date.ampm);
				dateOutput = dateOutput.replace("[pm]", date.ampm);
			}
			
			//trace("dateOutput="+dateOutput)
			formattedText = dateOutput;
			return dateOutput;
		}
		
		// get date time value object
		public function getDateVO(todaysDate:Date = null, useLeadingZeros:Boolean = true):DateVO {
			
			// create date if it is not passed in
			if (todaysDate==null) {
				todaysDate = new Date();
			}
			
			date = new DateVO();
			LeadingZerosClass.useLeadingZeros = useLeadingZeros;

			// save cpu cycles. :)
			if (hasDayName) {
				date.dayOfWeekName = getDayName(todaysDate);
			}
			if (hasDayOfMonth) {
				date.dayOfMonth = getDayOfMonth(todaysDate);
			}
			if (hasMonthName) {
				date.monthName = getMonthName(todaysDate);
			}
			if (hasMonth) {
				date.monthNumber = getMonth(todaysDate);
			}
			if (hasYear) {
				date.yearNumberShort = getYear(todaysDate);
			}
			if (hasFullYear) {
				date.yearNumber = getFullYear(todaysDate);
			}
			if (hasHour) {
				date.hours = getHours(todaysDate, hourFormat);
			}
			if (hasMinute) {
				date.minutes = getMinutes(todaysDate, useLeadingZeros);
			}
			if (hasSecond) {
				date.seconds = getSeconds(todaysDate, useLeadingZeros);
			}
			if (hasMillisecond) {
				date.milliseconds = getMilliseconds(todaysDate, useLeadingZeros);
			}
			if (hasAMPM) {
				date.ampm = getAMPM(todaysDate);
			}
		
			return date;
		}

		
		// replaces countdown tokens in text
		public function formatCountdown():String {
			// inspect for tokens in string
			if (countdownFormatChanged) {
				inspectCountdownFormat(_textFormat);
				//trace("inspecting countdown")
			}
			
			// get the difference between the target date and todays date
			// returns countdown object
			countdown = getDateDifferenceCountdown(targetDate, todaysDate, useLeadingZeros);
			// let user mess with the return values
			countdown = countdownFunction(countdown);
			
			// take the string and replace tokens
			formattedText = replaceCountdownTokens(countdown);
			
			return formattedText;

		}
		
		// replaces countdown related tokens 
		public function replaceCountdownTokens(countdown:CountdownVO):String {
			
			//trace("formatCountdown")
			var dateOutput:String = textFormat;
			
			// save cpu cycles. :)
			if (hasDay) {
				dateOutput = dateOutput.replace("[d]", countdown.days);
			}
			if (hasHour) {
				dateOutput = dateOutput.replace("[h]", countdown.hours);
			}
			if (hasMinute) {
				dateOutput = dateOutput.replace("[m]", countdown.minutes);
			}
			if (hasSecond) {
				dateOutput = dateOutput.replace("[s]", countdown.seconds);
			}
			if (hasMillisecond) {
				dateOutput = dateOutput.replace("[ms]", countdown.milliseconds);
			}
			if (hasTotalDays) {
				dateOutput = dateOutput.replace("[td]", countdown.totalDays);
			}
			if (hasTotalHours) {
				dateOutput = dateOutput.replace("[th]", countdown.totalHours);
			}
			if (hasTotalMinutes) {
				dateOutput = dateOutput.replace("[tm]", countdown.totalMinutes);
			}
			if (hasTotalSeconds) {
				dateOutput = dateOutput.replace("[ts]", countdown.totalSeconds);
			}
			
			//trace("dateOutput="+dateOutput)
			formattedText = dateOutput;
			return dateOutput;
			
		}
		
		// get the difference between two dates. returns milliseconds
		public function getDateDifference(targetDate:Date, todaysDate:Date):Number {
			dateDiff = targetDate.getTime() - todaysDate.getTime();
			return dateDiff;
		}
		
		// get the difference between a date and now. returns milliseconds
		public function getDateDifferenceFromNow(targetDate:Date):Number {
			dateDiff = getDateDifference(targetDate, new Date());
			return dateDiff;
		}
		
		// get the difference between two dates
		// returns super sweet object with multiple properties
		public function getDateDifferenceCountdown(targetDate:Date = null, todaysDate:Date = null, useLeadingZeros:Boolean = true):CountdownVO {
			
			if (targetDate==null) {
				targetDate = this.targetDate;
			}
			var endDate:Date = targetDate;
			if (todaysDate==null) {
				todaysDate = new Date();
			}
			dateDiff = getDateDifference(endDate, todaysDate);;
			
			if (dateDiff < 0) {
				elapsedTarget = true;
				if (countup) {
					dateDiff = Math.abs(dateDiff);
				}
			}
			
			countdown = new CountdownVO();
			LeadingZerosClass.useLeadingZeros = useLeadingZeros;
			
			// if dateDiff is less than zero than convert to integer
			// if we use the count up feature then date diff will be greater than zero
			if (dateDiff < 0) {
				countdown.days = "0";
				countdown.hours = "0";
				countdown.minutes = LeadingZerosClass.padNumber(0,2);
				countdown.seconds = LeadingZerosClass.padNumber(0,2);
				countdown.milliseconds = LeadingZerosClass.padNumber(0,3);
	
				countdown.totalHours = "0";
				countdown.totalMinutes = "0";
				countdown.totalSeconds = "0";
				countdown.totalMilliseconds = "0";
				countdown.totalDifference = "0";
				countdown.difference = 0;
				return countdown;
			}
			
			// get the difference in days
			var days:int = Math.floor(dateDiff/DAY);
			days = (days < 0) ? 0 : days;
			var remainder:Number = ((dateDiff/DAY) - Math.floor(dateDiff/DAY));
			
			// get the remaining hours
			var num:Number = remainder * 24;
			var hours:int = Math.floor(num);
			remainder = num - hours;
			num = remainder * 60;
			
			// get the remaining minutes
			var minutes:int = Math.floor(num);
			remainder = num - minutes;
			num = remainder * 60;
			
			// get the remaining seconds
			var seconds:int = Math.floor(num);
			remainder = num - seconds;
			num = remainder * 1000;
			
			// get the remaining milliseconds
			var milliseconds:int = Math.floor(num);
			
			// set the difference in days, hours, min, sec, ms
			countdown.days = String(days);
			countdown.hours = String(hours);
			countdown.minutes = LeadingZerosClass.padNumber(minutes, 2);
			countdown.seconds = LeadingZerosClass.padNumber(seconds, 2);
			countdown.milliseconds = LeadingZerosClass.padNumber(milliseconds, 3);

			// calculate the total time in different time formats 
			countdown.totalDays = String(Math.floor(dateDiff/(1000*60*60*24)));
			countdown.totalHours = String(Math.floor(dateDiff/(1000*60*60)));
			countdown.totalMinutes = String(Math.floor(dateDiff/(1000*60)))
			countdown.totalSeconds = String(Math.floor(dateDiff/(1000)));
			
			// date difference is in milliseconds
			countdown.totalDifference = String(dateDiff);
			countdown.difference = dateDiff;
			
			// return countdown object
			return countdown;
		}
		
		
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
	    public function get monthNames():Array {
			return _monthNames;
	    }
	
	    /**
		 *  
		 */
	    public function set monthNames(value:Array):void {
	        _monthNames = value;
	    }
	    
	    public function getMonthName(date:Date):String {
	    	return _monthNames[date.getMonth()];	
	    }
	    
	    public function getMonth(date:Date):String {
	    	return String(date.getMonth() + 1);
	    }
	    
	    /**
		 *  @private
		 *  Storage for the dayNames property.
		 */
	    private var _dayNames:Array = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
	
	    /**
	     *  The weekday names.
		 *  Changing this property changes the day labels
		 *  Sunday is the first day (at index 0).
	     *  The rest of the week names follow in the normal order.
		 *
		 *  @default ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"].
	     *  @helpid 3607
	     *  @tiptext The names of days of week
	     */
	    public function get dayNames():Array
	    {
	      	return _dayNames;
	    }
	
	    /**
		 * 
		 */
	    public function set dayNames(value:Array):void
	    {
	        _dayNames = value;
	    }
		
		// get two digit year from date, for example "88"
		public function getYear(date:Date):String {
			var year:String = String(date.getFullYear());
			year = year.substr(2);
			return year;
		}
		
		// get four digit year from date, for example "1988"
		public function getFullYear(date:Date):String {
			var year:String = String(date.getFullYear());
			return year;
		}
	    
	    // get the name of the day from a date - for example, "Saturday"
	    public function getDayName(date:Date):String {
	    	return _dayNames[date.getDay()];
	    }
	    
	    // get day of month from a date, for example, "July"
	    public function getDayOfMonth(date:Date):String {
	    	return String(date.getDate());
	    }

		// get "AM" or "PM" string from a date
		public function getAMPM(date:Date):String {
			var hours:Number = date.getHours()
			var ampm:String = "AM";
		    if (hours >= 12)
		    {
		        ampm = "PM"
		    }
			return ampm;
		}
		
		// get hours in standard or military time from a date, for example, "6" hours
		public function getHours(date:Date, hourFormat:String = "12"):String {
			var hours:Number = date.getHours();
			if (hourFormat=="12") {
		    	if(hours > 12) {
					hours -= 12;
		     	}
			    if (hours == 0) {
			    	hours = 12;
			    }
			    /*
			    if (useLeadingZeros && seconds < 10) {
			        secondsOut = "0" + seconds;
			    }
			    */
		    }
			return String(hours);
		}
		
		// get minutes from a date, for example, "42" minutes
		public function getMinutes(date:Date, useLeadingZeros:Boolean = true):String {
			var minutes:Number = date.getMinutes();
			var minOut:String = String(minutes);
		    if (useLeadingZeros && minutes < 10) {
		        minOut = "0" + minutes;
		    }
			return minOut;
		}
		
		// get seconds from a date, for example, "12" seconds
		public function getSeconds(date:Date, useLeadingZeros:Boolean = true):String {
			var seconds:Number = date.getSeconds();
			var secondsOut:String = String(seconds);
		    if (useLeadingZeros && seconds < 10) {
		        secondsOut = "0" + seconds;
		    }
			return secondsOut;
		}
		
		// get milliseconds from a date, for example, "120" milliseconds
		public function getMilliseconds(date:Date, useLeadingZeros:Boolean = true):String {
			var milliSeconds:Number = date.getMilliseconds();
			var milliSecondsOut:String = String(milliSeconds);
		    if (useLeadingZeros && milliSeconds < 10) {
		        milliSecondsOut = "00" + milliSeconds;
		    }
		    else if (useLeadingZeros && milliSeconds < 100) {
		        milliSecondsOut = "0" + milliSeconds;
		    }
			return milliSecondsOut;
		}
		
		// check if time is valid
		public function isValidTime(h:int = 0, m:int= 0, s:int = 0):Boolean {
    		var date:Date = new Date(0, 0, 0, h, m, s);
        	
        	return (date.getHours() == h && date.getMinutes() == m);
		}
		
		// format of time should be 9:55PM
		// returns time object with multiple useful properties
		public function getTimeFromTimeString(timeString:String, militaryTime:Boolean = false):TimeVO {
			// index 1 is hours, 2 is minutes, 3 is seconds if not null, 4 is am or pm
			var timePattern:RegExp = /^(\d?\d):(\d\d)?:?(\d\d)? ?(AM|am|PM|pm)?$/
			var results:Object = timePattern.exec(timeString);
			time = new TimeVO();
			time.date = new Date();
			time.time = timeString;
			if (results==null) { return time; }
			time.hours = results[1];
			var hours:int = results[1];
			time.minutes = results[2];
			time.seconds = (results[3]!=null) ? results[3] : 0;
			var ampm:String = (results[4]!=null) ? String(results[4]).toUpperCase() : "";
			time.ampm = ampm;
			
			// support military time here - not tested much
			if (militaryTime) {
				if (ampm=="PM" && hours <12) {
					time.hours = hours + 12;
					hours = hours + 12;
				}
				else if (ampm=="AM" && hours==12) {
					time.hours = 0;
					hours = 0;
				}
				time.militaryTime = true;
			}
			
			time.date = getDateWithNewTime(new Date(), hours, Number(time.minutes), Number(time.seconds), 0);
			
			return time;
		}

		// parse a time string and set the time on the date
		// format of time should be 9:55PM, 10:44 AM, 3:30:23PM, etc seconds optional
		public function getDateFromTimeString(date:Date, time:String):Date {
			// result index 1 is hours, 2 is minutes, 3 is seconds if not null, 4 is am or pm
			var patt:RegExp = /^(\d?\d):(\d\d)?:?(\d\d)? ?(AM|am|PM|pm)?$/
			var results:Object = patt.exec(time);
			if (results==null) { return date; }
			var hours:int = results[1];
			var minutes:int = results[2];
			var seconds:int = (results[3]!=null) ? results[3] : 0;
			var ampm:String = (results[4]!=null) ? String(results[4]) : "";
			
			if (ampm!="") {
				if (ampm.toLowerCase()=="pm" && hours <12) {
					hours = hours + 12;
				}
				else if (ampm.toLowerCase()=="am" && hours==12) {
					hours = 0;
				}
			}
			
			date = getDateWithNewTime(date, hours, minutes, seconds, 0);
			return date;
		}
		
		// get date with a clean time, for example, time is reset to 12am, "Jan 1, 2008 12:00AM" 
		public function getCleanDate(date:Date):Date {
			date.setHours(0,0,0,0);
			return date;
		}
		
		// add time to a clean date
		public function getDateWithNewTime(date:Date, hours:Number=0, minutes:Number=0, seconds:Number=0, milliseconds:Number=0):Date {
			var cleanDate:Date = getCleanDate(date);
			cleanDate = addTime(cleanDate, hours, minutes, seconds, milliseconds);
			
			return cleanDate;
		}
		
		// reset time on today 
		public function getTodayWithNewTime(time:String):Date {
			var newDate:Date = getDateFromTimeString(new Date(), time);
			
			return newDate;
		}
		
		// add time to a clean date
		public function getTomorrowWithNewTime(time:String):Date {
			var newDate:Date = getTodayWithNewTime(time);
			newDate = addTime(newDate, 24);
			
			return newDate;
		}
		
		// get date formatted in a string type we can use
		public function getFormattedDate(date:Date):String {
			// we want to return format "Jan 01 2008"
			return date.toDateString();
		}
		
		public function getMinutesFromMilliseconds(ms:Number):Number {
			var minutes:Number = ms / 1000 / 60;
			return minutes;
		}
		
		// add time, hours, minutes, seconds, milliseconds to a date
		// returns a new date object
		public function addTime(date:Date, hours:Number=0, minutes:Number=0, seconds:Number=0, milliseconds:Number=0):Date {
			var addHours:int = hours * HOUR;
			var addMinutes:int = minutes * MINUTE;
			var addSeconds:int = seconds * SECOND;
			var addMilliseconds:int = milliseconds;
			var ms:int = date.getTime() + addHours + addMinutes + addSeconds + addMilliseconds;
			date = new Date(date.setHours(hours, minutes, seconds, milliseconds));
			targetDate = date;
			return date;
		}
	}
}