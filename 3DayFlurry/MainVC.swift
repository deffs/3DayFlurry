//
//  ViewController.swift
//  3DayFlurry
//
//  Created by Alex de France on 4/5/18.
//  Copyright © 2018 Def Labs. All rights reserved.
//

import UIKit
import Alamofire

class MainVC: UIViewController {

    @IBOutlet weak var stateBox: UITextField!
    @IBOutlet weak var cityBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var requestBtn: UIButton!
    
    var weatherData = [WeatherData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 5.0
        tableView.layer.masksToBounds = true
        
        roundViews(view: requestBtn)
        roundViews(view: cityBox)
        roundViews(view: stateBox)
        
        stateBox.attributedPlaceholder = NSAttributedString(string: "State (AA)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        cityBox.attributedPlaceholder = NSAttributedString(string: "City", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    func roundViews(view: Any) {
        if let btn = view as? UIButton {
            btn.layer.cornerRadius = 5.0
            btn.layer.masksToBounds = true
            btn.layer.borderColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
            btn.layer.borderWidth = 1.0
        }
        if let box = view as? UITextField {
            box.layer.cornerRadius = 5.0
            box.layer.masksToBounds = true
        }
    }
    

    func getWeather(completed: @escaping DownloadComplete) {
        guard stateBox.text != "" else {
            self.stateBox.layer.borderWidth = 2.0
            self.stateBox.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            return
        }
        self.stateBox.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        guard cityBox.text != "" else {
            self.cityBox.layer.borderWidth = 2.0
            self.cityBox.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            return
        }
        self.cityBox.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        if (stateBox.text?.count)! != 2 {
            let alert = UIAlertController(title: "Error", message: "Please Enter A Binary State Code", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: {
                self.stateBox.text = ""
            })
        }
        let cityText = cityBox.text?.replacingOccurrences(of: " ", with: "_")
        
        let requestString = startURL+stateBox.text!+"/"+cityText!+".json"
        print(requestString)
        Alamofire.request(requestString).responseJSON { (response) in
            print(response)
            if let dict = response.result.value as? [String:Any] {
                if let forecast = dict["forecast"] as? [String:Any] {
                    if let textfore = forecast["txt_forecast"] as? [String:Any] {
                        if let forecastday = textfore["forecastday"] as? [[String:Any]] {
                            for x in 0...5 {
                                var weather = WeatherData()
                                var icon = forecastday[x]["icon"] as? String
                                if icon!.contains("nt") {
                                    continue
                                }
                                if icon == "mostlycloudy" {
                                    icon = "cloudy"
                                }
                                else if icon == "chancetstorms" || icon == "tstorms" {
                                    icon = "thunderstorm"
                                }
                                weather.icon = icon!
                                weather.title = forecastday[x]["title"] as? String
                                weather.text = forecastday[x]["fcttext_metric"] as? String
                                self.weatherData.append(weather)
                            }
                        }
                    }
                    if let simple = forecast["simpleforecast"] as? [String:Any] {
                        if let temp = simple["forecastday"] as? [[String:Any]] {
                            for x in 0...2 {
                                if let high = temp[x]["high"] as? [String:String] {
                                    self.weatherData[x].highTemp = high["celsius"]!+"℃"
                                }
                                if let low = temp[x]["low"] as? [String:String] {
                                    self.weatherData[x].lowTemp = low["celsius"]!+"℃"
                                }
                            }
                            
                        }
                    }
                }
            }
            completed()
        }
    }
    
    @IBAction func getData(_ sender: UIButton) {
        view.endEditing(true)
        weatherData.removeAll()
        getWeather {
            if self.weatherData.isEmpty {
                let alert = UIAlertController(title: "Error", message: "Unable to Locate City", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: {
                    self.cityBox.text = ""
                })
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    

}


extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !weatherData.isEmpty {
            return weatherData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! MainTableViewCell
        if !weatherData.isEmpty {
            cell.mainImg.image = UIImage(named: weatherData[indexPath.section].icon!+".png")
            cell.dayLbl?.text = weatherData[indexPath.section].title!
            cell.descLbl?.text = weatherData[indexPath.section].text!
            cell.highLbl?.text = weatherData[indexPath.section].highTemp!
            cell.lowLbl?.text = weatherData[indexPath.section].lowTemp!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        self.tableView.tableFooterView = footer
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    
}
