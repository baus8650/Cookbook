//
//  InstructionsViewController.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/26/21.
//

import UIKit

class InstructionsViewController: UIViewController {
    
    // MARK: - Local Variables
    
    var newRecipe: RecipeItemController?
    var viewControllerNumber = 2
    var stepCounter: Int = 0
    private var stepsList = [String]()
    static let processCellIdentifier = "ProcessCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var processTable: UITableView!
    
    // MARK: - IBActions
    
    @IBAction func addStepPressed(_ sender: UIButton) {
        if stepCounter > 0 {
            let indexPath = IndexPath(row: stepCounter-1, section: 0)
            let previousCell = processTable.cellForRow(at: indexPath)! as! ProcessCell
            stepsList[stepCounter-1] = previousCell.processTextField.text!
        }
        stepsList.append("")
        processTable.insertRows(at: [IndexPath(row:stepCounter, section: 0)], with: .automatic)
        let indexPath = IndexPath(row: stepCounter, section: 0)
        processTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
        let currentCell = processTable.cellForRow(at: indexPath)! as! ProcessCell
        currentCell.processTextField.becomeFirstResponder()
        stepsList[stepCounter] = currentCell.processTextField.text ?? "No steps added"
        stepCounter += 1
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processTable.dataSource = self
        tabBarController?.delegate = self
    }
}

extension InstructionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.processCellIdentifier, for: indexPath) as? ProcessCell else {
            fatalError("Unable to dequeu ProcessCell")
        }
        cell.processTextField.delegate = self
        cell.processTextField.text = stepsList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            stepsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            stepCounter -= 1
        }
    }
}

extension InstructionsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if stepCounter > 0 {
            let indexPath = IndexPath(row: stepCounter-1, section: 0)
            let previousCell = processTable.cellForRow(at: indexPath)! as! ProcessCell
            stepsList[stepCounter-1] = previousCell.processTextField.text!
        }
        stepsList.append("")
        processTable.insertRows(at: [IndexPath(row:stepCounter, section: 0)], with: .automatic)
        let indexPath = IndexPath(row: stepCounter, section: 0)
        processTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
        let currentCell = processTable.cellForRow(at: indexPath)! as! ProcessCell
        currentCell.processTextField.becomeFirstResponder()
        stepsList[stepCounter] = currentCell.processTextField.text ?? "No steps added"
        stepCounter += 1
        return true
    }
}

extension InstructionsViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if stepCounter > 0 {
            let indexPath = IndexPath(row: stepCounter-1, section: 0)
            let currentCell = processTable.cellForRow(at: indexPath)! as! ProcessCell
            stepsList.append(currentCell.processTextField.text!)
            stepsList = stepsList.filter {$0 != ""}
        }
        newRecipe!.recipe.process = stepsList
        print("instruction tab bar function: ", newRecipe!.recipe)
    }
}
