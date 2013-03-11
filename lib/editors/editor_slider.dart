part of property_grid;

/**
 * The Slider value editor displays a html5 slider control 
 * for modifying a numeric value.  A custom slider configuration 
 * can be passed as a List<num> with two values, (min, max)
 */
class PropertyEditorSlider extends PropertyItemEditorBase {
  DivElement elementEditor;
  Slider slider;
  bool editing = false;
  
  /** 
   * The value that is divided by this number (e.g. if facotr is 10 and 
   * slider value is 123, returned value would be 12.3
   */
  int factor = 1;
  
  
  PropertyEditorSlider(PropertyItemController controller) : super(controller)
  {
    slider = new Slider();
//    slider.type = "range";
    slider.element.classes.add("property-grid-item-editor-slider");
    
    // Set the slider configuration, if specified
    var sliderConfig = controller.model.editorConfig;
    if (sliderConfig != null) {
      List<num> range = sliderConfig;
      if (range != null && range.length >= 2) {
        num minValue = range[0];
        num maxValue = range[1];
        slider.min = minValue;
        slider.max = maxValue;
        if (range.length >= 3) {
          factor = range[2];
        }
      }
    }

    // Wrap the slider in a background host element
    elementEditor = new DivElement();
    elementEditor.nodes.add(slider.element);
    elementEditor.classes.add("property-grid-item-editor-slider-host");
    elementEditor.tabIndex = 1;

    elementEditor.onBlur.listen((e) => _notifyFinishEditing());
    elementEditor.onKeyDown.listen((KeyboardEvent e) {
      // Complete the editing if the Return key was pressed
      const int KEY_ENTER = 13;
      if (e.keyCode == KEY_ENTER) {
        _notifyFinishEditing();
      }
    });

    slider.onValueChanged = (sender, value) {
      num value =  _getSliderValue();
      if (value != null) {
        controller.requestValueChange(value.toString());
      }
    };
  }

  void showEditor() {
    var cell = controller.elementCellValue;
    document.body.nodes.add(elementEditor);
    
    int left = _getElementPageLeft(cell);
    int top = _getElementPageTop(cell) + controller.view.elementView.clientHeight - gridScrollTop;
    
    int width = cell.clientWidth;
    elementEditor.style.left = "${left}px";
    elementEditor.style.top = "${top}px";
    elementEditor.style.width = "${width}px";
    _setSliderValue(controller.model.getValue());
    elementEditor.focus();

    editing = true;
  }
  
  void hideEditor() {
    if (!editing) return;
    editing = false;
    elementEditor.remove();
  }
  
  void _notifyFinishEditing() {
    if (editing) {
      num value =  _getSliderValue();
      if (value != null) {
        controller.finishEditing(value.toString());
      }
    }
  }
  
  void dispose() {
    editing = false;
  }
  
  num _getSliderValue() {
    try {
      if (slider == null || slider.value == null) return null;
      return slider.value / factor;
    } on Exception catch (e) {
      return 0;
    }
  }

  void _setSliderValue(String valueText) {
    var value = double.parse(valueText);
    slider.value = (value * factor).toInt();
  }
}
