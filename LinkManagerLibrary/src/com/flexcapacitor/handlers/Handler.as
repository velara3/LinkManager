




package com.flexcapacitor.handlers {
	
	import com.flexcapacitor.actions.Action;
	import com.flexcapacitor.managers.LinkManager;
	import com.flexcapacitor.proxy.ParametersProxy;
	import com.flexcapacitor.utils.ApplicationUtils;
	import com.flexcapacitor.utils.ClassUtils;
	import com.flexcapacitor.vo.LinkInfo;
	
	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.FlexVersion;
	
	// dispatches before actions start
	[Event(name="actionsStart", type="flash.events.Event")]
	
	// dispatches when all actions have completed running
	[Event(name="actionsComplete", type="flash.events.Event")]
	
	public class Handler extends EventDispatcher {
		
		public static const ACTIONS_START:String = "actionsStart";
		
		public static const ACTIONS_COMPLETE:String = "actionsComplete";
		
		[Bindable]
		// when enabled this handler is active
		// when not enabled this handler is ignored
		public var enabled:Boolean = true;
		
		// the state or the name of the state to redirect to when the 
		// state in a hyperlink or action is not found
		public var stateNotFoundState:Object;
		
		private var _runAfterStateChange:Boolean = true;
		
		// class containing information about the link event
		[Bindable]
		public var linkInfo:LinkInfo = new LinkInfo();
		
		protected var _runOnEveryClick:Boolean = false;
		
		// runs every time you click the link even on the current state
		[Bindable]
		public function set runOnEveryClick(value:Boolean):void {
			_runOnEveryClick = value;
		}
		
		public function get runOnEveryClick():Boolean {
			return _runOnEveryClick;
		}
		
		private var _value:String;
		
		// parameter value found on hyperlink
		[Bindable]
		public function set value(value:String):void {
			_value = value;
		}
		
		public function get value():String {
			return _value;
		}
		
		// ran once - set to true after the handler has ran once on the current state
		// set to false when runOnEveryClick is enabled
		public var ranOnce:Boolean = false;
		
		// when set to true and no parameters exist then this handler is called
		[Bindable]
		public var hasNoParameters:Boolean = false;
		
		// Run this handler at startup after required handlers are run
		[Bindable]
		public var runAtStartup:Boolean = true;
		
		// scrolls the application to the top after actions are run
		[Bindable]
		public var scrollToTop:Boolean = false;
		
		// state or states that parameter handler should respond in
		// can be an array of states or single state
		// leaving it blank includes it in all states
		public var includeInStates:* = "";
		
		// state or states that parameter should respond in
		// can be an array of states or single state
		// leaving it blank includes it in all states
		public var excludeFromStates:* = "";
		
		// list of actions to perform when the handler is run
		public var actions:Array = new Array();
		
		// internal list of actions to perform when the handler is run
		// inherited from link manager
		public var defaultActions:Array = new Array();
		
		// list of actions to perform when a fault event occurs
		// see faultAfterEvent and faultAfterEventTarget
		public var faultActions:Array = new Array();
		
		// current action (behavior)
		public var currentAction:Action;
		
		// current action index
		public var currentActionIndex:int = 0;
		
		// pauses actions 
		// usually used with Wait action 
		// Wait action waits until the event specified has occured
		public var pauseActions:Boolean = false;
		
		// stop and exit actions and exit
		public var exitActions:Boolean = false;
		
		// list of conditions to be met when the handler is run
		public var conditions:Array = new Array();
		
		// result list of conditions that were last ran
		public var conditionsReport:Array = new Array();
		
		[Bindable]
		// object used to store your custom data specific to current handler 
		public var data:Object = new Object();
		
		// name of handler
		public var name:String = "";
		
		// should we dispatch events
		public var dispatchEvents:Boolean = true;
		
		public var isFlex3:Boolean = FlexVersion.compatibilityVersionString=="3.0.0";
		
		// used to display condition reports and trace messages to the console
		// use debugHandlerConditions to walk through parameter conditions
		public var debug:Boolean = false;
		
		[Bindable]
		// parameters proxy allows you to access the parameters by name
		// use the parametersMap property to set the names for the values
		// if a parameter map is set on the handler it overrides the parameter map 
		// set on the link manager
		public var parameters:ParametersProxy = new ParametersProxy();
		
		/**
		 * set to true to enter the debugger when checking if the condition is able to run
		 **/
		public var debugHandlerConditions:Boolean = false;
		
		public function Handler(target:IEventDispatcher=null) {
			super(target);
		}
		
		public function get application():Object {
			var document:Object = LinkManager.getInstance().document || FlexGlobals.topLevelApplication; 
			return document;
		}
		
		public function validate():Boolean {
			var valid:Boolean = true;
			conditionsReport.length = 0;
			
			// run through the conditions and see if we meet them
			for each (var condition:Condition in conditions) {
				condition.debug = debug;
				if (condition.validate()) {
					conditionsReport.push(condition.conditionReport);
					continue;
				}
				else {
					conditionsReport.push(condition.conditionReport);
					valid = false;
				}
			}
			
			if (debug) {
				// passed all conditions to run
				if (conditionsReport.length==0) {
					//trace("ActionHandler: Conditions Report Valid");
				}
				else {
					trace("ActionHandler: Conditions Report \n\t" + conditionsReport.join("\n\t"));
				}
			}
			
			return valid;
		}
		
		// override this method
		public function run():void {
			
		}
		
		// loop through the default actions and remove ones the user has specified
		public function mixArrays(defaultActions:Array, actions:Array):Array {
			var beforeArray:Array = [];
			var afterArray:Array = [];
			var mixedArray:Array = [];
			var newDefaultActions:Array = [];
			var classNames:Array = [];
			var actionsLength:int = actions.length;
			var defaultActionsLength:int = defaultActions.length;
			var action:Action;
			var i:int=0;
			var scrollToPosition:Action;
			
			// get list of classes
			for (i=0;i<actionsLength;i++) {
				action = actions[i];
				var actionClassName:String = Object(action).constructor;
				classNames.push(actionClassName);
			}
			
			// loop through the default actions and remove ones the user has specified 
			for (i=0;i<defaultActionsLength;i++) {
				var defaultAction:Action = defaultActions[i];
				var defaultActionClassName:String = Object(defaultAction).constructor;
				
				// remove this class if it's part of the actions
				// this means the user is adding his own behavior 
				// sort of a brute force override
				if (classNames.indexOf(defaultActionClassName)!=-1 && defaultActionClassName!="[class Wait]") {
					continue;
				}
				else {
					if (defaultActionClassName!="[class ScrollToPosition]") {
						newDefaultActions.push(defaultAction);
					}
					else {
						scrollToPosition = defaultAction;
					}
				}
			}
			
			// loop through the user actions and place them before or after the default actions stack
			for (i=0;i<actionsLength;i++) {
				action = actions[i];
				if (action.occurs=="before") {
					beforeArray.push(action);
					continue;
				}
				
				if (action.occurs=="after") {
					afterArray.push(action);
					continue;
				}
			}
			
			mixedArray = beforeArray.concat(newDefaultActions.concat(afterArray));
			// always add scroll to position at the end
			if (scrollToPosition!=null) {
				mixedArray.push(scrollToPosition);
			}
			
			return mixedArray;
		}
		
		// todo: add support for fault actions
		public function runActions(currentActions:Array = null, startIndex:int = 0):void {
			//if (enterDebuggingSession) trace("\t\t - Entering debugger... press the Step Over button...");
			//if (enterDebuggingSession) enterDebugger();
			var linkManager:LinkManager = LinkManager.getInstance();
			
			var i:int = startIndex;
			var mixedArray:Array = [];
			currentActions = (currentActions==null) ? actions : currentActions;
			
			mixedArray = mixArrays(defaultActions, currentActions);
			var length:int = mixedArray.length;
			
			
			// dispatch an event before any actions have run
			if (i == 0 && dispatchEvents) {
				dispatchEvent(new Event(ACTIONS_START));
			}
			
			var application:Object = linkManager.document;
			
			
			// run through actions and see if we need to do anything
			for (;i<length;i++) {
				currentActionIndex = i;
				var parent:* = application;
				var target:*; // = application;
				var action:Action = mixedArray[i];
				
				action.linkManager = LinkManager.getInstance();
				action.handler = this;
				action.linkInfo = linkInfo;
				currentAction = action;
				
				
				// show current action messages in console
				if (debug || action.debug) {
					trace(ClassUtils.staticInstance.getClassName(action));
				}
				
				
				if (Object(action).hasOwnProperty("apply")) {
					if (Object(action).hasOwnProperty("target")) {
						target = action["target"];
						
						// set the target if not set
						if (target==null) {
							target = application;
							//action["target"] = target;
						}
						
						// set the parent if target is available
						if (target && !target is Application && Object(target).hasOwnProperty("parent") && DisplayObject(target).parent!=null) {
							parent = DisplayObject(target).parent;
						}
					}
					
					// Enter debugger
					if (action.debugCode) trace("\n\t " + ClassUtils.staticInstance.getClassName(action) + ": Entering debugger... press the Step Into button...");
					if (action.debugCode) enterDebugger();
					
					// add continue after event listeners
					if (action.continueAfterEvent) {
						action.addContinueAfterListeners(this, target);
					}
						
						// add continue after event listeners
					else if (action.continueAfterFrames) {
						action.addContinueAfterFrames(this, target, action.continueAfterFrames);
					}
						
						// add continue after event listeners
					else if (action.continueAfterTime) {
						action.addContinueAfterTime(this, target, action.continueAfterTime);
					}
					
					
					// run the action
					if (action.dispatchEvents) {
						action.applyAndDispatch(parent);
					}
					else {
						action.apply(parent);
					}
					
					// an action may set the pauseActions property to true
					// we stop running through the array and usually an event
					// will trigger it to continue later where it left off
					if (pauseActions) {
						if (linkManager.ranStartUpHandlers) {
							addEventListener(Handler.ACTIONS_COMPLETE, linkManager.handlerActionsComplete);
							linkManager.handlersQueue.addItem(this);
						}
						break;
					}
					
					if (exitActions) {
						currentActionIndex = length;
						i = length;
						exitActions = false;
						break;
					}
				}
			}
			
			// dispatch an event after all actions have run
			if (i == length && dispatchEvents) {
				dispatchEvent(new Event(ACTIONS_COMPLETE));
			}
		}
		
		// deprecated
		// todo: update this to pass in an event that has the actions on it
		public function continueActionsHandler(event:Event):void {
			var startIndex:int = currentActionIndex + 1;
			pauseActions = false;
			runActions(actions, startIndex);
		}
		
		public function resetActions():void {
			currentAction = null;
			currentActionIndex = 0;
		}
		
		public function faultActionsHandler(event:Event):void {
			pauseActions = false;
			runActions(faultActions);
		}
		
		public function resetHandler():void {
			if (runOnEveryClick) {
				ranOnce = false;
			}
		}
	}
}