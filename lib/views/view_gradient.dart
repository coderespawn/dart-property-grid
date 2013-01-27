part of property_grid;

class PropertyViewGradient extends PropertyItemViewBase {
  /** The color preview box shown on the right */
  CanvasElement gradientPreview;

  PropertyViewGradient(PropertyItemController controller, Element elementCell)
      : super(controller, elementCell)
  {
    elementView = new DivElement();
    elementView.classes.add("property-grid-item-view-gradient-base");
    elementCell.nodes.add(elementView);

    gradientPreview = new CanvasElement();
    gradientPreview.classes.add("property-grid-item-view-gradient-preview");
    elementView.nodes.add(gradientPreview);

    _initialize();
    refresh();
  }
  
  /** Refreshes the value in the view to reflect the value shown in the model */
  void refresh() {
    // Set the text
    GradientValue value = controller.model.getValue();
    gradientPreview.width = gradientPreview.clientWidth;
    gradientPreview.height = gradientPreview.clientHeight;
    
    final context = gradientPreview.context2d;
    var canvasGradient = context.createLinearGradient(0, 0, gradientPreview.width, 0);
    value.stops.forEach((stop) {
      canvasGradient.addColorStop(stop.location, stop.color.toString());
    });
    
    context.save();
    context.fillStyle = canvasGradient;
    context.fillRect(0, 0, gradientPreview.width, gradientPreview.height);
    context.restore();
  }
}
