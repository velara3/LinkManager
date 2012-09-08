




package com.flexcapacitor.actions {
	
	import com.flexcapacitor.managers.LinkManager;
	import com.flexcapacitor.utils.InheritanceLookup;
	import com.flexcapacitor.utils.StateUtils;
	import com.flexcapacitor.vo.LinkInfo;
	
	import flash.debugger.enterDebugger;
	import flash.events.Event;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.modules.ModuleLoader;
	import mx.states.SetProperty;
	import mx.states.State;

	/** 
	 *  Dispatched when the state specified in the state property or hyperlink was not found on the target
	 *  @eventType flash.events.Event
	 */
	[Event(name="goToStateFault", type="flash.events.Event")]
	
	public class GoToState extends Action implements IDefaultAction {
		
		protected var instance:mx.states.SetProperty;
		
		public function GoToState(target:Object = null, value:Object = null) {
			instance = new mx.states.SetProperty(target, "currentState", value);
			
		}
		
		private var _stateNotFoundStateName:String;
		
		/**
		 *  @private
		 */
		public function get stateNotFoundState():String {
			return _stateNotFoundStateName;
		}
		
		[Inspectable(category="General")]
		/**
		 * The state or the name of the state to go to if the one specified in stateName is not found. Optional.
		 */
		public function set stateNotFoundState(state:*):void {
			if (state is String) {
				_stateNotFoundStateName = state;
			}
			else if (state is State) {
				_stateNotFoundStateName = State(state).name;
			}
		}
		
		private var explicitStateValue:Boolean = false;
		/**
		 *  @private
		 */
		public function get state():* {
			return instance.value;
		}
	    
	    [Inspectable(category="General")]
	    /**
	     * The state or the name of the state to go to. 
		 * Default is state name in linkInfo.stateName property
	     */
	    public function set state(state:Object):void {
	    	if (state is String) {
				explicitStateValue = true;
				instance.value = state;
	    	}
	    	else if (state is State) {
				explicitStateValue = true;
				instance.value = State(state).name;
	    	}
	    	
	    	// manually set the target property to current state
			instance.name = "currentState";
	    }
		
		/**
		 *  @private
		 */
		public function get target():Object {
			return instance.target;
		}
		
		[Inspectable(category="General")]
		/**
		 *  The name of the target that contains state to set
		 */
		public function set target(value:Object):void {
			instance.target = value;
		}
		
		private var _caseSensitive:Boolean = false;
		
		/**
		 *  @private
		 */
		public function get caseSensitive():Boolean {
			return _caseSensitive;
		}
		
		[Inspectable(category="General")]
		/**
		 *  Determines if the state name is case sensitive
		 */
		public function set caseSensitive(value:Boolean):void {
			_caseSensitive = value;
		}
		
		/**
		 * Go to state 
		 * */
		override public function apply(parent:UIComponent = null):void {
			var alternativeStateFound:Boolean = false;
			var stateFound:Boolean = false;
			var isBaseState:Boolean = false;
			var isCurrentState:Boolean = false;
			var actualStateName:String = "";
			var currentState:String;
			var destinationState:State;
			var alternativeStateName:String;
			var linkStateName:String;
			var linkHyperlink:String;
			
			// get instance to the link manager class
			linkManager = LinkManager.getInstance();
			
			// state found in hyperlink
			linkStateName = linkInfo.stateName;
			
			// hyperlink in linkinfo
			linkHyperlink = linkInfo.hyperlink;
			
			// check up the chain to see if we need to debug
			var debugInline:Boolean = InheritanceLookup.checkInheritance("debug", null, this, handler, linkManager);
			
			if (debugInline) { 
				trace("You have chosen to debug this action. Click step into to continue...");
				enterDebugger()
			}

			// if parent component is null get the application
			parent = (parent==null) ? UIComponent(application) : parent;
			
			// if target is null get the direct parent of the state
			// or application if parent isn't specified
			var targetComponent:Object = instance.target ? instance.target : parent;
			
			if (targetComponent is ModuleLoader && targetComponent.child) {
				targetComponent = targetComponent.child;
			}
			
			// LINK INFO
			// if the link event originated from a hyperlink and not explicity set
			if (linkInfo.origin=="internal" && !explicitStateValue) {
				
				// currently there's no way the target property has been integrated into the 
				// getLinkInfo method. so we call it again here
				var linkInfo2:LinkInfo = linkManager.getLinkInfo(linkInfo.hyperlink, targetComponent, linkInfo.mouseTarget, linkInfo.origin);

				
				if (!linkInfo2.hasState || linkInfo2.isAnchor) {
					return;
				}
				
				// if state isn't found
				// we may be on the base state
				if (linkInfo2.isBaseState) {
					
					// if we are not on that state already than go to that state
					if (!linkInfo2.isCurrentState) {
						setStateTo(instance, targetComponent, "", parent);
						
						// prevent automatic update from handling this event
						/*if (target is Application) {
							linkManager.cancelBrowserURLUpdate = true;
						}
						
						instance.value = "";
						instance.target = targetComponent;
						instance.apply(parent);*/
					}

				}
				
				// if the state exists and we aren't on it then go to it
				else if (linkInfo2.stateFound) {
					
					// if we are not on that state already then go to that state
					//if (!linkInfo2.isCurrentState) {
					// go to the state anyway in case browser manager does not react to fragment changes (js bug)
					if (!linkInfo2.isCurrentState) {
						
						setStateTo(instance, targetComponent, linkInfo2.stateName, parent);
						// prevent automatic update from handling this event
						/*if (target is Application) {
							linkManager.cancelBrowserURLUpdate = true;
						}
						
						// go to state
						instance.value = linkInfo2.stateName;
						instance.target = targetComponent;
						instance.apply(parent);*/
						
					}
				}
					
				// state is not found and we are not on the base state
				else {
					
					if (debugInline) {
						trace("\tState was not found, '" + String(linkStateName) + "'");
					}
					
					// check for alternative state
					alternativeStateName = InheritanceLookup.checkInheritance("stateNotFoundState", null, this, handler, linkManager);
					
					alternativeStateFound = StateUtils.getStateExists(targetComponent, alternativeStateName);
					
					// if alternative state found navigate to it
					if (alternativeStateFound) {
						
						setStateTo(instance, targetComponent, alternativeStateName, parent);
						// prevent automatic update from handling this event
						/*if (target is Application) {
							linkManager.cancelBrowserURLUpdate = true;
						}
						
						instance.value = alternativeStateName;
						instance.target = targetComponent;
						instance.apply(parent);*/
					}
					
					dispatchEvent(new Event("goToStateFault"));
				}
			}
			
			// other situations
			else {
				
				stateFound = StateUtils.getStateExists(targetComponent, state, caseSensitive);
				isBaseState = StateUtils.isBaseState(state);
				currentState = StateUtils.getCurrentState(targetComponent);
				isCurrentState = StateUtils.isCurrentState(targetComponent, state);
				
				// if state is found and we are not on that state then go to state
				if (stateFound) {
					
					// if we are not on that state already than go to that state
					//if (!isCurrentState) {
					// go to the state anyway in case browser manager does not react to fragment changes (js bug)
					if (!isCurrentState) {
						
						actualStateName = StateUtils.getActualStateName(targetComponent, state);
						setStateTo(instance, targetComponent, actualStateName, parent);
						
						// prevent automatic update from handling this event
						/*if (target is Application) {
							linkManager.cancelBrowserURLUpdate = true;
						}
						
						instance.value = actualStateName;
						instance.target = targetComponent;
						instance.apply(parent);*/
					}
				}
				
				// if state isn't found
				// we may be on the base state
				else if (isBaseState) {
					
					// if we are not on that state already than go to that state
					//if (!isCurrentState) {
					// go to the state anyway in case browser manager does not react to fragment changes (js bug)
					if (!isCurrentState) {
						
						setStateTo(instance, targetComponent, "", parent);
						
						// prevent automatic update from handling this event
						/*if (target is Application) {
							linkManager.cancelBrowserURLUpdate = true;
						}
						
						instance.value = "";
						instance.target = targetComponent;
						instance.apply(parent);*/
					}
					
				}
				
				// state is not found and we are not on the base state
				else {
					
					if (debugInline) {
						trace("\tState was not found, '" + state + "'");
					}
					
					// check for alternative state
					alternativeStateName = InheritanceLookup.checkInheritance("stateNotFoundState", null, this, handler, linkManager);
					
					alternativeStateFound = StateUtils.getStateExists(targetComponent, alternativeStateName);
					
					// if alternative state found navigate to it
					if (alternativeStateFound) {
						
						setStateTo(instance, targetComponent, alternativeStateName, parent);
						
						// prevent automatic update from handling this event
						/*if (target is Application) {
							linkManager.cancelBrowserURLUpdate = true;
						}
						
						instance.value = alternativeStateName;
						instance.target = targetComponent;
						instance.apply(parent);*/
					}
					
					dispatchEvent(new Event("goToStateFault"));
				}
				
			}

			
		}
		
		public function setStateTo(instance:mx.states.SetProperty, target:Object, stateName:String, parent:Object):void {
			
			
			// prevent automatic update from handling this event
			if (target is Application) {
				linkManager.cancelBrowserURLUpdate = true;
			}
			
			instance.value = stateName==null ? "" : stateName;
			instance.target = target;
			instance.apply(parent as UIComponent);
		}

	}
}