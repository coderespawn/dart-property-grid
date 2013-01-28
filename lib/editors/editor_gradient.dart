part of property_grid;

/**
 * The Color Picker editor lets the user choose a color value
 */
class PropertyEditorGradient extends PropertyItemEditorBase {
  DivElement elementEditor;
  DivElement elementEditorInnerWrapper;
  bool editing = false;
  GradientPicker gradientPicker;
  
  PropertyEditorGradient(PropertyItemController controller) : super(controller)
  {
    int colorPickerSize = 128;
    if (controller.model.editorConfig != null && controller.model.editorConfig is num) {
      colorPickerSize = controller.model.editorConfig.toInt();
    }
    GradientValue gradient = controller.model.getValue();
    gradientPicker = new GradientPicker(gradient: gradient, width: 160);
    
    // Wrap the slider in a background host element
    elementEditorInnerWrapper = new DivElement();
    elementEditorInnerWrapper.classes.add("property-grid-item-editor-gradient-picker");
    elementEditorInnerWrapper.nodes.add(gradientPicker.elementBase);

    elementEditor = new DivElement();
    elementEditor.classes.add("property-grid-item-editor-gradient-picker-host");
    elementEditor.tabIndex = 1;
    elementEditor.nodes.add(elementEditorInnerWrapper);

  }

  void showEditor() {
    var cell = controller.elementCellValue;
    elementEditor.style.left = "0px";
    document.body.nodes.add(elementEditor);

    int left = _getElementPageLeft(cell);
    int top = _getElementPageTop(cell) + controller.view.elementView.clientHeight - gridScrollTop;

    int editorWidth = elementEditor.clientWidth;
    int editorHeight = elementEditor.clientWidth;
    if (left + editorWidth > window.innerWidth) {
      left = document.body.clientWidth - editorWidth; 
    }

    
    int width = cell.clientWidth;
    elementEditor.style.left = "${left}px";
    elementEditor.style.top = "${top}px";
    elementEditor.focus();

    gradientPicker.gradient = controller.model.getValue();
    
    elementEditor.onBlur.listen((e) => _notifyFinishEditing());
    elementEditor.onKeyDown.listen((KeyboardEvent e) {
      // Complete the editing if the Return key was pressed
      const int KEY_ENTER = 13;
      if (e.keyCode == KEY_ENTER) {
        _notifyFinishEditing();
      }
    });
    
    gradientPicker.gradientChanged = (GradientValue value) {
      controller.requestValueChange(value);
    };
    
    editing = true;
  }
  
  void hideEditor() {
    if (!editing) return;
    editing = false;
    elementEditor.remove();
  }
  
  void _notifyFinishEditing() {
    if (editing) {
      controller.finishEditing(gradientPicker.gradient);
    }
  }
  
  void dispose() {
    editing = false;
  }
}
