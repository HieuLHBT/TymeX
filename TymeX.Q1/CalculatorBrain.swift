//
//  CalculatorBrain.swift
//  TymeX.Q1
//
//  Created by Thanh Hiếu on 27/10/24.
//

import UIKit

//Operator methods
func sign(_ a:Double) -> Double {
    return -a
}
func add(_ a:Double,_ b:Double) -> Double {
    return a + b
}
func sub(_ a:Double,_ b:Double) -> Double {
    return a - b
}
func mul(_ a:Double,_ b:Double) -> Double {
    return a * b
}
func div(_ a:Double,_ b:Double) -> Double {
    return a / b
}

//Objects that handle function keys
class CalculatorBrain {
    
    private var accumulator:Double?;
    
    struct PendingCalculation {
        let firstOperand:Double
        let function:(Double, Double) -> Double
    }
    
    enum OperatorType {
        case binaryOperator((Double, Double) -> Double)
        case equal
    }
    
    //Convert characters to system structures
    private let operators:[String:OperatorType] = [
        "+": .binaryOperator(add),
        "-": .binaryOperator(sub),
        "x": .binaryOperator(mul),
        "÷": .binaryOperator(div),
        "=": .equal
    ]
    
    func setOperand(_ operand:Double) {
        accumulator = operand;
    }
    
    //Functions that handle the functions of operators
    var pendingCalculation:PendingCalculation?
    func performFunctions(_ mathSymbol:String) {
        if let operatorType = operators[mathSymbol] {
            switch operatorType {
            case .binaryOperator(let binaryfunction):
                if let value = accumulator {
                    pendingCalculation = PendingCalculation(firstOperand: value, function: binaryfunction)
                    accumulator = nil
                }
            case .equal:
                if let secondOperand = accumulator {
                    if let pendingCalculation = pendingCalculation {
                        accumulator =  pendingCalculation.function(pendingCalculation.firstOperand, secondOperand)
                        self.pendingCalculation = nil
                    }
                }
            }
        }
    }
    
    //Data storage and return
    public var result:Double? {
        get {
            return accumulator;
        }
    }
}
