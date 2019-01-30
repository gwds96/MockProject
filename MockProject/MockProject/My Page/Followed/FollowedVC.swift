import UIKit

class FollowedVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let keyChain = KeychainSwift()
    var urlFollowed = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listVenueFollowed")!
    var venue = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlFollowed.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")")]
        let request = URLRequest(url: urlFollowed.url!)
        let task = URLSession.shared.dataTask(with: request) {(result, response, error) in
            guard
                let data = result,
                error == nil else {
                    return
            }
            do {
                guard let obj = try? JSONDecoder().decode(MainEvent.self, from: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.venue = obj.response.venues ?? []
                    self.tableView.reloadData()
                    }
                }
            }
        task.resume()
    }
    
}

// MARK: TableView for list followed event places ViewController
extension FollowedVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "FollowedCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! FollowedCell
        cell.nameLabel.text = venue[indexPath.row].name
        cell.localLabel.text = "\(venue[indexPath.row].description ?? ""), \(venue[indexPath.row].geo_area!)"
        cell.phoneLabel.text = venue[indexPath.row].contact_phone
        cell.addressLabel.text = venue[indexPath.row].contact_address
        return cell
    }
}
