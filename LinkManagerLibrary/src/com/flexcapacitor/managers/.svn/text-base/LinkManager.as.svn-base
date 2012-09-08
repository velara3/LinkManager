




/**
 * These instructions and features are out of date
 * This class allows you to make your flex project linkable so you can copy and paste a link in the browser and go directly 
 * to a specific state or state in your application. It also sets the page title as you move through the pages. It also
 * runs actions on certain events.
 * 
 * REMEMBER!
 * Actions can have conditions and conditions can have actions!
 * This is the foundation of AIR (aniphoric information representation) 
 * and coding if else nested statements in an xml language
 * NOTE! The feature mentioned above is not yet implemented
 * 
 * There are 3 entry points to this class and how it interprits a hyperlink
 * - When someone enters a url into the browser address bar and hits enter, back or forward
 * - When someone clicks back or forward
 * - When someone clicks a hyperlink or hyperlink based component
 * 
 * These are a few types of supported url syntaxes
 * - internal server - which is stateName#anchorName?parameterName=parameterValue;parameterName=parameterValue;
 * - address bar url - which is http://domain.com/page.html#parameterName=parameterValue;parameterName=parameterValue;
 * - normal http url - which is http://domain.com/page.html
 * - download - fileName.zip or http://domain.com/fileName.zip
 * 
 * - 
 **/
package com.flexcapacitor.managers {
	import com.flexcapacitor.actions.DownloadTarget;
	import com.flexcapacitor.actions.GoToState;
	import com.flexcapacitor.actions.GoToURL;
	import com.flexcapacitor.actions.ScrollToAnchor;
	import com.flexcapacitor.actions.ScrollToPosition;
	import com.flexcapacitor.actions.SetFragment;
	import com.flexcapacitor.actions.SetPageTitle;
	import com.flexcapacitor.actions.Wait;
	import com.flexcapacitor.controls.Anchor;
	import com.flexcapacitor.controls.IContentLoadingComponent;
	import com.flexcapacitor.handlers.ActionHandler;
	import com.flexcapacitor.handlers.FragmentHandler;
	import com.flexcapacitor.handlers.Handler;
	import com.flexcapacitor.handlers.ParameterHandler;
	import com.flexcapacitor.handlers.StateHandler;
	import com.flexcapacitor.proxy.ParametersProxy;
	import com.flexcapacitor.utils.ArrayUtils;
	import com.flexcapacitor.utils.StateUtils;
	import com.flexcapacitor.vo.ContentLoadingItem;
	import com.flexcapacitor.vo.HistoryInfo;
	import com.flexcapacitor.vo.LinkInfo;
	import com.flexcapacitor.vo.ParameterProperty;
	import com.flexcapacitor.vo.StateOption;
	
	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.core.FlexVersion;
	import mx.core.IMXMLObject;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.managers.CursorManager;
	import mx.managers.FocusManager;
	import mx.managers.SystemManager;
	import mx.states.State;
	import mx.utils.NameUtil;
	import mx.utils.ObjectUtil;
	
	import spark.components.Scroller;
	
	
	[Event(name="handlersStart", type="mx.events.Event")]
	
	[Event(name="handlersComplete", type="mx.events.Event")]
	
	[Event(name="contentUpdateComplete", type="mx.events.Event")]
	
	public class LinkManager extends EventDispatcher implements IMXMLObject {
		
		import mx.utils.URLUtil;
		import mx.events.StateChangeEvent;
		import mx.managers.IBrowserManager;
		import mx.events.BrowserChangeEvent;
		import mx.managers.BrowserManager;
		
		
		// shows debug information in the Flex Builder debug console 
		public var debug:Boolean = false;
		
		// enters the debugger in a few key spots
		public var enterDebuggingSession:Boolean = false;
		
		// name used in the url to define an state
		[Bindable]
		public var STATE_PARAMETER_ALIAS:String = "s";
		
		// name used in the url to define an anchor
		[Bindable]
		public var ANCHOR_PARAMETER_ALIAS:String = "a";
		
		// name of the home state
		[Bindable]
		public var HOME_STATE_PARAMETER_ALIAS:String = "";
		
		// alias to the base state - default is "home"
		[Bindable]
		public var BASE_STATE_ALIAS:String = "home";
		
		// special link that will write the url fragment but not read it
		// works with the generate fragment value
		[Bindable]
		public var GENERATE:String = "_generate";
		
		// event when a hyperlink is invoked
		[Bindable]
		public var HYPERLINK_EVENT:String = "hyperlink";
		
		// default target for hyperlinks
		// known targets are _self, _blank, _state, _anchor
		[Bindable]
		public var DEFAULT_HYPERLINK_TARGET:String = "_self";
		
		// browser constant for loading a url in this browser window is "_self" (replaces current content)
		[Bindable]
		public var SELF_HYPERLINK:String = "_self";
		
		// constant for navigating to a new window is "_blank"
		[Bindable]
		public var BLANK_HYPERLINK:String = "_blank";
		
		// anchor constant is "_anchor"
		[Bindable]
		public var ANCHOR_HYPERLINK:String = "_anchor";
		
		// anchor constant is "_download"
		[Bindable]
		public var DOWNLOAD_HYPERLINK:String = "_download";
		
		// anchor constant is "_browser"
		// sends the link through to the browser via navigateToURL()
		[Bindable]
		public var BROWSER_HYPERLINK:String = "_browser";
		
		// media constant is "_media"
		[Bindable]
		public var MEDIA_HYPERLINK:String = "_media";
		
		// if you set the hyperlink target to "browser:myWindow" you will
		// launch they hyperlink in a browser window named "myWindow"
		// not implemented
		[Bindable]
		public var BROWSER_WINDOW_TARGET:String = "browser:";
		
		// constant for startUp event
		public const STARTUP:String = "startUp";
		
		// constant for required handlers event
		public const REQUIRED_HANDLERS:String = "requiredHandlers";
		
		// handlers start event
		public const HANDLERS_START:String = "handlersStart";
		
		// handlers complete event
		public const HANDLERS_COMPLETE:String = "handlersComplete";
		
		// content load and laid out event
		public const CONTENT_UPDATE_COMPLETE:String = "contentUpdateComplete";
		
		// request for general purpose use and reuse
		public var request:URLRequest = new URLRequest();
		
		// url loader for general purpose use and reuse
		public var loader:URLLoader = new URLLoader();
		
		// default value of a null parameters proxy property
		public var defaultProxyValue:String = "";
		
		// Page scroll size when using the mouse wheel - default is 25 to match the default browser page size
		[Bindable]
		public var verticalLineScrollSize:int = 25;
		
		// reference to the browser manager
		[Bindable]
		public var browserManager:IBrowserManager;
		
		// current url fragment
		[Bindable]
		public var url:String = "";
		
		// generated url fragment
		[Bindable]
		public var generatedFragmentTemplate:Object;
		
		// site / domain / project title for display in the browser
		[Bindable]
		public var projectName:String = "";
		
		// current state title for display in the browser
		[Bindable]
		public var stateTitle:String = "";
		
		private var _fullTitle:String = "";
		
		// the url fragment that has been parsed into an object
		[Bindable]
		public var fragmentObject:Object = new Object();
		
		// an internal parameters object used between states
		// ie myState?param1=10;param2=test;
		// param1 and param2 name and values are saved to this object
		// if a hyperlink doesn't have parameters you can 
		// set clearParameters to false to maintain the previous hyperlink parameters as you move between states 
		[Bindable]
		public var parametersObject:Object = new Object();
		
		// object that contains the current parameters on the url
		[Bindable]
		public var parametersList:ParametersProxy = new ParametersProxy();
		
		// name of parameters by location. for example, this url, "/article/428" could be mapped to 
		// "/state/id" on the parameters proxy object as parameters.state and parameters.id
		// and appear in the parametersArray array as parametersArray[0] and parametersArray[1]
		[Bindable]
		public var parametersMap:String = "";
		
		// array of parameters by location in the fragment. for example, this url, "/article/428" would be mapped to
		// parametersArray array and accessed as parametersArray[0] and parametersArray[1] 
		// if a parametersArrayDefinition existed with a value of "/state/id" then 
		// you could access the values on the parameters proxy via parameters.state and parameters.id
		[Bindable]
		public var parametersArray:Array = [];
		
		// object that contains the current parameters on the url
		[Bindable]
		public static var parameters:ParametersProxy = new ParametersProxy();
		
		// parametersObject is an internal object used when navigating with hyperlinks between states
		// ie myState?param1=10;param2=test;
		// param1 and param2 are properties created on this object when that hyperlink is clicked
		// if a hyperlink doesn't have parameters you can 
		// set clearParameters to false to maintain the previous hyperlink parameters as you move between states
		[Bindable]
		public var clearParameters:Boolean = true;
		
		// paramters on a state hyperlink
		// myState?param1=10;param2=test;
		// the parameters on the previous string would be "param1=10;param2=test;"
		[Bindable]
		private var parametersOld:String = "";
		
		// current state
		[Bindable]
		public var currentState:String = "";
		
		// current anchor
		[Bindable]
		public var currentAnchor:String = "";
		
		// flag to check if anchor location is pending
		[Bindable]
		public var anchorPending:Boolean = false;
		
		// show busy cursor until handlers have completed
		[Bindable]
		public var showBusyCursorDuringHandlers:Boolean = false;
		
		// show a predefined preloader until handlers have completed
		[Bindable]
		public var showPreloaderDuringHandlers:Boolean = true;
		
		// draw focus skin on clicked hyperlink
		[Bindable]
		public var enableDrawFocus:Boolean = false;
		
		// anchor to move to - deprecated
		[Bindable]
		public var anchorName:String = "";
		
		// anchor symbol
		[Bindable]
		public var anchorSymbol:String = "@";
		
		// anchor symbol
		[Bindable]
		public var anchorSeparatorSymbol:String = "#";
		
		// parameter delimiter
		public var parameterDelimiter:String = "?";
		
		// parameter name value pair delimiter
		public var nameValuePairDelimiter:String = "=";
		
		// The character that separates the name and value pairs in the String.
		// for example, in the parameters string, "parameter1=value1;parameter2=value2" 
		// the separator is the semi-colon, ";"
		[Bindable]
		public var parameterSetSeparator:String = ";";
		
		// Whether or not to decode URL-encoded characters in the String
		[Bindable]
		public var decodeURL:Boolean = true;
		
		// Whether or not to encode URL characters in the String
		// should it default to true???
		[Bindable]
		public var encodeURL:Boolean = true;
		
		// the state or the name of the state to redirect to when the 
		// state in a hyperlink or action is not found
		[Bindable]
		public var stateNotFoundState:Object;
		
		// default state if no state is specified in the application currentState property
		[Bindable]
		public var defaultState:String = "";
		
		public var isFlex3:Boolean = FlexVersion.compatibilityVersionString=="3.0.0";
		
		/**
		 * Whether or not to show the base state name in the url fragment
		 * see BASE_STATE_ALIAS
		 * */
		[Bindable]
		public var showBaseStateAliasInFragment:Boolean = isFlex3;
		
		// a property holder for application start state
		private var applicationStartState:String;
		
		private var _browserHistory:Array = new Array();
		[Bindable]
		public var browserHistory:ArrayCollection = new ArrayCollection(_browserHistory);
		
		// queue of events during startup that must finish before creation complete event handlers are called
		private var _handlersQueue:Array = new Array();
		public var handlersQueue:ArrayCollection = new ArrayCollection(_handlersQueue);
		
		// indicates if we need to update the url fragement when state change event occurs
		[Bindable]
		public var updateURLFragment:Boolean = true;
		
		public var goToState:GoToState = new GoToState();
		public var setPageTitle:SetPageTitle = new SetPageTitle();
		public var scrollToAnchor:ScrollToAnchor = new ScrollToAnchor();
		public var scrollToPosition:ScrollToPosition = new ScrollToPosition();
		public var setBrowserFragment:SetFragment = new SetFragment();
		public var waitBehavior:Wait = new Wait();
		public var downloadFile:DownloadTarget = new DownloadTarget();
		public var goToURL:GoToURL = new GoToURL();
		
		// used to download
		[Bindable]
		public var fileReference:FileReference = new FileReference();
		
		// first run
		private var firstRun:Boolean = true;
		
		/**
		 * Show pretty URL when possible
		 * 
		 * */
		public var showPrettyURL:Boolean = true;
		
		// enable google tracking
		// you must include google analytics code in the html-template/index-template.html page
		[Bindable]
		public var enableGoogleTracking:Boolean = false;
		
		// a textarea or a component with the text property
		[Bindable]
		public var debugComponent:*;
		
		// reference to a preloader you can show when busy
		[Bindable]
		public var preloader:UIComponent;
		
		[Bindable]
		public var id:String = "";
		
		// when we deliberately change the fragment we don't want to handle it in the browser url change handler
		[Bindable]
		public function set cancelBrowserURLUpdate(value:Boolean):void {
			_cancelBrowserURLUpdate = value;
		}
		public function get cancelBrowserURLUpdate():Boolean {
			return _cancelBrowserURLUpdate;
		}
		private var _cancelBrowserURLUpdate:Boolean = false;
		
		// grab the page title from the application if set and use it as the default page title if not set
		[Bindable]
		public var applicationPageTitle:String = "";
		
		// options for adding dynamic parameters to the url fragment
		[Bindable]
		public var dynamicParameters:Array = [];
		
		// options for setting options on the states
		[Bindable]
		public var stateOptions:Array = [];
		
		// options for adding anchor, state and parameter handlers
		[Bindable]
		public var handlers:Array= [];
		
		// handlers that handle content type
		[Bindable]
		public var contentTypeHandlers:Array = [];
		
		/**
		 * Handlers that run at startup (initialize) that must complete before any other handlers are run
		 * */
		[Bindable]
		public var requiredHandlers:Array = [];
		
		// default actions for handling hyperlinks
		[Bindable]
		public var defaultActions:Array = [];
		
		// main actions list including content type actions for handling hyperlinks
		// do not modify this. modify defaultActions or defaultContentTypeActions
		// actions are combined into this one dynamically
		[Bindable]
		public var actions:Array = [];
		
		// default content type actions for handling hyperlinks
		[Bindable]
		public var defaultContentTypeActions:Array = [];
		
		// content type
		private var _contentTypeActions:Array = [];
		
		// media handlers
		public var contentTypeActions:ArrayCollection = new ArrayCollection(_contentTypeActions);
		
		// default actions for handling hyperlinks
		[Bindable]
		public var defaultHandler:ActionHandler = new ActionHandler();
		
		// default actions for handling hyperlinks
		[Bindable]
		public var contentTypeHandler:ActionHandler = new ActionHandler();
		
		// handlers run add application creation complete
		[Bindable]
		public var startUpHandlers:Array = [];
		
		// indicates if startup handlers have been run
		[Bindable]
		public var ranStartUpHandlers:Boolean = false;
		
		private var _history:Array = new Array();
		
		/**
		 * Used to restore vertical scroll position on pages already visited. Used with the back and forward buttons.
		 * 
		 * */
		[Bindable]
		public var history:ArrayCollection = new ArrayCollection(_history);
		
		private var _contentLoadingItems:Array = new Array();
		
		/**
		 * Used to store items that have content that can loaded
		 * 
		 * */
		[Bindable]
		public var contentLoadingItems:ArrayCollection = new ArrayCollection(_contentLoadingItems);
		
		[Bindable]	
		public var anchorManager:AnchorManager = AnchorManager.getInstance();
		
		// timer for timing out the preloader
		public var preloaderTimer:Timer;
		
		// timeout for preloader. default is 25 seconds
		public var preloaderTimeout:int = 25000;
		
		// will set the default fragment at startup
		[Bindable]
		public var defaultFragment:String = "";
		
		// will decode query string parameters into fragment parameters at startup
		[Bindable]
		public var decodeQueryString:Boolean = true;
		
		// mode of handling hyperlinks
		// normal - all handling is done automatically by the class
		// verbose - nothing is done by the class except to get link information
		// use a fragmentHandler to listen for verbose events 
		[Bindable]
		[Inspectable(enumeration="normal,verbose")]
		public var mode:String = "normal";
		
		// When true the project name is after the page / state name
		[Bindable]
		public function set isTitleBeforeProjectName(value:Boolean):void {
			setPageTitle.isTitleBeforeProjectName = value;
		}
		
		public function get isTitleBeforeProjectName():Boolean {
			return setPageTitle.isTitleBeforeProjectName;
		}
		
		private var _anchors:Dictionary;
		
		/**
		 * List of anchor components specifically anchors
		 * returns a dictionary of anchor components
		 * */
		[Bindable(name="propertyChange")]
		public function addAnchor(anchor:InteractiveObject):void {
			
			if (_anchors==null) _anchors = new Dictionary();
			_anchors[Anchor(anchor).target] = Anchor(anchor);
			dispatchEvent(new PropertyChangeEvent("propertyChange"));
		}
		
		public function get anchors():* {
			if (_anchors==null) _anchors = new Dictionary();
			return _anchors;
		}
		
		public function removeAnchor(anchor:InteractiveObject):void {
			if (anchor in _anchors) {
				delete _anchors[anchor];
			}
		}
		
		public function getAnchor(target:InteractiveObject):InteractiveObject {
			if (target in _anchors) {
				return _anchors[target];
			}
			return null;
		}
		
		// when the link manager has been initialized
		[Bindable]
		public var created:Boolean = false;
		
		/**
		 * Fragment that is determined at startup. Can be the original URL fragment, 
		 * the defaultFragment property or decoded fragment value by enabling the decodeQueryString property 
		 * 
		 * */
		public var startupFragment:String = "";
		
		public function LinkManager(getInstanceCall:Boolean = false) {
			//traceConsole('Link Manager: constructor');
			
		}
		
		private static var _instance:LinkManager;
		private static var _created:Boolean = false;
		private var _applicationCreated:Boolean = false;
		private var _ranRequiredHandlers:Boolean = false;
		
		public static function getInstance():LinkManager {
			
			// instance exists
			if (_instance!=null) {
				return _instance;
			}
				// instance doesn't exist yet
			else {
				_instance = new LinkManager();
				return _instance;
			}
		}
		
		public function queueChange(event:CollectionEvent):void {
			//traceConsole("Link Manager: Queue Changed")
			
		}
		
		// the rest of the document may not be initialized yet
		public function initialized(document:Object, id:String):void {
			if (created) return;
			
			var currentFragment:String = "";
			
			application = document;
			this.document = document;
			
			handlersQueue.addEventListener(CollectionEvent.COLLECTION_CHANGE, queueChange);
			
			traceConsole("Link Manager: Initialized");
			
			// get the document title if it was set on the application
			applicationPageTitle = ExternalInterface.call("eval", "document.title");
			
			// set the vertical line scroll size to match the browsers (default 25)
			if (isFlex3) {
				application.verticalLineScrollSize = verticalLineScrollSize;
			}
			else {
				// no property yet
			}
			
			// figure out if there is a start state defined on the application and save it here
			applicationStartState = (document.currentState=="" || document.currentState==null) ? "" : document.currentState;
			
			// store the page title to the current application state
			stateTitle = applicationStartState;
			
			// listen for application url changes and browser url changes
			browserManager = BrowserManager.getInstance();
			browserManager.addEventListener(BrowserChangeEvent.APPLICATION_URL_CHANGE, applicationURLChange, false, 0, true);
			browserManager.addEventListener(BrowserChangeEvent.BROWSER_URL_CHANGE, browserURLChange, false, 0, true);
			
			// set default fragment if set
			if (defaultFragment!="") {
				cancelBrowserURLUpdate = true;
				url = defaultFragment;
			}
			
			// decode query string
			// TODO: should we redirect to a page without the query string (only the fragment string)
			// for a flash only page? this is aimed at people who have an alternative html content site
			// if we do it it would break debugging connection but we could work around it
			// check for localhost or ?debug=true...
			// UPDATE is this the application parameters Object???
			if (decodeQueryString) {
				var currentURL:String = ExternalInterface.call("eval", "document.location.href");
				var URLQuery:String = decodeURLQueryString(currentURL);
				if (URLQuery!= null && URLQuery!="debug=true" && URLQuery!="") {
					url = URLQuery;
				}
			}
			
			// BUG - init() doesn't seem to be setting the fragment
			// so we set the fragment a few lines down
			//browserManager.init("", fullTitle);
			browserManager.init();
			
			// listen to the state change event on the application
			document.addEventListener(StateChangeEvent.CURRENT_STATE_CHANGE, stateChange, false, 0, true);
			
			// add event listener for application initialize and creation complete
			document.addEventListener(FlexEvent.INITIALIZE, applicationInitialized, false, 0, true);
			document.addEventListener(FlexEvent.APPLICATION_COMPLETE, applicationComplete, false, 0, true);
			
			_instance = this;
			
			// get fragment - if the url has a fragment already (for example, a bookmark)
			currentFragment = browserManager.fragment;
			
			// setup default actions
			setupDefaultActions();
			
			// setup default actions
			setupDefaultContentTypeActions();
			
			// combine them into one super actions array
			actions = getDynamicActionsArray();
			
			// if the current fragment is blank and the defaults are not blank then set it now
			if (currentFragment=="" && url!="") {
				cancelBrowserURLUpdate = true;
				browserManager.setFragment(url);
			}
				
			// otherwise if we want to show the base state name in the fragment
			// then do that here
			else if (isFlex3 && currentFragment=="" && url=="" && showBaseStateAliasInFragment) {
				cancelBrowserURLUpdate = true;
				browserManager.setFragment(BASE_STATE_ALIAS);
			}
			
			else if (currentFragment=="" && url=="" && applicationStartState!="") {
				cancelBrowserURLUpdate = true;
				browserManager.setFragment(applicationStartState);
			}
			
			startupFragment = browserManager.fragment;
			
			// run initialized handlers
			var linkInfo:LinkInfo = getLinkInfo(startupFragment);
			parametersObject = linkInfo.parametersObject;
			parametersList.update();
			parameters.update();
			
			created = true;
		}
		
		private function applicationInitialized(event:Event):void {
			
			document.removeEventListener(FlexEvent.INITIALIZE, applicationInitialized);
			
			if (requiredHandlers.length>0) {
				runRequiredHandlers();
			}
			else {
				_ranRequiredHandlers = true;
			}
		}
		
		public function runRequiredHandlers():void {
			//traceConsole("Link Manager: Application Initialized");
			browserManager = BrowserManager.getInstance();
			var browserFragment:String = browserManager.fragment;
			
			// run initialized handlers - runAfterStateChange
			var linkInfo:LinkInfo = getLinkInfo(startupFragment);
			parametersObject = linkInfo.parametersObject;
			
			traceConsole("Link Manager: Running Required Handlers");
			addEventListener(HANDLERS_COMPLETE, requiredHandlersComplete);
			runHandlers(requiredHandlers, linkInfo, REQUIRED_HANDLERS);
			
			if (handlersQueue.length==0) {
				removeEventListener(HANDLERS_COMPLETE, requiredHandlersComplete);
				_ranRequiredHandlers = true;
			}
			
		}
		
		private function applicationComplete(event:Event):void {
			// traceConsole("Link Manager: Application creationComplete");
			document.removeEventListener(FlexEvent.APPLICATION_COMPLETE, applicationComplete);
			
			_applicationCreated = true;
			
			// we wait for the prerequisite handlers to run
			if (_ranRequiredHandlers) {
				addEventListener(HANDLERS_COMPLETE, handlersComplete);
				runStartUpHandlers();
			}
			
			// if we are waiting for the handlers to finish we can check the handlers completed event
		}
		
		public function runStartUpHandlers():void {
			// run regular handlers that have runAtStartup set to true
			traceConsole("Link Manager: Running normal handlers at startup");
			
			var linkInfo:LinkInfo = getLinkInfo(startupFragment);
			parametersObject = linkInfo.parametersObject;
			
			ranStartUpHandlers = true;
			runHandlers(handlers, linkInfo, STARTUP);
			
		}
		
		public function requiredHandlersComplete(event:Event):void {
			traceConsole("Link Manager: Required Handlers Complete");
			
			removeEventListener(HANDLERS_COMPLETE, requiredHandlersComplete);
			
			// if the application has been created and we haven't run start up handlers yet
			if (_applicationCreated && !ranStartUpHandlers) {
				
				var linkInfo:LinkInfo = getLinkInfo(startupFragment);
				parametersObject = linkInfo.parametersObject;
				
				traceConsole("Link Manager: Running normal handlers at startup");
				runHandlers(handlers, linkInfo, STARTUP);
				ranStartUpHandlers = true;
			}
		}
		
		// when a handler finishes running it's actions we dispatch this event
		// when all the handlers have dispatched their actionsComplete event
		// we dispatch the handlersComplete event
		public function handlerActionsComplete(event:Event):void {
			
			if (event.currentTarget.hasOwnProperty("name") && event.currentTarget.name!="") {
				traceConsole("Link Manager: Handler " + event.currentTarget.name + " Actions Completed");
			}
			else {
				traceConsole("Link Manager: Handler Actions Completed");
			}
			
			// remove handler if it's in a queue
			var itemExists:int = handlersQueue.getItemIndex(event.currentTarget);
			
			removeEventListener(Handler.ACTIONS_COMPLETE, handlerActionsComplete);
			
			// if there is a queue then remove the item
			// if it's the last item then dispatch a handlers complete event
			if (itemExists!=-1) {
				handlersQueue.removeItemAt(itemExists);
				
				if (!ranStartUpHandlers && handlersQueue.length==0) {
					traceConsole("Link Manager: Required Handlers Complete");
					
					ranStartUpHandlers = true;
					removeEventListener(HANDLERS_COMPLETE, requiredHandlersComplete);
					dispatchEvent(new Event(HANDLERS_COMPLETE));
					hidePreloaders();
				}
				else if (ranStartUpHandlers && handlersQueue.length==0) {
					dispatchEvent(new Event(HANDLERS_COMPLETE));
					hidePreloaders();
				}
				else {
					// we don't know what happened
					hidePreloaders();
				}
			}
			else if (ranStartUpHandlers && handlersQueue.length==0) {
				dispatchEvent(new Event(HANDLERS_COMPLETE));
				hidePreloaders();
			}
			else {
				// we don't know what happened
				hidePreloaders();
			}
		}
		
		public function handlersComplete(event:Event):void {
			traceConsole("Link Manager: Handlers Complete");
			
			hidePreloaders();
			
		}
		
		// handlers have a ranOnce flag that is used to prevent a hyperlink click from
		// calling a state handler more than once per state change. 
		// there is a property called runOnEveryClick that you can set to change this behavior
		// this function resets the ranOnce property to false when changing states 
		public function resetHandlers():void {
			
			for each (var handler:Handler in handlers) {
				if (handler.runOnEveryClick) {
					handler.ranOnce = false;
				}
			}
		}
		
		// hmmm 
		// run through all the handlers and if there is a match based on conditions described inside
		// then run the actions associated with the handler
		public function runHandlers(handlers:Array, linkInfo:LinkInfo, event:String = ""):void {
			var len:uint = handlers.length;
			var destinationStateName:String = (linkInfo.stateName) ? linkInfo.stateName : "";
			var currentHandlers:Array = handlers;
			var ranDefaultActions:Boolean = false;
			var parameterFound:Boolean = false;
			var parameterCount:int = 0;
			var isStartUp:Boolean = event==STARTUP;
			var isPrerequisite:Boolean = event==REQUIRED_HANDLERS;
			var value:Object = "";
			var name:Object;
			var dispatchedEvent:Boolean = false;
			var matchFound:Boolean = false;
			var handlerParametersObject:Object;
			var description:String;
			parametersObject = linkInfo.parametersObject;
			
			if (isPrerequisite) {
				traceConsole("Link Manager: Required Handlers Start");
			}
			else {
				traceConsole("Link Manager: Handlers Start");
			}
			
			dispatchEvent(new Event(HANDLERS_START));
			
			// show busy cursor
			showPreloaders();
			
			// clear handlers queue
			handlersQueue.removeAll();
			
			
			// run through handlers and see if we need to do anything
			for each (var handler:Handler in currentHandlers) {
				parameterCount = 0;
				matchFound = false;
				
				// get handler description
				if (handler.value!="" && handler.value!=null) {
					description = handler.value;
				}
				else if (handler.hasOwnProperty("pattern") && Object(handler).pattern) {
					description = Object(handler).pattern;
				}
				
				// check if handler is enabled
				if (handler.debugHandlerConditions) {
					traceConsole("\t\t - Entering debugger... press the Step Into button...");
					enterDebugger();
				}
				
				// check if handler is enabled
				if (!handler.enabled) continue;
				
				// if running at startup
				if (isStartUp && !handler.runAtStartup) continue;
				
				// set link info
				handler.linkInfo = linkInfo;
				
				// set default handlers
				handler.defaultActions = actions;
				
				// set parameters proxy on handler
				// if parameters map is set on handler then it overrides the link manager 
				if (FragmentHandler(handler).parametersMap!=null) {
					handlerParametersObject = getParametersArrayObject(linkInfo.parametersArray, FragmentHandler(handler).parametersMap);
					handler.parameters.update(handlerParametersObject);
				}
				else {
					handler.parameters = parametersList;
				}
				
				// TODO:we might be able to simply the code below
				
				// ACTION HANDLER //
				if (handler is ActionHandler) {
					
					// check if this should be run every time the link is clicked
					// regardless if we are on the same state or not 
					//if (currentState == linkInfo.stateName && !handler.runOnEveryClick && handler.ranOnce) {
					if (!handler.runOnEveryClick && handler.ranOnce) {
						continue;
					}
					
					// handle conditions
					if (handler.validate()) {
						handler.run();
						ranDefaultActions = true;
					}
					
					continue;
				}
				
				// FRAGMENT HANDLER //
				if (handler is FragmentHandler) {
					
					// check if this should be run every time the link is clicked
					// regardless if we are on the same state or not 
					//if (currentState == linkInfo.stateName && !handler.runOnEveryClick && handler.ranOnce) {
					if (!handler.runOnEveryClick && handler.ranOnce) {
						continue;
					}
					
					// handle conditions
					if (handler.validate()) {
						
						value = linkInfo.fragment;
						
						// FIND OUT WHAT COULD EXCLUDE THIS HANDLER FROM RUNNING
						// if they set the equals parameter check to see if we match
						// if it doesn't match throw it out
						if (FragmentHandler(handler).value!="" 
							&& FragmentHandler(handler).value != value
							&& FragmentHandler(handler).pattern=="") {
							continue;
						}
						
						//  if they set the isNotBlank make sure it's not blank and then call the function
						if (FragmentHandler(handler).isNotBlank && 
							value=="" &&
							value==null &&
							value=="null") {
							continue;
						}
						
						// check if they are looking for blank parameter in the handler
						if (FragmentHandler(handler).isBlank) {
							
							// check if its equal to something or nothing
							if (value!="" && value!=null && value!="null") {
								continue; // equal to something - don't run handler
							}
						}
						
						// find match
						if (FragmentHandler(handler).value!="" && FragmentHandler(handler).value!=null) {
							if (FragmentHandler(handler).caseSensitive && FragmentHandler(handler).value == value) {
								matchFound = true;
							}
							else if (FragmentHandler(handler).value.toLowerCase() == value.toLowerCase()) {
								matchFound = true;
							}
						}
						else if (FragmentHandler(handler).pattern) {
							
							// use a regexp to find a match
							if (value is RegExp && String(value).match(FragmentHandler(handler).pattern)) {
								matchFound = true;
							}
							
							// create a simple string pattern to find a match using "*" and "_" as wildcard
							else if (String(FragmentHandler(handler).pattern).indexOf("_")!=-1 
								|| String(FragmentHandler(handler).pattern).indexOf("*")!=-1) {
								// create reg exp pattern out of string
								var newRegExpValue:RegExp = new RegExp(String(FragmentHandler(handler).pattern).replace(/[_|\*]/g,"(.*)"));
								if (String(value).match(newRegExpValue)) {
									matchFound = true;
								}
							}
						}
						
						// if fragment matches then run through the conditions
						if (matchFound) {
							//handler.value = value; handler can look in the linkInfo.fragment 
							handler.run();
							ranDefaultActions = true;
						}
					}
					
					continue;
				}
				
				// PARAMETER HANDLER //
				// if a handler is set to search for a parameter we run this code
				if (handler is ParameterHandler) {
					
					// check if this should be run every time the link is clicked
					// regardless if we are on the same state or not 
					//if (currentState == linkInfo.stateName && !handler.runOnEveryClick && handler.ranOnce) {
					if (!handler.runOnEveryClick && handler.ranOnce) {
						continue;
					}
					
					// handle conditions
					if (!handler.validate()) {
						continue;
					}
					
					// loop through all the parameters and see if we find the one specified
					for (name in parametersObject) {
						parameterCount++;
						
						value = parametersObject[name];
						parameterFound = false;
						
						// find match
						if (ParameterHandler(handler).caseSensitive && ParameterHandler(handler).parameter == name) {
							parameterFound = true;
						}
						else if (ParameterHandler(handler).parameter.toLowerCase() == name.toLowerCase()) {
							parameterFound = true;
						}
						
						// if parameter is found then run through the conditions
						if (parameterFound) {
							
							// FIND OUT WHAT COULD EXCLUDE THIS HANDLER FROM RUNNING
							// check the state
							if (!isHandlerInState(handler, destinationStateName)) {
								break;
							}
							
							// if they set the equals parameter check to see if we match
							if (ParameterHandler(handler).equals!="" && ParameterHandler(handler).equals != value) {
								break;
							}
							
							//  if they set the isNotBlank make sure it's not blank and then call the function
							if (ParameterHandler(handler).isNotBlank && 
								value=="" &&
								value==null &&
								value=="null") {
								break;
							}
							
							// check if they set the equals parameter in the handler
							if (ParameterHandler(handler).isBlank) {
								
								// check if its equal to something or nothing
								if (value!="" && value!=null && value!="null") {
									break; // equal to something - don't run handler
								}
							}
							
							handler.value = String(value);
							handler.run();
							ranDefaultActions = true;
							
						}
						
					}
					
					// handle when there are no parameters (blank fragment)
					if (parameterCount==0 && handler.hasNoParameters) {
						handler.value = "";
						handler.run();
						ranDefaultActions = true;
					}
					
					continue;
				}
				
				// STATE HANDLER //
				// if a handler is set to respond to a state change we run this code
				if (handler is StateHandler) {
					
					// check the state
					// if the handler doesn't run on the state we are going to then exit
					if (isHandlerInState(handler, destinationStateName)) {
						
						// check if this should be run every time the link is clicked
						// regardless if we are on the same state or not 
						//if (currentState == linkInfo.stateName && !handler.runOnEveryClick && handler.ranOnce) {
						if (!handler.runOnEveryClick && handler.ranOnce) {
							continue;
						}
						
						// handle conditions
						if (!handler.validate()) {
							continue;
						}
						
						// if we have a parameter check it matches our conditions
						if (StateHandler(handler).parameter!="") {
							
							// loop through all the parameters and see if we find the one specified
							for (name in parametersObject) {
								parameterCount++;
								value = parametersObject[name];
								
								// find match
								if (StateHandler(handler).caseSensitive && StateHandler(handler).parameter == name) {
									parameterFound = true;
								}
								else if (StateHandler(handler).parameter.toLowerCase() == name.toLowerCase()) {
									parameterFound = true;
								}
								
								// if parameter is found then run through the conditions
								if (parameterFound) {
									
									// FIND OUT WHAT COULD EXCLUDE THIS HANDLER FROM RUNNING
									// if they set the equals parameter check to see if we match
									// if it doesn't match throw it out
									if (StateHandler(handler).equals!="" && StateHandler(handler).equals != value) {
										break;
									}
									
									//  if they set the isNotBlank make sure it's not blank and then call the function
									if (StateHandler(handler).isNotBlank && 
										value=="" &&
										value==null &&
										value=="null") {
										break;
									}
									
									// check if they are looking for blank parameter in the handler
									if (StateHandler(handler).isBlank) {
										
										// check if its equal to something or nothing
										if (value!="" && value!=null && value!="null") {
											break; // equal to something - don't run handler
										}
									}
									
									handler.value = String(value);
									handler.run();
									ranDefaultActions = true;
									
								}
								
							}
						}
							
						// no parameter specified - run handler
						else {
							handler.value = "";
							handler.run();
							ranDefaultActions = true;
						}
					}
					
					continue;
				}
			}
			
			// NOTE: default actions are set at the top of the method
			// no handlers were run 
			// run the default actions
			if (!ranDefaultActions && !isStartUp) {
				defaultHandler.debug = debug;
				defaultHandler.debugHandlerConditions = enterDebuggingSession;
				defaultHandler.actions = actions;
				defaultHandler.linkInfo = linkInfo;
				defaultHandler.scrollToTop = scrollToTopOnStateChange;
				defaultHandler.run();
			}
			else if (!ranDefaultActions && isStartUp) {
				defaultHandler.debug = debug;
				defaultHandler.debugHandlerConditions = enterDebuggingSession;
				defaultHandler.actions = actions;
				defaultHandler.linkInfo = linkInfo;
				defaultHandler.scrollToTop = scrollToTopOnStateChange;
				defaultHandler.run();
			}
			
			// we should dispatch a handlerComplete event 
			// but we don't do it here unless there are no handlers in the queue
			if (handlersQueue.length==0) {
				dispatchEvent(new Event(HANDLERS_COMPLETE));
				hidePreloaders();
			}
			
		}
		
		private function preloaderTimeoutComplete(event:TimerEvent):void {
			hidePreloaders();
		}
		
		public function showPreloaders():void {
			
			if (showBusyCursorDuringHandlers) {
				CursorManager.setBusyCursor();
			}
			if (showPreloaderDuringHandlers) {
				if (preloader!=null) {
					preloader.visible = true;
				}
			}
			
			if (showBusyCursorDuringHandlers || showPreloaderDuringHandlers) {
				if (preloaderTimer==null) {
					preloaderTimer = new Timer(preloaderTimeout);
					preloaderTimer.addEventListener(TimerEvent.TIMER_COMPLETE, preloaderTimeoutComplete, false, 0, true);
				}
				else {
					preloaderTimer.stop();
					preloaderTimer.reset();
				}
				preloaderTimer.start();
			}
			
		}
		
		public function hidePreloaders():void {
			
			if (showBusyCursorDuringHandlers) {
				CursorManager.removeBusyCursor();
			}
			if (showPreloaderDuringHandlers) {
				if (preloader!=null) {
					preloader.visible = false;
				}
			}
			
			if (preloaderTimer!=null) {
				preloaderTimer.stop();
				preloaderTimer.reset();
			}
			
		}
		
		// this is called when the application changes the url in the browser
		// we don't really do much here because we, as the application, are making the calls
		private function applicationURLChange(event:BrowserChangeEvent):void {
			//trace("Link Manager: Previous url "+ event.lastURL); // Previous URL
			traceConsole("Link Manager: New URL \"" + event.url + "\""); // Current URL in the browser
			//currentState = "";
		}
		
		// when someone enters a url in the browser this event is called
		// we parse it or READ IT and move to the correct state
		// TODO: This needs to be refactored and cleaned up
		[Event("browserURLChange")]
		private function browserURLChange(event:BrowserChangeEvent):void {
			
			// not sure but on some browsers when you set the fragment to "" it triggers a false urlEntered event 
			// setting this flag prevents an endless loop
			if (cancelBrowserURLUpdate) {
				cancelBrowserURLUpdate = false;
				return;
			}
			
			traceConsole("Link Manager: The URL changed through either back, forward or address bar change. ");
			
			traceConsole("Link Manager: Hyperlink \"" + hyperlink + "\"");
			
			
			// get the hyperlink
			var linkInfo:LinkInfo = getLinkInfo(fragment);
			
			// we have to set this so that the url is not updated in the browser
			linkInfo.browserURLChangeEvent = true;
			
			// get previous fragment
			lastURL = event.lastURL;
			
			// get fragment
			var fragment:String = getFragment(lastURL);
			
			// add to history
			addToHistory(true);
			
			// run handlers
			runHandlers(handlers, linkInfo);
			parametersList.update();
			parameters.update();
			
		}
		
		// TODO: Determine if we want to automatically determine the URL
		// when the user goes to a new state manually via currentState="somestate"
		// we might want to update the url in the browser
		private function stateChange(event:StateChangeEvent):void {
			
			// if we are manually moving to a state we don't want to update the url
			if (cancelBrowserURLUpdate) {
				cancelBrowserURLUpdate = false;
				return;
			}
			
			// disable for now
			return;
			
			// We will need to determine the fragment
			// when we go to a new state on the application then we update the url
			
			//traceConsole('Link Manager: state change event');
			var linkInfo:LinkInfo = getLinkInfo();
			
			// we have to set this so that the url is not updated in the browser
			//linkInfo.browserURLChangeEvent = true;
			
			// run handlers
			runHandlers(handlers, linkInfo);
			
			// DISABLED
			return;
			
		}
		
		// manual method to set the hyperlink
		[Bindable]
		[Inspectable(category="General")]
		public function set hyperlink(value:String):void {
			handleHyperlink(value);
		}
		
		public function get hyperlink():String {
			return getFragment();
		}
		
		private var _targets:Dictionary;
		private var _targetReferences:Array;
		/**
		 * Array of components or display objects that have hyperlink behavior
		 * assigned to them. 
		 * -- Not working at this time --
		 * */
		[Bindable]
		[Inspectable(category="General")]
		public function set targets(value:Array):void {
			if (_targets==null) {
				_targets = new Dictionary();
			}
			
			_targetReferences = value;
			for each (var target:InteractiveObject in _targets) {
				if (target) {
					target.addEventListener(MouseEvent.CLICK, targetsHandler, false, 0, true);
					_targets[target] = NameUtil.displayObjectToString(target);
				}
			}
		}
		
		public function get targets():Array {
			var targets:Array;
			for each (var target:InteractiveObject in _targets) {
				targets.push(target);
			}
			return targets;
		}
		
		public function targetsHandler(event:MouseEvent):void {
			
		}
		
		// get or set url fragment
		// when setting we pass to the handleHyperlink method that in turn runs any handlers
		[Bindable]
		public function set fragment(value:String):void {
			handleHyperlink(value);
		}
		
		public function get fragment():String {
			return getFragment();
		}
		
		// method to manually set the hyperlink
		public function setHyperlink(hyperlink:String = "", hyperlinkTarget:String = "", mouseTarget:* = null):void {
			handleHyperlink(hyperlink, hyperlinkTarget, mouseTarget);
		}
		
		// method to manually set the hyperlink to the default fragment
		public function setHyperlinkToDefault():void {
			setHyperlink(defaultFragment);
		}
		
		// method to manually set the hyperlink to the default fragment
		public function setHyperlinkToGenerated():void {
			setHyperlink(GENERATE);
		}
		
		// handle when a link is clicked
		// check first if state exists and then navigate to it
		// if state doesn't exist go follow link using hyperlinkTarget
		// if hyperlinkTarget doesn't exist then open in current window
		// _home is a keyword for the home state
		
		// we should consolodate this into internal, url and external links
		// TODO: Refactor this to use the linkInfo properties
		public function handleHyperlink(hyperlink:String = "", hyperlinkTarget:String = "", mouseTarget:* = null, origin:String = "internal"):void {
			
			if (hyperlink.toLowerCase()==GENERATE.toLowerCase()) {
				if (generatedFragmentTemplate!=null) {
					var isFunction:Boolean = (generatedFragmentTemplate is Function);
					if (isFunction) {
						hyperlink = (generatedFragmentTemplate as Function).call();
					}
					else {
						hyperlink = String(generatedFragmentTemplate);
					}
				}
				else {
					hyperlink = defaultFragment;
				}
			}
			
			// draw focus around mouse target
			if (mouseTarget) {
				if (Object(mouseTarget).hasOwnProperty("drawFocus")) {
					if (enableDrawFocus) {
						Object(mouseTarget).drawFocus(true);
					}
				}
			}
			
			if (hyperlink=="") {
				traceConsole("Link Manager: Hyperlink is not set");
				return;
			}
			
			if (hyperlinkTarget==null) {
				hyperlinkTarget = "";
			}
			
			var currentFragment:String = getFragment();
			var linkInfo:LinkInfo = getLinkInfo(hyperlink, hyperlinkTarget, mouseTarget, origin);
			
			dispatchEvent(new Event(HYPERLINK_EVENT));
			
			// add to history
			addToHistory();
			
			// we allow a user to interupt and change the location they are on
			if (linkInfo.isAnchor) {
				// clear content loading queue - used waiting until everything is loaded 
				// before moving to an anchor
				clearContentLoadingQueue();
				
				// stop loading a page / state when a new one is requested
				cancelServiceCalls();
			}
			
			if (linkInfo.hasTarget) {
				runHandlers(contentTypeHandlers, linkInfo);
				return;
			}
			
			if (mode=="normal") {
				traceConsole("Link Manager: Hyperlink \"" + hyperlink + "\"");
				runHandlers(handlers, linkInfo);
			}
			else if (mode=="verbose") {
				traceConsole("Link Manager: Hyperlink (verbose) " + hyperlink);
				runHandlers(handlers, linkInfo);
			}
			
			// let's just break out of here from now on
			return;
			
			// WE SHOULD BE ABLE TO USE THE LINK INFO OBJECT INSTEAD OF HALF THIS CODE
			var desiredState:State;
			var stateName:String = "";
			var stateFound:Boolean = false;
			var anchor:String = "";
			var isHomeState:Boolean = (hyperlink.indexOf(BASE_STATE_ALIAS)==0);
			var isAnchor:Boolean = (hyperlink.indexOf(anchorSymbol)==0);
			var isParameters:Boolean = (hyperlink.indexOf(parameterDelimiter)==0);
			var isURL:Boolean = (hyperlink.indexOf("http://")==0);
			var questionIndex:int = hyperlink.indexOf(parameterDelimiter);
			var anchorIndex:int = hyperlink.indexOf(anchorSymbol);
			var hasAnchor:Boolean = (hyperlink.indexOf(anchorSymbol)!=-1);
			var hasParameter:Boolean = (hyperlink.indexOf(parameterDelimiter)!=-1);
			var nameBeforeAnchor:String = (hasAnchor) ? hyperlink.split(anchorSymbol)[0] : "";
			var nameBeforeParameters:String = (hasParameter) ? hyperlink.split(parameterDelimiter)[0] : "";
			var oldParameters:String = parameters;
			var oldParametersObject:Object = parametersObject;
			var newParameters:String = (hasParameter) ? hyperlink.split(parameterDelimiter)[1] : "";
			var linkClickEvent:FlexEvent = new FlexEvent('linkClickEvent');
			var request:URLRequest; 
			var stateEndIndex:uint = 0;
			var stateFoundBeforeAnchor:Boolean = false;
			var stateFoundBeforeParameters:Boolean = false;
			var stateNotFoundStateFound:Boolean = false;
			
			/*	    	// state, anchor and parameters
			// for example, myState#myAnchor?myParameter=1;myParameter2=test;
			// parameters should always be at the end - we need to error check for that
			anchor = (hasParameter && hasAnchor && !isAnchor) ? nameBeforeParameters.split(anchorSymbol)[1] : anchor;
			
			// state and anchor
			// for example, myState#myAnchor
			anchor = (hasAnchor && !isAnchor && !hasParameter) ? String(hyperlink.split(anchorSymbol)[1]) : anchor;
			
			// anchor and parameters
			// for example, #myAnchor?myParameter=1;
			anchor = (isAnchor && hasParameter) ? String(hyperlink.split(parameterDelimiter)[0]).split(anchorSymbol)[1] : anchor;
			newParameters = (isAnchor && hasParameter) ? hyperlink.split(parameterDelimiter)[1] : newParameters;
			// remove semicolon at the end of the line
			newParameters = (newParameters.lastIndexOf(";")==newParameters.length-1) ? newParameters.substr(0, newParameters.length-1) : newParameters;
			
			// only anchor
			// #myAnchor
			anchor = (isAnchor && !hasParameter) ? hyperlink.split(anchorSymbol)[1] : anchor;
			*/	    	
			/*	    	// find the stateName
			if (true) {
			if (hasParameter || hasAnchor) {
			stateFoundBeforeAnchor = stateExists(nameBeforeAnchor);
			stateFoundBeforeParameters = stateExists(nameBeforeParameters);
			
			if (stateFoundBeforeAnchor) {
			stateName = nameBeforeAnchor;
			stateFound = true;
			//desiredState = findState(nameBeforeAnchor);
			}
			else if (stateFoundBeforeParameters) {
			stateName = nameBeforeParameters;
			stateFound = true;
			//desiredState = findState(nameBeforeQuestion);
			}
			}
			else {
			stateFound = stateExists(hyperlink);
			
			if (stateFound) {
			stateName = hyperlink;
			}
			else {
			traceConsole("Link Manager: State in hyperlink was not found, '" +hyperlink+ "'");
			
			// TODO: We should dispatch an event here!!!
			stateNotFoundStateFound = stateExists(stateNotFoundState);
			
			// TODO: We should dispatch an event here!!!
			// TODO: We should navigate to the not found state - testing
			if (stateNotFoundStateFound) {
			if (!isCurrentState(stateNotFoundState)) {
			setState(stateNotFoundState);
			}
			else {
			if (anchorPending) {
			anchorManager.addAnchorWatch(anchor, getCurrentState());
			}
			else {
			anchorManager.scrollToTop();
			}
			}
			}
			}
			}
			}
			
			// set parameters object if state is found
			parametersObject = (newParameters!="") ? URLUtil.stringToObject(newParameters, separator, decodeURL) : (clearParameters) ? {} : parametersObject;
			*/
			// HYPERLINK IS A STATE
			if (hyperlinkTarget==STATE_HYPERLINK) {
				
				// check if state exists and then move to it
				if (stateFound) {
					// set class level variables so that state change event handles moving to the anchor
					anchorName = anchor;
					parameters = (!clearParameters && oldParameters) ? oldParameters : newParameters;
					parametersObject = (!clearParameters && oldParametersObject) ? oldParametersObject : parametersObject;
					
					anchorPending = (hasAnchor) ? true : false;
					
					if (!isCurrentState(stateName)) {
						setState(stateName);
					}
					else {
						if (anchorPending) {
							anchorManager.addAnchorWatch(anchor, getCurrentState());
						}
						else {
							anchorManager.scrollToTop();
						}
					}
					
				}
				else {
					traceConsole("Link Manager: State in hyperlink was not found, '" +hyperlink+ "'");
					stateNotFoundStateFound = stateExists(String(stateNotFoundState));
					
					// TODO: We should dispatch an event here!!!
					// TODO: We should navigate to the not found state - testing
					if (stateNotFoundStateFound) {
						
						if (!isCurrentState(String(stateNotFoundState))) {
							// don't update the URL so they can see what they entered
							cancelBrowserURLUpdate = true;
							setState(String(stateNotFoundState));
						}
						else {
							if (anchorPending) {
								anchorManager.addAnchorWatch(anchor, getCurrentState());
							}
							else {
								anchorManager.scrollToTop();
							}
						}
					}
				}
			}
				
				// HYPERLINK TARGET is ANCHOR 
				// try and guess the target of the hyperlink
			else if (hyperlinkTarget==ANCHOR_HYPERLINK) {
				anchorPending = true;
				anchorName = anchor;
				anchorManager.addAnchorWatch(anchor, getCurrentState());
			}
				
				// HYPERLINK TARGET is DOWNLOAD 
			else if (hyperlinkTarget==DOWNLOAD_HYPERLINK) {
				request = new URLRequest(hyperlink);
				if (useBrowserDownloadDialog) {
					navigateToURL(request);
				}
				else {
					fileReference.download(request);
				}
			}
				
				// HYPERLINK TARGET is BROWSER 
			else if (hyperlinkTarget==BROWSER_HYPERLINK) {
				request = new URLRequest(hyperlink);
				navigateToURL(request);
			}
				
				// HYPERLINK TARGET is CURRENT or BLANK or named BROWSER WINDOW 
				// a named browser window could also be a frame
			else if (hyperlinkTarget==SELF_HYPERLINK || hyperlinkTarget==BLANK_HYPERLINK || hyperlinkTarget.length>0) {
				
				request = new URLRequest(hyperlink);
				navigateToURL(request, hyperlinkTarget);
			}
				
				// HYPERLINK TARGET is UNDEFINED 
				// try and guess the target of the monkeylink
			else if (hyperlinkTarget=="") {
				stateFound = linkInfo.stateFound;
				stateName = linkInfo.stateName;
				
				anchorName = linkInfo.anchorName;
				anchorPending = linkInfo.anchorPending;
				
				isAnchor = linkInfo.isAnchor;
				isParameters = linkInfo.isParameter;
				isURL = linkInfo.isURL;
				
				parameters = linkInfo.parameters; // (!clearParameters && oldParameters) ? oldParameters : newParameters;
				parametersObject = linkInfo.parametersObject; // (!clearParameters && oldParametersObject) ? oldParametersObject : parametersObject;
				
				
				// HYPERLINK IS STATE //
				if (stateFound) {
					
					if (stateName != currentState) {
						resetHandlers();
					}
					runHandlers(handlers, linkInfo, true);
					setState(stateName);
					runHandlers(handlers, linkInfo);
				}
					
					// HYPERLINK IS ANCHOR //
				else if (isAnchor) {
					anchorManager.addAnchorWatch(anchor, getCurrentState());
					runHandlers(handlers, linkInfo);
				}
					
					// HYPERLINK IS PARAMETERS //
				else if (isParameters) {
					setState(getCurrentState(isFlex3));
					runHandlers(handlers, linkInfo);
				}
					
					// HYPERLINK IS URL
				else if (isURL) {
					request = new URLRequest(hyperlink);
					navigateToURL(request, DEFAULT_HYPERLINK_TARGET);
				}
					
					// HYPERLINK TYPE IS NOT FOUND
				else {
					if (linkInfo.stateSpecifiedButNotFound) {
						// TODO: redirect to state not found state
						
					}
					else  {
						// navigate to webpage - assume it's an external link
						// we could also pop up a message indicating what happened and if they want to proceed
						request = new URLRequest(hyperlink);
						navigateToURL(request);
					}
				}
				
			}
			
		}
		
		public function addToHistory(browserURLChangeEvent:Boolean = false):void {
			var historyFragment:String;
			
			// get the last URL not the current URL because the user changed it
			if (browserURLChangeEvent) {
				historyFragment = getFragment(lastURL);
			}
			else {
				if (fragment=="") {
					return;
				}
				else {
					historyFragment = fragment;
				}
			}
			
			var historyInfoIndex:int = ArrayUtils.getItemIndexByProperty(history, "fragment", historyFragment);
			var historyInfo:HistoryInfo;
			
			// if found update
			if (historyInfoIndex!=-1) {
				historyInfo = HistoryInfo(history.getItemAt(historyInfoIndex));
				historyInfo.verticalPosition = getVerticalScrollPosition();
				history.removeItemAt(historyInfoIndex);
				history.addItemAt(historyInfo, historyInfoIndex);
			}
			
			// if not found add
			else {
				historyInfo = new HistoryInfo();
				historyInfo.fragment = historyFragment;
				historyInfo.verticalPosition = getVerticalScrollPosition();
				history.addItem(historyInfo);
			}
			
		}
		
		public function getVerticalScrollPosition():int {
			if (isFlex3) {
				return application.verticalScrollPosition;
			}
			else {
				if (scroller==null || scroller.viewport==null) {
					return 0;
				}
				var top:int = scroller.localToGlobal(new Point()).y;
				var currentPosition:int = scroller.viewport.verticalScrollPosition + top;
				return currentPosition;
			}
		}
		
		// setup of default set of actions run through when clicking on a hyperlink
		// content type actions are run before this
		public function setupDefaultActions():void {
			waitBehavior.continueAfterFrames = 2;
			
			// user set his own set of actions 
			// not responsible for inaccurate behavior
			// also not responsible if it fixes something
			if (defaultActions.length==0) {
				// setup default actions - order sets the behavior we want
				defaultActions.push(scrollToAnchor, goToState, waitBehavior, setBrowserFragment, setPageTitle, waitBehavior, scrollToPosition);
			}
		}
		
		// handles when a target is set in hyperlinkTarget 
		public function setupDefaultContentTypeActions():void {
			
			if (defaultContentTypeActions.length==0) {
				// setup default content type actions
				defaultContentTypeActions.push(downloadFile, goToURL);
			}
			
		}
		
		public function getDynamicActionsArray():Array {
			var newActions:Array = defaultContentTypeActions.concat(defaultActions);
			return newActions;
		}
		
		private var _useBrowserDownloadDialog:Boolean = false;
		
		// sends the file uri to the browser to try to use the browser download dialog 
		// instead of the flash download dialog
		// with some mime types the browser will open
		// to get this to really work we need to send the url to a server that will 
		// initiate a proper browser download dialog
		[Bindable]
		[Inspectable(category="General")]
		public function set useBrowserDownloadDialog(value:Boolean):void {
			_useBrowserDownloadDialog = value;
		}
		
		public function get useBrowserDownloadDialog():Boolean {
			return _useBrowserDownloadDialog;
		}
		
		private var _useBrowserScrollbars:Boolean = false;
		private var _previousVerticalScrollPolicy:String = "";
		private var _previousHorizontalScrollPolicy:String = "";
		
		
		// lets the browser create scrollbars instead of having Flex create them
		[Bindable]
		[Inspectable(category="General")]
		public function set useBrowserScrollbars(value:Boolean):void {
			_useBrowserScrollbars = value;
			
			if (value) {
				_previousVerticalScrollPolicy = application.verticalScrollPolicy;
				_previousHorizontalScrollPolicy = application.horizontalScrollPolicy;
				
				application.addEventListener(FlexEvent.CREATION_COMPLETE, resizeApplication, false, 0, false);
				application.addEventListener(FlexEvent.UPDATE_COMPLETE, resizeApplication, false, 0, false);
				
				application.verticalScrollPolicy = "off";
				
				ExternalInterface.call("eval", "document.body.style.overflow='auto'");
				
			}
			else {
				application.horizontalScrollPolicy = (_previousHorizontalScrollPolicy) ? _previousHorizontalScrollPolicy : "auto"
				application.verticalScrollPolicy = (_previousVerticalScrollPolicy) ? _previousVerticalScrollPolicy : "auto";
				
				application.removeEventListener(FlexEvent.CREATION_COMPLETE, resizeApplication);
				application.removeEventListener(FlexEvent.UPDATE_COMPLETE, resizeApplication);
				
				ExternalInterface.call("eval", "document.body.style.overflow='none'");
			}
		}
		
		public function get useBrowserScrollbars():Boolean {
			return _useBrowserScrollbars;
		}
		
		// For use when browser scroll bars is enabled
		// read only height of the application
		[Bindable]
		protected var browserApplicationHeight:Number = 0;
		
		// read only height of the stage
		[Bindable]
		protected var browserStageHeight:Number = 0;
		
		// read only height of the application the last time the browser window was resized
		[Bindable]
		protected var browserLastApplicationHeight:Number = 0;
		
		// read only height of the stage the last time the browser window was resized
		[Bindable]
		protected var browserLastStageHeight:Number = 0;
		
		// read only of the target height
		[Bindable]
		protected var browserTargetHeight:uint = 0;
		
		// read only of the target height
		[Bindable]
		public var browserScrollBarTarget:UIComponent;
		
		
		public function resizeApplication(event:FlexEvent):void {
			updateBrowserScrollbars()
		}
		
		public function updateBrowserScrollbars():void {
			if (application==null || application.stage==null) return;
			
			// what happens if the stage is smaller than the browser view port?
			if (browserStageHeight <= browserApplicationHeight) {
				// ignore for now
			}
			
			if (browserScrollBarTarget) {
				var point:Point = browserScrollBarTarget.localToGlobal(new Point(0,0));
				browserTargetHeight = point.y + browserScrollBarTarget.height;
			}
			else {
				browserTargetHeight = application.stage.height;
				traceConsole("Link Manager: Warning. You must set the browserScrollBarTarget to your highest or last container and disable the MouseWheelManager if it is included. ");
			}
			
			ExternalInterface.call("eval", "document.body.style.height='" + browserTargetHeight + "px'");
			
			// save last height values
			browserLastApplicationHeight = browserApplicationHeight;
			browserLastStageHeight = browserLastStageHeight;
			
			// store current height values
			browserStageHeight = application.stage.height;
			browserApplicationHeight = application.height;
		}
		
		private var _application:Object;
		public var document:Object;
		
		public function get application():Object {
			if (_application==null) return null;
			
			return _application;
		}
		
		public function set application(value:Object):void {
			_application = value;
		}
		
		
		[Bindable]
		public function set anchorToTopAlias(value:String):void {
			anchorManager.TOP = value;
		}
		
		public function get anchorToTopAlias():String {
			return anchorManager.TOP;
		}
		
		// scroll to the top of the page when going to a new state
		// you can change this by creating a StateOption and setting the property of the same name
		// in the stateOptions array  
		public var scrollToTopOnStateChange:Boolean = true;
		
		// save the last scroll position when going back to a previous state
		public var lastScrollPosition:int = 0;
		
		// last url - usually changes on browser url change event
		[Bindable]
		public var lastURL:String = "";
		
		// create the fragment
		public function createFragment(stateName:String = "", anchor:String = "", parameters:String = "", dynamicParameters:String = "", encode:Boolean = false):String {
			var fragment:String = "";
			var object:Object = new Object();
			var parameters:String = URLUtil.objectToString(parametersObject, parameterSetSeparator, encode);
			var parametersListValues:String = "";
			
			// check the parameters list
			parametersListValues = getParametersList();
			
			// if only state name exists then use PRETTY URL
			if (anchor=="" && parameters=="" && parametersListValues=="") {
				if (stateName!="") {
					return stateName;
				}
				else {
					return BASE_STATE_ALIAS;
				}
			}
			
			// add state name
			if (stateName!="") {
				fragment = STATE_PARAMETER_ALIAS + "=" + stateName + parameterSetSeparator;
			}
			else {
				fragment = STATE_PARAMETER_ALIAS + "=" + BASE_STATE_ALIAS + parameterSetSeparator;
			}
			
			// add anchor - actually, we don't want to add the anchor to the url
			// update: well yes we do, but only in some circumstances
			// mimic browser behavior
			if (anchor!="") {
				fragment = fragment + ANCHOR_PARAMETER_ALIAS + "=" + anchor + parameterSetSeparator;
			}
			
			// add parameters 
			if (parameters!="") {
				fragment = fragment + parameters;
			}
			
			return fragment;
		}
		
		// returns the determined fragment given the link information 
		// and optionally a full uri if requested
		public function determineFragment(linkInfo:LinkInfo, fullURL:Boolean = false):String {
			var currentFragment:String = getFragment();
			var fragment:String = linkInfo.fragment;
			var anchorAlias:String = ANCHOR_PARAMETER_ALIAS;
			var stateAlias:String = STATE_PARAMETER_ALIAS;
			var baseStateAlias:String = BASE_STATE_ALIAS;
			var dynamicParametersObject:Object = getDynamicParameters();
			var showBaseStateInFragment:Boolean = showBaseStateAliasInFragment;
			var currentState:String = getCurrentState(isFlex3);
			var nameValuePairDelimiter:String = nameValuePairDelimiter;
			var parameterSetSeparator:String = parameterSetSeparator;
			var anchorSymbol:String = anchorSymbol;
			var parametersObject:Object = new Object();
			var canShowPrettyUrl:Boolean = true;
			var newFragment:String = "";
			var anchorExists:Boolean = isAnchorSpecifiedInParameters(fragment);
			var parameterArrayURI:String = fragment;
			
			// if it's an array of parameters such as "/something/something/something" then ignore for now
			if (linkInfo.isParameterArray) {
				if (fullURL) {
					parameterArrayURI = createURI(fragment);
				}
				return parameterArrayURI;
			}
			
			// if its only an anchor we add or update the current URL
			if (linkInfo.isAnchor) {
				
				if (fragment!="") {
					newFragment = getFragmentWithUpdatedAnchorName(linkInfo.anchorName, fragment);
				
					if (fullURL) {
						return createURI(newFragment);
					}
					else {
						return newFragment;
					}
				}
			}
			
			// add anchor
			if (linkInfo.hasAnchor && !linkInfo.isAnchorKeyword) {
				parametersObject[anchorAlias] = linkInfo.anchorName;
			}
			
			// get state
			if (linkInfo.hasState) {
				parametersObject[stateAlias] = linkInfo.stateName;
			}
			else {
				if (currentState==baseStateAlias && showBaseStateInFragment) {
					parametersObject[stateAlias] = baseStateAlias;
				}
				else if (currentState!=baseStateAlias) {
					parametersObject[stateAlias] = currentState;
				}
			}
			
			// get parameters - note: we might want to check if the parameter exists and warn the developer
			if (linkInfo.hasParameters) {
				for (var parameterName:String in linkInfo.parametersObject) {
					if (parameterName!=null) {
						parametersObject[parameterName] = linkInfo.parametersObject[parameterName];
						canShowPrettyUrl = false;
					}
				}
			}
			
			// get dynamic parameters - note: we might want to check if the parameter exists and warn the developer
			for (var propertyName:String in dynamicParametersObject) {
				parametersObject[propertyName] = dynamicParametersObject[propertyName];
				canShowPrettyUrl = false;
			}
			
			// if only state or state and anchor then use pretty url
			if (canShowPrettyUrl && showPrettyURL) {
				
				// add state
				// check if state is base state
				if (linkInfo.isBaseState) {
					if (linkInfo.hasState && showBaseStateInFragment) {
						newFragment = parametersObject[stateAlias];
					}
				}
				else if (linkInfo.hasState) {
					newFragment = parametersObject[stateAlias];
				}
				else if (linkInfo.isAnchor) {
					if (currentState==baseStateAlias && showBaseStateInFragment) {
						newFragment = baseStateAlias;
					}
					else if (currentState!=baseStateAlias) {
						newFragment = currentState;
					}
				}
				else {
					if (currentState==baseStateAlias && showBaseStateInFragment) {
						newFragment = baseStateAlias;
					}
					else if (currentState!=baseStateAlias) {
						newFragment = currentState;
					}
				}
				
				// add anchor
				if (newFragment!="" && linkInfo.hasAnchor && !linkInfo.isAnchorKeyword) {
					newFragment += anchorSymbol + parametersObject[anchorAlias];
				}
				
			}
			
			// show standard url
			// TODO: we could make a compressed url and store on the server
			else {
				newFragment = URLUtil.objectToString(parametersObject, parameterSetSeparator, encodeURL);
			}
			
			// compare new fragment to original fragment
			// if they are the same use the original
			if (isFragmentEqual(fragment, newFragment)) {
				newFragment = fragment;
			}
			
			
			if (fullURL) {
				return createURI(newFragment);
			}
			else {
				return newFragment;
			}
			
			
		}
		
		public function getFragmentWithUpdatedAnchorName(name:String, fragment:String = null):String {
			fragment = (fragment==null) ? getFragment() : fragment;
			var anchorAlias:String = ANCHOR_PARAMETER_ALIAS;
			
			var anchorExists:Boolean = isAnchorSpecifiedInParameters(fragment);
			var anchorInFragment:String = getAnchorSpecifiedInParameters(fragment);
			
			if (anchorExists) {
				if (anchorInFragment==name) {
					// we don't need to update
					return fragment;
				}
				else {
					// replace anchor
					var fragmentObject:Object = URLUtil.stringToObject(String(fragment), parameterSetSeparator, decodeURL);
					fragmentObject[anchorAlias] = name;
					fragment = URLUtil.objectToString(fragmentObject, parameterSetSeparator, encodeURL);
					if (fragment.indexOf(parameterSetSeparator)!=-1) {
						//fragment = fragment.split(parameterSetSeparator).reverse().join(parameterSetSeparator);
					}
				}
			}
			
			
			return fragment;
		}
		
		public function isFragmentEqual(link:Object, link2:Object):Boolean {
			var match:Boolean = false;
			
			if (link is String && link2 is String) {
				var linkObject:Object = URLUtil.stringToObject(String(link), parameterSetSeparator, decodeURL);
				var linkObject2:Object = URLUtil.stringToObject(String(link2), parameterSetSeparator, decodeURL);
				
				match = ObjectUtil.compare(linkObject, linkObject2)==0;
			}
			else if (link is LinkInfo && link2 is LinkInfo) {				
				match = ObjectUtil.compare(link, link2)==0;
			}
			
			return match;
		}
		
		// derive the fragment - possibly deprecated
		public function deriveFragment(includeAnchor:Boolean = true):String {
			var fragment:String = "";
			var currentState:String = getCurrentState();
			var anchor:String = (includeAnchor) ? anchorName : "";
			var parameters:String = parametersOld;
			var dynamicParameters:String = "";
			var stateString:String = STATE_PARAMETER_ALIAS + "=" + currentState;
			var anchorString:String = ANCHOR_PARAMETER_ALIAS + "=" + anchor;
			var baseStateString:String = STATE_PARAMETER_ALIAS + "=" + BASE_STATE_ALIAS;
			
			// check the parameters list
			dynamicParameters = getParametersList();
			
			// if only state name exists then use PRETTY URL
			// pretty url = http://www.domain.com/page.html#myState
			if (anchor=="" && parameters=="" && dynamicParameters=="") {
				if (currentState!="" && currentState!=null) {
					return currentState;
				}
				else {
					if (showBaseStateAliasInFragment) {
						return BASE_STATE_ALIAS;
					}
					else {
						return "";
					}
				}
			}
			
			// add state name
			// make sure it's not already added
			if (currentState!=null && parameters.indexOf(stateString)==-1 && dynamicParameters.indexOf(stateString)==-1) {
				fragment = stateString + parameterSetSeparator;
			}
			else {
				if (showBaseStateAliasInFragment && parameters.indexOf(baseStateString)==-1 && dynamicParameters.indexOf(baseStateString)==-1) {
					// we are always somewhere - in this case it is the base state
					fragment = baseStateString + parameterSetSeparator;
				}
				
			}
			
			// add anchor 
			if (anchor!="" && parameters.indexOf(anchorString)==-1 && dynamicParameters.indexOf(anchorString)==-1) {
				fragment = fragment + anchorString + parameterSetSeparator;
			}
			
			// add parameters
			if (parameters!="" || dynamicParameters!="") {
				parameters = (dynamicParameters!="") ? parameters + parameterSetSeparator + dynamicParameters : parameters;
				parameters = removeSeparators(parameters);
				parametersObject = URLUtil.stringToObject(parameters, parameterSetSeparator, decodeURL);
				fragment = fragment + parameters;
			}
			
			return fragment;
		}
		
		// set the fragment of the url
		// for example in this url, http://www.domain.com/page.html#param1=10;param2=test;
		// the fragment is "param1=10;param2=test;"
		public function setFragment(fragment:String, linkInfo:LinkInfo = null):void {
			browserManager = BrowserManager.getInstance();
			var currentFragment:String = browserManager.fragment;
			
			// check if the url is different
			if (fragment!=currentFragment) {
				// we don't want to trigger a change that we made
				// we listen for url entered events for things like the back and forward button 
				// and pasting in the url
				cancelBrowserURLUpdate = true;
				browserManager.setFragment(fragment);
				cancelBrowserURLUpdate = false;
				
				// update the parameters proxy
				parametersList.update();
				parameters.update();
			}
		}
		
		// get the fragment of the url
		// for example in this url, http://www.domain.com/page.html#param1=10;param2=test;
		// the fragment is "param1=10;param2=test;"
		public function getFragment(fromPath:String = null):String {
			browserManager = BrowserManager.getInstance();
			
			if (fromPath!=null && fromPath.indexOf("#")!=-1) {
				var index:int = fromPath.indexOf("#");
				var fragment:String = fromPath.substr(index+1);
				return fragment;
			}
			else {
				return browserManager.fragment;
			}
		}
		
		
		// gets the current directory
		// for example, this url, http://www.domain.com/directory/page.html
		// returns http://www.domain.com/directory/
		public function getCurrentServerSideDirectory():String {
			var url:String = application.url;
			url = url.substr(0, url.lastIndexOf("/")) + "/";
			return url;
		}
		
		// removes the separator from beginning or end of parameters string
		// for example, "param1=value;" becomes "param1=value"
		public function removeSeparators(value:String):String {
			var index:int = value.lastIndexOf(";");
			var length:int = value.length;
			var v3:String = value.substr(0, length-1);
			
			value = (value.lastIndexOf(";")==value.length-1) ? value.substr(0, index-1) : value;
			value = (value.indexOf(";")==0) ? value.substr(1, value.length) : value;
			return value;
		}
		
		// get full uri from a hyperlink value
		// for example if hyperlink is "myState" it will return the full uri "http://domain.com/myPage.html#myState"
		// if the hyperlink is already an absolute uri then we simply return that
		// used when visitor uses the context menu item "copy link location" 
		public function getURI(hyperlink:String, hyperlinkTarget:String = "", includeDynamicProperties:Boolean = false, includeAnchor:Boolean = true):String {
			
			if (hyperlink=="") {
				traceConsole("Link Manager: getURI - Hyperlink was empty");
				return "";
			}
			
			var linkInfo:LinkInfo = getLinkInfo(hyperlink, hyperlinkTarget);
			var uri:String = "";
			if (linkInfo.isURL) {
				uri = linkInfo.hyperlink;
			}
			else {
				uri = determineFragment(linkInfo, true);
			}
			return uri;
			
			
			// WE NEED TO MIGRATE ANY CODE FROM HERE INTO SETbROWSERfRAGMENT CLASS
			var desiredState:State;
			var stateName:String = "";
			var anchorName:String = "";
			var stateFound:Boolean = false;
			var isHomeState:Boolean = (hyperlink.indexOf(BASE_STATE_ALIAS)==0);
			var isAnchor:Boolean = (hyperlink.indexOf(anchorSymbol)==0);
			var isURL:Boolean = (hyperlink.indexOf("http://")==0 || hyperlink.indexOf("https://")==0 || hyperlink.indexOf("ftp://")==0);
			var questionIndex:int = hyperlink.indexOf("?");
			var anchorIndex:int = hyperlink.indexOf(anchorSymbol);
			var hasAnchor:Boolean = (hyperlink.indexOf(anchorSymbol)!=-1);
			var hasQuestion:Boolean = (hyperlink.indexOf("?")!=-1);
			var nameBeforeAnchor:String = (hasAnchor) ? hyperlink.split(anchorSymbol)[0] : "";
			var nameBeforeQuestion:String = (hasQuestion) ? hyperlink.split("?")[0] : "";
			var oldParameters:String = this.parameters;
			var oldParametersObject:Object = this.parametersObject;
			var parameters:String = (hasQuestion) ? hyperlink.split("?")[1] : "";
			var stateEndIndex:uint = 0;
			var stateFoundBeforeAnchor:Boolean = false;
			var stateFoundBeforeQuestion:Boolean = false;
			uri = hyperlink;
			var fragment:String = "";
			var hostPath:String = application.url;
			
			// state, anchor and parameters
			// for example, myState#myAnchor?myParameter=1;myParameter2=test;
			// parameters should always be at the end - we need to error check for that
			anchorName = (hasQuestion && hasAnchor && !isAnchor) ? nameBeforeQuestion.split(anchorSymbol)[1] : anchorName;
			
			// state and anchor
			// for example, myState#myAnchor
			anchorName = (hasAnchor && !isAnchor && !hasQuestion) ? String(hyperlink.split(anchorSymbol)[1]) : anchorName;
			
			// anchor and parameters
			// for example, #myAnchor?myParameter=1;
			anchorName = (isAnchor && hasQuestion) ? String(hyperlink.split("?")[0]).split(anchorSymbol)[1] : anchorName;
			parameters = (isAnchor && hasQuestion) ? hyperlink.split("?")[1] : parameters;
			// remove semicolon at the end of the line
			parameters = (parameters.lastIndexOf(";")==parameters.length-1) ? parameters.substr(0, parameters.length-1) : parameters;
			
			// only anchor
			// #myAnchor
			anchorName = (isAnchor && !hasQuestion) ? hyperlink.split(anchorSymbol)[1] : anchorName;
			
			// find the stateName
			if (hasQuestion || hasAnchor) {
				stateFoundBeforeAnchor = stateExists(nameBeforeAnchor);
				stateFoundBeforeQuestion = stateExists(nameBeforeQuestion);
				
				if (stateFoundBeforeAnchor) {
					stateName = nameBeforeAnchor;
					stateFound = true;
					//desiredState = findState(nameBeforeAnchor);
				}
				else if (stateFoundBeforeQuestion) {
					stateName = nameBeforeQuestion;
					stateFound = true;
					//desiredState = findState(nameBeforeQuestion);
				}
			}
			else {
				stateFound = stateExists(hyperlink);
				
				if (stateFound) {
					stateName = hyperlink;
				}
			}
			
			// find the target
			if (target=="" || target==null) {
				target = findHyperlinkTarget(hyperlink);
			}
			
			
			// HYPERLINK IS A STATE
			if (target==STATE_HYPERLINK) {
				fragment = createFragment(stateName, anchorName, parameters);
				
				// we keep this check for future use
				if (stateFound) {
					uri = createURI(fragment);
					return uri;
				}
				else {
					uri = createURI(fragment);
					return uri;
				}
			}
				
				// HYPERLINK TARGET is ANCHOR
			else if (target==ANCHOR_HYPERLINK) {
				fragment = createFragment(stateName, anchorName, parameters);
				
				// we keep this check for future use
				if (stateFound) {
					uri = createURI(fragment);
					return uri;
				}
				else {
					uri = createURI(fragment);
					return uri;
				}
			}
				
				// HYPERLINK TARGET is DOWNLOAD
			else if (target==DOWNLOAD_HYPERLINK) {
				
				if (isURL) {
					return uri;
				}
				else {
					// concatenate the hyperlink to the document directory
					uri = getCurrentServerSideDirectory() + hyperlink;
					return uri;
				}
			}
				
				// HYPERLINK TARGET is BROWSER
			else if (target==BROWSER_HYPERLINK) {
				
				if (isURL) {
					return uri;
				}
				else {
					// concatenate the hyperlink to the document directory
					uri = getCurrentServerSideDirectory() + hyperlink;
					return uri;
				}
			}
				
				// HYPERLINK TARGET is CURRENT or BLANK or named BROWSER WINDOW 
				// a named browser window could also be a frame
			else if (target==SELF_HYPERLINK || target==BLANK_HYPERLINK || target.length>0) {
				
				if (isURL) {
					return uri;
				}
				else {
					uri = getCurrentServerSideDirectory() + hyperlink;
					return uri;
				}
			}
			
			return uri;
		}
		
		// create uri from fragment and base url 
		// for example, the base may be http://www.domain.com/myPage.html or http://www.domain.com/myPage.html#
		// the fragement would be appended by this method so the final result would be,
		//  http://www.domain.com/myPage.html#myState
		// it was created to add a anchor symbol before the fragment when the base url doesn't contain one  
		public function createURI(fragment:String = ""):String {
			var base:String = BrowserManager.getInstance().base;
			
			if (base.charAt(base.length-1)!=anchorSeparatorSymbol) {
				base = base + anchorSeparatorSymbol;
			}
			return base + fragment;
		}
		
		// find the state by name or id
		// also checks for match against BASE_STATE_ALIAS which is usually defined as "home"
		// if it can't find the state it returns null
		// see also stateExists()
		public function findState(stateNameOrId:String):State {
			var states:Array;
			var state:State;
			var stateFound:Boolean = false;
			var isHomeState:Boolean = (stateNameOrId==BASE_STATE_ALIAS);
			
			if (isHomeState) {
				// return a fake state that we will redirect to the base state
				stateFound = true;
				state = new State();
				state.name = "";
				return state;
			}
			
			states = application.states;
			
			for each (var item:State in states) {
				if (item.name.toLowerCase()==stateNameOrId.toLowerCase()) {
					state = item;
					break;
				}
				if (item.hasOwnProperty("id") && String(item["id"]).toLowerCase()==stateNameOrId.toLowerCase()) {
					state = item;
					break;
				}
			}
			return state;
		}
		
		// check if state is base state
		public function isBaseState(stateName:String, caseSensitive:Boolean = true):Boolean {
			if (!caseSensitive) {
				if (!stateName || stateName=="" || stateName.toLowerCase()==BASE_STATE_ALIAS.toLowerCase()) {
					return true;
				}
			}
			else if (!stateName || stateName=="" || stateName==BASE_STATE_ALIAS) {
				return true;
			}
			return false;
		}
		
		// WE SHOULD USE StateUtils.getStateExists(targetComponent, state, caseSensitive);
		// check if state exists by state name or id
		// also checks against the BASE_STATE_ALIAS which is usually defined as "home"
		// does not check against the BASE_STATE_ALIAS in flex 4
		public function stateExists(stateNameOrId:String, target:Object=null):Boolean {
			var states:Array;
			var stateFound:Boolean = false;
			var isHomeState:Boolean = (stateNameOrId.toLowerCase()==BASE_STATE_ALIAS.toLowerCase());
			
			if (isFlex3 && isHomeState) {
				stateFound = true;
				return stateFound;
			}
			
			if (target is String) {
				target = null;
			}
			
			if (target==null || target.states==null) {
				if (document==null || document.states==null) {
					return false;
				}
				else {
					target = document;
				}
			}
			
			states = target.states;
			
			for each (var state:State in states) {
				if (state.name!=null && state.name.toLowerCase()==stateNameOrId.toLowerCase()) {
					stateFound = true;
					break;
				}
				if (state.hasOwnProperty("id") && String(state["id"]).toLowerCase()==stateNameOrId.toLowerCase()) {
					stateFound = true;
					break;
				}
			}
			return stateFound;
		}
		
		// determines what to show in the browser title
		public function get fullTitle():String {
			if (projectName=="") {
				var title:String = applicationPageTitle;
				if (title!=null) {
					projectName = title;
				}
			}
			
			// check state options to see if we need to show an alias or even display anything at all
			for each (var stateOption:StateOption in stateOptions) {
				var stateName:String = (stateOption.state!=null) ? stateOption.state.name : stateOption.stateName;
				
				if (stateName==getCurrentState()) {
					
					if (stateOption.showDisplayName) {
						stateTitle = stateOption.displayName;
					}
					else {
						stateTitle = "";
					}
					break;
				}
			}
			
			if (projectName!="") {
				_fullTitle = (stateTitle != "" && stateTitle!=null) ? projectName + " - " + stateTitle : projectName;
			}
			else {
				_fullTitle = stateTitle;
			}
			
			return _fullTitle;
		}
		
		//*************** RESPOND TO BROWSER URL CHANGE *********************
		// we are READING and RESPONDING TO A URL CHANGE FROM THE USER OR THE BROWSER
		// user defined function to let the user receive the url fragment, target state and fragment object and modify them 
		public function defaultReadLinkFunction(fragment:String, stateName:String, destinationState:State, fragmentObject:Object, stateExists:Boolean):String {
			return stateName;
		}
		
		// User defined function to let user receive the url fragment and modify it before changing states
		private var _readLinkFunction:Function = defaultReadLinkFunction;
		
		// lets user define their own function to modify the url fragment 
		public function set readLinkFunction(value:Function):void {
			if (value!=null) {
				_readLinkFunction = value;
			}
		}
		
		// gets current url function
		public function get readLinkFunction():Function {
			return _readLinkFunction;
		}
		
		//*************** MODIFY URL ADDRESS BAR *********************
		// HERE we are WRITING the LINK to the address bar
		// When the url is about to be written you can modify it
		// you can return the fragment string or fragmentObject
		public function defaultWriteLinkFunction(fragment:String, fragmentObject:Object, state:String, previousState:String):* {
			return fragment;
		}
		
		// User defined function to let user write or rewrite the url fragment before writing it to the browser address bar
		private var _writeLinkFunction:Function = defaultWriteLinkFunction;
		
		// lets user define their own function to modify the url fragment 
		public function set writeLinkFunction(value:Function):void {
			if (value!=null) {
				_writeLinkFunction = value;
			}
		}
		
		// gets current url function
		public function get writeLinkFunction():Function {
			return _writeLinkFunction;
		}
		
		//*************** MODIFY BROWSER TITLE BAR *********************
		// default modify browser page title 
		// title is the page title to display
		// siteTitle is the page title. the info before the state "My Site - My Current State" would be "My Site"
		public function defaultTitleFunction(title:String, siteTitle:String, state:String):String {
			return title;
		}
		
		// User defined function to let user modify the browser page title before writing it
		private var _titleFunction:Function = defaultTitleFunction;
		
		// lets user define their own function to modify the browser page title fragment 
		public function set titleFunction(value:Function):void {
			
			if (value!=null) {
				_titleFunction = value;
			}
		}
		
		// gets current browser page title function
		public function get titleFunction():Function {
			return _titleFunction;
		}
		
		// adds a parameter to the url fragment using the name and value passed in to this function
		// updates the url in the browser
		// a url might be http://www.google.com/page.html#state=about
		// if we called addParameter('search_query', 'flex');
		// the url in the browser would change to
		// http://www.google.com/page.html#state=about;search_query=flex
		public function addParameter(name:String, value:String, title:String = null):void {
			// we just gather information in the first section
			// get the fragment that is past the hash mark and convert it to an object
			// typical fragment would be http://www.google.com/page.html#state=about
			var fragment:String = browserManager.fragment;
			var isFragmentEmpty:Boolean = (fragment==null || fragment.length<1) ? true : false;
			fragmentObject = URLUtil.stringToObject(browserManager.fragment, parameterSetSeparator, decodeURL);
			
			var propertyExists:Boolean = fragmentObject.hasOwnProperty(name);
			fragmentObject[name] = value;
			url = URLUtil.objectToString(fragmentObject, parameterSetSeparator, encodeURL);
			browserManager.setFragment(url);
			if (title!=null) {
				stateTitle = title;
				browserManager.setTitle(fullTitle);
			}
		}
		
		// returns an object from parameters
		public function getParametersObject(parameters:String):Object {
			
			parameters = removeSeparators(parameters);
			parametersObject = URLUtil.stringToObject(parameters, parameterSetSeparator, decodeURL);
			
			return parametersObject;
		}
		
		
		/**
		 * Get a link object containing information about this hyperlink
		 * I think this is the prettiest code I've written in a while
		 **/
		public function getLinkInfo(hyperlink:String = "", hyperlinkTarget:Object = "", mouseTarget:Object = null, origin:String = "internal"):LinkInfo {
			var newLinkInfo:LinkInfo = new LinkInfo();
			
			var stateName:String = "";
			var anchorName:String = "";
			var parameters:String = "";
			var parametersArray:Array = [];
			var url:String = "";
			
			var anchorFound:Boolean = false; // not able to be handled here
			var stateFound:Boolean = false;
			var isBaseState:Boolean = false;
			var isAnchorKeyword:Boolean = false;
			
			var isAnchor:Boolean = false;
			var isParameters:Boolean = false;
			var isState:Boolean = false;
			var isURL:Boolean = false;
			var isPrettyURL:Boolean = false;
			var isHybridURL:Boolean = false;
			var isParametersListURL:Boolean = false;
			var isParameterArray:Boolean = false;
			
			var hasAnchor:Boolean = false;
			var hasParameters:Boolean = false;
			var hasState:Boolean = false;
			var hasTarget:Boolean = (hyperlinkTarget!="" && hyperlinkTarget!=null);
			
			var oldParameters:String = this.parametersOld;
			var oldParametersObject:Object = this.parametersObject;
			var newParametersObject:Object = new Object();
			
			var anchorPending:Boolean = false;
			
			var match:Array;
			
			var fragment:String = browserManager.fragment;
			
			var parametersString:String = "";
			
			var stateMatch:Boolean = false;
			var anchorMatch:Boolean = false;
			var parametersMatch:Boolean = false;
			var urlMatch:Boolean = false;
			
			var stateSpecifiedButNotFound:Boolean = false;
			
			var pageTitle:String = "";
			
			var follow:Boolean = true;
			
			var verticalPosition:int = 0;
			
			if (isFlex3 && document!=null) {
				verticalPosition = document.verticalScrollPosition;
			}
			
			if (mouseTarget!=null) {
				pageTitle = Object(mouseTarget).hasOwnProperty("pageTitle") && mouseTarget.pageTitle!=null ? mouseTarget.pageTitle : pageTitle;
				follow = Object(mouseTarget).hasOwnProperty("follow") && mouseTarget.follow!=null ? mouseTarget.follow : follow;
			}
			
			// WE NEED TO CHECK FOR DIFFERENT FORMATS
			
			// NOTE - Anchor can be # or @
			
			// FORMAT 1 - stateName@anchorName?parameterName=value;repeatName=repeatValue
			// FORMAT 2 - stateName@anchorName
			// FORMAT 3 - stateName?parameterName=parameterValue
			// FORMAT 4 - stateName
			// FORMAT 5 - @anchorName?parameterName=parameterValue
			// FORMAT 6 - @anchorName
			// FORMAT 7 - ?parameterName=parameterValue
			// FORMAT 8 - parameterName=parameterValue
			// FORMAT 9 - http://domain.com
			
			
			// UPDATE: we now use the "origin" property to check if a link is internal or external
			
			// NOTE: we can also have a blank hyperlink 
			// in that case we may need to determine what the url should be
			
			// NOTE: We may never receive Format 1, 2 or 3 in the url 
			// because we always write the url in name value pairs when there is more than just the state name
			// for example, we wouldn't write stateName#anchorName to the browser url
			// we would write, s=stateName;a=anchorName
			// Formats 1, 2 and 3 are used as shortcuts for use in the anchor components hyperlink property
			// we rewrite them any time they are exported out of the application
			
			
			// FORMAT 1 - stateName@anchorName?parameterName=value;repeatName=repeatValue
			// we are matching "?" optional and then any word character up to a equals sign
			match = hyperlink.match(/^(\w+)[@|#](\w+)\?(.*)/);
			if (match!=null) {
				stateName = (match.length>1) ? match[1] : "";
				anchorName = (match.length>2) ? match[2] : "";
				parameters = (match.length>3) ? match[3] : "";
				stateMatch = true;
				hasState = true;
				hasAnchor = true;
				hasParameters = true;
				isState = true;
				stateFound = hasState ? stateExists(stateName) : stateFound;
				isBaseState = (isFlex3 && stateName==BASE_STATE_ALIAS);
				isAnchorKeyword = anchorManager.isKeyword(anchorName);
				fragment = hyperlink;
				isHybridURL = true;
			}
			
			// FORMAT 2 - state#anchor, state@anchor, state@1234
			// we are matching any word character, a pound sign and then any word characters
			match = hyperlink.match(/^(\w+)[@|#](\w+)/);
			if (match!=null && !stateMatch) {
				stateName = (match.length>1) ? match[1] : "";
				anchorName = (match.length>2) ? match[2] : "";
				stateMatch = true;
				hasState = true;
				hasAnchor = true;
				isState = true;
				stateFound = hasState ? stateExists(stateName) : stateFound;
				isBaseState = (isFlex3 && stateName==BASE_STATE_ALIAS);
				isAnchorKeyword = anchorManager.isKeyword(anchorName);
				fragment = hyperlink;
				isPrettyURL = true;
			}
			
			// FORMAT 3 - state?parameterName=parameterValue
			// we are matching any word character, a question mark and then any word characters
			match = hyperlink.match(/^(\w+)\?(.*)/);
			if (match!=null && !stateMatch) {
				stateName = (match.length>1) ? match[1] : "";
				parameters = (match.length>2) ? match[2] : "";
				stateMatch = true;
				hasState = true;
				hasParameters = true;
				isState = true;
				stateFound = hasState ? stateExists(stateName) : stateFound;
				isBaseState = (isFlex3 && stateName==BASE_STATE_ALIAS);
				fragment = hyperlink;
				isHybridURL = true;
			}
			
			// FORMAT 4 - state
			// we are matching any word character and then the end of the line
			// need to make sure this isn't greedy
			match = hyperlink.match(/^(\w+)$/);
			if (match!=null && !stateMatch) {
				stateName = (match.length>1) ? match[1] : "";
				stateMatch = true;
				hasState = true;
				isState = true;
				stateFound = hasState ? stateExists(stateName) : stateFound;
				isBaseState = (isFlex3 && stateName==BASE_STATE_ALIAS);
				fragment = hyperlink;
				isPrettyURL = true;
			}
			
			
			// FORMAT 5 - @anchorName?parameterName=parameterValue
			// NOTE: We throw out the parameters in this situation because of the nature of anchors
			// we are matching any word character, a question mark and then any word characters
			match = hyperlink.match(/^[@|#](\w+)\?(.*)/);
			if (match!=null && !anchorMatch) {
				anchorName = (match.length>1) ? match[1] : "";
				// parameters = (match.length>2) ? match[2] : "";
				isAnchorKeyword = anchorManager.isKeyword(anchorName);
				anchorMatch = true;
				hasAnchor = true;
				isAnchor = true;
				isHybridURL = true;
			}
			
			// FORMAT 6 - #anchorName, @anchorName, #123, @123
			// we are matching any word character, a question mark and then any word characters
			match = hyperlink.match(/^[@|#](\w+)\b/);
			if (match!=null && !anchorMatch) {
				anchorName = (match.length>1) ? match[1] : "";
				parameters = (match.length>2) ? match[2] : "";
				isAnchorKeyword = anchorManager.isKeyword(anchorName);
				anchorMatch = true;
				hasAnchor = true;
				isAnchor = true;
				isPrettyURL = true;
			}
			
			// FORMAT 7 - ?parameterName=parameterValue
			// FORMAT 8 - parameterName=parameterValue
			// we are matching "?" optional and then any word character up to an equals sign
			match = hyperlink.match(/^\??(\w+=.*)/);
			if (match!=null) {
				parameters = (match.length>1) ? match[1] : "";
				parametersMatch = true;
				isParameters = true;
				hasParameters = true;
				fragment = hyperlink;
				isParametersListURL = true;
			}
			
			// FORMAT 9 - /param1/param2/param3/etc
			// we are matching a "/" optional and then any character up to another slash (optional)
			match = hyperlink.match(/^\/(.*)$/);
			if (match!=null) { 
				parameters = (match.length>1) ? match[1] : "";
				parametersArray = parameters.split("/");
				parametersMatch = true;
				isParameters = true;
				hasParameters = true;
				fragment = hyperlink;
				isParameterArray = true;
			}
			
			// FORMAT 10 - http://domain.com
			// we are matching "http" and then any characters
			match = hyperlink.match(/^(http.*)/);
			if (match!=null) {
				url = (match.length>1) ? match[1] : "";
				urlMatch = true;
				isURL = true;
			}
			
			
			// gathering information
			// if parameters exist
			if (hasParameters && !isParameterArray) {
				
				// check if it has a state
				if (!hasState) {
					hasState = isStateSpecifiedInParameters(parameters);
					stateName = hasState ? getStateSpecifiedInParameters(parameters) : stateName;
					stateFound = hasState ? stateExists(stateName) : stateFound;
					isBaseState = (isFlex3 && stateName==BASE_STATE_ALIAS);
				}
				
				// check if an anchor exists
				if (!hasAnchor) {
					hasAnchor = isAnchorSpecifiedInParameters(parameters);
					anchorName = hasAnchor ? getAnchorSpecifiedInParameters(parameters) : anchorName;
					isAnchorKeyword = hasAnchor ? anchorManager.isKeyword(anchorName) : isAnchorKeyword;
				}
				
				// remove semicolon at the end of the line
				parameters = cleanParametersString(parameters);
				
				// put parameters into parameters object
				newParametersObject = URLUtil.stringToObject(parameters, parameterSetSeparator, decodeURL);
				
				// run through parameters and remove null property names
				// this is caused by semi colon at the end of the string 
				for (var parameter:String in newParametersObject) {
					
					
					// check for and remove parameters with value of "=null;"
					if (parameter!="" && parameter!=null && parameter!="null" &&
						parameter!=STATE_PARAMETER_ALIAS &&
						parameter!=ANCHOR_PARAMETER_ALIAS) {
						
						// build new parameters string
						parametersString = parameter + "=" + newParametersObject[parameter] + parameterSetSeparator + parametersString;
						
					}
					else {
						delete newParametersObject[parameter];
					}
				}
				
				// remove semicolon at the end of the line
				parameters = cleanParametersString(parameters);
				parametersString = cleanParametersString(parametersString);
				
				// rebuild parameters object without null properties
				if (parametersString!="") {
					parameters = parametersString;
					newParametersObject = URLUtil.stringToObject(parametersString, parameterSetSeparator, decodeURL);
				}
				
			}
			else if (isParameterArray) {
				
				newParametersObject = getParametersArrayObject(parametersArray, parametersMap);
				
				if (newParametersObject.hasOwnProperty("state")) {
					
					stateName = newParametersObject.state;
					stateMatch = true;
					hasState = true;
					isState = true;
					stateFound = hasState ? StateUtils.getStateExists((hyperlinkTarget) ? hyperlinkTarget : document, stateName) : stateFound;
					isBaseState = (isFlex3 && stateName==BASE_STATE_ALIAS);
				}
				/*
				// check if parameter array definition exists
				if (parametersMap!="" || parametersMap!=null) {
					var array:Array = (parametersMap!="") ? parametersMap.split(/[,|\/]/) : [];
					var i:int = 0;
					
					for (i=0;i<array.length;i++) {
						
						// add parameters to parameters proxy object
						if (i<parametersArray.length) {
							newParametersObject[array[i]] = parametersArray[i];
						}
						else {
							newParametersObject[array[i]] = "";
						}
					}
				}*/
			}
			
			
			// check for 404 - State not Found
			if ((hasState || stateMatch) && !stateFound) {
				stateSpecifiedButNotFound = true;
			}
			
			
			// if anchor exists
			if (hasAnchor) {
				anchorPending = true;
			}
			
			
			// return the information
			newLinkInfo.anchorFound = anchorFound;
			newLinkInfo.anchorPending = anchorPending;
			newLinkInfo.anchorName = anchorName;
			newLinkInfo.follow = follow;
			newLinkInfo.fragment = fragment;
			newLinkInfo.hasAnchor = hasAnchor;
			newLinkInfo.hasParameters = hasParameters;
			newLinkInfo.hasState = hasState;
			newLinkInfo.hasTarget = hasTarget;
			newLinkInfo.hyperlink = hyperlink;
			newLinkInfo.hyperlinkTarget = String(hyperlinkTarget);
			newLinkInfo.isAnchor = isAnchor;
			newLinkInfo.isAnchorKeyword = isAnchorKeyword;
			newLinkInfo.isBaseState = isBaseState;
			newLinkInfo.isParameter = isParameters;
			newLinkInfo.isURL = isURL;
			newLinkInfo.isParametersListURL = isParametersListURL;
			newLinkInfo.isParameterArray = isParameterArray;
			newLinkInfo.mouseTarget = mouseTarget;
			newLinkInfo.pageTitle = pageTitle;
			newLinkInfo.parameters = parameters;
			newLinkInfo.parametersArray = parametersArray;
			newLinkInfo.parametersObject = newParametersObject;
			newLinkInfo.stateFound = stateFound;
			newLinkInfo.stateSpecifiedButNotFound = stateSpecifiedButNotFound;
			newLinkInfo.stateName = stateName;
			newLinkInfo.url = url;
			newLinkInfo.verticalPosition = verticalPosition;
			
			newLinkInfo.determinedFragment = determineFragment(newLinkInfo);
			
			return newLinkInfo;
		}
		
		public function getParametersArrayObject(parametersArray:Array=null, parametersMap:String=""):Object {
			var parametersObject:Object = new Object();
			
			// check if parameter array definition exists
			if (parametersMap!="" || parametersMap!=null) {
				var array:Array = (parametersMap!="") ? parametersMap.split(/[,|\/]/) : [];
				var i:int = 0;
				
				for (i=0;i<array.length;i++) {
					
					// add parameters to parameters proxy object
					if (i<parametersArray.length) {
						parametersObject[array[i]] = parametersArray[i];
					}
					else {
						parametersObject[array[i]] = "";
					}
				}
				return parametersObject
			}
			return parametersObject;
		}
		
		// false since flex 4
		public function getCurrentState(includeBaseStateAlias:Boolean = false):String {
			
			var state:String = (document!=null) ? document.currentState : "";
			if (includeBaseStateAlias && (state=="" || state==null)) {
				state = BASE_STATE_ALIAS;
			}
			return state;
		}
		
		public function goToHomeState(title:String = ""):void {
			setState(BASE_STATE_ALIAS);
		}
		
		public function isCurrentState(stateName:String = ""):Boolean {
			var desiredState:State = findState(stateName);
			if (application.currentState != desiredState.name) {
				return false;
			}
			return true;
		}
		
		/**
		 * Returns true if the state alias is specified in the parameters 
		 * will return false if the value is null or empty unless returnFalseIfNull is true
		 * 
		 * */
		public function isStateSpecifiedInParameters(parameters:String, returnFalseIfNull:Boolean = true):Boolean {
			var parametersObject:Object;
			var stateExists:Boolean = false;
			
			if (parameters) {
				parametersObject = URLUtil.stringToObject(parameters, parameterSetSeparator, decodeURL);
				
				// check if state parameter exists
				if (parametersObject.hasOwnProperty(STATE_PARAMETER_ALIAS)) {
					
					// if state parameter is not null return true
					if (parametersObject[STATE_PARAMETER_ALIAS]!="" &&
						parametersObject[STATE_PARAMETER_ALIAS]!="null" && 
						parametersObject[STATE_PARAMETER_ALIAS]!=null) {
						
						return true;
					}
						
						// if parameter exists and its empty still return true
					else if (returnFalseIfNull) {
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * Returns true if the anchor alias is specified in the parameters 
		 * will return false if the value is null or empty unless returnFalseIfNull is true
		 * 
		 * */
		public function isAnchorSpecifiedInParameters(parameters:String, returnFalseIfNull:Boolean = true):Boolean {
			var parametersObject:Object;
			var anchorExists:Boolean = false;
			
			if (parameters) {
				parametersObject = URLUtil.stringToObject(parameters, parameterSetSeparator, decodeURL);
				
				// check if anchor parameter exists
				if (parametersObject.hasOwnProperty(ANCHOR_PARAMETER_ALIAS)) {
					
					// if anchor parameter is not null return true
					if (parametersObject[ANCHOR_PARAMETER_ALIAS]!="" &&
						parametersObject[ANCHOR_PARAMETER_ALIAS]!="null" && 
						parametersObject[ANCHOR_PARAMETER_ALIAS]!=null) {
						return true;
					}
						
						// if parameter exists and its empty still return true
					else if (returnFalseIfNull) {
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * Returns the value of the anchor specified in the parameters
		 * 
		 * */
		public function getAnchorSpecifiedInParameters(parameters:String):String {
			return getKeySpecifiedInParameters(ANCHOR_PARAMETER_ALIAS, parameters);
		}
		
		/**
		 * Returns the value of the state specified in the parameters
		 * 
		 * */
		public function getStateSpecifiedInParameters(parameters:String):String {
			return getKeySpecifiedInParameters(STATE_PARAMETER_ALIAS, parameters);
		}
		
		/**
		 * Returns the value of the key specified in the parameters
		 * 
		 * */
		public function getKeySpecifiedInParameters(key:String, parameters:String):String {
			var parametersObject:Object;
			var keyValue:String;
			
			if (parameters) {
				parametersObject = URLUtil.stringToObject(parameters, parameterSetSeparator, decodeURL);
				
				// get state name
				if (parametersObject.hasOwnProperty(key) ) {
					keyValue = parametersObject[key];
					return keyValue;
				}
			}
			
			return keyValue;
		}
		
		// go to desired state if it exists deprecated?
		// checks for home state keyword
		// if state isn't found it checks if stateNotFoundState is set and if so redirects to there
		public function setState(stateName:String, title:String = ""):void {
			var stateFound:Boolean = stateExists(stateName);
			var desiredState:State = findState(stateName);
			var isBaseState:Boolean = isBaseState(stateName);
			var fragment:String = browserManager.fragment; // this is null if link manager hasn't been created
			var currentStateLocal:String = getCurrentState();
			
			if (isBaseState) {
				// if state exists then move to the state
				stateTitle = "";
				currentState = BASE_STATE_ALIAS;
				
				if (currentStateLocal != "" && currentStateLocal != null) {
					application.setCurrentState("");
					
				}
				
				// get fragment but don't include anchor
				var derivedFragment:String = deriveFragment(false);
				fragment = browserManager.fragment;
				
				// if we are on the same state but the anchor or parameters have changed
				// we need to update the fragment
				if (fragment!=derivedFragment) {
					browserManager.setFragment(derivedFragment);
				}
				
				// move to any anchors if we have them
				if (anchorPending) {
					anchorManager.addAnchorWatch(anchorName, getCurrentState());
				}
				else {
					anchorManager.scrollToTop();
				}
				
				updateURLFragment = true;
				browserManager.setTitle(fullTitle);
			}
			else if (stateFound) {
				// if state exists then move to the state
				stateTitle = desiredState.name;
				currentState = stateName;
				
				if (application.currentState != desiredState.name) {
					application.setCurrentState(desiredState.name);
				}
				else {
					derivedFragment = deriveFragment(false);
					
					// if we are on the same state but the anchor or parameters have changed
					// we need to update the fragment
					if (fragment!=derivedFragment) {
						browserManager.setFragment(derivedFragment);
					}
					
					// move to any anchors if we have them
					if (anchorPending) {
						anchorManager.addAnchorWatch(anchorName, getCurrentState());
					}
					else {
						anchorManager.scrollToTop();
					}
				}
				
				updateURLFragment = true;
				browserManager.setTitle(fullTitle);
			}
			else {
				traceConsole("Link Manager: State in setState was not found, '" + stateName + "'");
				
				stateTitle = '';
				
				if (stateNotFoundState!=null && stateNotFoundState!="") {
					currentState = String(stateNotFoundState);
					application.currentState = String(stateNotFoundState);
				}
				else {
					currentState = "";
					browserManager.setFragment("");
				}
				
				updateURLFragment = true;
				browserManager.setTitle(fullTitle);
			}
		}
		
		// adds support for google analytics
		// you must enable the property enableGoogleAnalytics
		// and add the google analytics javascript code to the html-template/index.template.html file
		public function googleAnalyticsHandler():void {
			ExternalInterface.call("pageTracker._trackPageview", "/#" + browserManager.fragment);
		}
		
		// we shouldn't need this anymore with state options
		public function cleanStateName(value:String = ""):String {
			// capitalize the first letter
			// replace underscores with spaces
			if (value==null) value ="";
			
			value = value.replace(/_/g, " ");
			
			return value;
		}
		
		// checks to see if this handler should run in the state we are in
		public function isHandlerInState(handler:Handler, state:String = ""):Boolean {
			var handlerIncluded:Boolean = true;
			state = (state=="") ? currentState : state;
			// handle base state
			
			// INCLUDE CONDITIONS //
			// includeInStates is an array of states
			if (handler.includeInStates is Array) {
				handlerIncluded = false;
				
				// loop through the array of states and see if it matches the current state
				for each (var value:* in handler.includeInStates) {
					
					// if value is state and the state is found we are supposed to include it - return true
					if (value is State &&
						(State(value).name.toLowerCase()==state.toLowerCase())) {
						handlerIncluded = false;
					}
						
						// if value is a string and the state is found include it - return true
					else if (value is String &&
						(String(value).toLowerCase()==state.toLowerCase())) {
						handlerIncluded = true;
					}
				}
			}
				
				// includeInStates is a single state
			else if (handler.includeInStates is State) {
				if (State(handler.includeInStates).name.toLowerCase()==state.toLowerCase()) {
					handlerIncluded = true;
				}
				else {
					handlerIncluded = false;
				}
			}
				
				// includeInStates is a string of a state
			else if (handler.includeInStates is String && handler.includeInStates!="") {
				
				// if the state is found include it - return true
				if (String(handler.includeInStates).toLowerCase()==state.toLowerCase()) {
					handlerIncluded = true;
				}
				else {
					handlerIncluded = false;
				}
			}
			
			// EXCLUDE CONDITIONS //
			// check what states we should exclude
			if (handler.excludeFromStates is Array) {
				// by default handler should be included (true) but if includeInStates is set we leave it as is
				handlerIncluded = (handler.includeInStates=="" || handler.includeInStates==null) ? true : handlerIncluded;
				
				// loop through the array of states and see if it matches the current state
				for each (value in handler.excludeFromStates) {
					
					// if value is a state and the state is found we are supposed to exclude it - return false
					if (value is State &&
						(State(value).name.toLowerCase()==state.toLowerCase())) {
						handlerIncluded = false;
					}
					
					// if the value is a string and the state is found we are supposed to exclude it - return false
					if (value is String &&
						(value.toLowerCase()==state.toLowerCase())) {
						handlerIncluded = false;
					}
				}
			}
				
				// excludeFromStates is a single state
			else if (handler.excludeFromStates is State) {
				
				// if the state is found we are supposed to exclude it - return false
				if (State(handler.excludeFromStates).name.toLowerCase()==state.toLowerCase()) {
					handlerIncluded = false;
				}
			}
				
				// excludeFromStates is a string of a state
			else if (handler.excludeFromStates is String && handler.excludeFromStates!="" && handler.excludeFromStates!=null) {
				
				// if the state is found we are supposed to exclude it - return false
				if (String(handler.excludeFromStates).toLowerCase()==state.toLowerCase()) {
					handlerIncluded = false;
				}
			}
			
			return handlerIncluded;
		}
		
		// checks whether the custom parameter should be added to the url
		// when moving to a new state
		public function addParameterToState(item:ParameterProperty, state:String):Boolean {
			var add:Boolean = true;
			
			// loop through the states to include it in
			if (item.includeInStates is Array) {
				add = false;
				for each (var value:String in item.includeInStates) {
					if (value.toLowerCase()==state.toLowerCase()) {
						add = true;
					}
				}
			}
			else if (item.includeInStates is String && item.includeInStates!="") {
				if (String(item.includeInStates).toLowerCase()==state.toLowerCase()) {
					add = true;
				}
				else {
					add = false;
				}
			}
			
			// check if we should exclude the parameter
			if (item.excludeFromStates is Array) {
				// add is left to previous value
				for each (value in item.excludeFromStates) {
					// if the state is found we are supposed to exclude it - return false
					if (value.toLowerCase()==state.toLowerCase()) {
						add = false;
					}
				}
			}
			else if (item.excludeFromStates is String && item.excludeFromStates!="") {
				// if the state is found we are supposed to exclude it - return false
				if (String(item.excludeFromStates).toLowerCase()==state.toLowerCase()) {
					add = false;
				}
				else {
					add = true;
				}
			}
			
			// if none of the conditions apply then we add it
			return add;
		}
		
		// returns an object or string of values to be appended to the url
		public function getDynamicParameters(getString:Boolean = false):Object {
			var parametersObject:Object = {};
			var state:String = getCurrentState(isFlex3);
			var includeInState:Boolean = true;
			var value:String = "";
			
			// loop through the parameters list and find any parameters we may need to add
			for each (var item:ParameterProperty in dynamicParameters) {
				
				// check if we are on a state to be included and we are not on a state to be excluded
				includeInState = addParameterToState(item, state);
				
				if (includeInState) {
					
					// check if target exists and has the property we want to watch
					if (item.target && Object(item.target).hasOwnProperty(item.propertyName)) {
						
						// get value from target
						value = item.target[item.propertyName];
						
						// check if the value is blank or empty
						if (value=="" || value==null) {
							
							// if it is empty do we want to include it
							if (item.includeIfPropertyIsEmpty) {
								parametersObject[item.parameterName] = "";
							}
						}
						else {
							parametersObject[item.parameterName] = value;
						}
					}
					else {
						if (debug) {
							traceConsole("Link Manager: Parameter target '" + item.target + "' does not contain property " + item.propertyName);
							if (item.target is String) {
								traceConsole("Link Manager: Currently parameter target must be a reference not a string. ");
							}
						}
					}
				}
			}
			
			if (!getString) {
				return parametersObject;
			}
			else {
				return URLUtil.objectToString(parametersObject, parameterSetSeparator, encodeURL);
			}
		}
		
		// get and return any parameters we need to add to the url fragment
		public function getParametersList(encode:Boolean = false):String {
			var parametersObject:Object = {};
			var state:String = currentState;
			var includedState:Boolean = true;
			var value:String = "";
			
			// loop through the parameters list and find any parameters we may need to add
			for each (var item:ParameterProperty in dynamicParameters) {
				
				// check if we are on a state to be included and we are not on a state to be excluded
				includedState = addParameterToState(item, state);
				
				if (includedState) {
					
					// check if target exists and has the property we want to watch
					if (item.target && Object(item.target).hasOwnProperty(item.propertyName)) {
						
						// get value from target
						value = item.target[item.propertyName];
						
						// check if the value is blank or empty
						if (value=="" || value==null) {
							
							// if it is empty do we want to include it
							if (item.includeIfPropertyIsEmpty) {
								parametersObject[item.parameterName] = "";
							}
						}
						else {
							parametersObject[item.parameterName] = value;
						}
					}
				}
			}
			
			return URLUtil.objectToString(parametersObject, parameterSetSeparator, encode);
		}
		
		public function clearContentLoadingQueue():void {
			contentLoadingItems.removeAll();
		}
		
		public function cancelServiceCalls():void {
			//TODO: cancelServiceCalls
		}
		
		public function cancelHandlers():void {
			//TODO: cancelHandlers
		}
		
		public function addContentLoadingItem(item:ContentLoadingItem):void {
			var exists:Boolean = contentLoadingItems.contains(item);
			var itemIndex:int = ArrayUtils.getItemIndexByProperty(contentLoadingItems, "id", item.id);
			var index:uint;
			
			// remove previous instances
			if (exists) {
				index = contentLoadingItems.getItemIndex(item);
				contentLoadingItems.removeItemAt(index);
			}
			
			// for some reason there are sometimes two extra items
			// i think it could be a bug with repeaters
			// better to be greedy here since the alternative is not dispatching the content complete events
			if (itemIndex!=-1) {
				contentLoadingItems.removeItemAt(itemIndex);
			}
			trace("Link Manager: Adding " + item.id + " to the content loading queue");
			contentLoadingItems.addItem(item);
		}
		
		public function removeContentLoadingItem(item:ContentLoadingItem, dispatchEvents:Boolean = true):void {
			var items:ArrayCollection = contentLoadingItems;
			var exists:Boolean = contentLoadingItems.contains(item);
			var index:int;
			
			if (exists) {
				trace("Link Manager: Removing " + item.id + " from the content loading queue");
				index = contentLoadingItems.getItemIndex(item);
				contentLoadingItems.removeItemAt(index);
			}
			
			
			if (contentLoadingItems.length == 0 && dispatchEvents) {
				trace("Link Manager: Content Update Complete");
				dispatchEvent(new Event(CONTENT_UPDATE_COMPLETE));
				hidePreloaders();
			}
		}
		
		// removes the parameters separator character from the beginning and the end of the string 
		public function cleanParametersString(value:String = ""):String {
			
			value = (value.lastIndexOf(parameterSetSeparator)==value.length-1) ? value.substr(0, value.length-1) : value;
			value = (value.indexOf(parameterSetSeparator)==0) ? value.substr(1, value.length) : value;
			return value;
		}
		
		protected function decodeURLQueryString(url:String = ""):String {
			var query:String = "";
			var base:String = "";
			var fragment:String = "";
			var temp:Array = [];
			var match:Array;
			var variables:URLVariables;
			
			if (url==null) return "";
			match = url.match(/\?((?P<query>[^#]*)#?(?P<fragment>.*))/);
			
			// TODO: we should also check the fragment for an anchor
			if (match!=null && match.query!=null) {
				query = match.query;
				query = query.replace(/&/g, ";");
			}
			return query;
		}
		
		public function isLinkVisited(hyperlink:String):Boolean {
			var currentFragment:String = getFragment();
			
			if (hyperlink=="") {
				return false;
			}
			
			var historyInfoIndex:int = ArrayUtils.getItemIndexByProperty(history, "fragment", hyperlink);
			var historyInfo:HistoryInfo;
			
			// if found update
			if (historyInfoIndex!=-1) {
				return true;
			}
			return false;
		}
		
		public function isLinkActive(hyperlink:String):Boolean {
			var currentFragment:String = getFragment();
			var currentLinkInfo:LinkInfo = getLinkInfo(currentFragment);
			var hyperlinkInfo:LinkInfo = getLinkInfo(hyperlink);
			
			if (!hyperlinkInfo.isURL && hyperlinkInfo.fragment==currentLinkInfo.fragment) {
				return true;
			}
			return false;
		}
		
		public function get scroller():Object {
			if (!isFlex3) {
				if (application.hasOwnProperty("contentGroup")) {
					for (var i:int=0;i<Object(application.contentGroup).numChildren;i++) {
						var item:Object = Object(application.contentGroup).getChildAt(i);
						
						if (item is Scroller) {
							return item;
						}
					}
				}
				
				//trace("No scroller was found. Please wrap your content in a Scroller component");
				return null;
			}
			
			return null;
		}
		
		private function traceConsole(value:String):void {
			if (debug) {
				trace(value);
			}
			if (debugComponent) {
				if (debugComponent.hasOwnProperty("text")) {
					debugComponent.text += value + "\n";
				}
			}
		}
	}
}