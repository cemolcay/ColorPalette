ColorPalette
===

A color palette grid view for iOS.

Demo
----

![alt tag](https://github.com/cemolcay/ColorPalette/raw/master/demo.gif)

Requirements
----

* Swift 3.0+
* iOS 8.0+

Install
----

``` ruby
pod 'ColorPalette'
```

Usage
----

Create a `ColorPaletteView` either from storyboard or programmatically.  
Set `rowCount` and `columnCount` to setup palette grid. (Defaults 2x10).  
Implement `delegate` and `dataSource`.  

#### ColorPaletteViewDataSource

Use this data source method to fill palette with colors.

```
func colorPalette(_ colorPalette: ColorPaletteView, colorAt index: Int) -> UIColor?
```

#### ColorPaletteViewDelegate

Use this delegate method to inform about color selection changes.

```
func colorPalette(_ colorPalette: ColorPaletteView, didSelect color: UIColor, at index: Int)
```

You can also observe `colorPalette.selectedColor` dynamic property to create bindings.

#### ColorPaletteItemViewOptions

This is a basic struct with border, corner radius, and background color properties of palette items with their selected or unselected states.  

You can use either `colorPalette.paletteItemDisplayOptions` property to set each property or use the `@IBInspectable` bridge properties from storyboard.

![alt tag](https://github.com/cemolcay/ColorPalette/raw/master/storyboard.png)