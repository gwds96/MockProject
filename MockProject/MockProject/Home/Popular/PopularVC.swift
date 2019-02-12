import UIKit
import Foundation

class PopularVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let urlEvents = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listPopularEvents")!
    
    var events = [Events]()
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    // MARK: func cache image
    func takeImage(url: String) -> UIImage {
        var image: UIImage? = nil
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            image = imageFromCache
            return image!
        }
        
        if let urlImage = URL(string: url) {
            do {
                let dataImage = try Data(contentsOf: urlImage)
                let img = UIImage(data: dataImage)!
                imageCache.setObject(img, forKey: url as AnyObject)
                image = img
                return image!
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return UIImage.init(named: "Noimage")!
    }
    
    override func viewDidLoad() {
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background popular"))
        tableView.backgroundView?.alpha = 0.2
        
        let task = URLSession.shared.dataTask(with: urlEvents) {(result, response, error) in
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
                    self.events = obj.response.events ?? []
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
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
            cell.eventImage.image = takeImage(url: urlString)
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
            vc.eventImg = takeImage(url: urlString)
        } else {
            vc.eventImg = #imageLiteral(resourceName: "Noimage")
        }
        vc.eventTitle = events[indexPath.row].name
        vc.eventId = events[indexPath.row].id
        vc.venue_id = String(events[indexPath.row].venue.id!)
        self.present(vc, animated: true, completion: nil)
    }
}
