




package com.flexcapacitor.utils {
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;
	import flash.utils.getDefinitionByName;
	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;

	public class TypeUtils {

		public function TypeUtils() {

		}


		/**
		 * Sets property or style on target visual element
		 * Property can contain metadata. For example, "propertyName:propertyType" or
		 * "property:style" where the inclusion of ":style" indicates a style.
		 * */
		public static function applyProperty(target:Object, property:String, value:*, type:String = "String", isPropertyStyle:Object=null):void {
			var propertyType:String = property.indexOf(":") != -1 ? property.split(":")[1] : type;
			var valueString:String = value is String ? value : null;
			
			// why is the non null value for property indicate isStyle?
			var isStyle:Boolean = property.toLowerCase().indexOf(":style") != -1 || isPropertyStyle ? true : false;
			var isPercent:Boolean = value is String && value != null && value.charAt(value.length - 1) == "%";
			property = property.indexOf(":") != -1 ? property.split(":")[0] : property;
			value = isPercent ? value.slice(0, value.length - 1) : value;
			value = getCorrectType(value, propertyType);


			try {
				if (target) {
					if (property == "width") {
						setWidth(DisplayObject(target), value, isPercent);
					}
					else if (property == "height") {
						setHeight(DisplayObject(target), value, isPercent);
					}
					else if (isStyle) {
						if (target is UIComponent) {
							// we should use the set constraint methods here???
							UIComponent(target).setStyle(property, value);
						}
						else {
							throw new Error("Target does not have property " + property);
						}
					}
					else {
						
						if (Object(target).hasOwnProperty(property)) {
							// this throws an error when the property is not on the target
							target[property] = value;
						}
						else {
							// property is not found on object
							// or property is a style
							// need support for styles
							trace("isStyle is set to false and target doesn't contain " + property);
						}
					}

				}
			}
			catch (error:ErrorEvent) {
				trace("Could not apply " + String(value) + " to " + String(target) + "." + property + "\n" + error.text);
			}

		}

		/**
		 * Sets the height
		 * */
		public static function setHeight(target:DisplayObject, value:*, isPercent:Object=null):void {
			var element:IVisualElement = target as IVisualElement;
			var removePercent:Boolean;
			
			if (isPercent==null) {
				isPercent = value != null && value is String && value.charAt(value.length - 1) == "%";
				removePercent = isPercent;
			}
			else if (isPercent) {
				removePercent = value != null && value is String && value.charAt(value.length - 1) == "%";
			}
			
			value = removePercent ? value.slice(0, value.length - 1) : value;

			if (element) {
				if (isPercent) {
					element.percentHeight = Number(value);
				}
				else {
					element.percentHeight = undefined;

					// no value was entered into the text field
					// let the value reset
					if (value != undefined) {
						target.height = Number(value);
					}
				}
			}
			else {
				// no value was entered into the text field
				// let the value reset
				if (value != undefined) {
					target.height = Number(value);
				}
			}
		}

		/**
		 * Sets the width
		 * */
		public static function setWidth(target:DisplayObject, value:*, isPercent:Object=null):void {
			var element:IVisualElement = target as IVisualElement;
			var removePercent:Boolean;
			
			if (isPercent==null) {
				isPercent = value != null && value is String && value.charAt(value.length - 1) == "%";
				removePercent = isPercent;
			}
			else if (isPercent) {
				removePercent = value != null && value is String && value.charAt(value.length - 1) == "%";
			}

			value = removePercent ? value.slice(0, value.length - 1) : value;

			if (element) {
				if (isPercent) {
					element.percentWidth = Number(value);
				}
				else {
					element.percentWidth = undefined;

					// no value was entered into the text field
					// let the value reset
					if (value != undefined) {
						target.width = Number(value);
					}
				}
			}
			else {
				// no value was entered into the text field
				// let the value reset
				if (value != undefined) {
					target.width = Number(value);
				}
			}
		}

		/**
		 * Casts the value to the correct type
		 * NOTE: May not work for colors
		 * Also supports casting to specific class. use ClassDefinition as type
		 * returns instance of flash.utils.getDefinitionByName(className)
		 * */
		public static function getCorrectType(value:String, type:String):* {
			if (type == "Boolean" && value.toLowerCase() == "false") {
				return false;
			}
			else if (type == "Boolean" && value.toLowerCase() == "true") {
				return true;
			}
			else if (type == "Number") {
				if (value == null || value == "") {
					return undefined
				};
				return Number(value);
			}
			else if (type == "int") {
				if (value == null || value == "") {
					return undefined
				};
				return int(value);
			}
			else if (type == "String") {
				return String(value);
			}
			// TODO: Return color type
			else if (type == "Color") {
				return String(value);
			}
			else if (type == "ClassDefinition") {
				if (value) {
					var ClassDefinition:Class = flash.utils.getDefinitionByName(value) as Class;
					return new ClassDefinition();
				}
				return new Object();
			}
			else {
				return value;
			}
		}
	}
}