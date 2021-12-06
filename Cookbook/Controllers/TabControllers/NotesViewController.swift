//
//  NotesViewController.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/26/21.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    // MARK: - Local Variables
    
    var newRecipe: RecipeItemController?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    var context:NSManagedObjectContext!
    var viewControllerNumber = 3
    let navController = UINavigationController(rootViewController: RecipeCollectionViewController())
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var notesField: UITextView!
    
    // MARK: - IBActions
    
    @IBAction func addRecipePressed(_ sender: UIButton) {
        if notesField.text == "Please enter any notes or tips for this recipe." {
            newRecipe!.recipe.notes = ""
        } else {
            newRecipe!.recipe.notes = notesField.text
        }
        openDatabase()
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CollectionView") as! RecipeCollectionViewController
        let navigationController = UINavigationController(rootViewController: viewController)
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
    
    // MARK: - Helper Functions
    
    func openDatabase() {
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: context)
        let recipeObject = NSManagedObject(entity: entity!, insertInto: context)
        saveData(recDBObj:recipeObject)
    }
    
    func saveData(recDBObj:NSManagedObject) {
        recDBObj.setValue(newRecipe!.recipe.name, forKey: "name")
        recDBObj.setValue(newRecipe!.recipe.duration, forKey: "duration")
        recDBObj.setValue(Int32(newRecipe!.recipe.difficulty ?? 3), forKey: "difficulty")
        recDBObj.setValue(Int32(newRecipe!.recipe.servings ??  1), forKey: "servings")
        recDBObj.setValue(newRecipe!.recipe.tags, forKey: "tags")
        recDBObj.setValue(newRecipe!.recipe.favorite, forKey: "favorite")
        recDBObj.setValue(newRecipe!.recipe.images, forKey: "image")
        recDBObj.setValue(newRecipe!.recipe.ingredients, forKey: "ingredients")
        recDBObj.setValue(newRecipe!.recipe.materials, forKey: "materials")
        recDBObj.setValue(newRecipe!.recipe.process, forKey: "process")
        recDBObj.setValue(newRecipe!.recipe.notes, forKey: "notes")
        recDBObj.setValue(Date(), forKey: "date")
        
        do {
            try context.save()
            print("Saving data succeeded", recDBObj)
        } catch {
            print("Storing data Failed")
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesField.delegate = self
        notesField.text = "Please enter any notes or tips for this recipe."
        notesField.textColor = UIColor.lightGray
        tabBarController?.delegate = self
    }
}

extension NotesViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesField.textColor == UIColor.lightGray {
            notesField.text = nil
            notesField.textColor = UIColor(named: "TestColor")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if notesField.text.isEmpty {
            notesField.text = "Please enter any notes or tips for this recipe."
            notesField.textColor = UIColor.lightGray
        }
    }
}

extension NotesViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if notesField.text == "Please enter any notes or tips for this recipe." {
            newRecipe!.recipe.notes = ""
        } else {
            newRecipe!.recipe.notes = notesField.text
        }
        print("notes tab bar function: ", newRecipe!.recipe)
    }
}
