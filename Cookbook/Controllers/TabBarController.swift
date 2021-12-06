//
//  TabBarController.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/30/21.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Local Variables
    
    var newRecipe: RecipeItemController?
    var viewControllerNumber = Int()
    
    // MARK: - Helper Functions
    
    private func setupChildViewControllers() {
        guard let viewControllers = viewControllers else {
            return
        }
        
        for viewController in viewControllers {
            var childViewController: UIViewController?
            childViewController = viewController
            switch childViewController {
            case let viewController as InformationViewController:
                viewController.newRecipe = newRecipe
            case let viewController as ComponentsViewController:
                viewController.newRecipe = newRecipe
            case let viewController as InstructionsViewController:
                viewController.newRecipe = newRecipe
            case let viewController as NotesViewController:
                viewController.newRecipe = newRecipe
            default:
                break
            }
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupChildViewControllers()
    }
}
