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
}

abstract class PropertyItemViewBase implements IPropertyItemView {
  /** The property item controller of this view */
  PropertyItemController controller;
  
  Element elementCell;
  Element elementView;

  var _handlerOnClick;
  PropertyItemViewBase(this.controller, this.elementCell);
  
  void _initialize() {
    if (elementView == null) {
      throw new Exception("View element has not been created yet");
    }
    
    _handlerOnClick = _onMouseClick;
    elementView.on.click.add(_handlerOnClick);
  }
  
  void dispose() {
    elementView.on.click.remove(_handlerOnClick);
    elementView.remove();
    elementView = null;
  }
  
  void _onMouseClick(MouseEvent e) {
    controller.onViewClicked();
    e.preventDefault();
    e.stopPropagation();
  }
}


class PropertyItemViewFactory {
  static IPropertyItemView create(PropertyItemController controller, String type, Element elementCell) {
    if (type == "label") {
      return new PropertyViewLabel(controller, elementCell);
    } 
    if (type == "color") {
      return new PropertyViewColor(controller, elementCell);
    } 
    else {
      throw new PropertyGridException("Cannot created property item view of type $type");
    }
  }
}