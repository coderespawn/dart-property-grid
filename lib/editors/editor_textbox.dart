part of property_grid;

class PropertyEditorTextbox extends PropertyItemEditorBase {
  InputElement textbox;
  bool editing = false;
  
  PropertyEditorTextbox(PropertyItemController controller) : super(controller)
  {
    textbox = new InputElement();
    textbox.classes.add("property-grid-item-editor-textbox");
  }

  void showEditor() {
    controller.setViewVisible(false);
    var cell = controller.elementCellValue;
    cell.nodes.add(textbox);
    
    textbox.value = controller.model.getValue().toString();
    textbox.focus();

    textbox.on.blur.add((e) => _notifyFinishEditing());
    textbox.on.keyDown.add((KeyboardEvent e) {
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
    textbox.remove();
    controller.setViewVisible(true);
  }
  
  void _notifyFinishEditing() {
    if (editing) {
      controller.finishEditing(textbox.value);
    }
  }
  
  void dispose() {
    editing = false;
  }
}
