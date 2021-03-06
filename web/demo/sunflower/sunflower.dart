// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
// Modified to use property grid control

library sunflower;

import 'dart:html';
import 'dart:math';
import 'package:property_grid/property_grid.dart';
import 'package:gradient_picker/gradient_picker.dart';  // Needed only if GradientValue data structure is used
import 'package:color_picker/color_picker.dart';  // Needed only if ColorValue data structure is used

const TAU = PI * 2;

const MAX_D = 400;
var PHI;
var context;

// Algorithm related parameters
int seeds = 500;
num scaleFactor = 4;
num phiIndex = 5;

// Appearence related parameters
String title = "Sunflower";
num seedRadius = 3;
SunColor seedColor = new SunColor(32, 255, 192);
SunColor strokeColor = new SunColor(35, 54, 157);
num seedStrokeWidth = 1.5;
String seedType = "Circle";
File background;
ImageElement backgroundImage;
GradientValue flowerGradient = new GradientValue();

// Misc parameters
num centerX = MAX_D / 2;
num centerY = MAX_D / 2;

/** 
 * Create a property model for the list of properties that needs 
 * to be displayed on the property grid.  This can be defined 
 * by the developer for any class / object that needs to be represented
 * in the property grid
 */ 
var sunflowerProperties = createSunflowerBinding();


main() {
  _initState();
  var propertyGrid = new PropertyGrid(querySelector("#my_property_grid"));
  propertyGrid.model = sunflowerProperties;

  CanvasElement canvas = querySelector("#canvas");
  centerX = centerY = MAX_D / 2;
  context = canvas.context2D;

  drawFrame(context);
}

_initState() {
  // Create an initial gradient color
  flowerGradient.clear();
  flowerGradient.addStopValue(new ColorValue.fromRGB(255, 0, 0), 0);
  flowerGradient.addStopValue(new ColorValue.fromRGB(255, 255, 0), 0.33);
  flowerGradient.addStopValue(new ColorValue.fromRGB(0, 255, 255), 0.66);
  flowerGradient.addStopValue(new ColorValue.fromRGB(0, 0, 255), 1);
}
/**
 * Draw the complete figure for the current number of seeds.
 */
void drawFrame(CanvasRenderingContext2D context) {
  context.clearRect(0, 0, MAX_D, MAX_D);

  // Draw the background, if specified
  if (backgroundImage != null) {
    context.save();
    context.fillStyle = "transparent";
    context.drawImageScaledFromSource(backgroundImage, 0, 0, backgroundImage.width, backgroundImage.height, 
        0, 0, context.canvas.width, context.canvas.height);
    context.restore();
  }
  
  // draw the title
  context.save();
  context.fillStyle = "black";
  context.font = '40px Calibri';
  context.fillText(title, 80, 50);
  context.restore();
  
  PHI = (sqrt(phiIndex) + 1) / 2;
  final num maxRadius = sqrt(seeds) * scaleFactor;

  for (var i = 0; i < seeds; i++) {
    var theta = i * TAU / PHI;
    var r = sqrt(i) * scaleFactor;
    var x = centerX + r * cos(theta);
    var y = centerY - r * sin(theta);
    
    final radiusPercent = r / maxRadius;
    var color = flowerGradient.getColor(radiusPercent).toString();

    drawSeed(context, x, y, color);
  }

}

/**
 * Draw a small circle representing a seed centered at (x,y).
 */
void drawSeed(CanvasRenderingContext2D context, num x, num y, String color) {
  context.beginPath();
  context.lineWidth = seedStrokeWidth;
  context.fillStyle = color;
  context.strokeStyle = strokeColor.toRgba();
  if (seedType == "Circle") {
    context.arc(x, y, seedRadius, 0, TAU, false);
  } else if (seedType == "Drops") {
    context.arc(x, y, seedRadius, 0, PI, false);
  } else if (seedType == "Seeds") {
    final tanticleLength = seedRadius * 3;
    num dx = x - centerX;
    num dy = y - centerY;
    num length = sqrt (dx * dx + dy * dy);
    if (length <= 0.000001) { length = 1; }
    num x2 = x + (dx / length * tanticleLength).toInt();
    num y2 = y + (dy / length * tanticleLength).toInt();
    context.moveTo(x, y);
    context.lineTo(x2, y2);
  }
  context.fill();
  context.closePath();
  context.stroke();
}

/** 
 * Creates a property model for the sunflower object.  
 * The model defines the property items and their getter setters
 */
PropertyGridModel createSunflowerBinding() {
  var model = new PropertyGridModel();

  // Algorithm bindings
  model.register("Seeds", () => seeds.toString(), (String value) { seeds = double.parse(value).toInt(); drawFrame(context); }, 
      "label", "slider", category: "Algorithm", description: "The number of seeds in the sunflower", editorConfig: [0, 1000]);

  model.register("PHI Index", () => phiIndex.toString(), (String value) { phiIndex = double.parse(value); drawFrame(context); }, 
      "label", "slider", category: "Algorithm", description: "The PHI Index", editorConfig: [5000, 5200, 1000]);

  model.register("Scale Factor", () => scaleFactor.toString(), (String value) { scaleFactor = double.parse(value); drawFrame(context); }, 
      "label", "slider", category: "Algorithm", description: "The Scale Factor", editorConfig: [300, 800, 100]);

  // Appearence bindings
  model.register("Title", () => title, (String value) { title = value; drawFrame(context); }, 
      "label", "textbox", category: "Appearence", description: "Caption shown on the top");

  model.register("Seed Radius", () => seedRadius.toString(), (String value) { seedRadius = double.parse(value); drawFrame(context); }, 
      "label", "slider", category: "Appearence", description: "The seed radius", editorConfig: [100, 600, 100]);

  model.register("Flower Color", () => flowerGradient, (GradientValue value) { flowerGradient = value; drawFrame(context); }, 
      "gradient", "gradient", category: "Appearence", description: "The flower's gradient color");

  model.register("Stroke Size", () => seedStrokeWidth.toString(), (String value) { seedStrokeWidth = double.parse(value); drawFrame(context); }, 
      "label", "slider", category: "Appearence", description: "The seed's stroke width", editorConfig: [100, 6000, 1000]);

  model.register("Stroke Color", () => strokeColor.toString(), (String value) { strokeColor = new SunColor.parse(value); drawFrame(context); }, 
      "color", "color", category: "Appearence", description: "The seed's stroke color", editorConfig: 128 /* size of color picker */);
  
  model.register("Seed Type", () => seedType, (String value) { seedType = value; drawFrame(context); }, 
      "label", "spinner", category: "Appearence", description: "The seed's shape type", editorConfig: _getShapeTypes);

  model.register("Background", () => background == null ? "" : background.name, (File value) => _createImage(value), 
      "label", "browse", category: "Appearence", description: "The background image");

  // Misc bindings
  model.register("Center X", () => centerX.toString(), (String value) { centerX = double.parse(value).toInt(); drawFrame(context); }, 
      "label", "slider", category: "Misc", description: "Sunflower's center (x-axis)", editorConfig: [0, 400]);

  model.register("Center Y", () => centerY.toString(), (String value) { centerY = double.parse(value).toInt(); drawFrame(context); }, 
      "label", "slider", category: "Misc", description: "Sunflower's center (y-axis)", editorConfig: [0, 400]);

  return model;
}

_getShapeTypes() => ["Seeds", "Circle", "Drops"];

void _createImage(File _background) {
  if (_background == null) return;
  background = _background;
  backgroundImage = new ImageElement();
  print (background);
  print (Url.createObjectUrl(background));
  backgroundImage.onLoad.listen((e) => drawFrame(context));
  backgroundImage.src = Url.createObjectUrl(background);
}

/** Custom color class that will be used with the property grid */
class SunColor {
  int r;
  int g;
  int b;
  SunColor(this.r, this.g, this.b);
  SunColor.parse(String data) {
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
  String toRgba() => "rgba($r, $g, $b, 1.0)";
}