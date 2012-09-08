



/**
 * Used for display in the Outline view
 * */
package com.flexcapacitor.vo {
	import com.flexcapacitor.utils.InspectorUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;

	public class VisualElementVO {

		public var id:String;
		public var name:String;
		public var type:String;
		public var superClass:String;
		public var element:DisplayObject;
		public var children:ArrayCollection;
		public var parent:DisplayObjectContainer;
		public var label:String;

		public function VisualElementVO() {

		}

		public static function unmarshall(element:DisplayObject):VisualElementVO {
			var vo:VisualElementVO = new VisualElementVO();
			vo.id = 		InspectorUtils.getIdentifier(element);
			vo.name = 		InspectorUtils.getName(element);
			vo.type = 		InspectorUtils.getClassName(DisplayObject(element));
			vo.superClass = InspectorUtils.getSuperClassName(DisplayObject(element));
			vo.element = 	element;
			vo.label =		vo.type;
			
			// get vo.children manually

			return vo;
		}
	}
}