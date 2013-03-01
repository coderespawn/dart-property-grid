part of property_grid;

class PropertyViewLabel extends PropertyItemViewBase {
  PropertyViewLabel(PropertyItemController controller, Element elementCell)
      : super(controller, elementCell)
  {
    elementView = new DivElement();
    elementView.classes.add("property-grid-item-view-label");
    elementCell.nodes.add(elementView);
    _initialize();
    refresh();
  }

  /** Refreshes the value in the view to reflect the value shown in the model */
  void refresh() {
    var value = controller.model.getValue();
    elementView.innerHtml = value.toString();
  }
}


class PropertyViewLabelShort extends PropertyViewLabel {
  PropertyViewLabelShort(PropertyItemController controller, Element elementCell)
      : super(controller, elementCell) {
    
  }
  
  /** Refreshes the value in the view to reflect the value shown in the model */
  void refresh() {
    var value = controller.model.getValue().toString();
    final maxLength = 12;
    if (value.length > maxLength) {
      value = "${value.substring(0, maxLength)}...";
    }
    elementView.innerHtml = value.toString();
  }
}