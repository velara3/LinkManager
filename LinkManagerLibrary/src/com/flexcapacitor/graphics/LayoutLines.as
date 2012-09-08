




package com.flexcapacitor.graphics {
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.graphics.SolidColorStroke;
	import mx.managers.SystemManager;
	
	import spark.components.Group;
	import spark.core.SpriteVisualElement;
	import spark.primitives.Line;

	public class LayoutLines {
		
		public var backgroundFillAlpha:Number = 0;
		public var backgroundFillColor:uint = 0x000000;
		public var lineAlpha:Number = .8;
		public var lineColor:uint = 0x00FF00;
		public var horizontalOffset:int = -5;
		public var verticalOffset:int = -5;
		public var lineThickness:int = 1;
		public var group:Group;
		
		public function LayoutLines() {
			
		}
		private static var _instance:LayoutLines;
		
		public static function getInstance():LayoutLines {
			
			if (_instance!=null) {
				return _instance;
			}
			else {
				_instance = new LayoutLines();
				return _instance;
			}
		}
		
		public function drawLines(target:DisplayObject, groupTarget:DisplayObject = null):void {
			var point:Point;
			var targetWidth:int;
			var targetHeight:int;
			var application:Object = FlexGlobals.topLevelApplication;
			var systemManager:MovieClip = MovieClip(SystemManager.getSWFRoot(target));
			
			if (target == null) { 
				if (group) {	
					group.graphics.clear();
				}
				return;
			}
			
			if (systemManager!=null) {
				var isPopUp:Boolean;// = target is UIComponent ? UIComponent(target).isPopUp : false;
				
				// if we add to the application we won't show on pop up manager elements
				if (groupTarget is Group) {
					group = Group(groupTarget);
				}
				else if (group==null || group.parent==null) {
					group = new Group();
					group.mouseEnabled = false;
					
					if (isPopUp) {
						systemManager.addChild(DisplayObject(group));
					}
					else {
						application.addElement(DisplayObject(group));
					}
				}
				else {
					group.graphics.clear();
					
					/*if (isPopUp) {
						systemManager.addChild(DisplayObject(group));
					}
					else {
						application.addElement(DisplayObject(group));
					}*/
				}
			}
			else {
				return;
			}
			
			targetWidth = DisplayObject(target).width;
			targetHeight = DisplayObject(target).height;
			
			point = new Point();
			point = DisplayObject(target).localToGlobal(point);
			
			var topOffset:Number = 0 - (lineThickness / 2);
			var leftOffset:Number = 0 - (lineThickness / 2);
			var rightOffset:Number = targetWidth + 0 - (lineThickness / 2);
			var bottomOffset:Number = targetHeight + 0 - (lineThickness / 2);
			
			// move group to new location
			group.x = point.x;
			group.y = point.y;
			
			// add a background fill
			group.graphics.beginFill(backgroundFillColor, backgroundFillAlpha);
			group.graphics.drawRect(0, 0, targetWidth, targetHeight);
			group.graphics.endFill();
			
			// adds a thin line at the top
			group.graphics.beginFill(lineColor, lineAlpha);
			group.graphics.drawRect(horizontalOffset, topOffset, targetWidth + 10, lineThickness);
			group.graphics.endFill();
			
			// adds a thin line to the bottom of the spacer
			group.graphics.beginFill(lineColor, lineAlpha);
			group.graphics.drawRect(horizontalOffset, bottomOffset, targetWidth + 10, lineThickness);
			group.graphics.endFill();
			
			// adds a thin line to the left
			group.graphics.beginFill(lineColor, lineAlpha);
			group.graphics.drawRect(leftOffset, verticalOffset, lineThickness, targetHeight + 10);
			group.graphics.endFill();
			
			// adds a thin line to the right
			group.graphics.beginFill(lineColor, lineAlpha);
			group.graphics.drawRect(rightOffset, verticalOffset, lineThickness, targetHeight + 10);
			group.graphics.endFill();
		}
		
		public function drawLines2(target:DisplayObject, groupTarget:DisplayObject = null):void {
			var point:Point;
			var targetWidth:int;
			var targetHeight:int;
			var systemManager:MovieClip = MovieClip(SystemManager.getSWFRoot(target));
			
			if (target == null) 
				return;
			
			if (systemManager!=null) {
				
				if (group==null) {
					group = new Group();
					group.mouseEnabled = false;
					systemManager.addChild(DisplayObject(group));
				}
				else {
					group.removeAllElements();
				}
			}
			else {
				return;
			}
			
			targetWidth = DisplayObject(target).width;
			targetHeight = DisplayObject(target).height;
			
			point = new Point();
			point = DisplayObject(target).localToGlobal(point);
			
			var topLine:Line = new Line();
			var bottomLine:Line = new Line();
			var leftLine:Line = new Line();
			var rightLine:Line = new Line();
			
			var stroke:SolidColorStroke = new SolidColorStroke();
			stroke.color = lineColor;
			stroke.alpha = lineAlpha;
			topLine.stroke = stroke;
			bottomLine.stroke = stroke;
			leftLine.stroke = stroke;
			rightLine.stroke = stroke;
			
			topLine.xFrom = 0;
			topLine.xTo = systemManager.width;
			topLine.y = point.y - (lineThickness / 2);
			
			bottomLine.xFrom = 0;
			bottomLine.xTo = systemManager.width;
			bottomLine.y = point.y + targetHeight - (lineThickness / 2);
			
			leftLine.x = point.x - (lineThickness / 2);
			leftLine.yFrom = 0;
			leftLine.yTo = systemManager.height;
			
			rightLine.x = point.x + targetWidth - (lineThickness / 2);
			rightLine.yFrom = 0;
			rightLine.yTo = systemManager.height;

			group.addElement(topLine);
			group.addElement(bottomLine);
			group.addElement(leftLine);
			group.addElement(rightLine);
			
			if (group.parent!=systemManager) {
				systemManager.addChild(group);
			}
			
		}
		
		public function clear(target:Object=null, groupTarget:Object=null, remove:Boolean=false):void {
			/*if (target==null) {
				throw new Error("Outline cannot be cleared because target is null");
			}
			var application:Object = FlexGlobals.topLevelApplication;
			var systemManager:MovieClip = MovieClip(SystemManager.getSWFRoot(application));
			
			if (systemManager || application) {
				*/
				if (group) {
					group.graphics.clear();
					
					if (remove && group.parent) {
						if (group.parent.hasOwnProperty("removeElement")) {
							Object(group.parent).removeElement(group);
						}
						else if (group.parent.hasOwnProperty("removeChild")) {
							group.parent.removeChild(group);
						}
					}
				}
			
		}
		
		public function remove(target:Object, groupTarget:Object=null):void {
			var application:Object = FlexGlobals.topLevelApplication;
			var systemManager:MovieClip = MovieClip(SystemManager.getSWFRoot(target));
			
			if (systemManager) {
				
				if (group && group.parent==systemManager) {
					group.graphics.clear();
					systemManager.removeChild(group);
				}
			}
			
			if (application) {
				
				if (group && group.parent==application) {
					group.graphics.clear();
					application.removeChild(group);
				}
			}
		}
		
		public function clear2(target:Object, groupTarget:Object=null):void {
			var systemManager:MovieClip = MovieClip(SystemManager.getSWFRoot(target));
			
			if (systemManager) {
				
				if (group!=null) {
					group.graphics.clear();
				}
			}
		}
		
	}
}