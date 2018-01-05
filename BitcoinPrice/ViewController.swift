//
//  ViewController.swift
//  BitcoinPrice
//
//  Created by Shivam Dev on 05/01/18.
//  Copyright © 2018 Shivam Dev. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // API CALLING
    let baseURL = "https://blockchain.info/ticker"
    var currencyArray = ["USD", "AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "DKK", "EUR", "GBP", "HKD", "INR", "ISK", "JPY", "KRW", "NZD", "PLN", "RUB", "SEK", "SGD", "THB", "TWD"]
    
    //ARRAY IS USED FOR STORING THE DATA WHICH WE GET FROM JSON
    var currencySymbol: [String]  = []
    var currencyPrice: [String] = []
    var storedPrice: [String] = []
    var check = 0

    
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 5
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var bitcoinPrice: UITextField!
    
    //RUN WHEN SCREEN WILL LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // These tasks can also be done in IB if you prefer.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    //WHEN USER WILL PRESS "CHECK BUTTON" changePrice WILL CALL THE API
    @IBAction func changePrice(_ sender: Any) {
        
        //API CALLING FUCTION
         getBitcoinData(url: baseURL)
        
        //IT CHANGES THE PRICE WHEN THE USER BITCOIN AMOUNT
        if let priceContain = bitcoinPrice.text {
            for i in 0..<currencyPrice.count {
                currencyPrice[i] = String(Double(storedPrice[i])! * Double(priceContain)!)
            }
        }
        
    }
    
    //    //    //    //MARK: - Networking
    //    //    //    /***************************************************************/
    //    //
    func getBitcoinData(url: String) {

          //ALAMOFIRE IS FROM COCOAPOD
            Alamofire.request(url, method: .get)
                .responseJSON { response in
                    if response.result.isSuccess {
                        print("Sucess! Got the Bitcoin data")
                        //SWIFTYJASON IS USED HERE
                        let bitcoinJSON : JSON = JSON(response.result.value!)
                        self.updateWeatherData(json: bitcoinJSON)
                    } else {
                        print("Error: \(String(describing: response.result.error))")
                        print("Connection Unavailable")
                    }
            }
        
        
    }
    
    //    //    //    //MARK: - JSON Parsing
    //    //    //    /***************************************************************/
    
    func updateWeatherData(json : JSON) {
        for i in 0..<currencyArray.count {
            
            if let tempResult = json[currencyArray[i]]["sell"].double, let tempResult2 = json[currencyArray[i]]["symbol"].string {
                currencyPrice.append(String(tempResult))
                currencySymbol.append(tempResult2)
                storedPrice.append(String(tempResult))
            } else {
                print("Bitcoin Unavailable")
            }

        }
    }
    

    
    // MARK: - Table View delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.currencyArray.count
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIImageView(frame: self.tableView.bounds)
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        
        // THIS CONDITION WILL WORK ONLY THERE IS VALUE STORED IN THE ARRAY
        if !currencyPrice.isEmpty {
            cell.textLabel?.text = "\(currencyArray[indexPath.section]) ------> \(currencySymbol[indexPath.section]) \(currencyPrice[indexPath.section])"
        } else {
            cell.textLabel?.text = "\(currencyArray[indexPath.section])"
        }

        
        // add border and color
        cell.layer.borderColor = UIColor.green.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.backgroundColor = #colorLiteral(red: 0.0001922522367, green: 1, blue: 0.1971572093, alpha: 0.7135862585)
        cell.textLabel?.font = UIFont(name: "Avenir", size:22)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        return cell
    }
    

}

