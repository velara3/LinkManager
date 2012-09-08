




package com.flexcapacitor.controls {

	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.core.IFlexModule;
	import mx.core.IFlexModuleFactory;
	import mx.core.UIComponent;
	import mx.effects.Move;
	import mx.events.CloseEvent;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;


	public class AlertNotification extends Alert {

		public static const NONMODAL:uint = 0x8000;
		public static const OK:uint = 0x0004;
		public static const CANCEL:uint = 0x0008;
		public static const YES:uint = 0x0001;
		public static const NO:uint = 0x0002;
		
		/**
		 * Top means alert is at 0. See padding to adjust this
		 * */
		public static const TOP:String = "top";
		
		/**
		 * Topish means middle between midriff and top 
		 * */
		public static const TOPISH:String = "topish";
		
		/**
		 * Between the middle and the top
		 * */
		public static const MIDRIFF:String = "midriff";
		
		/**
		 * Smack dab in the middle
		 * */
		public static const CENTER:String = "center";
		
		public var moveInstance:Move;
		public static var moveInstance:Move;
		
		public var location:String;
		public static var location:String = MIDRIFF;
		
		public var paddingTop:Object;
		public static var paddingTop:int = 0;
		
		public var visibleDuration:Object;
		public static var visibleDuration:Object = 5000;
		
		public var moveDuration:Object;
		public static var moveDuration:int = 300;
		
		public var autoHideAlert:Object;
		public static var autoHideAlert:Boolean = true;
		
		public var modal:Object;
		public static var modal:Boolean = false;
		
		public static var iconClass:Class;
		private var openTime:int;
		
		public var showCountDown:Object;
		public static var showCountDown:Boolean = true;
		
		public static var countdownMessage:String = "This window will close in %1 seconds.";
		
		private var _title:String;

		public function AlertNotification() {
			super();
			
			moveInstance = new Move(this);
		}
		
		public static function show(text:String = "", title:String = "", flags:uint = 0x4, parent:Sprite = null, closeHandler:Function = null):InteractiveObject {
			return new AlertNotification().show(text, title, flags, parent, closeHandler);
		}

		public function show(text:String = "", title:String = "", flags:uint = 0x4, parent:Sprite = null, closeHandler:Function = null):InteractiveObject {

			// set local variables if not set
			if (location==null) 		location 		= AlertNotification.location;
			if (modal==null) 			modal 			= AlertNotification.modal;
			if (autoHideAlert==null) 	autoHideAlert 	= AlertNotification.autoHideAlert;
			if (visibleDuration==null)	visibleDuration = AlertNotification.visibleDuration;
			if (paddingTop==null) 		paddingTop 		= int(AlertNotification.paddingTop);
			if (moveDuration==null) 	moveDuration 	= int(AlertNotification.moveDuration);
			if (iconClass==null) 		iconClass		= AlertNotification.iconClass;
			if (showCountDown==null)	showCountDown 	= AlertNotification.showCountDown;
			
			if (!parent) {
				var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
				// no types so no dependencies
				var mp:Object = sm.getImplementation("mx.managers.IMarshallPlanSystemManager");
				if (mp && mp.useSWFBridge())
					parent = Sprite(sm.getSandboxRoot());
				else
					parent = Sprite(FlexGlobals.topLevelApplication);
			}

			var alert:Alert = this;

			if (flags & Alert.OK || flags & Alert.CANCEL || flags & Alert.YES || flags & Alert.NO) {
				alert.buttonFlags = flags;
			}

			if (defaultButtonFlag == Alert.OK || defaultButtonFlag == Alert.CANCEL || defaultButtonFlag == Alert.YES || defaultButtonFlag == Alert.NO) {
				alert.defaultButtonFlag = defaultButtonFlag;
			}

			alert.text = text;
			alert.title = title;
			alert.iconClass = iconClass;

			if (closeHandler != null) {
				alert.addEventListener(CloseEvent.CLOSE, closeHandler, false, 0, true);
			}

			// Setting a module factory allows the correct embedded font to be found.
			if (moduleFactory)
				alert.moduleFactory = moduleFactory;
			else if (parent is IFlexModule)
				alert.moduleFactory = IFlexModule(parent).moduleFactory;
			else {
				if (parent is IFlexModuleFactory)
					alert.moduleFactory = IFlexModuleFactory(parent);
				else
					alert.moduleFactory = FlexGlobals.topLevelApplication.moduleFactory;

				// also set document if parent isn't a UIComponent
				if (!parent is UIComponent)
					alert.document = FlexGlobals.topLevelApplication.document;
			}

			PopUpManager.addPopUp(alert, parent, modal);
			PopUpManager.centerPopUp(alert);

			moveInstance.yFrom = -alert.height;
			moveInstance.yTo = 0; // default is midtop
			
			if (location == CENTER) {
				moveInstance.yTo = alert.y;
			}
			else if (location == MIDRIFF) {
				moveInstance.yTo = int(alert.y / 2);
			}
			else if (location == TOPISH) {
				moveInstance.yTo = int(alert.y / 4);
			}
			else if (location == TOP) {
				moveInstance.yTo = 0;
			}
			
			// add padding
			moveInstance.yTo += int(paddingTop);
			moveInstance.duration = int(moveDuration);
			moveInstance.play();

			alert.setActualSize(alert.getExplicitOrMeasuredWidth(), alert.getExplicitOrMeasuredHeight());
			alert.addEventListener(FlexEvent.CREATION_COMPLETE, static_creationCompleteHandler, false, 0, true);
			alert.addEventListener(MouseEvent.CLICK, mouseClickHandler, false, 0, true);
			alert.setStyle("hideEffect", "Fade");
			alert.useHandCursor = true;
			
			// update countdown message
			if (autoHideAlert) {
				alert.addEventListener(Event.ENTER_FRAME, updateTitle, false, 0, true);
				openTime = getTimer();
			}
			
			return alert;
		}
		
		// show the user a countdown until the message is removed
		public function updateTitle(event:Event):void {
			var timePast:int = getTimer() - openTime;
			var titleMessage:String;
			
			if (timePast >= visibleDuration) {
				closeThisMofo();
			}
			else {
				
				if (showCountDown) {
					
					// replace %1 with seconds left
					if (_title!="" && _title!=null) {
						this.title = _title + " - " + countdownMessage.replace(/(\%1)/gi, Math.floor((int(visibleDuration)-timePast)/1000)+1);
					}
					else {
						this.title = countdownMessage.replace(/(\%1)/gi, Math.floor((int(visibleDuration)-timePast)/1000)+1);
					}
				}
			}
		}
		
		// prevent window from closing if user clicks on window
		public function mouseClickHandler(event:MouseEvent):void {
			this.title = _title;
			removeEventListener(Event.ENTER_FRAME, updateTitle);
		}

		// close this mofo
		public function closeThisMofo():void {
			removeEventListener(Event.ENTER_FRAME, updateTitle);

			// if it's not already closed hide the window
			if (visible) {
				moveInstance.play(null, true);
				moveInstance.addEventListener(EffectEvent.EFFECT_END, closeHandler, false, 0, true);
			}
		}

		// after window is hidden remove it from the stage
		public function closeHandler(event:EffectEvent):void {
			removeEventListener(Event.ENTER_FRAME, updateTitle);
			moveInstance.removeEventListener(EffectEvent.EFFECT_END, closeHandler);
			PopUpManager.removePopUp(this);
		}


		/**
		 * center window after it has been created
		 *  @private
		 */
		private static function static_creationCompleteHandler(event:FlexEvent):void {
			if (event.target is IFlexDisplayObject && event.eventPhase == EventPhase.AT_TARGET) {
				event.target.removeEventListener(FlexEvent.CREATION_COMPLETE, static_creationCompleteHandler);
				PopUpManager.centerPopUp(IFlexDisplayObject(event.target));
			}
		}
	}
}