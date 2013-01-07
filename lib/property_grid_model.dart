part of property_grid;

class PropertyGridModel {
  List<PropertyItem> items = new List<PropertyItem>();
  void register(String name, PropertyItemGetter getter, PropertyItemSetter setter,
      String viewType, String editorType, {var editorConfig, String category, String description}) {
    var item = new PropertyItem(name, getter, setter, viewType, editorType, 
        editorConfig: editorConfig, category: category, description: description);
    items.add(item);
  }
}
