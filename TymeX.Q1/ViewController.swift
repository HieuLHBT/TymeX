//
//  ViewController.swift
//  TymeX.Q1
//
//  Created by Thanh Hiếu on 27/10/24.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    //Map the UI used in the screen
    @IBOutlet weak var baseButton: UIButton!
    @IBOutlet weak var conversionButton: UIButton!
    @IBOutlet var main: UIView!
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var calculatorDisplay: UILabel!
    @IBOutlet weak var currencyConversion: UILabel!
    
    //Custom status check variable
    private var isTyping = false
    private var isCheck = false
    private var isCheckDot = false
    
    //Variables using tool function
    private let loadding = LoadingOverlay()
    private let calculatorBrain = CalculatorBrain();
    
    //Data variables and API usage
    private var dataAPI:DataAPI!
    private var currencyAPI = CurrencyAPI()
    
    //Variable to store currency conversion data
    var nameBase:String = ""
    var nameConversion:String = ""
    
    //Screen navigation
    enum NameType {
        case base
        case convert
    }
    var nameType:NameType = .base
    
    let monitor = NWPathMonitor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineStacks()
        main.isUserInteractionEnabled = false
        
        checkNetworkConnection()
    }
    
    //Check internet connection during application launch
    func checkNetworkConnection() {
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.callAPI()
                } else {
                    let alert = UIAlertController(title: "WARNING", message: "No network, please check network connection and restart the application!", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default){ (act) in
                    }
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    deinit {
        monitor.cancel()
    }
    
    //Due to API limitations, the function is not used yet, a warning is displayed to notify the user.
    @IBAction func checkButton(_ sender: Any) {
        let alert = UIAlertController(title: "WARNING", message: "The current API does not support data changes!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Handle data redirection to exchange rate list screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueName = segue.identifier {
            switch segueName {
            case "idenBase":
                self.nameType = .base
                if let destinationController = segue.destination as? ListRatesController {
                    destinationController.lists = dataAPI.rates
                    destinationController.date = dataAPI.date
                }
            case "idenConvert":
                self.nameType = .convert
                if let destinationController = segue.destination as? ListRatesController {
                    destinationController.lists = dataAPI.rates
                    destinationController.date = dataAPI.date
                }
            default:
                break
            }
        }
    }
    
    //Handling the display of converted currency values
    private var displayConversionValue: Double {
        get {
            return Double(currencyConversion.text!)!
        }
        set {
            if newValue == 0 {
                currencyConversion.text = "0"
                return
            }
            let integerPart = floor(newValue)
            let decimalPart = newValue - Double(integerPart)
            
            let integerFormatter = NumberFormatter()
            integerFormatter.numberStyle = .decimal
            let formattedIntegerPart = integerFormatter.string(from: NSNumber(value: integerPart)) ?? "0"
            
            let decimalString = String(format: "%.3f", decimalPart).dropFirst(2)
            
            currencyConversion.text = "\(formattedIntegerPart).\(decimalString)"
        }
    }
    func conversionMoney() {
        if nameBase != nameConversion {
            displayConversionValue = Double(dataAPI!.rates[nameConversion]!) * Double(calculatorDisplay.text!)!
        } else {
            currencyConversion.text = calculatorDisplay.text
        }
    }
    
    //Call, check and load data from API
    func checkData() async -> Void {
        loadding.hideOverlayView()
        main.isUserInteractionEnabled = true
        if (self.dataAPI!.success) {
            self.baseButton.setTitle(self.dataAPI!.base + " ↕", for: UIControl.State.normal)
            self.conversionButton.setTitle(self.dataAPI!.base + " ↕", for: UIControl.State.normal)
            self.nameBase = self.dataAPI!.base
            self.nameConversion = self.dataAPI!.base
        } else if (!self.dataAPI!.success) {
            let alert = UIAlertController(title: "WARNING", message: dataAPI.error?.info, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default){ (act) in
                self.callAPI()
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    func callAPI() {
        self.loadding.showOverlay(view: self.view)
        Task { @MainActor in
            await self.currencyAPI.currencyAPI(completion: {dataAPI in
                self.dataAPI = dataAPI
                Task { @MainActor in
                    await self.checkData()
                }
            })
        }
    }
    
    //Create border for display frame
    func lineStacks() {
        let border = UIView()
        border.backgroundColor = UIColor.gray
        stack1.superview?.addSubview(border)
        border.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            border.heightAnchor.constraint(equalToConstant: 1),
            border.leadingAnchor.constraint(equalTo: stack1.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: stack1.trailingAnchor),
            border.topAnchor.constraint(equalTo: stack1.bottomAnchor, constant: 0)
        ])
    }
    
    //Handling of delete buttons and default settings
    func rs() {
        isCheckDot = false
        isTyping = false
        displayDoubleValue = 0
        conversionMoney()
    }
    @IBAction func delAllButtonProcessing(_ sender: Any) {
        rs()
    }
    @IBAction func delButtonProcessing(_ sender: Any) {
        let calculaDefualt = calculatorDisplay.text!;
        if calculaDefualt != "0" {
            if calculaDefualt.count == 1 {
                rs()
                return
            }
            if calculaDefualt.last == "." {
                isCheckDot = false
            }
            isTyping = true
            calculatorDisplay.text = String(calculatorDisplay.text!.dropLast())
            conversionMoney()
        } else {
            rs()
        }
    }
    
    //Data entry key processing
    @IBAction func nbButtonProcessing(_ sender: UIButton) {
        calculatorDisplay.minimumScaleFactor = 0.5
        let digit = sender.currentTitle!
        let calculaDefualt = calculatorDisplay.text!
        if !isTyping {
            if digit == "0" || digit == "." {
                return
            }
            calculatorDisplay.text = digit
            isTyping = true
            conversionMoney()
        }
        else {
            if digit == "." && !isCheckDot {
                calculatorDisplay.text = calculaDefualt + digit
                isCheckDot = true
            } else if digit == "." && isCheckDot {
                return
            }
            calculatorDisplay.text = calculaDefualt + digit
            conversionMoney()
        }
        
    }
    
    //Display user input values
    private var displayDoubleValue: Double {
        get {
            return Double(calculatorDisplay.text!)!;
        }
        set {
            if newValue.getDecimals() == 0 {
                calculatorDisplay.text = String(format: "%0.0f", newValue)
            }
            else if newValue.getDecimals() < 10 {
                calculatorDisplay.text = String(newValue);
            }
            else {
                calculatorDisplay.text = String(format: "%0.10f", newValue)
            }
        }
    }
    
    //Handling touch operations on operator functions
    @IBAction func fncButtonProcessing(_ sender: UIButton) {
        if isTyping {
            isTyping = false
            calculatorBrain.setOperand(displayDoubleValue);
        }
        let mathSymbol = sender.currentTitle!
        calculatorBrain.performFunctions(mathSymbol);
        if let result = calculatorBrain.result {
            displayDoubleValue = result
        }
        conversionMoney()
    }
    
    //Handling return value after screen transition
    @IBAction func unWindChangeNameController(segue:UIStoryboardSegue) {
        if let sourceController = segue.source as? ListRatesController {
            if let name = sourceController.rate {
                switch nameType {
                case .base:
                    self.baseButton.setTitle(name + " ↕", for: UIControl.State.normal)
                    self.nameBase = name
                case .convert:
                    self.conversionButton.setTitle(name + " ↕", for: UIControl.State.normal)
                    self.nameConversion = name
                    self.conversionMoney()
                }
            }
        }
    }
}

//Reformat data type
extension Double {
    func getDecimals() -> Int {
        if !self.isNaN {
            let stringDecimals = String(self).split(separator: ".")[1]
            return stringDecimals == "0" ? 0 : stringDecimals.count
        }
        else {
            return -1
        }
    }
}
