part of property_grid;

/** Holds the item and all the relavant objects needed to display a property item */
class PropertyItemController {
  /** The parent property grid this item controller belongs to */
  PropertyGrid grid;
  
  /** The property item model managed by this controller */
  PropertyItem model;
  
  /** The view to display the property item's value */
  IPropertyItemView view;
  
  /** The editor that is displayed to edit the value */
  IPropertyItemEditor editor;
  
  /** The element that displays the Name of the property item */
  Element elementCellName;
  
  /** The element that displays the Value of the property item  */
  Element elementCellValue;
  
  /** Indicates if the item is selected */
  bool selected;
  
  /** The CSS selector to apply on the selected name element */
  final String selectedCssClass = "property-grid-item-name-selected";
  
  /** Value before the edit was started.  This is passed to the listener when the edit operation completes */
  var valueBeforeEdit;
  
  PropertyItemController(this.grid, this.model, this.elementCellName, this.elementCellValue) {
    view = PropertyItemViewFactory.create(this, model.viewType, elementCellValue);
    if (model.editorType != null) {
      editor = PropertyItemEditorFactory.create(this, model.editorType, model.editorConfig);
    }
    
    elementCellName.onClick.listen((e) => grid.onItemSelected(this));
    view.elementView.onClick.listen((e) => grid.onItemSelected(this));
  }
  
  void dispose() {
    if (view != null) {
      view.dispose();
      view = null;
    }
    
    if (editor != null) {
      editor.dispose();
      editor = null;
    }
  }
  
  
  void setSelected(bool selected) {
    this.selected = selected;
    if (selected) {
      elementCellName.classes.add(selectedCssClass);
    } else {
      elementCellName.classes.remove(selectedCssClass);
    }
  }
  
  void setViewVisible(bool visible) {
    view.elementView.style.display = visible ? "block" : "none";
  }
  
  /** Called from the UI */
  void requestValueChange(value) {
    model.setValue(value);
    view.refresh();
    grid.onPropertyChanged(this);
  }

  void onViewClicked() {
    if (editor != null) {
      valueBeforeEdit = model.getValue();
      editor.showEditor();
    }
  }
  
  void finishEditing(value) {
    editor.hideEditor();
    model.setValue(value);
    view.refresh();
    
    if (grid._notifyPropertyEditComplete != null) {
      var newValue = model.getValue();
      grid._notifyPropertyEditComplete(this, valueBeforeEdit, newValue);
    }
  }
  
  void refreshView() => view.refresh();
}
