//
//  InformationViewController.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/26/21.
//

import UIKit
import CoreData

class InformationViewController: UITableViewController, UINavigationControllerDelegate {
    
    // MARK: - Local Variables
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    var servingSizeNumber: Int = 1
    var newRecipe: RecipeItemController?
    var pickerData = [String]()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cookingTimeField: UITextField!
    @IBOutlet weak var difficultySlider: UISlider!
    @IBOutlet weak var tagsField: UITextField!
    @IBOutlet weak var servingSize: UIPickerView!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - IBActions
    
    @IBAction func difficultySliderPressed(_ sender: UISlider) {
        difficultySlider.value = difficultySlider.value.rounded()
    }
    
    @IBAction func favoriteSwitchPressed(_ sender: UISwitch) {
        if ((sender as AnyObject).isOn == true) {
            newRecipe!.recipe.favorite = true
        } else {
            newRecipe!.recipe.favorite = false
        }
    }
    
    // MARK: - Helper Functions
    
    func tagSeparation(str: String) -> Array<String> {
        if str != "" {
            let formattedTags = str.components(separatedBy: ", ")
            return formattedTags
        } else {
            let formattedTags = [""]
            return formattedTags
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.servingSize.delegate = self
        self.servingSize.dataSource = self
        tabBarController?.delegate = self
        
        for i in 1...100 {
            pickerData.append("\(i)")
        }
    }
    
}

// MARK: - Extensions

extension InformationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        servingSizeNumber = Int(pickerData[row]) ?? 3
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension InformationViewController: UIImagePickerControllerDelegate {
    @IBAction func addImagePressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    @IBAction func selectImagePressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self;
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
}

extension InformationViewController: UITabBarDelegate, UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        newRecipe!.recipe.name = nameField.text!
        newRecipe!.recipe.duration = cookingTimeField.text!
        newRecipe!.recipe.difficulty = Int(difficultySlider.value)
        newRecipe!.recipe.servings = servingSizeNumber
        newRecipe!.recipe.tags = tagSeparation(str: tagsField.text!)
        newRecipe!.recipe.images = imageView.image?.jpegData(compressionQuality: 1.0)
    }
}
