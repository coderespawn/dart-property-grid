library property_item_test;

import "package:unittest/unittest.dart";
import "package:property_grid/property_grid.dart";


void main() {
  group("Property Item:", () {
    test("property_getter", () {
      String name = "abc";
      PropertyItem property = new PropertyItem("Test", () => name, (value) => name = value, "label", null);
      expect(property.getValue(), equals("abc"));
    });
  
    test("variable_value_after_property_change", () {
      String name = "abc";
      PropertyItem property = new PropertyItem("Test", () => name, (value) => name = value, "label", null);
      property.setValue("xyz");
  
      expect(name, equals("xyz"));
    });
      
    test("property_value_after_variable_change", () {
      String name = "abc";
      PropertyItem property = new PropertyItem("Test", () => name, (value) => name = value, "label", null);
      name = "xyz";
  
      expect(property.getValue(), equals("xyz"));
    });
  
    test("property_value_after_variable_change", () {
      String name = "abc";
      PropertyItem property = new PropertyItem("Test", () => name, (value) => name = value, "label", null);
      name = "xyz";
  
      expect(property.getValue(), equals("xyz"));
    });
  });
}

