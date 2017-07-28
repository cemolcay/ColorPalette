//
//  ColorPaletteView.swift
//  ColorPalette
//
//  Created by Cem Olcay on 28/07/2017.
//  Copyright © 2017 cemolcay. All rights reserved.
//

import UIKit

/// ColorPaletteView data filling functions.
public protocol ColorPaletteViewDataSource: class {
  /// Fills the ColorPaletteView with colors.
  ///
  /// - Parameters:
  ///   - colorPalette: The palette that going to be filled.
  ///   - index: Index of palette.
  /// - Returns: Return nil if you don't want to fill that index with a color. Otherwise return a color.
  func colorPalette(_ colorPalette: ColorPaletteView, colorAt index: Int) -> UIColor?
}

/// ColorPaletteView actions delegate.
public protocol ColorPaletteViewDelegate: class {
  /// Called when a color selected from palette.
  ///
  /// - Parameters:
  ///   - colorPalette: The palette that a color been selected.
  ///   - color: Selected color.
  ///   - index: Index of selected color in palette.
  func colorPalette(_ colorPalette: ColorPaletteView, didSelect color: UIColor, at index: Int)
}

/// Display options of color palette item views.
public struct ColorPaletteItemViewOptions {
  public var borderColor: UIColor
  public var selectedBorderColor: UIColor
  public var borderWidth: CGFloat
  public var selectedBorderWidth: CGFloat
  public var cornerRadius: CGFloat
  public var selectedCornerRadius: CGFloat
  public var backgroundColor: UIColor

  public static let `default`: ColorPaletteItemViewOptions = ColorPaletteItemViewOptions(
    borderColor: UIColor(red: 213.0/255.0, green: 213.0/255.0, blue: 213.0/255.0, alpha: 1),
    selectedBorderColor: UIColor(red: 130.0/255.0, green: 130.0/255.0, blue: 130.0/255.0, alpha: 1),
    borderWidth: 2 / UIScreen.main.scale,
    selectedBorderWidth: 4 / UIScreen.main.scale,
    cornerRadius: 5,
    selectedCornerRadius: 5,
    backgroundColor: UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1))
}

/// Color item view in palette.
@IBDesignable public class ColorPaletteItemView: UIControl {

  /// Nil if has not assigned a color. Otherwise the color that represents in the palette.
  public var color: UIColor?

  /// View rendering options.
  public var displayOptions: ColorPaletteItemViewOptions = .default

  public init(color: UIColor?) {
    super.init(frame: .zero)
    self.color = color
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    backgroundColor = color ?? displayOptions.backgroundColor
    layer.borderColor = isSelected ? displayOptions.selectedBorderColor.cgColor : displayOptions.borderColor.cgColor
    layer.borderWidth = isSelected ? displayOptions.selectedBorderWidth : displayOptions.borderWidth
    layer.cornerRadius = isSelected ? displayOptions.cornerRadius : displayOptions.selectedCornerRadius
  }
}

/// Color palette view with custom row and column count and colors.
@IBDesignable public class ColorPaletteView: UIView {

  /// Delegate of the palette.
  public weak var delegate: ColorPaletteViewDelegate?

  /// Data source of the palette.
  public weak var dataSource: ColorPaletteViewDataSource?

  /// Currently selected color.
  public dynamic var selectedColor: UIColor?

  /// Number of rows in palette
  @IBInspectable public var rowCount: Int = 2 { didSet{ reloadPalette() }}

  /// Number of columns in palette.
  @IBInspectable public var columnCount: Int = 10 { didSet{ reloadPalette() }}

  /// Horizontal spacing between colors.
  @IBInspectable public var horizontalSpacing: CGFloat = 8 { didSet{ setNeedsLayout() }}

  /// Vertical spacing between colors.
  @IBInspectable public var verticalSpacing: CGFloat = 8 { didSet{ setNeedsLayout() }}

  // IBInspectable bridges of `ColorPaletteItemViewOptions`.
  @IBInspectable public var paletteItemBorderColor: UIColor = ColorPaletteItemViewOptions.default.borderColor
    { didSet{ paletteItemDisplayOptions.borderColor = paletteItemBorderColor }}
  @IBInspectable public var paletteItemSelectedBorderColor: UIColor = ColorPaletteItemViewOptions.default.selectedBorderColor
    { didSet{ paletteItemDisplayOptions.selectedBorderColor = paletteItemSelectedBorderColor }}
  @IBInspectable public var paletteItemBorderWidth: CGFloat = ColorPaletteItemViewOptions.default.borderWidth
    { didSet{ paletteItemDisplayOptions.borderWidth = paletteItemBorderWidth }}
  @IBInspectable public var paletteItemSelectedBorderWidth: CGFloat = ColorPaletteItemViewOptions.default.selectedBorderWidth
    { didSet{ paletteItemDisplayOptions.selectedBorderWidth = paletteItemSelectedBorderWidth }}
  @IBInspectable public var paletteItemCornerRadius: CGFloat = ColorPaletteItemViewOptions.default.cornerRadius
    { didSet{ paletteItemDisplayOptions.cornerRadius = paletteItemCornerRadius }}
  @IBInspectable public var paletteItemSelectedCornerRadius: CGFloat = ColorPaletteItemViewOptions.default.selectedCornerRadius
    { didSet{ paletteItemDisplayOptions.selectedCornerRadius = paletteItemSelectedCornerRadius }}
  @IBInspectable public var paletteItemBackgroundColor: UIColor = ColorPaletteItemViewOptions.default.backgroundColor
    { didSet{ paletteItemDisplayOptions.backgroundColor = paletteItemBackgroundColor }}

  /// Display options of palette items.
  public var paletteItemDisplayOptions: ColorPaletteItemViewOptions = .default { didSet{ setNeedsLayout() } }

  /// Color items in the palette.
  private var paletteItems: [ColorPaletteItemView] = []

  public override init(frame: CGRect) {
    super.init(frame: frame)
    paletteItems = [ColorPaletteItemView](
      repeating: ColorPaletteItemView(color: nil),
      count: rowCount * columnCount)
    reloadPalette()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    paletteItems = [ColorPaletteItemView](
      repeating: ColorPaletteItemView(color: nil),
      count: rowCount * columnCount)
    reloadPalette()
  }

  /// Call this function when you change the color data of the palette.
  public func reloadPalette() {
    // Reset palette items.
    paletteItems.forEach({ $0.removeFromSuperview() })
    paletteItems = []

    // Create new palette items.
    for i in 0..<rowCount*columnCount {
      let color = dataSource?.colorPalette(self, colorAt: i)
      let paletteItem = ColorPaletteItemView(color: color)
      paletteItem.displayOptions = paletteItemDisplayOptions
      paletteItem.addTarget(self, action: #selector(paletteItemDidSelect(sender:)), for: .touchUpInside)
      paletteItems.append(paletteItem)
      addSubview(paletteItem)
    }

    // Draw new palette.
    setNeedsLayout()
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    let itemSize = CGSize(
      width: (frame.size.width - (horizontalSpacing * CGFloat(columnCount + 1))) / CGFloat(columnCount),
      height: (frame.size.height - (verticalSpacing * CGFloat(rowCount + 1))) / CGFloat(rowCount))
    for row in 0..<rowCount {
      for column in 0..<columnCount {
        let index = (row * columnCount) + column
        let item = paletteItems[index]
        item.frame = CGRect(
          x: (horizontalSpacing * CGFloat(column + 1)) + (CGFloat(column) * itemSize.width),
          y: (verticalSpacing * CGFloat(row + 1)) + (CGFloat(row) * itemSize.height),
          width: itemSize.width,
          height: itemSize.height)
      }
    }
  }

  /// Called when a palette item has selected
  ///
  /// - Parameter sender: Selected palette item.
  public func paletteItemDidSelect(sender: ColorPaletteItemView) {
    // Make sure the item is selectable (has color and defined in palette).
    guard let index = paletteItems.index(of: sender),
      let color = sender.color
      else { return }

    // Mark item as selected.
    paletteItems.forEach({ $0.isSelected = $0 == sender; $0.setNeedsLayout() })
    selectedColor = color

    // Inform delegte.
    delegate?.colorPalette(self, didSelect: color, at: index)
  }
}
