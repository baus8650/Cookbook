//
//  IngredientsCell.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/27/21.
//

import UIKit

class IngredientsCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var ingredientTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientTextField.delegate = self
    }
}

