part of property_grid;

/**
 * The Spinner value editor displays a html select control 
 * to choose a value from the list.  A getter function should be 
 * passed in the configuration to fetch the values to be displayed 
 * in the spinner
 */
class PropertyEditorSpinner extends PropertyItemEditorBase {
  SelectElement spinner;
  bool editing = false;
  
  PropertyEditorSpinner(PropertyItemController controller) : super(controller)
  {
    spinner = new SelectElement();
    spinner.classes.add("property-grid-item-editor-spinner");
    
    // fill up the spinner with the list of specified values from the config
    var config = controller.model.editorConfig;
    if (config != null) {
      var getValues = config;
      List values = getValues();
      for (var value in values) {
        String valueText = value.toString();
        OptionElement option = new OptionElement();
        option.innerHtml = valueText;
        option.value = valueText;
        spinner.nodes.add(option);
      }
    }
  }

  void showEditor() {
    controller.setViewVisible(false);
    var cell = controller.elementCellValue;
    cell.nodes.add(spinner);
    
    spinner.value = controller.model.getValue().toString();
    spinner.focus();

    spinner.on.blur.add((e) => _notifyFinishEditing());
    spinner.on.keyDown.add((KeyboardEvent e) {
      // Complete the editing if the Return key was pressed
      const int KEY_ENTER = 13;
      if (e.keyCode == KEY_ENTER) {
        _notifyFinishEditing();
      }
    });
    editing = true;
  }
  
  void hideEditor() {
    if (!editing) return;
    editing = false;
    spinner.remove();
    controller.setViewVisible(true);
  }
  
  void _notifyFinishEditing() {
    if (editing) {
      controller.finishEditing(spinner.value);
    }
  }
  
  void dispose() {
    editing = false;
  }
}
