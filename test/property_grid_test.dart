library property_grid_test;
import "dart:html";
import "package:unittest/unittest.dart";
import "package:property_grid/property_grid.dart";


void main() {
  group("Property Grid:", () {
    Element hostElement;
    PropertyGrid propertyGrid;
    PropertyGridModel model;
    
    // test property variables
    num count = 10;
    String name = "John Doe";
    
    setUp(() {
      model = new PropertyGridModel();
      model.register("Count", () => count.toString(), (String value) => count = int.parse(value), "label", "slider", editorConfig: [12, 120]);
      model.register("Name", () => name, (String value) => name = value, "label", "textbox");

      hostElement = new DivElement();
      propertyGrid = new PropertyGrid(hostElement);
      propertyGrid.model = model;
    });
    
    tearDown(() {
      hostElement = null;
      propertyGrid = null;
      model = null;
    });

    test("change_property_int", () {
      propertyGrid.get("Count").requestValueChange("123");
      expect(count, 123);
    });
    
    test("change_property_int_invalid", () {
      expect(() => propertyGrid.get("Count").requestValueChange("123x"),
          throwsFormatException);
    });
    
    test("change_property_string", () {
      propertyGrid.get("Name").requestValueChange("Bot");
      expect(name, "Bot");
    });
    
    test("change_property_string_empty", () {
      propertyGrid.get("Name").requestValueChange("");
      expect(name, "");
    });
    
    test("invalid_property_access", () {
      expect(() => propertyGrid.get("INVALID_NAME"), throwsArgumentError);
    });

    test("change_variable_int", () {
      count = 512;
      int propertyValue = int.parse(propertyGrid.get("Count").model.getValue());
      expect(propertyValue, 512);
    });
    
    test("change_variable_int_negative", () {
      count = -512;
      int propertyValue = int.parse(propertyGrid.get("Count").model.getValue());
      expect(propertyValue, -512);
    });
    
    test("change_variable_string", () {
      name = "ABC";
      String propertyValue = propertyGrid.get("Name").model.getValue();
      expect(propertyValue, "ABC");
    });
    
    test("change_variable_string_empty", () {
      name = "";
      String propertyValue = propertyGrid.get("Name").model.getValue();
      expect(propertyValue, "");
    });

    test("editor_type_textbox", () {
      var item = propertyGrid.get("Name");
      expect(item.editor is PropertyEditorTextbox, isTrue);
    });
    
    test("editor_type_slider", () {
      var item = propertyGrid.get("Count");
      expect(item.editor is PropertyEditorSlider, isTrue);
    });
    
    test("view_type_invalid", () {
      model.register("Test", () => name, (String value) => name = value, "INVALID", "textbox");
      propertyGrid.model = null;
      expect(() => propertyGrid.model = model, throwsA(new isInstanceOf<PropertyGridException>()));
    });
    
    test("view_type_label", () {
      model.register("Test", () => name, (String value) => name = value, "label", "textbox");
      propertyGrid.model = null;
      propertyGrid.model = model;
      expect(propertyGrid.get("Test").view, new isInstanceOf<PropertyViewLabel>());
    });
    
    test("view_type_color", () {
      model.register("Test", () => name, (String value) => name = value, "color", "textbox");
      propertyGrid.model = null;
      propertyGrid.model = model;
      expect(propertyGrid.get("Test").view, new isInstanceOf<PropertyViewColor>());
    });

    test("editor_type_textbox", () {
      model.register("Test", () => name, (String value) => name = value, "color", "textbox");
      propertyGrid.model = null;
      propertyGrid.model = model;
      expect(propertyGrid.get("Test").editor, new isInstanceOf<PropertyEditorTextbox>());
    });

    test("editor_type_slider", () {
      model.register("Test", () => name, (String value) => name = value, "color", "slider");
      propertyGrid.model = null;
      propertyGrid.model = model;
      expect(propertyGrid.get("Test").editor, new isInstanceOf<PropertyEditorSlider>());
    });

    test("editor_type_spinner", () {
      model.register("Test", () => name, (String value) => name = value, "color", "spinner");
      propertyGrid.model = null;
      propertyGrid.model = model;
      expect(propertyGrid.get("Test").editor, new isInstanceOf<PropertyEditorSpinner>());
    });

    test("editor_type_color", () {
      model.register("Test", () => name, (String value) => name = value, "color", "color");
      propertyGrid.model = null;
      propertyGrid.model = model;
      expect(propertyGrid.get("Test").editor, new isInstanceOf<PropertyEditorColor>());
    });

    test("editor_type_invalid", () {
      model.register("Test", () => name, (String value) => name = value, "label", "INVALID");
      propertyGrid.model = null;
      expect(() => propertyGrid.model = model, throwsA(new isInstanceOf<PropertyGridException>()));
    });
  });
}

