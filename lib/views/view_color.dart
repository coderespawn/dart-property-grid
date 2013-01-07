part of property_grid;

class PropertyViewColor extends PropertyItemViewBase {
  /** The color preview box shown on the right */
  Element elementColorPreview;

  /** The color text label element */
  Element elementColorText;
  
  PropertyViewColor(PropertyItemController controller, Element elementCell)
      : super(controller, elementCell)
  {
    elementView = new DivElement();
    elementView.classes.add("property-grid-item-view-color-base");
    elementCell.nodes.add(elementView);

    elementColorPreview = new DivElement();
    elementColorPreview.classes.add("property-grid-item-view-color-preview");
    elementView.nodes.add(elementColorPreview);

    elementColorText = new DivElement();
    elementColorText.classes.add("property-grid-item-view-color-text");
    elementView.nodes.add(elementColorText);

    _initialize();
    refresh();
  }

  /** Refreshes the value in the view to reflect the value shown in the model */
  void refresh() {
    // Set the text
    var value = controller.model.getValue();
    elementColorText.innerHtml = value.toString();
    
    // Set the preview color
    var color = new ColorValue.from(value);
    elementColorPreview.style.backgroundColor = color.toString();
  }
}
