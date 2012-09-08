

package com.flexcapacitor.utils {
	
	import com.flexcapacitor.utils.ApplicationUtils;
	
	import mx.core.Application;
	import mx.states.State;
	
	public class StateUtils {
		
		public function StateUtils() {
			
		}
		
		/**
		 * Get the current state of the target component (or Application if target is null)
		 * The baseStateAlias is the string to use if the current state is an empty string (an empty string represents the base state)
		 * */
		public static function getCurrentState(target:Object = null, baseStateAlias:String = null):String {
			// default state is the base state (empty string)
			var currentState:String = "";
			
			// if target is null use the application
			target = target==null ? application : target;
			
			// check if the target has the currentState property
			// (if it doesn't we might not have the correct type of class)
			if (target.hasOwnProperty("currentState")) {
				currentState = target.currentState;
			}
			else {
				throw new Error("Target must have currentState property");
				return "";
			}
			
			// if the current state is an empty string or null it means the target is on the base state
			// if a alias for the base state is passed is provided then return the base state alias
			if (baseStateAlias!=null && (currentState=="" || currentState==null)) {
				currentState = baseStateAlias;
			}
			
			return currentState;
		}
		
		/**
		 * Get a reference to a State by it's name
		 * If target is null then the Application will be used
		 * */
	    public static function getState(target:Object, stateName:String, caseSensitive:Boolean = false):State {
            var states:Array;
            var state:State;
            var stateFound:Boolean = false;
			
			// if target is null use the application
			target = target==null ? application : target;
			
			// check if the target has the states property
			// if it doesn't we might not have the correct type of class
			if (target.hasOwnProperty("states")) {
				states = target.states;
			}
			else {
				throw new Error("Target must have states property");
				return "";
			}
        	
			// loop through each state and find a match
        	for each (var item:State in states) {
				
				if (caseSensitive) {

					if (item.name==stateName) {
						state = item;
						break;
					}
					if (item.hasOwnProperty("id") && String(item["id"])==stateName) {
						state = item;
						break;
					}
				}
				else {
					
	        		if (item.name.toLowerCase()==stateName.toLowerCase()) {
	        			state = item;
	        			break;
	        		}
	        		if (item.hasOwnProperty("id") && String(item["id"]).toLowerCase()==stateName.toLowerCase()) {
	        			state = item;
	        			break;
	        		}
				}
        	}
			
        	return state;
        }
		
		/**
		 * Returns true if a state with the name or identity exists on the target
		 * If target is null then the Application will be used
		 * NOTE: UIComponent has hasState method
		 * */
	    public static function getStateExists(target:Object, stateName:String, caseSensitive:Boolean = false):Boolean {
			var states:Array;
			var state:State;
			var stateFound:Boolean = false;
			
			// if target is null use the application
			if (target==null) return false;
			if (stateName==null) return false;
			
			states = target.states;
			
			// loop through each state in the targets states array
        	for each (var item:State in states) {
				
				// check if state matches state name
				if (caseSensitive) {
					
					if (item.name==stateName) {
						stateFound = true;
						break;
					}
				}
				else {
					
					if (item.name.toLowerCase()==stateName.toLowerCase()) {
						stateFound = true;
						break;
					}
				}
        	}
			
        	return stateFound;
        }
		
		/**
		 * Returns the actual state name of the state with correct case from target and state name or id
		 * */
		public static function getActualStateName(target:Object = null, stateName:String = ""):String {
			var states:Array;
			var state:State;
			var stateFound:Boolean = false;
			
			// if target is null use the application
			target = target==null ? application : target;
			
			// check if the target has the states property
			// if it doesn't we might not have the correct type of class
			if (target.hasOwnProperty("states")) {
				states = target.states;
			}
			else {
				throw new Error("Target must have states property");
				return "";
			}
			
			// loop through each state and find a match
			for each (var item:State in states) {
				
				if (item.name.toLowerCase()==stateName.toLowerCase()) {
					state = item;
					return state.name;
				}
				if (item.hasOwnProperty("id") && String(item["id"]).toLowerCase()==stateName.toLowerCase()) {
					state = item;
					return state.name;
				}
			}
			
			return "";
			
		}
		
		/**
		 * Returns true if the current state of the target component (or top level Application if target is null) equals the state name passed in
		 * */
		public static function isCurrentState(target:Object = null, stateName:String = "", caseSensitive:Boolean = false):Boolean {
			// default state is the base state (empty string)
			var currentState:String = "";
			var matchFound:Boolean = false;
			
			// if target is null use the application
			target = target==null ? application : target;
			
			// check if the target has the currentState property
			// (if it doesn't we might not have the correct type of class)
			if (target.hasOwnProperty("currentState")) {
				currentState = target.currentState;
			}
			else {
				throw new Error("Target must have currentState property");
				return false;
			}
			
			// check if current state matches state name
			if (caseSensitive) {
				
				if (currentState==stateName) {
					matchFound = true;
				}
			}
			else {
				
				if (currentState!=null && currentState.toLowerCase()==stateName.toLowerCase()) {
					matchFound = true;
				}
			}
			
			return matchFound;
		}
		
		/**
		 * Check if state is base state
		 * The base state will always equal an empty string, null or baseStateAlias
		 * */
		public static function isBaseState(stateName:String, baseStateAlias:String = "", caseSensitive:Boolean = false):Boolean {

			if (caseSensitive) {
				if (stateName==null || stateName==baseStateAlias) {
					return true;
				}
			}
			else {
				if (stateName==null || stateName.toLowerCase()==baseStateAlias.toLowerCase()) {
					return true;
				}
			}
			return false;
		}
		
		public static function get application():Object {
			return ApplicationUtils.getInstance();
		}

	}
}