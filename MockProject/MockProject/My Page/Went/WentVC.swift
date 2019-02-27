import UIKit

class WentVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    let keyChain = KeychainSwift()
    var urlWent = URLComponents(string: urlMain + "listMyEvents")!
    var event = [Events]()
    
    weak var presentDelegate: PresentDelegate?
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "EventCells", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EventCells")
        
        spinActivity.startAnimating()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background went going"))
        tableView.backgroundView?.alpha = 0.2
        
        loadData()
    }
        
    func loadData() {
        urlWent.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")"), URLQueryItem(name: "status", value: "2")]
        let request = URLRequest(url: urlWent.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            self.event = obj.response.events ?? []
                DispatchQueue.main.async {
                    self.spinActivity.stopAnimating()
                    self.tableView.reloadData()
                }
        }
    }
}

extension WentVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "EventCells"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! EventCells
        
        cell.selectionStyle = .none
        
        cell.backgroundColor = nil
        if let urlString = event[indexPath.row].photo {
            cell.eventImage.cacheImage(urlImage: urlString)
        } else {
            cell.eventImage.image = #imageLiteral(resourceName: "Noimage")
        }
        cell.eventTitleLabel.text = event[indexPath.row].name
        cell.eventDateStartLabel.text = "🗓 \(event[indexPath.row].schedule_start_date ?? "")"
        cell.eventDateEndLabel.text = "To  \(event[indexPath.row].schedule_end_date ?? "")"
        cell.eventTimeStartLabel.text = "⏰ \(event[indexPath.row].schedule_start_time ?? "")"
        cell.eventTimeEndLabel.text = "To  \(event[indexPath.row].schedule_end_time ?? "")"
        cell.eventPlaceLabel.text = "📍 \(event[indexPath.row].venue.name ?? "")"
        cell.willGoingLabel.text = String(event[indexPath.row].going_count ?? 0)
        cell.wentLabel.text = String(event[indexPath.row].went_count ?? 0)
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
