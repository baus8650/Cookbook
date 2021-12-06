//
//  RecipeItem.swift
//  Cookbook
//
//  Created by Tim Bausch on 11/27/21.
//

import Foundation
import UIKit

struct RecipeItem {
    var name: String?
    var duration: String?
    var difficulty: Int?
    var servings: Int?
    var tags: [String]?
    var favorite: Bool
    var ingredients: [String]?
    var materials: [String]?
    var process: [String]?
    var notes: String?
    var images: Data?
}
