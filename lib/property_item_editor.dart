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
  
  int get gridScrollTop => controller.grid.elementGridWrapper.scrollTop;
}

abstract class IPropertyItemEditorFactory {
  IPropertyItemEditor create(PropertyItemController controller, String type, var editorConfig);
}

class PropertyItemEditorFactory implements IPropertyItemEditorFactory {
  
  static PropertyItemEditorFactory _instance = null;
  static PropertyItemEditorFactory get instance {
    if (_instance == null) {
      _instance = new PropertyItemEditorFactory();
    }
    return _instance;
  }
  
  Map<String, IPropertyItemEditorFactory> customFactories = new Map<String, IPropertyItemEditorFactory>();
  void registerFactory(String type, IPropertyItemEditorFactory factory) {
    customFactories[type] = factory;
  }
  
  IPropertyItemEditor create(PropertyItemController controller, String type, var editorConfig) {
    // Check if we have a custom factory to instantiate the type
    if (customFactories.containsKey(type)) {
      final factory = customFactories[type];
      return factory.create(controller, type, editorConfig);
    }
    
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
    else if (type == "gradient") {
      return new PropertyEditorGradient(controller);
    }
    else if (type == "browse") {
      return new PropertyEditorBrowse(controller);
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
