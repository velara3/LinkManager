




package com.flexcapacitor.actions {
	
	import com.flexcapacitor.managers.LinkManager;
	import com.flexcapacitor.utils.StateUtils;
	import com.flexcapacitor.vo.StateOption;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;
	import mx.states.SetProperty;

	/** 
	 *  
	 *
	 *  @eventType flash.events.Event
	 */
	[Event(name="callFunction", type="flash.events.Event")]
	
	public class SetPageTitle extends Action implements IDefaultAction {
		
		protected var instance:mx.states.SetProperty;
		
		public function SetPageTitle(title:String = null) {
			instance = new mx.states.SetProperty();
			if (title!=null) value = title;
		}
		
		private var _target:Object;
		
		[Inspectable(category="General")]
		/**
		 * Lists the title before the project name if project name is specified
		 **/
		public var isTitleBeforeProjectName:Boolean = false;
		
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
		
		[Inspectable(category="General")]
		public function set value(value:String):void {
			instance.value = value;
		}
		
		/**
		 *  @private
		 */
		public function get value():String {
			return instance.value;
		}
		
		// TODO: Maybe convert this to SetProperty = see gotostate
		override public function apply(parent:UIComponent = null):void {
			var browserManager:IBrowserManager = BrowserManager.getInstance();
			linkManager = LinkManager.getInstance();
			var projectName:String = linkManager.projectName;
			var stateOptions:Array = linkManager.stateOptions;
			var title:String = value;
			var fullTitle:String = "";
			
			// if its just an anchor (changing vertical location) don't update the page title
			if (linkInfo.isAnchor) return;
			
			// if parent component is null get the application
			parent = (parent==null) ? UIComponent(application) : parent;
			
			// if target is null get the direct parent of the state
			// or application if parent isn't specified
			var targetObject:Object = instance.target ? instance.target : parent;
			
			if (projectName=="") {
				var originalPageTitle:String = linkManager.applicationPageTitle;
				if (originalPageTitle!=null && originalPageTitle!="") {
					projectName = originalPageTitle;
				}
			}
			
			// check state options to see if we need to show an alias or even display anything at all
			for each (var stateOption:StateOption in stateOptions) {
				var stateName:String = (stateOption.state!=null) ? stateOption.state.name : stateOption.stateName;
				
				if (stateName==StateUtils.getCurrentState(targetObject)) {
					
					if (stateOption.showDisplayName) {
						title = stateOption.displayName;
					}
					else {
						title = "";
					}
					break;
				}
			}
			
			// use the page title value if available
			if (linkInfo.pageTitle!="") {
				title = linkInfo.pageTitle;
			}
			
			
			// check the project name and arrange the full title
			if (projectName!="") {
				
				if (isTitleBeforeProjectName) {
					fullTitle = (title != "" && title!=null) ? title + " - " + projectName : projectName;
				}
				else {
					fullTitle = (title != "" && title!=null) ? projectName + " - " + title : projectName;
				}
			}
			else {
				fullTitle = title;
			}
			
			if (fullTitle!=null) {
				browserManager.setTitle(fullTitle);
			}
			
		}
		
	}
}