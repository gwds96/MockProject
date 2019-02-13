import UIKit
import Foundation

class PopularVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let urlEvents = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listPopularEvents")!
    
    var events = [Events]()
    
    override func viewDidLoad() {
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background popular"))
        tableView.backgroundView?.alpha = 0.2
        requestData(urlRequest: URLRequest(url: urlEvents)) { (obj: MainEvent) in
            DispatchQueue.main.async {
                self.events = obj.response.events ?? []
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
        let certifier = "PopularDetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier)
            as! PopularDetailVC
        if let urlString = events[indexPath.row].photo {
            vc.eventUrlImgString = urlString
        }
        vc.eventTitle = events[indexPath.row].name
        vc.eventId = events[indexPath.row].id
        vc.venue_id = String(events[indexPath.row].venue.id!)
        self.present(vc, animated: true, completion: nil)
    }
}
