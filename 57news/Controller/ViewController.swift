//
//  ViewController.swift
//  57news
//
//  Created by Wissa Azmy on 2/23/18.
//  Copyright © 2018 Wissa Azmy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let url = URL(string: "https://mob.57357.org/news?lang=en")
    let headers: HTTPHeaders = [
        "X-header-Key": "CS3RGl74MMuHsq2MMDUvxStumW5I72szMXLOkN7WuvA",
        "Accept": "application/json"
    ]
    
    var newsArray : [NewsItem] = [NewsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        downloadData()
        
        //Remove any extra rows from the table
        tableView.tableFooterView = UIView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemCell", for: indexPath) as! NewsItemCell
        cell.nameLbl.text = String(newsArray[indexPath.row].name)
        cell.descriptionLbl.text = String(newsArray[indexPath.row].description)
        
        if let imageURL = URL(string: newsArray[indexPath.row].image){
            let imgData = try? Data(contentsOf: imageURL)
            if let dateFile = imgData{
                let imageFile = UIImage(data: dateFile)
                cell.newsItemImg.image = imageFile
            }
        }
    
        return cell
    }

    
    // MARK:- NETWORKING
    func downloadData() {
        guard let downloadURL = url else { return }
        Alamofire.request(downloadURL, headers: headers) .responseJSON {response in
            switch response.result{
            case .success(let value):
                print("Data downloaded Successfully")
                
                let jsonData = JSON(value)
                var i = 0
                while i <= jsonData["news"].count{
                    let item = NewsItem()
                    
                    item.id = jsonData["news"][i]["id"].stringValue
                    item.name = jsonData["news"][i]["name"].stringValue
                    item.description = jsonData["news"][i]["description"].stringValue
                    item.image = jsonData["news"][i]["image"].stringValue
                    
                    self.newsArray.append(item)
                    self.tableView.reloadData()
                    
                    i += 1
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
}

