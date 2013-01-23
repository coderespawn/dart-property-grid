part of property_grid;

class PropertyViewBrowse extends PropertyItemViewBase {
  /** The color preview box shown on the right */
  InputElement btnBrowse;
  
  /** Container to hold the browse buttons */
  Element elementBrowseContainer;

  /** The color text label element */
  Element elementBrowseText;
  
  PropertyViewBrowse(PropertyItemController controller, Element elementCell)
      : super(controller, elementCell)
  {
    elementView = new DivElement();
    elementView.classes.add("property-grid-item-view-browse-base");
    elementCell.nodes.add(elementView);

    elementBrowseContainer = new DivElement();
    elementBrowseContainer.classes.add("property-grid-item-view-browse-button");
    elementView.nodes.add(elementBrowseContainer);
    
    
    btnBrowse = new InputElement();
    btnBrowse.type = "file";
    elementBrowseContainer.nodes.add(btnBrowse);

    elementBrowseText = new DivElement();
    elementBrowseText.classes.add("property-grid-item-view-browse-text");
    elementView.nodes.add(elementBrowseText);

    _initialize();
    refresh();
  }

  /** Refreshes the value in the view to reflect the value shown in the model */
  void refresh() {
    // Set the text
    var value = controller.model.getValue();
    elementBrowseText.innerHtml = value.toString();
  }
  
  void onBrowseClicked() {
    
  }
}