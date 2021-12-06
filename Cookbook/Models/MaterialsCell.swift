//
//  MaterialsCell.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/27/21.
//

import UIKit

class MaterialsCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var materialTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        materialTextField.delegate = self
    }

}
