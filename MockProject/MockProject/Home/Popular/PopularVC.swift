import UIKit
import Foundation

protocol PresentDelegate: class {
    func present(_ events: Events)
}

class PopularVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    let urlEvents = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listPopularEvents")!
    
    weak var presentDelegate: PresentDelegate?
    
    var events = [Events]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinActivity.startAnimating()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.3
        requestData(urlRequest: URLRequest(url: urlEvents)) { (obj: MainEvent) in
            self.events = obj.response.events ?? []
            DispatchQueue.main.async {
                self.spinActivity.stopAnimating()
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
        let certifier = "PopularCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! PopularCell
        cell.backgroundColor = nil
        if let urlString = events[indexPath.row].photo {
            cell.eventImage.cacheImage(urlImage: urlString)
        } else {
            cell.eventImage.image = #imageLiteral(resourceName: "Noimage")
        }
        cell.titlelabel.text = events[indexPath.row].name
        cell.dateStartLabel.text = "🗓 \(events[indexPath.row].schedule_start_date ?? "")"
        cell.timeStartLabel.text = "⏰ \(events[indexPath.row].schedule_start_time ?? "")"
        cell.placeLabel.text = "📍 \(events[indexPath.row].venue.name ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDelegate?.present(events[indexPath.row])
    }
    
}
