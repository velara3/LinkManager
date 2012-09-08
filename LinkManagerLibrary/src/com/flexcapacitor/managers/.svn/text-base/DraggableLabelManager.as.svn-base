package com.flexcapacitor.managers
{

	/**
	 *  Class is a Singleton
	 */
	public class DraggableLabelManager
	{
		private static var instance:DraggableLabelManager;
		private static var created:Boolean;
		public var target:*;
		public var isDragging:Boolean = false;
		public var isDraggingOut:Boolean = false;
		public var selectedColor:int = 0;
		public var selectedColorSize:int = 0;
		
		/**
		 * Constructor - Singleton
		 */
		public function DraggableLabelManager()
		{
			if ( !created )
			{
				throw new Error("DraggableLabelManager Class cannot be instantiated");
			}
		}
		
		/**
		 * Returns the one single instance of this class
		 */
		public static function getInstance():DraggableLabelManager
		{
			if (instance == null)
			{
				created = true;
				instance = new DraggableLabelManager();
				created = false;
			}
			
			return instance;
		}
	}
}