import UIKit

//Question 2.1. Product Inventory Management
//Model
class Product {
    var name:String
    var price:Double
    var quantity:Int
    
    init?(name:String, price:Double, quantity:Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
    
    func totalPrice() -> Double {
        return price * Double(quantity)
    }
    
}

//Product data
let products:[Product] = [
    .init(name: "Laptop", price: 999.99, quantity: 5)!,
    .init(name: "Smartphone", price: 499.99, quantity: 10)!,
    .init(name: "Tablet", price: 299.99, quantity: 0)!,
    .init(name: "Smartwatch", price: 199.99, quantity: 3)!
]

//Calculate the total inventory value
func totalInventoryValue( _ products: [Product]) -> Double {
    var total:Double = 0
    for product in products {
        if product.quantity > 0 {
            total += product.totalPrice()
        }
    }
    return Double(round(100 * total) / 100)
}
print("\nTotal inventory value: \(totalInventoryValue(products))")

//Find the most expenslve product
func mostExpensiveProduct(_ products: [Product]) -> String {
    var product = products[0]
    for i in 1..<products.count {
        if products[i].price > product.price {
            product = products[i]
        }
    }
    return product.name
}
print("\nMost expenslve product: \(mostExpensiveProduct(products))")

//Check if a product named "Headphones" is in stock
func checkProductQuantity(_ products: [Product], _ productName: String) -> Bool {
    for product in products {
        if product.name == productName {
            return product.quantity > 0
        }
    }
    return false
}
print("\nCheck product named 'Headphones': \(checkProductQuantity(products, "Headphones"))")

//Sort products in descending/ascending order with options like by price, quantity
func sortDescending(_ products:  [Product], _ options: String) -> [Product] {
    var productsSort = products
    switch options {
    case "price":
        productsSort = products.sorted(by: { $0.price > $1.price })
        return productsSort
    case "quantity":
        productsSort = products.sorted(by: { $0.quantity > $1.quantity })
        return productsSort
    default:
        return productsSort
    }
}

func sortAscending(_ products: [Product], _ options: String) -> [Product] {
    var productsSort = products
    switch options {
    case "price":
        productsSort = products.sorted(by: { $0.price < $1.price })
        return productsSort
    case "quantity":
        productsSort = products.sorted(by: { $0.quantity < $1.quantity })
        return productsSort
    default:
        return productsSort
    }
}

print("\nSort descending quantity:")
for product in sortDescending(products, "quantity") {
    print("\(product.name): price \(product.price), quantity \(product.quantity)")
}

print("\nSort descending price:")
for product in sortDescending(products, "price") {
    print("\(product.name): price \(product.price), quantity \(product.quantity)")
}

print("\nSort ascending quantity:")
for product in sortAscending(products, "quantity") {
    print("\(product.name): price \(product.price), quantity \(product.quantity)")
}

print("\nSort ascending price:")
for product in sortAscending(products, "price") {
    print("\(product.name): price \(product.price), quantity \(product.quantity)")
}



//Question 2.2. Array Manipulation and Missing Number Problem
//Data
let array: [Int] = [3, 7, 1, 2, 6, 4]

//Find and return the mising number
func findMissingNumber(_ array: [Int]) -> Int {
    let sumOfArray = array.reduce(0, +)
    let n = (array.count + 1)
    let sumOfNumbersFromOneToN = n * (n + 1) / 2
    return sumOfNumbersFromOneToN - sumOfArray
}

print("\nMissing number: \(findMissingNumber(array))")
