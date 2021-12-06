//
//  ComponentsViewController.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/26/21.
//

import UIKit
import CoreData

class ComponentsViewController: UIViewController {
    
    // MARK: - Local Variables

    var newRecipe: RecipeItemController?
    var ingredientCounter: Int = 0
    var materialCounter: Int = 0
    var editingField: String = ""
    var viewControllerNumber = 1
    private var ingredientsList = [String]()
    private var materialsList = [String]()
    static let ingredientsCellIdentifier = "IngredientsCell"
    static let materialsCellIdentifier = "MaterialsCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var materialsTableView: UITableView!
    
    // MARK: - IBActions
    
    @IBAction func addIngredientsPressed(_ sender: UIButton) {
        editingField = "ingredients"
        if ingredientCounter > 0 {
            let indexPath = IndexPath(row: ingredientCounter-1, section: 0)
            let previousCell = ingredientsTableView.cellForRow(at: indexPath)! as! IngredientsCell
            ingredientsList[ingredientCounter-1] = previousCell.ingredientTextField.text!
        }
        ingredientsList.append("")
        ingredientsTableView.insertRows(at: [IndexPath(row:ingredientCounter, section: 0)], with: .automatic)
        let indexPath = IndexPath(row: ingredientCounter, section: 0)
        ingredientsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        let currentCell = ingredientsTableView.cellForRow(at: indexPath)! as! IngredientsCell
        currentCell.ingredientTextField.becomeFirstResponder()
        ingredientsList[ingredientCounter] = currentCell.ingredientTextField.text ?? "No ingredients added"
        
        ingredientCounter += 1
    }
    
    @IBAction func addMaterialPressed(_ sender: UIButton) {
        editingField = "materials"
        if materialCounter > 0 {
            let indexPath = IndexPath(row: materialCounter-1, section: 0)
            let previousCell = materialsTableView.cellForRow(at: indexPath)! as! MaterialsCell
            materialsList[materialCounter-1] = previousCell.materialTextField.text!
        }
        materialsTableView.reloadData()
        materialsList.append("")
        materialsTableView.insertRows(at: [IndexPath(row:materialCounter, section: 0)], with: .automatic)
        let indexPath = IndexPath(row: materialCounter, section: 0)
        materialsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        let currentCell = materialsTableView.cellForRow(at: indexPath)! as! MaterialsCell
        currentCell.materialTextField.becomeFirstResponder()
        materialsList[materialCounter] = currentCell.materialTextField.text ?? "No ingredients added"
        materialCounter += 1
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
            super.viewDidLoad()
            ingredientsTableView.dataSource = self
            materialsTableView.dataSource = self
            tabBarController?.delegate = self
        }
}

extension ComponentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView {
            return ingredientsList.count
        } else {
            return materialsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ingredientsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.ingredientsCellIdentifier, for: indexPath) as? IngredientsCell else {
                fatalError("Unable to dequeue ReminderCell")
            }
            cell.ingredientTextField.delegate = self
            cell.ingredientTextField.text = ingredientsList[indexPath.row]
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.materialsCellIdentifier, for: indexPath) as? MaterialsCell else {
                fatalError("Unable to dequeue ReminderCell")
            }
            cell.materialTextField.delegate = self
            
            cell.materialTextField.text = materialsList[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == ingredientsTableView {
            if editingStyle == .delete {
                ingredientsList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                ingredientCounter -= 1
            }
        } else if tableView == materialsTableView {
            if editingStyle == .delete {
                materialsList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                materialCounter -= 1
            }
        }
    }
}

extension ComponentsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if editingField == "ingredients" {
            if ingredientCounter > 0 {
                let indexPath = IndexPath(row: ingredientCounter-1, section: 0)
                let previousCell = ingredientsTableView.cellForRow(at: indexPath)! as! IngredientsCell
                ingredientsList[ingredientCounter-1] = previousCell.ingredientTextField.text!
            }
            ingredientsList.append("")
            ingredientsTableView.insertRows(at: [IndexPath(row:ingredientCounter, section: 0)], with: .automatic)
            let indexPath = IndexPath(row: ingredientCounter, section: 0)
            ingredientsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            let currentCell = ingredientsTableView.cellForRow(at: indexPath)! as! IngredientsCell
            currentCell.ingredientTextField.becomeFirstResponder()
            ingredientsList[ingredientCounter] = currentCell.ingredientTextField.text ?? "No ingredients added"
            ingredientCounter += 1
            return true
        } else if editingField == "materials" {
            if materialCounter > 0 {
                let indexPath = IndexPath(row: materialCounter-1, section: 0)
                let previousCell = materialsTableView.cellForRow(at: indexPath)! as! MaterialsCell
                materialsList[materialCounter-1] = previousCell.materialTextField.text!
            }
            materialsTableView.reloadData()
            materialsList.append("")
            materialsTableView.insertRows(at: [IndexPath(row:materialCounter, section: 0)], with: .automatic)
            let indexPath = IndexPath(row: materialCounter, section: 0)
            materialsTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            let currentCell = materialsTableView.cellForRow(at: indexPath)! as! MaterialsCell
            currentCell.materialTextField.becomeFirstResponder()
            materialsList[materialCounter] = currentCell.materialTextField.text ?? "No ingredients added"
            materialCounter += 1
            return true
        }
        return true
    }
}

extension ComponentsViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        newRecipe!.recipe.ingredients = ingredientsList
        newRecipe!.recipe.materials = materialsList
        print("component tab bar function: ", newRecipe!.recipe)
    }
}
