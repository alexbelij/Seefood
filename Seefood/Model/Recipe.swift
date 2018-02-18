//
//  Recipe.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/11/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

struct Recipe {
    let name: String
    let description: String
    let ingredients: [(name: String, amount: String)]
    let recipeSteps: [String]
    let imageName: String
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.name == rhs.name
    }
    static func < (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.name < rhs.name
    }
}

// TODO: Hash value for string array ?
extension Recipe: Hashable {
    var hashValue: Int {
        return name.hashValue ^ description.hashValue
    }
}

extension Recipe {
    func getCommaRecipeString() -> String {
        var ingredientsString = ""
        for (index, ingredient) in self.ingredients.enumerated() {
            if index != self.ingredients.count - 1 {
                ingredientsString.append("\(ingredient.name), ")
            } else {
                ingredientsString.append("\(ingredient.name)")
            }
        }
        return ingredientsString
    }
}

