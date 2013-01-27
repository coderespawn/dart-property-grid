part of property_grid;

typedef PropertyItemSetter(value);
typedef PropertyItemGetter();

/** 
 * Property Grid Item represents the definition of a property item within 
 * the property grid.
 */
class PropertyItem {
  PropertyItem(this.name, this.getValue, this.setValue, this.viewType, this.editorType, 
      {this.editorConfig, this.category, this.description}) {
    if (category == null) {
      category = "Misc";
    }
  }
  
  /** The name of the property item.  This name is displayed in the property grid */
  String name;

  /** 
   * The getter function for the item. Used by the property grid to query
   * the value 
   */
  PropertyItemGetter getValue;
  
  /** 
   * The setter function for the item. Used by the property grid to set the 
   * value when it changes 
   */
  PropertyItemSetter setValue;
  
  /** The editor that is displayed for editing this property item */ 
  String editorType;

  /** Custom configuration data for the editor */
  var editorConfig;
  
  /** The view that is used to display the value in the property grid item */ 
  String viewType;
  
  /** The description of the item. Displayed when the user clicks the item */
  String description;
  
  /** 
   * The category this item belongs to.  Property items are grouped based on the
   * category in the property grid
   */
  String category;
}
