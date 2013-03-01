part of property_grid;

typedef void PropertyChangeEvent(PropertyItemController property);
typedef void PropertyEditCompleteEvent(PropertyItemController property, dynamic originalValue, dynamic newValue);

class PropertyGrid {
  /** 
   * The element provided by the client.  The property grid will be placed 
   * inside this element 
   */
  Element elementClient;
  
  /** The base element of the property grid. Other elements are placed inside this */
  Element elementBase;
  
  /** The element that displays the property items */
  TableElement grid;
  
  /** Wrapper element to give the grid the maximum available height */ 
  Element elementGridWrapper;

  /** The element taht displays the description of an item */
  Element elementDescriptionWrapper;
  Element elementDescription;
  
  /** Listener for property value change events */
  PropertyChangeEvent propertyChangeEvent;

  /** Listener for property value change events. Fired when the value editing is done */
  PropertyEditCompleteEvent propertyEditCompleteEvent;
  
  set description(String value) => elementDescription.innerHtml = value;
  
  /** The currently selected object's property grid model */
  PropertyGridModel _model = null;
  PropertyGridModel get model => _model;
  
  /** Controllers for each item created for the current model */
  List<PropertyItemController> itemControllers = new List<PropertyItemController>();
  
  PropertyItemController get(String name) {
    var items = itemControllers.where((item) => item.model.name == name).toList();
    if (items.length == 0) {
      throw new ArgumentError("Cannot find item with the name: $name");
    }
    return items[0];
  }
   
  /** 
   * The currently selected item in the property grid.  This item would be 
   * highlighted and it's description would be shown 
   */
  PropertyItemController _selectedPropertyItem;
  
  set model(PropertyGridModel value) {
    if (_model == value) {
      // Same model object reassigned here.  Refresh
      // the values instead of rebuilding the DOM 
      refresh();
    }
    else {
      // New property model assignement.  rebuild the DOM
      _model = value;
      _bindModel();
    }
  }
  
  PropertyGrid(this.elementClient) {
    elementBase = new DivElement();
    elementBase.classes.add("property-grid-base");
    elementBase.classes.add("property-grid-disable-selection");
    elementClient.nodes.add(elementBase);
    
    elementGridWrapper = new DivElement();
    elementGridWrapper.classes.add("property-grid-wrapper");
    elementBase.nodes.add(elementGridWrapper);
    
    grid = new TableElement();
    grid.classes.add("property-grid");
    elementGridWrapper.nodes.add(grid);
    
    elementDescription = new DivElement();
    elementDescription.classes.add("property-grid-description");
    elementDescriptionWrapper = new DivElement();
    elementDescriptionWrapper.nodes.add(elementDescription);
    elementDescriptionWrapper.classes.add("property-grid-description-wrapper");
    elementBase.nodes.add(elementDescriptionWrapper);
    
    resize();
  }
  
  void resize() {
    final width = elementClient.clientWidth;
    final height = elementClient.clientHeight;
    
    final descriptionHeight = elementDescriptionWrapper.clientHeight;
    final gridHeight = height - descriptionHeight;
    
    elementGridWrapper.style.height = "${gridHeight}px";
    
    // Notify all the views
    
  }

  /** Binds the model to the grid */
  void _bindModel() {
    // dispose off the existing item controllers
    if (_selectedPropertyItem != null && _selectedPropertyItem.editor != null) {
      _selectedPropertyItem.editor.hideEditor();
    }
    itemControllers.forEach((controller) => controller.dispose());
    itemControllers.clear();
    grid.nodes.clear();
    _clearSelectedItem();
    
    description = "";
    if (_model == null) return;

    // Group the items by their categories
    var itemsByCategory = new Map<String, List<PropertyItem>>();
    for (var item in _model.items) {
      if (!itemsByCategory.containsKey(item.category)) {
        itemsByCategory[item.category] = new List<PropertyItem>();
      }
      itemsByCategory[item.category].add(item);
    }
    
    var categoryList = itemsByCategory.keys;
    if (itemsByCategory.keys.length == model.preferedOrder.length) {
      categoryList = model.preferedOrder;
    }
    for (var category in categoryList) {
      var categoryElement = _insertCategoryElement(category);
      var categoryItems = itemsByCategory[category];
      for (var item in categoryItems) {
        _insertPropertyItem(item, categoryElement);
      }
    }
    
  }
  
  void refresh() {
    for (var item in itemControllers) {
      item.refreshView();
    }
    
    itemControllers.forEach((item) => item.view.onResized());
  }
  
  /** Whenever a property value is changed, this function is invoked */
  void onPropertyChanged(PropertyItemController item) {
    if (propertyChangeEvent != null) {
      propertyChangeEvent(item);
    }
  }

  /** Inserts the category element into the DOM */
  Element _insertCategoryElement(String category) {
    var categoryBody = grid.createTBody();
    TableRowElement categoryRow = new TableRowElement();
    categoryRow.classes.add("property-grid-item");
    categoryRow.classes.add("property-grid-category");
    var header = new TableCellElement();
    header.colSpan = 2;
    categoryRow.nodes.add(header);

    final String cssIconPlus = "property-grid-icon-plus";
    final String cssIconMinus = "property-grid-icon-minus";
    
    // Create an icon element to show the expand / collapse state
    var expandIcon = new DivElement();
    expandIcon.classes.add("property-grid-category-icon");
    expandIcon.classes.add(cssIconMinus);
    header.nodes.add(expandIcon);
    
    // Create a div element to place the category text
    var headerElement = new DivElement();
    headerElement.innerHtml = category;
    header.nodes.add(headerElement);

    // Add the category body to the grid
    categoryRow.nodes.add(header);
    categoryBody.nodes.add(categoryRow);
    grid.nodes.add(categoryBody);
    
    // Create a new body for the items that belong to this category
    var categoryItemBody = grid.createTBody();
    categoryItemBody.classes.add("property-grid-category-body");
    grid.nodes.add(categoryItemBody);
    
    // Add code to hide the category item body when the category is clicked
    categoryRow.onClick.listen((e) {
      String hiddenCss = "property-grid-category-body-hide";
      bool hidden = categoryItemBody.classes.contains(hiddenCss);
      if (hidden) {
        // Expand
        categoryItemBody.classes.remove(hiddenCss);
        expandIcon.classes.remove(cssIconPlus);
        expandIcon.classes.add(cssIconMinus);
      } else {
        // Collapse
        categoryItemBody.classes.add(hiddenCss);
        expandIcon.classes.add(cssIconPlus);
        expandIcon.classes.remove(cssIconMinus);
      }
    });
    
    return categoryItemBody;
  }
  
  /** Inserts the Property item elements into the DOM */
  void _insertPropertyItem(PropertyItem model, Element parent) {
    var name = model.name;
    var value = model.getValue();
    var cellName = new TableCellElement();
    cellName.classes.add("property-grid-item-name");

    var cellNameText = new DivElement();
    cellNameText.innerHtml = name;
    cellNameText.classes.add("property-grid-item-name-text");
    cellName.nodes.add(cellNameText);

    var cellValue = new TableCellElement();
    cellValue.classes.add("property-grid-item-value");

    TableRowElement row = new TableRowElement();
    row.classes.add("property-grid-item");
    row.nodes.add(cellName);
    row.nodes.add(cellValue);
    parent.nodes.add(row);
    
    // Create and add the item view
    var itemController = new PropertyItemController(this, model, cellName, cellValue);
    itemControllers.add(itemController);
  }

  /** 
   * Clears the selected item from the property grid. This includes
   * removing any highlights and from the description field
   */
  void _clearSelectedItem() {
    if (_selectedPropertyItem != null) {
      _selectedPropertyItem.setSelected(false);
    }
    _selectedPropertyItem = null;
    elementDescription.innerHtml = "";
  }
   
  /** 
   * Called when the property item row is selected. Sets the current item 
   * to selected state. Highlights the row and sets it's description
   */
  void onItemSelected(PropertyItemController controller) {
    _clearSelectedItem();
    _selectedPropertyItem = controller;
    elementDescription.innerHtml = controller.model.description;
    controller.setSelected(true);
  }
  
  void _notifyPropertyEditComplete(PropertyItemController property, dynamic originalValue, dynamic newValue) {
    if (propertyEditCompleteEvent != null) {
      propertyEditCompleteEvent(property, originalValue, newValue);
    }
  }
}

class PropertyGridException {
  String message;
  PropertyGridException(this.message);
  String toString() => message;
}

