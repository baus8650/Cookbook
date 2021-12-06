//
//  RecipeCollectionViewCell.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/25/21.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var selectedLabel: UILabel!
 
    var isInEditingMode: Bool = false {
        didSet {
            selectedLabel.isHidden = !isInEditingMode
        }
    }
    override var isSelected: Bool {
        didSet {
            if isInEditingMode {
                selectedLabel.font = selectedLabel.font.withSize(30.0)
                selectedLabel.textColor = .red
                selectedLabel.text = isSelected ? "✓" : ""
            }
        }
    }
    
}
