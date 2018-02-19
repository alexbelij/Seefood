//
//  FoodsKnown.swift
//  Seefood
//
//  Created by Siddha Tiwari on 2/10/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

struct FoodsKnown {
    let foodLabels = ["potato", "apple", "banana", "flour"]
    let allRecipes = [
        Recipe(name: "Apple Sauce",
               description: "A puree of stewed apples",
               ingredients: [RecipeIngredient(name: "apple", amount: "1"),
                             RecipeIngredient(name: "sugar", amount: "1lb")],
               recipeSteps: ["Peel, core, and slice apples", "In a large pot, bring apples, lemon juice, and 1 1/2 cups water to a boil over high. Reduce heat and simmer until apples are very soft and falling apart, 25 to 30 minutes", "Mash with a potato masher or pulse in a food processor until smooth with small chunks remaining. (Add sugar, if using.)", "Let cool, then transfer applesauce to airtight containers."],
               imageName: "pizza"),
        Recipe(name: "Apple Pie",
               description: "An apple pie is a pie or a tart, in which the principal filling ingredient is apple.",
               ingredients: [RecipeIngredient(name: "apple", amount: "1"),
                             RecipeIngredient(name: "flour", amount: "lots")],
               recipeSteps: ["Heat oven to 425ºF. Prepare Double-Crust Pastry.", "Mix sugar, flour, cinnamon, nutmeg and salt in large bowl. Stir in apples. Turn into pastry-lined pie plate. Dot with butter. Trim overhanging edge of pastry 1/2 inch from rim of plate.", "Roll other round of pastry. Fold into fourths and cut slits so steam can escape. Unfold top pastry over filling; trim overhanging edge 1 inch from rim of plate. Fold and roll top edge under lower edge, pressing on rim to seal; flute as desired. Cover edge with 3-inch strip of aluminum foil to prevent excessive browning. Remove foil during last 15 minutes of baking.", "Bake 40 to 50 minutes or until crust is brown and juice begins to bubble through slits in crust. Serve warm if desired."],
               imageName: "pizza"),
        Recipe(name: "Banana Bread",
               description: "Banana bread is a type of bread made from mashed bananas.",
               ingredients: [RecipeIngredient(name: "banana", amount: "1"),
                             RecipeIngredient(name: "egg", amount: "1"),
                             RecipeIngredient(name: "flour", amount: "some"),
                             RecipeIngredient(name: "sugar", amount: "some")],
               recipeSteps: ["Preheat the oven to 350°F (175°C), and butter a 4x8-inch loaf pan.", "In a mixing bowl, mash the ripe bananas with a fork until completely smooth. Stir the melted butter into the mashed bananas.", "Mix in the baking soda and salt. Stir in the sugar, beaten egg, and vanilla extract. Mix in the flour.", "Pour the batter into your prepared loaf pan. Bake for 50 minutes to 1 hour at 350°F (175°C), or until a tester inserted into the center comes out clean.", "Remove from oven and let cool in the pan for a few minutes. Then remove the banana bread from the pan and let cool completely before serving. Slice and serve. (A bread knife helps to make slices that aren't crumbly.)"],
               imageName: "pizza"),
        Recipe(name: "Omelette",
               description: "In cuisine, an omelette or omelet is a dish made from beaten eggs fried with butter or oil in a frying pan.",
               ingredients: [RecipeIngredient(name: "egg", amount: "1")],
               recipeSteps: ["Beat eggs, water, salt and pepper in small bowl until blended.", "Heat butter in 6 to 8-inch nonstick omelet pan or skillet over medium-high heat until hot. Tilt pan to coat bottom. Pour in egg mixture. Mixture should set immediately at edges.", "Gently push cooked portions from edges toward the center with inverted turner so that uncooked eggs can reach the hot pan surface. Continue cooking, tilting pan and gently moving cooked portions as needed.", "When top surface of eggs is thickened and no visible liquid egg remains, Place filling on one side of the omelet. Fold omelet in half with turner. With a quick flip of the wrist, turn pan and Inver or Slide omelet onto plate. Serve immediately."],
               imageName: "pizza"),
        Recipe(name: "Scambled Eggs",
               description: "A dish of eggs prepared by beating them with a little liquid and then cooking and stirring gently.",
               ingredients: [RecipeIngredient(name: "egg", amount: "1")],
               recipeSteps: ["Beat eggs, milk, salt and pepper in medium bowl until blended.", "Heat butter in large nonstick skillet over medium heat until hot. Pour IN egg mixture. As eggs begin to set, Gently pull the eggs across the pan with a spatula, forming large soft curds.", "Continue cooking – pulling, lifting and folding eggs – until thickened and no visible liquid egg remains. Do not stir constantly. Remove from heat. Serve immediately."],
               imageName: "pizza"),
        Recipe(name: "Fried Eggs",
               description: "A fried egg is a cooked dish commonly made using a fresh hen's egg, fried whole with minimal accompaniment.",
               ingredients: [RecipeIngredient(name: "egg", amount: "1")],
               recipeSteps: ["For Over-Easy or Over-Hard Eggs: Heat 2 tsp. butter in nonstick skillet over medium-high heat until hot.", "Break eggs and slip into pan, 1 at a time. Immediatly reduce heat to low.", "Cook slowly until whites are completely set and yolks begin to thicken but are not hard. Slide turner under each egg and carefully flip it over in pan. cook second side to desired doneness. Sprinkle with salt and pepper. Serve immediately."],
               imageName: "pizza"),
        Recipe(name: "Fries",
               description: "Fried Potatoes",
               ingredients: [RecipeIngredient(name: "potato", amount: "1")],
               recipeSteps: ["Slice potatoes into French fries, and place into cold water so they won't turn brown while you prepare the oil.", "Heat oil in a large skillet over medium-high heat. While the oil is heating, sift the flour, garlic salt, onion salt, (regular) salt, and paprika into a large bowl. Gradually stir in enough water so that the mixture can be drizzled from a spoon.", "Dip potato slices into the batter one at a time, and place in the hot oil so they are not touching at first. The fries must be placed into the skillet one at a time, or they will clump together. Fry until golden brown and crispy. Remove and drain on paper towels."],
               imageName: "pizza"),
        Recipe(name: "Mashed Potatoes",
               description: "Mashed potatoes is a dish prepared by mashing boiled potatoes.",
               ingredients: [RecipeIngredient(name: "potato", amount: "1")],
               recipeSteps: ["Bring a pot of salted water to a boil. Add potatoes and cook until tender but still firm, about 15 minutes; drain.", "In a small saucepan heat butter and milk over low heat until butter is melted. Using a potato masher or electric beater, slowly blend milk mixture into potatoes until smooth and creamy. Season with salt and pepper to taste."],
               imageName: "pizza")
    ]
}
