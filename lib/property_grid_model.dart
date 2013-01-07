part of property_grid;

class PropertyGridModel {
  /** The items of the property grid */
  List<PropertyItem> items = new List<PropertyItem>();
  
  /** The prefered order of the category */
  List<String> preferedOrder = new List<String>();
  
  void register(String name, PropertyItemGetter getter, PropertyItemSetter setter,
      String viewType, String editorType, {var editorConfig, String category, String description}) {
    var item = new PropertyItem(name, getter, setter, viewType, editorType, 
        editorConfig: editorConfig, category: category, description: description);
    items.add(item);
    
    if (!preferedOrder.contains(item.category)) {
      preferedOrder.add(item.category);
    }
  }
}
