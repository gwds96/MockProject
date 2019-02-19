import UIKit

class EventsByCategoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    var categoryId: Int?
    var eventByCategory = [Events]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinActivity.startAnimating()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.3
        
        var urlEventsByCategory = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listEventsByCategory")!
            urlEventsByCategory = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listEventsByCategory")!
            urlEventsByCategory.queryItems = [URLQueryItem(name: "category_id", value: "\(categoryId!)")]
        let request = URLRequest(url: urlEventsByCategory.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            self.eventByCategory = obj.response.events ?? []
            DispatchQueue.main.async {
                self.spinActivity.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EventsByCategoryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventByCategory.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "EventsByCategoryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! EventsByCategoryCell
        cell.backgroundColor = nil
        if let urlString = eventByCategory[indexPath.row].photo {
            cell.eventImage.cacheImage(urlImage: urlString)
        } else {
            cell.eventImage.image = #imageLiteral(resourceName: "Noimage")
        }
        cell.eventTitleLabel.text = eventByCategory[indexPath.row].name
        cell.eventDateLabel.text = "🗓 \(eventByCategory[indexPath.row].schedule_start_date ?? "")"
        cell.eventTimeLabel.text = "⏰ \(eventByCategory[indexPath.row].schedule_start_time ?? "")"
        cell.eventPlaceLabel.text = "📍 \(eventByCategory[indexPath.row].venue.name ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // MARK: Get detail of the event
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let certifier = "PopularDetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! PopularDetailVC
        vc.eventId = eventByCategory[indexPath.row].id
        if let urlString = eventByCategory[indexPath.row].photo {
            vc.eventUrlImgString = urlString
        }
        vc.eventTitle = eventByCategory[indexPath.row].name
        vc.venue_id = String(eventByCategory[indexPath.row].venue.id!)
        present(vc, animated: true, completion: nil)
    }
}
