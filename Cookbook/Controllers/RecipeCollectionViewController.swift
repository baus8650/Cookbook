//
//  RecipeCollectionViewController.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/25/21.
//

import UIKit
import CoreData


class RecipeCollectionViewController: UICollectionViewController {

    // MARK: - Local Variables
    
    private let reuseIdentifier = "RecipeCell"
    var imageList = [Data]()
    var titleList = [String]()
    var recipeName: String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    private let itemsPerRow: CGFloat = 6
    
    private let sectionInsets = UIEdgeInsets(
        top: 50.0,
        left: 20.0,
        bottom: 50.0,
        right: 20.0
    )
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var selectedLabel: UILabel!
    
    // MARK: - IBActions
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            let items = selectedCells.map { $0.item }.sorted().reversed()
            for item in items {
                imageList.remove(at: item)
                titleList.remove(at: item)
            }
            collectionView.deleteItems(at: selectedCells)
            deleteButton.isEnabled = false
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabController") as! TabBarController
        viewController.newRecipe = RecipeItemController()
        UIApplication.shared.windows.first?.rootViewController = viewController
    }
    
    // MARK: - Helper Functions
    
    private func fetchData() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        appDelegate.persistentContainer.viewContext.perform {
            do {
                let result = try fetchRequest.execute()
                if result.count != 0 {
                    for data in result {
                        let name = data.name ?? "Placeholder Recipe"
                        let tempImage = UIImage(named: "test")
                        self.titleList.append(name)
                        self.imageList.append((data.image ?? tempImage?.jpegData(compressionQuality: 1.0))!)
                    }
                } else {
                    print("Core Data is empty")
                }
                self.collectionView?.reloadData()
            }
            catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
    
    func loadIngredients() {
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: context)
        let recipeObject = NSManagedObject(entity: entity!, insertInto: context)
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                titleList.append( data.value(forKey: "name") as! String)
                imageList.append(data.value(forKey: "image") as! Data)
            }
        } catch {
            print("Fetching data Failed")
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        imageList = [Data]()
        titleList = [String]()
        fetchData()
    }
}

// MARK: - UICollectionViewDatasource

extension RecipeCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return titleList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RecipeCell
        cell.imageView.image = UIImage(data: imageList[indexPath.row])
        cell.titleField.text = titleList[indexPath.row]
        cell.titleField.textColor = UIColor(named: "TestColor")
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            let cell = collectionView.cellForItem(at: indexPath) as! RecipeCell
            recipeName = cell.titleField.text!
            performSegue(withIdentifier: "CollectionToView", sender:self)
            cell.isInEditingMode = isEditing
            deleteButton.isEnabled = false
            
        } else {
            deleteButton.isEnabled = true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            deleteButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CollectionToView" {
            if let destVC = segue.destination as? RecipeViewController {
                destVC.recipeName = recipeName
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.allowsMultipleSelection = editing
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! RecipeCell
            cell.isInEditingMode = editing
        }
    }
    
}

// MARK: - Flow Layout Methods

extension RecipeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return sectionInsets.left
    }
    
    
}
