




package com.flexcapacitor.actions {
	
	import mx.core.UIComponent;
	import mx.states.SetProperty;

	public class SetProperty extends Action {
		
		protected var instance:mx.states.SetProperty;
		
		public function SetProperty(target:Object = null, property:String = null, value:Object = null) {
			instance = new mx.states.SetProperty(target, property, value);
		}
		
		[Inspectable(category="General")]
		/**
		 *  The name of the property to set.
		 */
		public function set property(value:String):void {
			instance.name = value;
		}
		
		/**
		 *  @private
		 */
		public function get property():String {
			return instance.name;
		}
		
		[Inspectable(category="General")]
		/**
		 *  The value of the property
		 */
		public function set value(value:String):void {
			instance.value = value;
		}
		
		/**
		 *  @private
		 */
		public function get value():String {
			return instance.value;
		}
		
		[Inspectable(category="General")]
		/**
		 *  The name of the target that contains property
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
		
		override public function apply(parent:UIComponent = null):void {
			instance.apply(parent);
		}

	}
}