




package com.flexcapacitor.context.menu {
	
	import com.flexcapacitor.controls.ImageViewer;
	
	import flash.events.ContextMenuEvent;
	

	public class ImageViewerClose extends MenuItem {

		
		public function ImageViewerClose() {
			super();
			
			caption = "Close Image Preview";
		}
		
		override public function itemSelectedHandler(event:ContextMenuEvent):void {
			if (mouseTarget is ImageViewer) {
				ImageViewer(mouseTarget).removePreview();
			}
			else if (mouseTarget.parent is ImageViewer) {
				ImageViewer(mouseTarget.parent).removePreview();
			}
		}
	}
}