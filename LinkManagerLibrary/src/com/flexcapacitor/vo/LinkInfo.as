


// this class is used to store hyperlink information
package com.flexcapacitor.vo {
	import mx.states.State;

	[Bindable]
	public class LinkInfo {


		/**
		 *
		 */
		public function LinkInfo() {

		}

		// if anchor was found
		public var anchorFound:Boolean = false;

		// anchor name
		public var anchorName:String = "";

		// anchor pending
		public var anchorPending:Boolean = false;

		// the link came from the browser 
		// for example, a user entered a new url address in the browser
		// or the user pressed the browser back or forward button
		public var browserURLChangeEvent:Boolean = false;

		// name of the current parameter - used in parameter handler
		public var currentParameterName:String = "";

		// value of the current parameter - used in parameter handler
		public var currentParameterValue:String = "";

		// fragment that has been written to the url
		public var determinedFragment:String = "";

		// tells search engines to follow
		public var follow:Boolean = true;

		// hyperlink fragment
		public var fragment:String = "";

		// does the hyperlink specify an anchor
		public var hasAnchor:Boolean = false;

		// has fragment changed
		public var hasFragmentChanged:Boolean = false;

		// does the hyperlink specify parameters
		public var hasParameters:Boolean = false;

		// does the hyperlink specify a state
		public var hasState:Boolean = false;

		// does the hyperlink have a target specified
		public var hasTarget:Boolean = false;

		// hyperlink - can be of three types. format1 is used to navigate internally through a flex app
		// format2 is used externally to bookmark or return to a given state. this is used typically when copying a link location
		// format3 are normal browser urls 
		// - format1 - "stateName#anchorName?parameter=value;parameter2=value"
		// - format2 - "?state=stateName;anchor=anchorName;parameter1=value;parameter2=value;"
		public var hyperlink:String = "";

		// hyperlink target - used to specify the type of link
		// typically you don't need to set this for internal hyperlinks
		public var hyperlinkTarget:String = "";

		// is the hyperlink an anchor (#anchorName)
		public var isAnchor:Boolean = false;

		// is anchor a keyword
		public var isAnchorKeyword:Boolean = false;

		// is home or base state (root state)
		public var isBaseState:Boolean = false;

		// is the state specified the state we are already on
		public var isCurrentState:Boolean = false;

		// is state specified the state we are already on
		public var isHybridURL:Boolean = false;

		// is the hyperlink parameters (?param1=value;param2=value;)
		public var isParameter:Boolean = false;

		// this means the url is in the format "/parameter1/parameter2/parameter3/etc"
		public var isParameterArray:Boolean = false;

		// is hyperlink a list of name value pairs ?parameterName=parameterValue;parameterName=parameterValue
		public var isParametersListURL:Boolean = false;

		// is url formatted stateName#anchor or stateName@anchor
		public var isPrettyURL:Boolean = false;

		// is the hyperlink a url (http://domain.com/page.html)
		public var isURL:Boolean = false;

		// component that generated this hyperlink event
		public var mouseTarget:*;

		// origin of hyperlink - could be internal or external
		// internal is #anchor, state#anchor, ?param=value;
		// external is a=anchor, s=state;a=anchor, param=value
		public var origin:String = "internal";

		// when available will set the page title
		public var pageTitle:String = "";

		// string of the parameters
		public var parameters:String = "";
		
		// object containing parameters (name and value pair)
		public var parametersArray:Array;

		// object containing parameters (name and value pair)
		public var parametersObject:Object = new Object();

		// state if set
		public var state:State;

		// if state was found
		public var stateFound:Boolean = false;

		// name of the state if available
		public var stateName:String = "";

		// if a state is specified but not found this is true
		public var stateSpecifiedButNotFound:Boolean = false;

		// url if available - usually the same as the hyperlink
		public var url:String = "";

		// current application vertical location
		public var verticalPosition:int = 0;
	/*
	   // clear all the values from the class
	   public function clear():void {
	   // could i just do a new LinkInfo() and clear out the values?
	   //this = new LinkInfo();
	   this.anchorFound = false;
	   this.anchorName = "";
	   this.anchorPending = false;
	   this.currentParameterName = "";
	   this.currentParameterValue = "";
	   this.determinedFragment = "";
	   this.hasAnchor = false;
	   this.hasFragmentChanged = false;
	   this.hasParameters = false;
	   this.hasState = false;
	   this.hasTarget = false;
	   this.hyperlink = "";
	   this.hyperlinkTarget = "";
	   this.isAnchor = false;
	   this.isAnchorKeyword = false;
	   this.isBaseState = false;
	   this.isCurrentState = false;
	   this.isParameter = false;
	   this.isURL = false;
	   this.mouseTarget = null;
	   this.origin = "internal";
	   this.pageTitle = "";
	   this.parameters = "";
	   this.parametersObject = {};
	   this.state = null;
	   this.stateFound = false;
	   this.stateName = "";
	   this.url = "";
	   this.verticalPosition = 0;
	 }*/
	/*public function destroy():void {
	   clear();
	   // how do we set this class to null?
	 }*/
	}
}