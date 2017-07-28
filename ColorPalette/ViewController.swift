//
//  ViewController.swift
//  ColorPalette
//
//  Created by Cem Olcay on 28/07/2017.
//  Copyright © 2017 cemolcay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ColorPaletteViewDelegate, ColorPaletteViewDataSource {
  @IBOutlet weak var selectedColorView: UIView?
  @IBOutlet weak var colorPalette: ColorPaletteView?
  let colors: [UIColor] = [
    .black,
    .white,
    .red,
    .blue,
    .yellow,
    .brown,
    .green,
    .magenta,
    .cyan,
    .darkGray,
    .orange,
    .purple,
  ]

  // MARK: Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    colorPalette?.delegate = self
    colorPalette?.dataSource = self
    colorPalette?.reloadPalette()

    selectedColorView?.layer.borderWidth = 1
    selectedColorView?.layer.borderColor = ColorPaletteItemViewOptions.default.borderColor.cgColor
    selectedColorView?.layer.cornerRadius = ColorPaletteItemViewOptions.default.cornerRadius
    selectedColorView?.backgroundColor = ColorPaletteItemViewOptions.default.backgroundColor
  }

  // MARK: ColorPaletteViewDataSource

  func colorPalette(_ colorPalette: ColorPaletteView, colorAt index: Int) -> UIColor? {
    if index >= colors.endIndex {
      return nil
    }
    return colors[index]
  }

  // MARK: ColorPaletteViewDelegate

  func colorPalette(_ colorPalette: ColorPaletteView, didSelect color: UIColor, at index: Int) {
    print("color at \(index) selected")
    selectedColorView?.backgroundColor = color
  }
}

