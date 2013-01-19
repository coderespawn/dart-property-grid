part of property_grid;

/** 
 * Property editors are invoked when a property view is clicked.  It lets 
 * the user modify the value of the property item
 */
abstract class IPropertyItemEditor {
  void showEditor();
  void hideEditor();
  void dispose();
}

abstract class PropertyItemEditorBase implements IPropertyItemEditor {
  PropertyItemController controller;
  PropertyItemEditorBase(this.controller);
}

class PropertyItemEditorFactory {
  static IPropertyItemEditor create(PropertyItemController controller, String type, var editorConfig) {
    if (type == null) {
      return new DummyPropertyItemEditor();
    }
    else if (type == "textbox") {
      return new PropertyEditorTextbox(controller);
    }
    else if (type == "slider") {
      return new PropertyEditorSlider(controller);
    }
    else if (type == "spinner") {
      return new PropertyEditorSpinner(controller);
    }
    else if (type == "color") {
      return new PropertyEditorColor(controller);
    }
    else {
      throw new PropertyGridException("Cannot create property item editor of type $type");
    }
  }
}

/** Use this if no editor is required */
class DummyPropertyItemEditor implements IPropertyItemEditor {
  void showEditor() {}
  void hideEditor() {}
  void dispose() {}
}