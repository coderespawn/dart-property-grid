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
