import UIKit

class WentVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let keyChain = KeychainSwift()
    var urlWent = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listMyEvents")!
    var event = [Events]()
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background went going"))
        tableView.backgroundView?.alpha = 0.2
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        urlWent.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")"), URLQueryItem(name: "status", value: "2")]
        let request = URLRequest(url: urlWent.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            self.event = obj.response.events ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension WentVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "WentCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! WentCell
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
        let certifier = "PopularDetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! PopularDetailVC
        vc.eventId = event[indexPath.row].id
        if let urlImage = event[indexPath.row].photo {
            vc.eventUrlImgString = urlImage
        }
        vc.eventTitle = event[indexPath.row].name
        vc.venue_id = String(event[indexPath.row].venue.id!)
        present(vc, animated: true, completion: nil)
    }
}
