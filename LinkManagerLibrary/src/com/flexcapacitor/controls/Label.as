package com.flexcapacitor.controls
{
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.controls.Image;
	import flash.events.MouseEvent;
	import mx.managers.CursorManager;
	import mx.managers.FocusManager;
	import mx.events.FlexEvent;
	import mx.core.EventPriority;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import com.flexcapacitor.managers.DraggableLabelManager;
	import mx.utils.ColorUtil;

/* 	bugs fixed
	fixed - when scrolling up or down with the mouse scroll wheel the text value is only partially selected
	fixed - when incrementing by a decimal value the decimal shows up to 9 places out
	fixed - when focusOnMouseUp is true then the component gains focus any time mouse up is called anywhere 
	fixed - mouse over does not show drag cursor until first click
	fixed - scrolls way to fast for list controls. uses effectiveGap
	fixed - does not increment the color picker in a way i understand. maybe have colorpicker options like
	increment by hue, increment by saturation, increment by brightness, etc
	
	features
	added - when pressing up or down arrow increment - addKeyPressBehavior 
	added - need to add a way to provide more space between increments - horizontalGap property??? maybe amount in pixels 
	added - effectiveGap
	added - dispatch event when value changes - change event dispatched
	*/

	/**
	 *  The Draggable Label (Advanced Label) component lets you drag the label left or right and increase or
	 *  decrease the value of the component attached to it.
	 */


	public class Label extends mx.controls.Label {
		
		/**
		 * Constructor
		 * */
		public function Label()
		{
			// Setup handlers
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0.0, true);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0.0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0.0, true);
			
			addEventListener(FlexEvent.CREATION_COMPLETE, initializedHandler);
			
			// We need to add mouse up and mouse move event handler at stage handler to handle mouse up and mouse move outside of the control.
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0.0, true);
		}
		
		/**
		 * Add event listener for mouse up and mouse move event at stage level when the control is added to stage.
		 * */
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0.0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0.0, true);
		}
		
		/**
		 * Handler when DraggableLabel is created and properties values have been set.  
		 * If addScrollBehavior property is set to true, we need to add mouse wheel listener 
		 * to DraggableLabel instance itself and the target component so that when the mouse 
		 * scrolling on both UI component we can handle it.
		 * */
		private function initializedHandler(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, initializedHandler);
			
			if(_addScrollBehavior && _target != null)
			{
				addEventListener(MouseEvent.MOUSE_WHEEL, selfMouseWheelHandler, false, 0.0, true);
				_target.addEventListener(MouseEvent.MOUSE_WHEEL, targetMouseWheelHandler, false, EventPriority.DEFAULT, true);
			}

			if(_addKeyBehavior && _target != null)
			{
				// labels never seem to gain focus so we do not add to it
				//addEventListener(KeyboardEvent.KEY_DOWN, selfKeyHandler, false, 0.0, true);
				_target.addEventListener(KeyboardEvent.KEY_DOWN, targetKeyHandler, false, EventPriority.DEFAULT, true);
			}
			
			// determine if target is color picker
			if (target.hasOwnProperty("selectedColor")) {
				_target.addEventListener(Event.CHANGE, colorPickerChange, false, EventPriority.DEFAULT, true);
				isColor = true;
			}
			
		}
		
		/**
		 * Handle when color picker changes color without user clicking on label
		 * 
		 */		
		private function colorPickerChange(event:Event):void {
			dragManager.selectedColor = _target['selectedColor'];
		}
		
		/**
		 * Handler when mouse scrolling happens in target component.  
		 * We need to prevent the default Behavior of the target component, '
		 * which may handle the scrolling action.
		 * */
		private function targetMouseWheelHandler(event:MouseEvent):void
		{
			if(event.cancelable)
				event.preventDefault();
			
			updateTargetProperty(event.delta > 0 ? 1 : -1);
		}
		
		/**
		 * Handler when mouse scrolling happens on the DraggableLabel itself.
		 * */
		private function selfMouseWheelHandler(event:MouseEvent):void
		{
			// handle scrollwheel on list components. it is reversed
			if (target.hasOwnProperty("rowCount")) {
				updateTargetProperty(event.delta > 0 ? -1 : 1);
			}
			else {
				updateTargetProperty(event.delta > 0 ? 1 : -1);
			}
		}

		/**
		 * Handler when key press happens in target component.  
		 * We need to prevent the default Behavior of the target component, 
		 * which may handle the keyboard action.
		 * */
		private function targetKeyHandler(event:KeyboardEvent):void
		{
			if(event.cancelable)
				event.preventDefault();

			if(event.keyCode==38) {
				updateTargetProperty(1);
			}
			else if (event.keyCode==40) {
				updateTargetProperty(-1);
			}
		}
		
		/**
		 * Handler when key press happens in label component.  
		 * We need to prevent the default Behavior of the label component, 
		 * which may handle the scrolling action.
		 * */
		private function selfKeyHandler(event:KeyboardEvent):void
		{
			if(event.cancelable)
				event.preventDefault();

			if(event.keyCode==38) {
				updateTargetProperty(1);
			}
			else if (event.keyCode==40) {
				updateTargetProperty(-1);
			}
		}
		
		// keep track of which target is being handled and current color selected
		public var dragManager:DraggableLabelManager = DraggableLabelManager.getInstance();
		
		private var _mouseDownCursorID:int = -1;
		private var _mouseOverCursorID:int = -1;
		
		// These help in tracking the movement of the mouse cursor, 
		// we use this to calculate increment/decrement value.
		private var _draggingStageX:int;
		private var _draggingStageY:int;
		
		// This variable, previous absolute difference is used to detect changes of drag direction 
		private var _previousAbsDifference:int = 0;
		
		/**
		 * Handler when mouse button is pressed down.
		 * */
		private function mouseDownHandler(event:MouseEvent):void
		{
			dragManager.target = this;
			hasDragged = false;
			
			// handle if target is color picker
			if (target.hasOwnProperty("selectedColor")) {
				dragManager.selectedColor = target["selectedColor"];
			}
			
			// remove mouse over cursor
			CursorManager.removeCursor(_mouseOverCursorID);
			_mouseOverCursorID = -1;
			
			if(_mouseDownCursorID < 0)
				_mouseDownCursorID = CursorManager.setCursor(_dragIcon);
			
			_draggingStageX = event.stageX;
			_draggingStageY = event.stageY;
			
			// we want to render our custom cursor after each mouse move
			event.updateAfterEvent();
		}
		
		/**
		 * Handler when mouse button is up.
		 * */
		private function mouseUpHandler(event:MouseEvent):void
		{
			
			// remove drag cursor
			CursorManager.removeCursor(_mouseDownCursorID);
			_mouseDownCursorID = -1;
			
			// check location of mouse and if over label remove drag cursor but keep mouse over cursor 
			// also focus on target if property is set and no drag occured
			if(this.hitTestPoint(event.stageX, event.stageY) && _mouseOverCursorID < 0) {
				_mouseOverCursorID = CursorManager.setCursor(_overIcon);
				
				// do not focus if user has just dragged
				if(_target != null && _focusOnMouseUp && !hasDragged)
				{
					_target.setFocus();
				}
				
				event.updateAfterEvent();
			}
			else
			{
				
				// remove mouse over cursor mouse up happens outside of the control
				CursorManager.removeCursor(_mouseOverCursorID); 
				_mouseOverCursorID = -1;
			}
		
			dragManager.target = null;
			dragManager.isDragging = false;
			
			if (isColor) { 
				dragManager.selectedColor = target["selectedColor"];		
				dragManager.selectedColorSize = 0;	
			}
		}
		
		/**
		 * Handler when mouse cursor goes over the DraggableLabel instance.
		 * */
		private function mouseOverHandler(event:MouseEvent):void
		{
			if(event.buttonDown) {
				// not sure why we were calling mouseDownHandler here
				//mouseDownHandler(event);
			}
			else
			{
				// show over cursor
				if(_mouseOverCursorID < 0) {
					_mouseOverCursorID = CursorManager.setCursor(_overIcon);
				}
			}
			
			event.updateAfterEvent();
		}
		
		/**
		 * Handler when mouse cursor goes away from the boundary of DraggableLabel instance.
		 * */
		private function mouseOutHandler(event:MouseEvent):void
		{
			if(!event.buttonDown)
			{
				// remove both mouse over and mouse down cursors
				CursorManager.removeCursor(_mouseOverCursorID);
				CursorManager.removeCursor(_mouseDownCursorID);
				
				_mouseOverCursorID = -1;
				_mouseDownCursorID = -1;
			}
			
			event.updateAfterEvent();
		}
		
		/**
		* A boolean value indicating if the user has dragged at least a single step size
		*/		
		public var hasDragged:Boolean = false;
		
		/**
		 * Handler when mouse is moving over the DraggableLabel instance.
		 * */
		public function mouseMoveHandler(event:MouseEvent):void
		{
			
			//if (dragManager.target!=this) {
			//	return;
			//}
			
			if(event.buttonDown && target != null && _enableDrag && _mouseDownCursorID >= 0)
			{
				// Calculate the difference, which depends on drag orientation used.
				dragManager.isDragging = true;
				
				var difference:int;
				
				if(_dragOrientation == "left-right")
					difference = event.stageX - _draggingStageX;
				else
					difference = _draggingStageY -  event.stageY;
						
				var absDiff:uint = Math.abs(difference);
				
				if(absDiff > _previousAbsDifference)
					_previousAbsDifference = absDiff;
				else
				{
					// If direction changed, reset the difference to 0.
					_draggingStageX = event.stageX;
					_draggingStageY = event.stageY;
					difference = 0;
					_previousAbsDifference = 0;
				}
						
				if(absDiff >= _effectiveGap)
				{
					//trace("difference : " + difference);
					hasDragged = true;
					
					_draggingStageX = event.stageX;
					_draggingStageY = event.stageY;
					
					_previousAbsDifference = 0;
					
					updateTargetProperty(difference > 0 ? 1 : -1);
					
				}
			}
		}
		
		/**
		 * Default value of the target property if it is null
		 * */
		public var defaultValue:* = 0;
		
		/**
		 * Update the target's property.
		 * */
		private function updateTargetProperty(difference:int):void
		{
			var isDirty:Boolean = false;
			
			if(_targetProperty == null)
			{
				// Target property is not set, we will try to discover it, if successful, 
				// set it as _targetProperty and the next update we would no longer need to re-discover.
				// Date data type like DateChooser and DateField is not supported.
				
				if(_target.hasOwnProperty("selectedColor")) {
					_targetProperty = "selectedColor";
				}
				else if(_target.hasOwnProperty("selectedIndex"))
					_targetProperty = "selectedIndex";
				else if(_target.hasOwnProperty("text"))
					_targetProperty = "text";
				else if(_target.hasOwnProperty("label"))
					_targetProperty = "label";
				else if(_target.hasOwnProperty("value"))
					_targetProperty = "value";
				else
					throw new Error("target property is not set and the auto discovery of target property fails.");
			}
			
			if(isNaN(target[targetProperty]) || target[targetProperty] == null || target[targetProperty] == "") 
			{ //|| target[targetProperty] == -1
				target[targetProperty] = isNaN(_minValue) ? defaultValue : _minValue;
				isDirty = true;
			}
			
			// call updatefunction to let user handle increment value
			var newValue:Number = _updateFunction(target, _targetProperty, difference, _stepSize, isColor);
			
			// check if we need to fix the point
			if (fixedPoint!=0) {
				newValue = Number(newValue.toFixed(fixedPoint));
			}
			
			if((isNaN(_minValue) || newValue >= _minValue) && (isNaN(_maxValue) || newValue <= _maxValue)) {
				
				target[_targetProperty] = newValue
				//trace("target property is now newValue " + target[targetProperty]);
				
				isDirty = true;
			}
			
			// deselect selected text and move cursor after value
			if (_target.hasOwnProperty("setSelection")) {
				var strLength:int = target[_targetProperty].toString().length;
				target['setSelection'](strLength, strLength);
			}
			
			// dispatch event if we made any changes
			if (isDirty) {
				dispatchEvent(new Event("change"));
				isDirty = false;
			}
		}
		
	    /**
	     * function to update value in target. user can define a new function
	     * @param target - target component
	     * @param targetProperty - target component property name
	     * @param difference - difference of mouse or key move
	     * @param stepSize - step size. default is 1
	     * @param isColor - is target a color picker
	     * @return number - new value to be assigned to target property
	     * 
	     */	
	    private function defaultUpdateFunction(target:*, targetProperty:String, difference:Number, stepSize:Number, isColor:Boolean):Number {
	    	var newValue:Number;
	    	
	    	// sometimes on update color appears lighter than color shown in the colorpicker
	    	// cause is unknown. selectedColorSize may not be saved every place it should???
	    	if (isColor) {
	    		var rgb:uint = dragManager.selectedColor;
	    		var diff:int = dragManager.selectedColorSize + (difference * stepSize);
	    		
	    		// adjust brightness of color
				newValue = ColorUtil.adjustBrightness(rgb, diff);
				dragManager.selectedColorSize = diff;
	    	}
	    	else {
	    		newValue = Number(target[targetProperty]) + (difference * stepSize);
	    	}
	    	
	        return newValue;
	    }
		
		/**
		* A boolean value indicating if target component is a color picker.
		*/
		public var isColor:Boolean = false;
		
		/**
		* Number of points of target property. Default value is 2. 
		*/		
		[Inspectable(category="Drag Properties")]
		public var fixedPoint:uint = 2;

		private var _target:UIComponent = null;
		
		/**
		 * Target component. Must extend UIComponent
		 * */
		public function get target():UIComponent
		{
			return _target;
		}
		
		[Inspectable(category="Drag Properties")]
		
		public function set target(value:UIComponent):void
		{
			_target = value;
		}
		
		private var _targetProperty:String = null;
		
		/**
		 * Property to increment or decrement on target component.  
		 * If this is not set, DraggableLabel will try to discover 
		 * the property by itself.  Auto-discovery supports Standard Controls 
		 * except DateField and DateChooser.
		 * */
		public function get targetProperty():String
		{
			return _targetProperty;
		}
		
		[Inspectable(category="Drag Properties")]
		public function set targetProperty(value:String):void
		{
			_targetProperty = value;
		}
		
		private var _dragOrientation:String = "left-right";
		
		/**
		 * Specifies left and right or up and down for the mouse dragging movement.
		 * Default is left and right.
		 * */
		public function get dragOrientation():String
		{
			return _dragOrientation;
		}
		
		[Inspectable(category="Drag Properties", enumeration="left-right,up-down")]
		public function set dragOrientation(value:String):void
		{
			_dragOrientation = value;
		}
		
		private var _enableDrag:Boolean = true;
		
		
		/**
		 * Enable or disable drag behavior. Default is true.  
		 * Please note that disabling this will just disable the 
		 * dragging, but scrolling (if enabled) will still work.
		 * */
		public function get enableDrag():Boolean
		{
			return _enableDrag;
		}
		
		[Inspectable(category="Drag Properties")]
		
		public function set enableDrag(value:Boolean):void
		{
			_enableDrag = value;
		}
		
		private var _focusOnMouseUp:Boolean = true;
		
		/**
		 * Option on mouse up the target component should gain focus with value
		 * selected. If dragging has just occured then mouse up does not set focus. Default is true.
		 * */
		public function get focusOnMouseUp():Boolean
		{
			return _focusOnMouseUp;
		}
		
		[Inspectable(category="Drag Properties")]
		
		public function set focusOnMouseUp(value:Boolean):void
		{
			_focusOnMouseUp = value;
		}
		
		/**
		 * Specify minimum value to be set by the mouse movement and if enabled, mouse scrolling.
		 * */
		private var _minValue:Number = NaN;
		
		public function get minValue():Number
		{
			return _minValue;
		}
		
		[Inspectable(category="Drag Properties")]
		
		public function set minValue(value:Number):void
		{
			_minValue = value;
		}
		
		private var _maxValue:Number = NaN;
		
		/**
		 * Specify maximum value to be set by the mouse movement and if enabled, mouse scrolling.
		 * */
		public function get maxValue():Number
		{
			return _maxValue;
		}
		
		[Inspectable(category="Drag Properties")]
		
		public function set maxValue(value:Number):void
		{
			_maxValue = value;
		}
		
		private var _addScrollBehavior:Boolean = false;
		
		/**
		 * Optionally adds scroll wheel behavior to the target component. When the
		 * target component has focus and the user scrolls up or down the value 
		 * increases or decreases.
		 * Default value is false.
		 * */
		public function get addScrollBehavior():Boolean
		{
			return _addScrollBehavior;
		}
		
		[Inspectable(category="Drag Properties")]
		
		public function set addScrollBehavior(value:Boolean):void
		{
			_addScrollBehavior = value;
		}

		private var _addKeyBehavior:Boolean = false;
		
		/**
		 * Optionally adds key board behavior to the target component. When the
		 * target component has focus and the user presses up or down the value 
		 * increases or decreases.
		 * Default value is false.
		 * */
		public function get addKeyBehavior():Boolean
		{
			return _addKeyBehavior;
		}
		
		[Inspectable(category="Drag Properties")]
		
		public function set addKeyBehavior(value:Boolean):void
		{
			_addKeyBehavior = value;
		}
		
		private var _stepSize:Number = 1;
		
		/**
		 * Size to increment or decrement. Default value is 1.
		 * */
		public function get stepSize():Number
		{
			return _stepSize;
		}
		
		[Inspectable(category="Drag Properties")]
		
		public function set stepSize(value:Number):void
		{
			_stepSize = value;
		}
		
		[Embed(source="drag-cursor.png")]
		[Bindable]
		private var _dragIcon:Class;
		
		/**
		 * Image to use when dragging.
		 * */
		public function get dragIcon():Class
		{
			return _dragIcon;
		}
		
		[Inspectable(category="Drag Properties")]
		public function set dragIcon(value:Class):void
		{
			_dragIcon = value;
		}
		
		[Embed(source="over-cursor.png")]
		[Bindable]
		private var _overIcon:Class;
		
		[Embed(source="hand-cursor.png")]
		[Bindable]
		public var handIcon:Class;
		
		/**
		 * Image to use when mouse is on the top of DraggableLabel instance.
		 * */
		public function get overIcon():Class
		{
			return _overIcon;
		}
		
		[Inspectable(category="Drag Properties")]
		
		public function set overIcon(value:Class):void
		{
			_overIcon = value;
		}
		
		/**
		 * Defines the effective gap in pixels, the default is 1, which means 1 pixel drag 
		 * will result in 1 step size change.  If you set this value to 3, then 3 pixels drag 
		 * (vertical or horizontal depending on drag orientation)  will result in 1 step size 
		 * change.
		 * */
		 
		 private var _effectiveGap:uint = 1;
		 
		[Inspectable(category="Drag Properties")]
		
		 public function get effectiveGap():uint
		 {
		 	return _effectiveGap;
		 }
		 
		 public function set effectiveGap(value:uint):void
		 {
		 	if(value < 1)
		 		throw new Error("<DraggableLabel>set effectiveGap() : Value of effective must be more than or equals to 1.");
		 		
		 	_effectiveGap = value;
		 }
	
		// user defined function to let user update the target with a value you choose
		private var _updateFunction:Function = defaultUpdateFunction;

		/**
		 * let user use function to update the target with the value you choose
		 * 
		 */
		public function set updateFunction(value:Function):void {
	    	
	    	if (value!=null) {
	    		_updateFunction = value;
	    	}
	    }
	    
	    public function get updateFunction():Function {
	    	
	    	return _updateFunction;
	    }
	}
}
