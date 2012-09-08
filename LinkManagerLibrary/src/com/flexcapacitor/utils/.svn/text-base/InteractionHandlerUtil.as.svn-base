




package com.flexcapacitor.utils {
	import com.flexcapacitor.handlers.InteractionHandler;
	import com.flexcapacitor.managers.LinkManager;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mx.core.Application;
	
	public class InteractionHandlerUtil {
		
		public function InteractionHandlerUtil(target:Object = null, event:String = null, faultEvent:Object = null) {
			// 
		}
		
		// number of frames to wait
		public var frames:int = 0;
		
		public var currentFrameIndex:int = 0;
		
		// number of seconds to wait
		public var seconds:Number = 0;
		
		/**
		 * reference to the handler this action is part of
		 **/
		public var handler:InteractionHandler;
		
		private var _event:Object = "result";
		
		[Inspectable(category="General")]
		/**
		 *  The name of the event to listen for
		 */
		public function set event(value:Object):void {
			_event = value;
		}
		
		/**
		 *  @private
		 */
		public function get event():Object {
			return _event;
		}
		
		private var _target:Object;
		
		[Inspectable(category="General")]
		/**
		 *  The name of the target that dispatches event
		 */
		public function set target(value:Object):void {
			_target = value;
		}
		
		/**
		 *  @private
		 */
		public function get target():Object {
			return _target;
		}
		
		private var _fault:Object;
		
		[Inspectable(category="General")]
		public function set faultEvent(value:Object):void {
			_fault = value;
		}
		
		/**
		 *  @private
		 */
		public function get faultEvent():Object {
			return _fault;
		}
		
		public function addTimeListeners(handler:InteractionHandler, target:Object, seconds:Number = 1):void {
			this.handler = handler;
			this.seconds = seconds;
			this.target = target;
			
			// pause applying actions until we get the events we need
			handler.pauseActions = true;
			
			var milliseconds:int = seconds * 1000;
			var event:Event = new Event("time");
			setTimeout(continueActionsHandler, milliseconds, event);
		}
		
		public function addFrameListeners(handler:InteractionHandler, target:Object, frames:int = 1, eventName:String = null):void {
			currentFrameIndex = 0;
			this.handler = handler;
			this.frames = frames;
			this.target = target;
			
			// pause applying actions until we get the events we need
			handler.pauseActions = true;
			
			if (eventName==null) {
				eventName = Event.ENTER_FRAME;
			}
			
			// wait a specific number of frames
			if (frames!=0) {
				target.addEventListener(eventName, continueActionsHandler, false, 0, true);
			}
		}
		
		public function addEventListeners(handler:InteractionHandler, target:Object, event:Array, faultEvent:Array = null):void {
			// we could add seconds to this list
			this.handler = handler;
			
			// wait for an event
			if (target.hasOwnProperty("addEventListener")) {
				if (event is Array) {
					for each (var eventName:String in event) {
						IEventDispatcher(target).addEventListener(eventName, continueActionsHandler, false, 0, true);
					}
				}
				
				if (faultEvent!=null) {
					for each (var faultEventName:String in faultEvent) {
						IEventDispatcher(target).addEventListener(faultEventName, continueActionsHandler, false, 0, true);
					}
				}
			}
			
			// pause applying actions until we get the events we need
			handler.pauseActions = true;
			
			// when all handlers have ran their actions then we dispatch an actions complete event
			/*if (linkManager.ranStartUpHandlers) {
			handler.addEventListener(Handler.ACTIONS_COMPLETE, linkManager.handlerActionsComplete);
			linkManager.handlersQueue.addItem(handler);
			}*/
			
		}
		
		public function continueActionsHandler(event:Event):void {
			// remove previous event listeners
			var startIndex:int = handler.currentActionIndex + 1;
			target = event.target;
			
			// wait a specified number of seconds
			if (seconds!=0) {
				handler.pauseActions = false;
				handler.runActions(handler.actions, startIndex);
			}
				
			// wait a specific number of frames
			else if (frames!=0) {
				currentFrameIndex++;
				if (currentFrameIndex>=frames) {
					target.removeEventListener(Event.ENTER_FRAME, continueActionsHandler);
					handler.pauseActions = false;
					handler.runActions(handler.actions, startIndex);
				}
			}
				
			// wait for an event
			else if (target.hasOwnProperty("addEventListener")) {
				
				if (event.type==this.event) {
					handler.pauseActions = false;
					target.removeEventListener(event.type, continueActionsHandler);
					handler.runActions(handler.actions, startIndex);
				}
					
				else if (event.type == this.faultEvent) {
					handler.pauseActions = false;
					target.removeEventListener(event.type, continueActionsHandler);
					handler.runActions(handler.faultActions);
				}
			}
		}
	}
}