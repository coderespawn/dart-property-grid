library main;

import 'dart:html';
import 'package:property_grid/property_grid_lib.dart';

String _fullName = "Ali Akbar";
int _age = 30;
String _location = "Mars";
String _language = "Dart";
Color _color = new Color(200, 125, 220);


void main() {
  var grid = new PropertyGrid(query("#my_property_grid"));
  var model = _createModel();
  grid.model = model;
}

PropertyGridModel _createModel() {
  var model = new PropertyGridModel();
  model.register("Full Name", () => _fullName, (String value) => _fullName = value, 
      "label", "textbox", category: "Info", description: "Name of the person");

  model.register("Age", () => _age.toString(), (String value) => _age = double.parse(value).toInt(), 
      "label", "slider", category: "Info", description: "Age of the person", editorConfig: [12, 120]);

  model.register("Location", () => _location, (String value) => _location = value, 
      "label", "textbox", category: "Info", description: "Current Location");
  
  model.register("Language", () => _language, (String value) => _language = value, 
      "label", "spinner", category: "Preference", description: "The user's prefered language", editorConfig: _getLanguageList);
  
  model.register("Color", () => _color.toString(), (String value) => _color = new Color.parse(value), 
      "color", "color", category: "Preference", description: "The user's prefered color", editorConfig: 128 /* size of color picker */);
  
  return model;
}

_getLanguageList() {
  return ["C#", "C++", "Dart", "Java", "JavaScript", "Ruby", "Python"];
}

class Color {
  int r;
  int g;
  int b;
  Color(this.r, this.g, this.b);
  Color.parse(String data) {
    var tokens = data.split(",");
    r = int.parse(tokens[0]);
    g = int.parse(tokens[1]);
    b = int.parse(tokens[2]);
  }
  String toString() => "$r, $g, $b";
  void set(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
}