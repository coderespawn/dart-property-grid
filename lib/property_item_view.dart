part of property_grid;

/** Represents the view that displays the value of the grid item */
abstract class IPropertyItemView {
  /** The property item controller of this view */
  PropertyItemController controller;
  
  /** The element of the value cell */ 
  Element get elementView;
  
  /** Refreshes the value in the view to reflect the value shown in the model */
  void refresh();
  
  /** Dispose off the property item view */
  void dispose();

  /** Notified by the grid when the grid is resized */
  void onResized();
}

abstract class PropertyItemViewBase implements IPropertyItemView {
  /** The property item controller of this view */
  PropertyItemController controller;
  
  Element elementCell;
  Element elementView;

  StreamSubscription _onClickSubscription;
  PropertyItemViewBase(this.controller, this.elementCell);
  
  void _initialize() {
    if (elementView == null) {
      throw new Exception("View element has not been created yet");
    }
    
    _onClickSubscription = elementView.onClick.listen(_onMouseClick);
  }
  
  void dispose() {
    _onClickSubscription.cancel();
    elementView.remove();
    elementView = null;
  }
  
  void _onMouseClick(MouseEvent e) {
    controller.onViewClicked();
    e.preventDefault();
    e.stopPropagation();
  }

  void onResized() {
  }
}

abstract class IPropertyItemViewFactory {
  IPropertyItemView create(PropertyItemController controller, String type, Element elementCell);
}

class PropertyItemViewFactory implements IPropertyItemViewFactory {

  static IPropertyItemViewFactory _instance = null;
  static IPropertyItemViewFactory get instance {
    if (_instance == null) {
      _instance = new PropertyItemViewFactory();
    }
    return _instance;
  }

  Map<String, IPropertyItemViewFactory> customFactories = new Map<String, IPropertyItemViewFactory>();
  void registerFactory(String type, IPropertyItemViewFactory factory) {
    customFactories[type] = factory;
  }
  
  
  IPropertyItemView create(PropertyItemController controller, String type, Element elementCell) {
    // Check if we have a custom factory to instantiate the type
    if (customFactories.containsKey(type)) {
      final factory = customFactories[type];
      return factory.create(controller, type, elementCell);
    }
    
    if (type == "label") {
      return new PropertyViewLabel(controller, elementCell);
    } 
    else if (type == "label_short") {
      return new PropertyViewLabelShort(controller, elementCell);
    } 
    else if (type == "color") {
      return new PropertyViewColor(controller, elementCell);
    }
    else if (type == "gradient") {
      return new PropertyViewGradient(controller, elementCell);
    }
    else {
      throw new PropertyGridException("Cannot created property item view of type $type");
    }
  }
}