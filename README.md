# Dart Property Grid

The property grid control enables the user to modify the properties of an object

![Property Grid](https://raw.github.com/coderespawn/dart-property-grid/master/doc/images/property_grid.png)

Each entry in the property grid is a `PropertyItem` grouped under various categories.  The values for each item are displayed in `views`.  Clicking a view will bring up an `editor` to modify it's value.  

To modify the properties of an object, a property model object needs to be defined

Start by importing the project as mentioned in the [pub](http://pub.dartlang.org/packages/property_grid)

Create a property model object for your class / data structure

	var model = new PropertyGridModel();
	
Register property items in the model with the `register()` function

	void register(String name, PropertyItemGetter getter, PropertyItemSetter setter,
		  String viewType, String editorType, {var editorConfig, String category, String description}) 

Define a `name` for the property item, it's `getter` / `setter`.  the `getter` function will be called by the property grid to query the value and display it in the property grid.  This value is displayed in the "view" of the type `viewType`.  Clicking this view would bring up the editor of type `editorType` where the user can modify the contents of the property item.   The editor would invoke the `setter` to set the updated value

Optional `category` and `description` can be provided to display extra information about the item on the property grid.  The `editorConfig` is based on the `editorType`.

`viewType` can have the following values:

 - label
 - color
 - gradient
 
`editorType` can have the following values:

 - textbox
 - slider
 - spinner
 - color
 - gradient
 - browse

The possible `editorConfig` for each `editorType` is:

 - **spinner**: A getter function that returns a List<String> for populating the spinner
 - **color**: A integer value specifying the size of the color picker (e.g. 128)
 - **slider**: `[minValue, maxValue, factor=1]`,  The first `minValue` parameter is the minimum value of the slider, followed by the `maxValue` maximum value parameter.  An optional third `factor` parameter can be passed in that divides the value in the slider. E.g. `[1104, 2722, 100]` would create a slider with the range of `(11.04, 27.22)`.  An input of `[10, 50]` would create a slider of range `10 to 50`
 - **textbox**: N/A
 - **gradient**: N/A
 - **browse**: N/A

 
## Property Views

 - **Label View**: Display simple textual values ![Label View](https://raw.github.com/coderespawn/dart-property-grid/master/doc/images/view_label.png)
 - **Color View**: Display a color value and its preview ![Label View](https://raw.github.com/coderespawn/dart-property-grid/master/doc/images/view_color.png)
 - **Gradient View**: Display a preview of the gradient color ![Label View](https://raw.github.com/coderespawn/dart-property-grid/master/doc/images/view_gradient.png)

## Property Editors

 - **Textbox Editor**: Replaces the view with a textbox and lets the user edit it's contents 
 
 ![Label View](https://raw.github.com/coderespawn/dart-property-grid/master/doc/images/editor_textbox.png)
 
 - **Color Editor**: Display a configurable color picker control 
 
 ![Label View](https://raw.github.com/coderespawn/dart-property-grid/master/doc/images/editor_color.png)

 - **Spinner**: Display a drop down list
 
 ![Label View](https://raw.github.com/coderespawn/dart-property-grid/master/doc/images/editor_spinner.png)

 - **Slider**: Display a slider to edit numeric values
 
 ![Label View](https://raw.github.com/coderespawn/dart-property-grid/master/doc/images/editor_slider.png)

 - **Gradient**: Display a gradient editor
 
 ![Label View](https://raw.github.com/coderespawn/dart-property-grid/master/doc/images/editor_gradient.png)

 - **File Upload Editor**: Display a File Upload button.  On selecting a file, the Html5 File object would be returned 
 
 ![Label View](https://raw.github.com/coderespawn/dart-property-grid/master/doc/images/editor_browse.png)


## Demo

View the live demo [here](http://dart-app-samples.appspot.com/demos/dart-property-grid/sunflower.html)
