part of property_grid;

/**
 * The Slider value editor displays a html5 slider control 
 * for modifying a numeric value.  A custom slider configuration 
 * can be passed as a List<num> with two values, (min, max)
 */
class PropertyEditorSlider extends PropertyItemEditorBase {
  DivElement elementEditor;
  InputElement slider;
  bool editing = false;
  
  PropertyEditorSlider(PropertyItemController controller) : super(controller)
  {
    slider = new InputElement();
    slider.type = "range";
    slider.classes.add("property-grid-item-editor-slider");
    
    // Set the slider configuration, if specified
    var sliderConfig = controller.model.editorConfig;
    if (sliderConfig != null && sliderConfig is List<num>) {
      List<num> range = sliderConfig;
      if (range.length >= 2) {
        num minValue = range[0];
        num maxValue = range[1];
        slider.min = minValue.toString();
        slider.max = maxValue.toString();
      }
    }
    
    // Wrap the slider in a background host element
    elementEditor = new DivElement();
    elementEditor.nodes.add(slider);
    elementEditor.classes.add("property-grid-item-editor-slider-host");
    elementEditor.tabIndex = 1;
  }

  void showEditor() {
    var cell = controller.elementCellValue;
    document.body.nodes.add(elementEditor);
    
    int left = _getElementPageLeft(cell);
    int top = _getElementPageTop(cell) + controller.view.elementView.clientHeight;
    
    int width = cell.clientWidth;
    elementEditor.style.left = "${left}px";
    elementEditor.style.top = "${top}px";
    elementEditor.style.width = "${width}px";
    slider.value = controller.model.getValue().toString();
    elementEditor.focus();

    elementEditor.on.blur.add((e) => _notifyFinishEditing());
    elementEditor.on.keyDown.add((KeyboardEvent e) {
      // Complete the editing if the Return key was pressed
      const int KEY_ENTER = 13;
      if (e.keyCode == KEY_ENTER) {
        _notifyFinishEditing();
      }
    });
    slider.on.change.add((e) => controller.requestValueChange(slider.value));
    editing = true;
  }
  
  void hideEditor() {
    if (!editing) return;
    editing = false;
    elementEditor.remove();
  }
  
  void _notifyFinishEditing() {
    if (editing) {
      controller.finishEditing(slider.value);
    }
  }
  
  void dispose() {
    editing = false;
  }
}
