




package com.flexcapacitor.actions {
	
	import com.flexcapacitor.handlers.InteractionHandler;
	import com.flexcapacitor.utils.InteractionHandlerUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.core.FlexGlobals;
	import mx.core.IMXMLObject;
	import mx.core.UIComponent;

	public class Interaction extends EventDispatcher implements IMXMLObject, IAction {
		
		public const ACTION_START:String = "actionStart";
		public const ACTION_COMPLETE:String = "actionComplete";

		private var _continueAfterEvents:Array = new Array();

		private var _faultAfterEvents:Array = new Array();
		
		/**
		 * 
		 * target of event that pauses the execution of actions until it is dispatched. default is application
		 * for example, if you make a http service call you can set this to the instance and listen for 
		 * a "result" event. the actions will stop executing until this event occurs
		 * after this event occurs execution will continue with the next action
		 * see also continueAfterEventTarget and faultAfterEvent and handler.faultActions
		 **/
		public var continueAfterEventTarget:Object;
		
		/**
		 * 
		 * target of event that runs the handler.faultActions - default is application
		 **/
		public var faultAfterEventTarget:Object;
		
		/**
		 * reference to the handler this action is part of
		 **/
		public var handler:InteractionHandler;
		
		/**
		 * Adds event handlers to pause and then continue on
		 * */
		 public var interactionUtils:InteractionHandlerUtil = new InteractionHandlerUtil();
		 
		 /**
		 * Dispatches events if true
		 * */
		 public var dispatchEvents:Boolean = true;
		 
		 /**
		 * Event frame type. Default is Event.ENTER_FRAME
		 * */
		 public var eventFrameType:String = Event.ENTER_FRAME;
		 
		/**
		 * set to true to enter the debugger in the behavior apply method
		 **/
		 [Inspectable(category="General")]
		public var debugCode:Boolean = false;
		
		/**
		 * debug - shows debug messages
		 * inherits from handler and link manager
		 **/
		[Inspectable(category="General")]
		public var debug:Boolean;
		
		
		public function Interaction(target:IEventDispatcher=null) {
			super(target);
		}
		
		/**
		 *
		 * event that runs the handler.faultActions when it is dispatched
		 **/
		public function get faultAfterEvent():Array {
			return _faultAfterEvents.length>0 ? _faultAfterEvents[0] : null;
		}

		public function set faultAfterEvent(value:Array):void {
			_faultAfterEvents = [value];
		}
		
		/**
		 * 
		 **/
		public function get faultAfterEvents():Array {
			return _faultAfterEvents;
		}

		public function set faultAfterEvents(value:Array):void {
			_faultAfterEvents = value;
		}
		
		/** 
		 *
		 * Event that pauses the execution of actions until it is dispatched
		 * for example, if you make a http service call you can set this to the "result" event
		 * and actions will stop executing until this event occurs
		 * after this event occurs execution will continue with the next action
		 * see also continueAfterEventTarget and faultAfterEvent and handler.faultActions
		 **/
		public function get continueAfterEvent():String {
			return _continueAfterEvents.length>0 ? _continueAfterEvents[0] : null;
		}

		public function set continueAfterEvent(value:String):void {
			_continueAfterEvents = [value];
		}
		
		/** 
		 *
		 * Events that pause the execution of actions until one of the events is dispatched
		 * for example, if you make a http service call you can set this to the "result" event
		 * and actions will stop executing until this event occurs
		 * after this event occurs execution will continue with the next action
		 * see also continueAfterEventTarget and faultAfterEvent and handler.faultActions
		 **/
		public function get continueAfterEvents():Array {
			return _continueAfterEvents;
		}

		public function set continueAfterEvents(value:Array):void {
			_continueAfterEvents = value;
		}
		
		
		private var _occurs:String = "after";
		
		/**
		 * When this action runs in relation to the go to state action.
		 * Values can be before or after. Default is after.
		 * */ 
		[Inspectable(category="General",enumeration="before,after,never")]
		public function set occurs(value:String):void {
			_occurs = value;
		}
		
		/**
		 *  @private
		 */
		public function get occurs():String {
			return _occurs;
		}
		
		
		private var _frames:int = 0;
		
		/**
		 * Number of frames to pass before continuing actions
		 * */ 
		[Inspectable(category="General")]
		public function set continueAfterFrames(value:int):void {
			_frames = value;
		}
		
		/**
		 *  @private
		 */
		public function get continueAfterFrames():int {
			return _frames;
		}
		
		
		private var _seconds:Number = 0;
		
		/**
		 * Number of seconds to pass before continuing actions
		 * */ 
		[Inspectable(category="General")]
		public function set continueAfterTime(value:Number):void {
			_seconds = value;
		}
		
		/**
		 *  @private
		 */
		public function get continueAfterTime():Number {
			return _seconds;
		}
		
		/**
		 * Gets reference to the parent application NOT the top level application
		 * This is to allow your app to be embedded in another app and still work
		 * */
		public function get application():Object {
			var document:Object = FlexGlobals.topLevelApplication; 
			return document;
		}

		public function initialized(document:Object, id:String):void {
			this.document = document;
			this.documentID = id;
		}
		
		/**
		 * Reference to the MXML document this action is created in or null if created via Actionscript
		 * */
		[Bindable]
		public var document:Object;
		
		/**
		 * ID of the MXML document this action is created in or null if created via Actionscript
		 * */
		[Bindable]
		public var documentID:String;
		
		/**
		 * Location to place your code when you create your own actions.
		 * Override this method when you extend this class
		 **/
		public function apply(parent:UIComponent = null):void {
			
		}
		
		/**
		 * dispatches start and complete events and applys the action
		 **/
		public function applyAndDispatch(parent:UIComponent = null):void {
			dispatchEvent(new Event(ACTION_START));
			apply(parent);
			dispatchEvent(new Event(ACTION_COMPLETE));
			
		}
		
		/**
		 * Add listeners that we will continue running through actions after we receive the event
		 * listeners are called in the event handler util class
		 * */
		public function addContinueAfterListeners(handler:InteractionHandler, parent:IEventDispatcher = null):void {
			continueAfterEventTarget = continueAfterEventTarget ? continueAfterEventTarget : parent;
			interactionUtils.addEventListeners(handler, continueAfterEventTarget, continueAfterEvents, faultAfterEvents);
		}
		
		/**
		 * Add listeners to listen to frames
		 * 
		 * */
		public function addContinueAfterFrames(handler:InteractionHandler, target:Object, frames:int):void {
			interactionUtils.addFrameListeners(handler, target, frames);
		}
		
		/**
		 * Add listeners that we will continue running through actions after we receive the event
		 * 
		 * */
		public function addContinueAfterTime(handler:InteractionHandler, target:Object, time:Number):void {
			interactionUtils.addTimeListeners(handler, target, time);
		}
	}
}