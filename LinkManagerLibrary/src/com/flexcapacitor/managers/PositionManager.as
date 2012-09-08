package com.flexcapacitor.managers
{
	import com.flexcapacitor.utils.ApplicationUtils;
	
	import flash.geom.Point;
	
	import mx.core.Application;
	import mx.core.Container;

	public class PositionManager {
		
		public function PositionManager() {
			
		}
		
		public var TOP_LEFT:String = "top left";
		public var TOP_CENTER:String = "top center";
		public var TOP_RIGHT:String = "top right";
		public var CENTER_LEFT:String = "center left";
		public var CENTER:String = "center";
		public var CENTER_RIGHT:String = "center right";
		public var BOTTOM_LEFT:String = "bottom left";
		public var BOTTOM_CENTER:String = "bottom center";
		public var BOTTOM_RIGHT:String = "bottom right";
		
		// set the default position to the center of the target
		public var _position:String = CENTER;
		
		// include the border in the positioning
		public var includeBorder:Boolean = false;
		
		public var WINXP_TASKBAR:int = 34;
		
		/**
		 Positions are 
		 TOP_LEFT,TOP_CENTER,TOP_RIGHT,
		 CENTER_LEFT,CENTER,CENTER_RIGHT,
		 BOTTOM_LEFT,BOTTOM_CENTER,BOTTOM_RIGHT;
 		**/
		public function set position(value:String):void {
			_position = value;
		}
		
		// padding from left
		private var _paddingLeft:Number = 0;
		public function set paddingLeft(value:Number):void {
			_paddingLeft = value;
		}
		
		// padding from top
		private var _paddingTop:Number = 0;
		public function set paddingTop(value:Number):void {
			_paddingTop = value;
		}
		
		// padding from right
		private var _paddingRight:Number = 0;
		public function set paddingRight(value:Number):void {
			_paddingRight = value;
		}
		
		// padding from bottom
		private var _paddingBottom:Number = 0;
		public function set paddingBottom(value:Number):void {
			_paddingBottom = value;
		}
		
		// set the position of the target to the position specified in relation to the reference object
		// set the includeBorder property on the position manager instance 
		public function setPosition(target:*, position:String, referenceObject:*, offscreen:Boolean = false):Point {
			var point:Point = new Point(0, 0);
			if (offscreen) {			
				point = findPosition(target, position, referenceObject, includeBorder);
			}
			else {
				point = findPosition(target, position, referenceObject, includeBorder);	
			}
			setTargetPosition(target, point);
			return point;
		}
		
		// sets the target to the values in the point object
		// target needs x and y properties
		private function setTargetPosition(target:*, point:Point):void {
			// in the future we may need to handle removing the target from current parent
			// and adding to new parent
			target.x = point.x;
			target.y = point.y;
		}
		
		// to change the position (left and right or top or bottom) offscreen change the offscreenAxis
		public function findPointOffscreen(target:*, point:Point, position:String):Point {
			if (offscreenAxis=="horizontal") {
				if (position.indexOf("left")>-1) {
					// hide to the left
					point.x = point.x - target.width;
				}
				else {
					// hide to the right
					point.x = point.x + target.width;
				}
			}
			else {
				if (position.indexOf("top")>-1) {
					// hide above top
					point.y = point.y - target.height;
				}
				else {
					// hide below bottom 
					point.y = point.y + target.height;
				}
			}
			return point;
		} 
		
		// can be horizontal or vertical
	    [Inspectable(type="String", category="General", name="Offscreen Position", defaultValue="horizontal", enumeration="horizontal,vertical")]
		public var offscreenAxis:String = "horizontal";
		
		// return a point object that tells you the position of the target 
		// at the position specified 
		// on the reference object
		// except positioned to the left or right of the object
		// so if you want to place an object 10x10 at the top center of a component 
		// but on the outside of the component rather than on the inside you would call
		// point = findOffscreenPosition(my10x10object, TOP_CENTER, mySourceComponent);
		// or use setPosition(my10x10object, TOP_CENTER, mySourceComponent);
		// target and referenceObject must at least support x, y, width and height;
		public function findOffscreenPosition(target:*, targetPosition:String, referenceObject:*):Point {
			
			var point:Point = new Point(0, 0);
			point = findPosition(target, targetPosition, referenceObject, includeBorder);
			point = findPointOffscreen(target, point, targetPosition);
			return point;
		}
		
		// returns a point object that contains the position of the 
		// target and referenceObject must at least support x, y, width and height;
		public function findPosition(target:*, targetPosition:String, referenceObject:*, includeBorder:Boolean=false):Point {
			
			var borderLeft:int = 0;
			var borderRight:int = 0;
			var borderTop:int = 0;
			var borderBottom:int = 0;
			
			if (referenceObject is Container || referenceObject.hasOwnProperty("viewMetrics")) {
				
				borderLeft = referenceObject['viewMetrics'].left;
				borderRight = referenceObject['viewMetrics'].right;
				borderTop = referenceObject['viewMetrics'].top;
				borderBottom = referenceObject['viewMetrics'].bottom;
			}
			
			if (target==null) {
				target = application;
			}
			
			var componentWidth:int = referenceObject.width;
			var componentHeight:int = referenceObject.height;
			var targetWidth:int = target.width;
			var targetHeight:int = target.height;
			
			var leftEdge:int = _paddingLeft;
			var topEdge:int = _paddingTop;
			//var rightEdge:int = int((componentWidth - borderLeft - borderRight) - targetWidth - _paddingLeft);
			//var bottomEdge:int = int((componentHeight - borderTop - borderBottom) - targetHeight - _paddingTop);
			var rightEdge:int = int((componentWidth - borderLeft - borderRight) - targetWidth - _paddingRight);
			var bottomEdge:int = int((componentHeight - borderTop - borderBottom) - targetHeight - _paddingBottom);

			var centerX:int = int(componentWidth/2 - targetWidth/2) - borderLeft;
			var centerY:int = int(componentHeight/2 - targetHeight/2) - borderTop;
			
			if (includeBorder) {
				leftEdge = leftEdge - borderLeft;
				topEdge = topEdge - borderTop;
				rightEdge = rightEdge + borderRight;
				bottomEdge = bottomEdge + borderBottom;
				
				//centerX = centerX;
				//centerY = centerY;
			}
			
			var newX:int = 0;
			var newY:int = 0;
			
			if (!targetPosition) {
				targetPosition = _position;
			}
			
			if (targetPosition == TOP_LEFT) {
				
				newX = leftEdge;
				newY = topEdge;
			}
			else if (targetPosition == TOP_CENTER) {
				
				newX = centerX;
				newY = topEdge;
			}
			else if (targetPosition == TOP_RIGHT) {
				
				newX = rightEdge;
				newY = topEdge;
			}
			else if (targetPosition == CENTER_LEFT) {
				
				newX = leftEdge;
				newY = centerY;
			}
			else if (targetPosition == CENTER) {
				
				newX = centerX;
				newY = centerY;
			}
			else if (targetPosition == CENTER_RIGHT) {
				
				newX = rightEdge;
				newY = centerY;
			}
			else if (targetPosition == BOTTOM_LEFT) {
				
				newX = leftEdge;
				newY = bottomEdge;
			}
			else if (targetPosition == BOTTOM_CENTER) {
				
				newX = centerX;
				newY = bottomEdge;
			}
			else if (targetPosition == BOTTOM_RIGHT) {
				
				newX = rightEdge;
				newY = bottomEdge;
			}
			
			return new Point(newX, newY);
		}
		
		public function get application():Object {
			return ApplicationUtils.getInstance();
		}
		/* 
		// how much to rotate when animating
		private var _rotationAmount:Number = 10;
		public function set rotationAmount(value:Number):void {
			_rotationAmount = value;
		}
		public function get rotationAmount():Number {
			return _rotationAmount;
		}
		
		// how long to animate a full rotation
		private var _animationDuration:int = 500;
		public function set animationDuration(value:int):void {
			_animationDuration = value;
		}
		public function get animationDuration():int {
			return _animationDuration;
		}
		
		// boolean to animate status icon
		private var _animate:Boolean = true;
		public function set animate(value:Boolean):void {
			_animate = value;
		}
		public function get animate():Boolean {
			return _animate;
		} */
		
	}
}