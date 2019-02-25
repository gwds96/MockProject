import UIKit

class WillGoVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    let keyChain = KeychainSwift()
    var urlWillGo = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listMyEvents")!
    var event = [Events]()
    
    weak var presentDelegate: PresentDelegate?
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinActivity.startAnimating()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background went going"))
        tableView.backgroundView?.alpha = 0.2
        
        loadData()
    }
    
    func loadData() {
        urlWillGo.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")"), URLQueryItem(name: "status", value: "1")]
        let request = URLRequest(url: urlWillGo.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            if let error = obj.error_message {
                if error == "Token is expired." {
                    refreshToken()
                    self.loadData()
                }
            } else {
                self.event = obj.response.events ?? []
                DispatchQueue.main.async {
                    self.spinActivity.stopAnimating()
                    self.tableView.reloadData()
            }
            }
        }
    }
}

extension WillGoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "WillGoCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! WillGoCell
        cell.backgroundColor = nil
        cell.nameLabel.text = event[indexPath.row].name
        cell.localLabel.text = event[indexPath.row].venue.name
        cell.dateLabel.text = event[indexPath.row].schedule_start_date
        cell.timeLabel.text = event[indexPath.row].schedule_start_time
        if let urlImage = event[indexPath.row].photo {
            cell.eventImage.cacheImage(urlImage: urlImage)
        } else {
            cell.eventImage.image = #imageLiteral(resourceName: "Noimage")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // MARK: - Get detail for the event
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDelegate?.present(event[indexPath.row])
    }
}
