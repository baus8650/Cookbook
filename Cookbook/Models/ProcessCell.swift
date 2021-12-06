//
//  ProcessCell.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/28/21.
//

import UIKit

class ProcessCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var processTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        processTextField.delegate = self
    }

}
