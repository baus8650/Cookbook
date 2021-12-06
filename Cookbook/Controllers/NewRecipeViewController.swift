//
//  NewRecipeViewController.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/25/21.
//

import UIKit

class NewRecipeViewController: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ingredientsField: UITextView!
    @IBOutlet weak var materialsField: UITextView!
    @IBOutlet weak var stepsField: UITextView!
    @IBAction func imageAddTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsField.text = """
        Two slices of bread.
        One slice of cheese.
        """
        materialsField.text = """
        One pan.
        One plate.
        """
        stepsField.text = """
        Butter bread.
        place cheese between two slices of bread.
        Cook both sides of bread on the skillet until golden brown.
        """
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        
            imageView.image = userPickedImage

            
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
