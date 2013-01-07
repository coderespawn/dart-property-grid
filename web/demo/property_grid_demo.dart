library main;

import 'dart:html';
import '../../property_grid_lib.dart';

String _fullName = "Ali Akbar";
int _age = 30;
String _location = "Mars";
String _language = "Dart";

void main() {
  var grid = new PropertyGrid(query("#my_property_grid"));
  var model = _createModel();
  grid.model = model;
}

PropertyGridModel _createModel() {
  var model = new PropertyGridModel();
  model.register("Full Name", () => _fullName, (String value) => _fullName = value, 
      "label", "textbox", category: "Info", description: "Name of the person");

  model.register("Age", () => _age, (String value) => _age = int.parse(value), 
      "label", "slider", category: "Info", description: "Age of the person", editorConfig: [12, 120]);

  model.register("Location", () => _location, (String value) => _location = value, 
      "label", "textbox", category: "Info", description: "Current Location");
  
  model.register("Language", () => _language, (String value) => _language = value, 
      "label", "spinner", category: "Info", description: "The user's prefered language", editorConfig: _getLanguageList);
  
  return model;
}

_getLanguageList() {
  return ["C#", "C++", "Dart", "Java", "JavaScript", "Ruby", "Python"];
}
