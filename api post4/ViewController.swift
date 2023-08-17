//
//  ViewController.swift
//  api post4
//
//  Created by Admin on 15/08/23.
//

import UIKit

struct root: Codable{
    var status: String?
    var locationList: [String?]
    var vehicleInfo: vehicleInfo?
}
struct vehicleInfo: Codable {
    var make: String?
    var model: String?
    var year: Int?
    var movingType: Int?
    var fuelType: Int?
    var age: Int?
    var segment: String?
}


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsondata?.locationList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"tablecell")as! TableViewCell
        cell.label1.text = jsondata?.locationList[indexPath.row]
        cell.label2.text = jsondata?.vehicleInfo?.make
        cell.label3.text = jsondata?.vehicleInfo?.model
        cell.label4.text = jsondata?.vehicleInfo?.year?.description
        cell.label5.text = jsondata?.vehicleInfo?.movingType?.description
        cell.label6.text = jsondata?.vehicleInfo?.fuelType?.description
        cell.label7.text = jsondata?.vehicleInfo?.age?.description
        cell.label8.text = jsondata?.vehicleInfo?.segment
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    var jsondata: root?
    

    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        response()
        
    }
    
    func response(){
        let url = "https://kuwycredit.in/servlet/rest/ltv/forecast/ltvLoc"
        let request = NSMutableURLRequest (url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
        request.addValue ("application/json",forHTTPHeaderField: "Content-Type")
        var params: [String: Any] = ["year":"2020","make":"RENAULT","model":"KWID","variant":"1.0 RXL"]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            let task = URLSession.shared.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                
                if let response = response {
                    let nsHTTPResponse = response as! HTTPURLResponse
                    let statusCode = nsHTTPResponse.statusCode
                    print("status rode = \(statusCode)")
                }
                if let error = error {
                    print ("\(error)")
                }
                if let data = data {
                    do {
                        let content = try? JSONDecoder().decode(root.self, from: data)
                        self.jsondata = content
                        print (content as Any)
                        
                        DispatchQueue.main.async{
                            self.tableview.reloadData()
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            })
            task.resume()
        }catch _ {
            print("oops something happened buddy")
        }
            
            
    }


}




