




package com.flexcapacitor.actions {
	
	import com.flexcapacitor.utils.ClassUtils;
	
	import mx.core.UIComponent;
	import mx.states.SetProperty;
	
	/** 
	 *  
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]

	public class CallMethod extends Action {
		
		protected var instance:mx.states.SetProperty;
		public var functionReference:Object;
		public var isFunctionReferenced:Boolean;
		
		public function CallMethod(target:Object = null, method:String = null, value:Object = null) {
			instance = new mx.states.SetProperty(target, method, value);
		}
		
		[Inspectable(category="General")]
		/**
		 *  The name of the method to call.
		 *  Do not put parameters in this method
		 */
		public function set name(value:*):void {
			
			if (value is String) {
				instance.name = String(value);
				isFunctionReferenced = false;
			}
			else if (value is Function) {
				functionReference = value;
				isFunctionReferenced = true;
			}
		}
		
		/**
		 *  @private
		 */
		public function get name():* {
			if (isFunctionReferenced) {
				return functionReference;
			}
			else {
				return instance.name;
			}
		}
		
		[Inspectable(category="General")]
		/**
		 *  The name of the target that contains method to call
		 */
		public function set target(value:Object):void {
			instance.target = value;
		}
		
		/**
		 *  @private
		 */
		public function get target():Object {
			return instance.target;
		}
		
		private var _value:Object;
		
	    [Inspectable(category="General")]
	    /**
	     *  The parameters of the method<br/>
		 *  Usage:<br/> &lt;behaviors:CallMethod target="{content1}" name="send" arguments="{[{xml:1,m:handler2.value}]}"/&gt;<br/>
		 *  Usage:<br/> &lt;behaviors:CallMethod target="{content1}"  name="send"&gt;<br/>
	&lt;behaviors:arguments&gt;<br/>
		&lt;mx:Array&gt;<br/>
			&lt;mx:Object&gt;<br/>
				&lt;mx:xml&gt;1&lt;/mx:xml&gt;<br/>
				&lt;mx:p&gt;{handler1.value}&lt;/mx:p&gt;<br/>
			&lt;/mx:Object&gt;<br/>
		&lt;/mx:Array&gt;<br/>
	&lt;/behaviors:arguments&gt;<br/>
&lt;/behaviors:CallMethod&gt;<br/>
	     */
	    public function set arguments(value:Object):void {
			_value = value;
	    }
	    
	    /**
	     *  @private
	     */
	    public function get arguments():Object {
			return _value;
	    }
	    
		override public function apply(parent:UIComponent = null):void {
	        var object:Object = instance.target ? instance.target : parent;
			
			if (linkInfo.isAnchor) return;
			
			if (isFunctionReferenced) {
				(functionReference as Function).apply(object, _value);
			}
			else if (object.hasOwnProperty(instance.name)) {
	        	if (_value!=null) {
	        		(object[instance.name] as Function).apply(object, _value);
	        	}
	        	else {
					object[instance.name]();
	        	}
	        }
			else {
				if (debug) {
					trace(ClassUtils.staticInstance.getClassName(this) + ": " + ClassUtils.staticInstance.getClassName(object) + " does not have method " + instance.name);
					
					if (instance.target==null) {
						trace(ClassUtils.staticInstance.getClassName(this) + ": If target is not created yet this method will fail. Try creating it before this behavior is called.");
					}
				}
			}
		}

	}
}