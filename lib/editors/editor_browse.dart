part of property_grid;

/**
 * The Slider value editor displays a html5 slider control 
 * for modifying a numeric value.  A custom slider configuration 
 * can be passed as a List<num> with two values, (min, max)
 */
class PropertyEditorBrowse extends PropertyItemEditorBase {
  DivElement elementEditor;
  FileUploadInputElement btnBrowse;
  bool editing = false;
  
  /** 
   * The value that is divided by this number (e.g. if facotr is 10 and 
   * slider value is 123, returned value would be 12.3
   */
  int factor = 1;
  
  PropertyEditorBrowse(PropertyItemController controller) : super(controller)
  {
    btnBrowse = new FileUploadInputElement();
    btnBrowse.classes.add("property-grid-item-editor-browse");
    
    // Set the slider configuration, if specified
    var editorConfig = controller.model.editorConfig;
    
    // Wrap the slider in a background host element
    elementEditor = new DivElement();
    elementEditor.nodes.add(btnBrowse);
    elementEditor.classes.add("property-grid-item-editor-browse-host");
    elementEditor.tabIndex = 1;

    elementEditor.onBlur.listen((e) => hideEditor());
    elementEditor.onKeyDown.listen((KeyboardEvent e) {
      // Complete the editing if the Return key was pressed
      const int KEY_ENTER = 13;
      if (e.keyCode == KEY_ENTER) {
        hideEditor();
      }
    });
    
    btnBrowse.onChange.listen(_notifyFinishEditing);
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
//    _setSliderValue(controller.model.getValue());
    elementEditor.focus();

    editing = true;
  }
  
  void hideEditor() {
    if (!editing) return;
    editing = false;
    elementEditor.remove();
  }
  
  void _notifyFinishEditing(Event e) {
    var files = btnBrowse.files;
    if (files != null && files.length > 0) {
      controller.finishEditing(btnBrowse.files[0]);
    } else {
      hideEditor();
    }
  }
  
  void dispose() {
    editing = false;
  }
  
}
