//
//  IngredientViewCell.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/28/21.
//

import UIKit

class IngredientViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var ingredientField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredientField.delegate = self
    }
}
