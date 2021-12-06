//
//  RecipeViewController.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/21/21.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {
    
    // MARK: - Local Variables
    
    var container: NSPersistentContainer!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let ingredientsCellIdentifier = "IngredientsCell"
    static let materialsCellIdentifier = "MaterialsCell"
    static let stepsCellIdentifier = "ProcessCell"
    
    var ingredientsList = [String]()
    var materialsList = [String]()
    var stepsList = [String]()
    var recipeName: String = ""
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var materialsTableView: UITableView!
    @IBOutlet weak var stepsTableView: UITableView!
    
    // MARK: - Helper Functions
    
    func loadIngredients() {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "name == %@", recipeName as! CVarArg)
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                nameLabel.text = (data.value(forKey: "name") as! String)
                let cookingTime = data.value(forKey: "duration") as! String
                let tags = data.value(forKey: "tags") as! [String]
                ingredientsList = data.value(forKey: "ingredients") as! [String]
                materialsList = data.value(forKey: "materials") as! [String]
                let servings = data.value(forKey: "servings") as! Int32
                stepsList = data.value(forKey: "process") as! [String]
                notesField.text = data.value(forKey: "notes") as! String
                recipeImage.image = UIImage(data: data.value(forKey: "image") as! Data)
                let favorite = data.value(forKey: "favorite") as! Bool
                let duration = data.value(forKey: "duration") as! String
                let difficulty = data.value(forKey: "difficulty") as! Int32
                let date = data.value(forKey: "date") as! Date
            }
        } catch {
            print("Fetching data Failed")
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTableView.dataSource = self
        materialsTableView.dataSource = self
        stepsTableView.dataSource = self
        loadIngredients()
    }
}

extension RecipeViewController: UITextFieldDelegate {
    
}

extension RecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView {
            return ingredientsList.count
        } else if tableView == materialsTableView {
            return materialsList.count
        } else {
            return stepsList.count
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
        } else if tableView == materialsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.materialsCellIdentifier, for: indexPath) as? MaterialsCell else {
                fatalError("Unable to dequeue ReminderCell")
            }
            cell.materialTextField.delegate = self
            
            cell.materialTextField.text = materialsList[indexPath.row]
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.stepsCellIdentifier, for: indexPath) as? ProcessCell else {
                fatalError("Unable to dequeue ReminderCell")
            }
            cell.processTextField.delegate = self
            
            cell.processTextField.text = stepsList[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == ingredientsTableView {
            if editingStyle == .delete {
                ingredientsList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if tableView == materialsTableView {
            if editingStyle == .delete {
                materialsList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if tableView == stepsTableView {
            if editingStyle == .delete {
                stepsList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
