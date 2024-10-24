//
//  ListRatesController.swift
//  TymeX.Q1
//
//  Created by Thanh Hiếu on 27/10/24.
//

import UIKit

class ListRatesController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    //UI objects to map
    @IBOutlet weak var tbList: UITableView!
    @IBOutlet weak var edtSearch: UITextField!
    @IBOutlet weak var lbDate: UILabel!
    
    //List of variables used
    var lists:[String:Float]!
    private var searchLists:[String:Float]!
    
    var rate:String!
    var date:String!
    
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Format the date as desired
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.lbDate.text = dateFormatter.string(from: date)
        } else {
            print("Incorrect string format!")
        }
       
        edtSearch.delegate = self
        
        self.searchLists = lists
        tbList.dataSource = self
        tbList.reloadData()
        
    }
    
    //Return data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identity = segue.identifier
        if identity == "idenMain" {
            if let sender = sender as? RateCell{
                self.rate = sender.nameRate
            }
        }
    }
    
    //Handle search function
    @IBAction func searchRate(_ sender: UITextField) {
        if let check = sender.text {
            searchLists = check.isEmpty ? lists : lists.filter{$0.key.lowercased().contains(check.lowercased())}
            tbList.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        edtSearch.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchLists.count
    }
    
    //Process data display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RateCell", for: indexPath) as! RateCell
        cell.txtName.text = Array(searchLists.keys)[indexPath.row]
        cell.txtValue.text = ": " + String(Array(searchLists.values)[indexPath.row])
        return cell
    }
    
}
