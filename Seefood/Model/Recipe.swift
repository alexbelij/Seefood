//
//  Recipe.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/11/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//
import Foundation

class Ingredient: NSObject, NSCoding {
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        self.init(name: name)
    }
    
}

class RecipeIngredient: Ingredient {
    
    var amount: String
    
    init(name:String, amount: String) {
        self.amount = amount
        super.init(name: name)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(self.amount, forKey: "amount")
        super.encode(with: aCoder)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let amount = aDecoder.decodeObject(forKey: "amount") as! String
        self.init(name: name, amount: amount)
    }
    
}

class Recipe: NSObject, NSCoding {
    
    let name: String
    let recipeDescription: String
    let ingredients: [RecipeIngredient]
    let recipeSteps: [String]
    let imageName: String
    
    init(name: String, description: String, ingredients: [RecipeIngredient], recipeSteps: [String], imageName: String) {
        self.name = name
        self.recipeDescription = description
        self.ingredients = ingredients
        self.recipeSteps = recipeSteps
        self.imageName = imageName
        
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as! Recipe? {
            return self.name == object.name
        } else {
            return false
        }
    }
    
    static func < (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.name < rhs.name
    }
    
    override var hash: Int {
        return self.name.hashValue
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(recipeDescription, forKey: "recipeDescription")
        //aCoder.encode(self.ingredients, forKey: "ingredients")
        aCoder.encode(ingredients, forKey: "ingredients")
        aCoder.encode(recipeSteps, forKey: "recipeSteps")
        aCoder.encode(imageName, forKey: "imageName")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
        let recipeDescription = aDecoder.decodeObject(forKey: "recipeDescription") as? String,
        let ingredients = aDecoder.decodeObject(forKey: "ingredients") as? [RecipeIngredient],
        let recipeSteps = aDecoder.decodeObject(forKey: "recipeSteps") as? [String],
        let imageName = aDecoder.decodeObject(forKey: "imageName") as? String else {print(1234); return nil}
        
        self.init(name: name, description: recipeDescription, ingredients: ingredients, recipeSteps: recipeSteps, imageName: imageName)
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

