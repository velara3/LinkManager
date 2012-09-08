



// this class lets you add a bunch of formatters to a string in the sequence you want
// it may in the future let you set targets and target properties
package com.flexcapacitor.formatters {
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.collections.XMLListCollection;
	import mx.formatters.Formatter;

	[DefaultProperty("dataProvider")]

	[DefaultBindingProperty(source="selectedItem", destination="dataProvider")]

	public class FormatterSequence {
		
		public function FormatterSequence() {
			
		}
		
		// formats the value passed in using each of the formatters in the formatters array
		public function format(value:Object):String {
			for each (var formatter:Formatter in collection) {
				if (formatter==null) continue;
				value = formatter.format(value);
			}
			return String(value);
		}
		
		[ArrayElementType("Object")]
        protected var collection:ICollectionView;
        private var _originalDataProvider:Object;
    	protected var actualCollection:ICollectionView;
		
		public function get dataProvider():Object {
			
	        if (_originalDataProvider) {
				return _originalDataProvider;
	        }
	        return collection;
	    }
		
		public function set dataProvider(value:Object):void {
			_originalDataProvider = value;
	        if (collection) {
	            //collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
	        }

	        if (value is Array) {
	            collection = new ArrayCollection(value as Array);
	        }
	        else if (value is ICollectionView) {
	            collection = ICollectionView(value);
	        }
	        else if (value is IList) {
	            collection = new ListCollectionView(IList(value));
	        }
	        else if (value is XMLList) {
	            collection = new XMLListCollection(value as XMLList);
	        }
	        else if (value is XML) {
	            var xl:XMLList = new XMLList();
	            xl += value;
	            collection = new XMLListCollection(xl);
	        }
	        else {
	            // convert it to an array containing this one item
	            var tmp:Array = [];
	            if (value != null) {
	                tmp.push(value);
		        }
	            collection = new ArrayCollection(tmp);
	        }
		}
		
		
		private var _targets:Array = new Array();
		
		// array of targets to apply this to
		// not created yet. would have FormatterTarget class
		// target, property, active or enabled 
		public function set targets(targets:Array):void {
			_targets = targets;
		}
		
		public function get targets():Array {
			return _targets;
		}
	}
}