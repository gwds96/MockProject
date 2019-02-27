import UIKit
import Foundation

protocol PresentDelegate: class {
    func present(_ events: Events)
}

class PopularVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    var urlEvents = URLComponents(string: urlMain + "listPopularEvents")!
    var pageIndex = 1
    
    weak var presentDelegate: PresentDelegate?
    
    var events = [Events]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "EventCells", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EventCells")
        
        spinActivity.startAnimating()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.3
        
        urlEvents.queryItems = [URLQueryItem(name: "pageIndex", value: "\(pageIndex)"), URLQueryItem(name: "pageSize", value: "10")]
        let request = URLRequest(url: urlEvents.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            self.events = obj.response.events ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.spinActivity.stopAnimating()
                
            }
        }
    }
    
        // MARK: - load more data
    func loadMoreData() {
        urlEvents.queryItems = [URLQueryItem(name: "pageIndex", value: "\(pageIndex)"), URLQueryItem(name: "pageSize", value: "10")]
        let request = URLRequest(url: urlEvents.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            self.events += obj.response.events ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
}

extension PopularVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "EventCells"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! EventCells
        
        cell.selectionStyle = .none
        
        cell.backgroundColor = nil
        if let urlString = events[indexPath.row].photo {
            cell.eventImage.cacheImage(urlImage: urlString)
        }
        cell.eventTitleLabel.text = events[indexPath.row].name
        cell.eventDateStartLabel.text = "🗓 \(events[indexPath.row].schedule_start_date ?? "")"
        cell.eventDateEndLabel.text = "To  \(events[indexPath.row].schedule_end_date ?? "")"
        cell.eventTimeStartLabel.text = "⏰ \(events[indexPath.row].schedule_start_time ?? "")"
        cell.eventTimeEndLabel.text = "To  \(events[indexPath.row].schedule_end_time ?? "")"
        cell.eventPlaceLabel.text = "📍 \(events[indexPath.row].venue.name ?? "")"
        cell.willGoingLabel.text = String(events[indexPath.row].going_count ?? 0)
        cell.wentLabel.text = String(events[indexPath.row].went_count ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == pageIndex * 10 - 1 {
            pageIndex += 1
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDelegate?.present(events[indexPath.row])
    }
    
}
