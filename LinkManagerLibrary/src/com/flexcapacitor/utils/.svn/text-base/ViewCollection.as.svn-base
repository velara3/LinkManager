
/**
 * VIEW COLLECTION
 * (C) Judah Frangipane
 * 
 * 	An ArrayCollection with a View Cursor built in
 *
 *  Defines the interface for enumerating a collection view bi-directionally.
 *  This cursor provides find, seek, and bookmarking capabilities along
 *  with the modification methods insert and remove.  
 *  When a cursor is first retrieved from a view, (typically by the ICollectionView
 *  <code>createCursor()</code> method) the value of the 
 *  <code>current</code> property should be the first
 *  item in the view, unless the view is empty.
 * 
 * PHP: products.productID IN ('5', 5+1, 5-1)
 *
 * Usage:
 * <ViewCollection dataProvider="{myArray}" />
 **/
 
 // TODO: convert move next and move prev to use the current index, current id
 // TODO: add move next page, move previous page
 // TODO: add page size property
 // TODO: add current page index property
package com.flexcapacitor.utils {
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.CursorBookmark;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.collections.ListCollectionView;
	import mx.collections.SortField;
	import mx.collections.XMLListCollection;
	import mx.events.CollectionEvent;
	
	/**
	 *  Dispatched whenever the cursor position is updated.
	 *
	 *  @eventType mx.events.FlexEvent.CURSOR_UPDATE
	 */
	[Event(name="cursorUpdate", type="mx.events.FlexEvent")]

	public class ViewCollection extends ArrayCollection {
		
		// constructor
		public function ViewCollection(array:* = null) {
			if (array != null) {
				dataProvider = array;
			}
		}

		private var initialCollection:ICollectionView = new ArrayCollection([]);
		
		public var viewCursor:IViewCursor = initialCollection.createCursor();

		private var _collection:ICollectionView = initialCollection;
		
		
		// set this to an array, array collection or xmllistcollection 
		public function set collection(object:*):void {
			if (object is Array) {
				_collection = new ArrayCollection(object);
			}
			else if (object is ArrayCollection) {
				_collection = object;
			}
			else if (object is XMLListCollection) {
				_collection = object;
			}
			else if (object is Object) {
				_collection = new ArrayCollection([object]);
			}
			
			// create cursor
			viewCursor = ICollectionView(_collection).createCursor();
			
			// set current index
			viewIndex = viewCursor.bookmark.getViewIndex();
			
			// apply any sorts
			_collection.sort = sort;
			
			// apply filters
			_collection.filterFunction = filterHandler;
			
			// refresh collection
			_collection.refresh();
			
			// check for queued lookups
			if (_currentId!=null && _currentId!="") {
				currentId = _currentId;
			}
			
			if (!ICollectionView(_collection).hasEventListener(CollectionEvent.COLLECTION_CHANGE)) {
				ICollectionView(_collection).addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
		}

		public function get collection():* {
			return _collection;
		}
		
		// this is the view cursor. use this to get the sorted and / or filtered view
		// if you set this property set it to the array, arraycollection or xmllistcollection
		// and a new view cursor will be created
		[Bindable]
		public function set dataProvider(object:*):void {
			if (object is IViewCursor) {
				trace("ViewCollection: Set the dataprovider to an array or collection not a view cursor");
				return;
			}
			if (object is Array) {
				_collection = new ArrayCollection(object);
			}
			else if (object is ArrayCollection) {
				_collection = object;
			}
			else if (object is XMLListCollection) {
				_collection = object;
			}
			else if (object is Object) {
				_collection = new ArrayCollection([object]);
			}
			
			// set the current index
			if (_collection.length>0) {
				currentIndex = 0;
			}
			
			// create cursor
			viewCursor = ICollectionView(_collection).createCursor();
			
			// set current index
			viewIndex = viewCursor.bookmark.getViewIndex();
			
			// apply any sorts
			_collection.sort = sort;
			
			// apply filters
			_collection.filterFunction = filterHandler;
			
			// refresh collection
			_collection.refresh();
			
			// check for queued lookups
			if (_currentId!=null && _currentId!="") {
				updateId(_currentId);
			}
			
			// add handler for events
			if (!ICollectionView(_collection).hasEventListener(CollectionEvent.COLLECTION_CHANGE)) {
				ICollectionView(_collection).addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
			}
		}

		public function get dataProvider():* {
			if (_isDataProviderView) {
				return viewCursor.view;
			}
			else {
				return _collection;
			}
		}
		
		private var _isDataProviderView:Boolean = false;
		
		// makes the dataProvider return the view instead of the collection. default is the collection
		public function set isDataProviderView(value:Boolean):void {
			_isDataProviderView = value;
		}
		
		
		public function get isDataProviderView():Boolean {
			return _isDataProviderView;
		}
		
		private var _filters:Array = [];
		
		// array of CollectionFilter objects with filter settings
		[Bindable]
		public function set filters(value:Array):void {
			// TODO: make this work
			// we want to grab the list of CollectionFilters and apply them to the array collection
			
       		dispatchEvent(new Event("filtersChanged"));
		}
		
		public function get filters():Array {
			return _filters;
		}
		
		// a list of sort fields
		public function set sortFields(value:Array):void {
			sort.fields = new Array(new SortField(null));
			sort.fields = value;
			_collection.sort = sort;
			_collection.refresh();
       		dispatchEvent(new Event("sortFieldsChanged"));
		}

		private var _viewIndex:int = 1;

		// todo: make this work
		public function set viewIndex(value:int):void {
			var currentViewIndex:int = viewCursor.bookmark.getViewIndex();
			var difference:int = currentViewIndex - value;
			
			// loop through the view forward or back until you get to new index
			// todo: test
			viewCursor.seek(CursorBookmark.CURRENT, difference);
			
		}
		
		// get current index in the view cursor (zero based index)
		public function get viewIndex():int {
			return viewCursor.bookmark.getViewIndex();
		}

		private var _currentIndex:int = 0;
		
		// sets the current index in the array collection
		// and updates the previousItem, currentItem and nextItem class objects
		// use the viewIndex to set the index in the view
		public function set currentIndex(index:int):void {
			updateItems(index);
			
		}

		// gets the current index of the collection
		public function get currentIndex():int {
			return _currentIndex;
		}
		
		// key on the objects in the collection
		// if the objects in the array are strings this value is ignored
		// if no key is set then it checks for "id" if that's not available then 
		// it exits 
		[Bindable]
		public var key:* = "id";

		private var _currentId:String = "";
		
		// finds the string that matches the value you pass in
		// or if the collection contains objects then looks at the key in the object
		// and compares it to the value you pass in
		// make sure to set the "key" to the name of the id field in your object
		// @see key
		[Bindable]
		public function set currentId(value:*):void {
			// we call updateId because if the value is the same as the _currentId then nothing 
			// inside the setter is run
			updateId(value);
		}
		
		// the current id
		public function get currentId():String {
			return _currentId;
		}
		
		public function updateId(value:String):void {
			var currentIdLocation:int = 0;
			
			// if current id is empty store it for later use
			if (value!="") {
				_currentId = value;
			}
			
			var length:int = ICollectionView(collection).length;
			
			// loop through the items in the collection
			for (var i:uint=0;i<length;i++) {
				var item:* = collection[i];
				
				// if collection item is a string do a string comparison
				if (item is String) {
					if (item==value) {
						// get current item
						// set current item
						// set next item
						// set previous item
						currentIdLocation = i;
						updateItems(currentIdLocation);
						break;
					}
				}
				else if (item is Object) {
					if (Object(item).hasOwnProperty(key)) {
						var itemValue:String = item[key]  as String;
						if (itemValue==value) {
							currentIdLocation = i;
							updateItems(currentIdLocation);
							break;
						}
					}
				}
			}
		}
		
		// sets the current, next and previous items by index in the collection
		public function updateItems(index:int):void {
			_currentIndex = index;
			var length:int = ListCollectionView(collection).length;
			var currentCollectionItem:*;
			var previousIndex:int = index-1;
			var nextIndex:int = index+1;
			
			// CURRENT ITEM
			// make sure we are in bounds
			if (!(index<0) && !(index>length-1)) {
				currentItem = ListCollectionView(collection).getItemAt(index);
			}
			
			// NEXT ITEM
			if (!(nextIndex<0) && !(nextIndex>length-1)) {
				nextItem = ListCollectionView(collection).getItemAt(nextIndex);
				afterLast = false;
				afterLastVisible = true;
			}
			else {
				afterLast = true;
				afterLastVisible = false;
			}
			
			// PREVIOUS ITEM
			if (!(previousIndex<0) && !(previousIndex>length-1)) {
				previousItem = ListCollectionView(collection).getItemAt(previousIndex);
				beforeFirst = false;
				beforeFirstVisible = true;
			}
			else {
				beforeFirst = true;
				beforeFirstVisible = false;
			}
		
			
			// view cursor method
			/* var currentCollectionItem:* = ListCollectionView(collection).getItemAt(index);
			var currentView:IViewCursor = ListCollectionView(collection).createCursor();
			var currentBookmark:CursorBookmark = currentView.bookmark;
			
			// find the item in the view
			currentView.findAny(currentCollectionItem);
			currentBookmark = currentView.bookmark
			
			if (currentView.current!=null) {
				// set current item
				currentItem = currentView.current;
				
				// set previous item
				currentView.seek(currentBookmark, -1);
				
				if (currentView.beforeFirst) {
					previousItem = "";
				}
				else {
					previousItem = currentView.current;
				}
				
				// set next item
				currentView.seek(currentBookmark, +1);
				
				if (currentView.afterLast) {
					nextItem = "";
				}
				else {
					nextItem = currentView.current;
				}
			} */
			
		}
		
		// function that runs collection filters
		public function filterHandler(item:*):Boolean {
			var valid:Boolean = true;
			
			// loop through the filters and make sure we have a match
			for each (var filter:CollectionFilter in filters) {
				filter.validate(item);
				
				if (!filter.valid) { 
					valid = false;
				}
			}
			
			return valid;
		}
		
		private var _afterLast:Boolean = false;

		// returns if we are after the last item in the collection
	    [Bindable("cursorUpdate")]
		public function set afterLast(value:Boolean):void {
			_afterLast = value;
		}
		public function get afterLast():Boolean {
			return _afterLast;
		}

		private var _beforeFirst:Boolean = false;
		
		// returns if we are before the first item in the collection
	    [Bindable("cursorUpdate")]
		public function set beforeFirst(value:Boolean):void {
			_beforeFirst = value;
		}
		public function get beforeFirst():Boolean {
			return _beforeFirst;
		}

		private var _afterLastVisible:Boolean = true;
		
		// when the item after the current item is available this value is true
		// used to show or hide visual components through data binding to the visible and include in layout properties
	    [Bindable]
		public function set afterLastVisible(value:Boolean):void {
			_afterLastVisible = value;
		}
		public function get afterLastVisible():Boolean {
			return _afterLastVisible;
		}

		private var _beforeFirstVisible:Boolean = true;
		
		// when the item before the current item is available this value is true
		// used to show or hide visual components through data binding to the visible and include in layout properties
	    [Bindable]
		public function set beforeFirstVisible(value:Boolean):void {
			_beforeFirstVisible = value;
		}
		public function get beforeFirstVisible():Boolean {
			return _beforeFirstVisible;
		}

		private var _currentVisible:Boolean = true;
		
		// when the item before the current item is available this value is true
		// used to show or hide visual components through data binding to the visible and include in layout properties
	    [Bindable]
		public function set currentVisible(value:Boolean):void {
			_currentVisible = value;
		}
		public function get currentVisible():Boolean {
			return _currentVisible;
		}
		
	    [Bindable("cursorUpdate")]
		public function get bookmark():CursorBookmark {
			return viewCursor.bookmark;
		}
		
		private var _currentItem:* = {};
		
		// gets current item in the collection
	    [Bindable]
		public function set currentItem(value:*):void {
			_currentItem = value;
		}
		
		// gets current item in the collection
		public function get currentItem():Object {
			return _currentItem;
		}
		
		private var _previousItem:* = {};

		// gets previous item in the collection
	    [Bindable]
		public function set previousItem(value:*):void {
			_previousItem = value;
		}

		public function get previousItem():Object {
			return _previousItem;
		}
		
		private var _nextItem:* = {};

		// gets previous item in the collection
	    [Bindable]
		public function set nextItem(value:*):void {
			_nextItem = value;
		}

		// gets next item in the collection
		public function get nextItem():Object {
			return _nextItem;
		}
		
		private var _pageSize:int = 10;

		// sets the page size in the collection
	    [Bindable]
		public function set pageSize(value:int):void {
			_pageSize = value;
		}

		public function get pageSize():int {
			return _pageSize;
		}
		
		private var _currentPage:int = 10;

		// sets the current page index in the collection
	    [Bindable]
		public function set currentPage(value:int):void {
			_currentPage = value;
		}

		public function get currentPage():int {
			return _currentPage;
		}

		// gets current item in the view cursor
	    [Bindable("cursorUpdate")]
		public function get current():Object {
			return viewCursor.current;
		}

		// gets previous item in the view cursor
	    [Bindable("cursorUpdate")]
		public function get previous():Object {
			return viewCursor.current;
		}

		// gets next item in the view cursor
	    [Bindable("cursorUpdate")]
		public function get next():Object {
			return viewCursor.current;
		}
		
		public function get view():Object {
			return viewCursor.view;
		}

		public function findAny(values:Object):Boolean {
			return viewCursor.findAny(values);
		}

		public function findFirst(values:Object):Boolean {
			return viewCursor.findFirst(values);
		}

		public function findLast(values:Object):Boolean {
			return viewCursor.findLast(values);
		}

		public function insert(item:Object):void {
			return viewCursor.insert(item);
		}

		public function remove():Object {
			return viewCursor.remove();
		}

		public function seek(bookmark:CursorBookmark, offset:int = 0, prefetch:int = 0):void {
			return viewCursor.seek(bookmark, offset, prefetch);
		}
		
		[Bindable("cursorUpdate")]
		public function collectionChangeHandler(event:CollectionEvent):void {
			dispatchEvent(event);
		}

		public function moveNext():Boolean {
			var validMove:Boolean = viewCursor.moveNext();
			if (!validMove && wrapSearch) {
				var length:int = viewCursor.view.length;
				for(var i:int = 0; i < length; i++) {
					viewCursor.movePrevious();
				}
			}
			viewIndex = viewCursor.bookmark.getViewIndex() + 1;
			return validMove;
		}

		public function movePrevious():Boolean {
			var validMove:Boolean = viewCursor.movePrevious();
			if (!validMove && wrapSearch) {
				var length:int = viewCursor.view.length;
				for(var i:int = 0; i < length; i++) {
					viewCursor.moveNext();
				}
			}
			viewIndex = viewCursor.bookmark.getViewIndex() + 1;
			return validMove;
		}

		// move to the next item in the view
		public function moveNextView():Boolean {
			var validMove:Boolean = viewCursor.moveNext();
			if (!validMove && wrapSearch) {
				var length:int = viewCursor.view.length;
				for(var i:int = 0; i < length; i++) {
					viewCursor.movePrevious();
				}
			}
			viewIndex = viewCursor.bookmark.getViewIndex() + 1;
			return validMove;
		}

		// move to the previous item in the view
		public function movePreviousView():Boolean {
			var validMove:Boolean = viewCursor.movePrevious();
			if (!validMove && wrapSearch) {
				var length:int = viewCursor.view.length;
				for(var i:int = 0; i < length; i++) {
					viewCursor.moveNext();
				}
			}
			viewIndex = viewCursor.bookmark.getViewIndex() + 1;
			return validMove;
		}

		// moves to the next page in the collection
		public function moveNextPage():Boolean {
			var validMove:Boolean = viewCursor.moveNext();
			if (!validMove && wrapSearch) {
				var length:int = viewCursor.view.length;
				for(var i:int = 0; i < length; i++) {
					viewCursor.movePrevious();
				}
			}
			viewIndex = viewCursor.bookmark.getViewIndex() + 1;
			return validMove;
		}

		// moves to the previous page in the collection
		public function movePreviousPage():Boolean {
			var validMove:Boolean = viewCursor.movePrevious();
			if (!validMove && wrapSearch) {
				var length:int = viewCursor.view.length;
				for(var i:int = 0; i < length; i++) {
					viewCursor.moveNext();
				}
			}
			viewIndex = viewCursor.bookmark.getViewIndex() + 1;
			return validMove;
		}

		// get the current index in the view
		// returns 0 if the currentIndex is null
		public function getCurrentPositionView():int {
			var currentIndex:* = viewCursor.bookmark.getViewIndex();
			if (currentIndex == null) {
				return 0;
			}
			else {
				return currentIndex;
			}
		}
		
		// get total number of items in the collection
		public function get totalCount():int {
			return ListCollectionView(collection).length;
		}

		// get total number of items in the view
		public function get totalCountView():int {
			return viewCursor.view.length;
		}

		public var wrapSearch:Boolean = true;

	}
}