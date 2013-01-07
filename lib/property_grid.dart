part of property_grid;

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
  Element elementDescription;
  
  set description(String value) => elementDescription.innerHtml = value;
  
  /** The currently selected object's property grid model */
  PropertyGridModel _model = null;
  PropertyGridModel get model => _model;
  
  /** Controllers for each item created for the current model */
  List<PropertyItemController> itemControllers = new List<PropertyItemController>();
  
  /** 
   * The currently selected item in the property grid.  This item would be 
   * highlighted and it's description would be shown 
   */
  PropertyItemController _selectedPropertyItem;
  
  set model(PropertyGridModel value) {
    _model = value;
    _bindModel();
  }
  
  PropertyGrid(this.elementClient) {
    elementBase = new DivElement();
    elementBase.classes.add("property-grid-base");
    elementClient.nodes.add(elementBase);
    
    elementGridWrapper = new DivElement();
    elementGridWrapper.classes.add("property-grid-wrapper");
    elementBase.nodes.add(elementGridWrapper);
    
    grid = new TableElement();
    grid.classes.add("property-grid");
    elementGridWrapper.nodes.add(grid);
    
    elementDescription = new DivElement();
    elementDescription.classes.add("property-grid-description");
    elementBase.nodes.add(elementDescription);
  }

  /** Binds the model to the grid */
  void _bindModel() {
    // dispose off the existing item controllers
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
    
    for (var category in itemsByCategory.keys) {
      var categoryElement = _insertCategoryElement(category);
      var categoryItems = itemsByCategory[category];
      for (var item in categoryItems) {
        _insertPropertyItem(item, categoryElement);
      }
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
    categoryRow.on.click.add((e) {
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
}

class PropertyGridException {
  String message;
  PropertyGridException(this.message);
  String toString() => message;
}

