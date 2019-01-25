import UIKit

class EventsByCategoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var categoryId: Int?
    var eventByCategory = [Events]()
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlEventsByCategory = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listEventsByCategory")!
//        let params = ["category_id": "\(categoryId!)", "pageIndex": "1", "pageSize": "10"]
        urlEventsByCategory.queryItems = [URLQueryItem(name: "category_id", value: "\(categoryId!)")]
        let request = URLRequest(url: urlEventsByCategory.url!)
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
                    self.eventByCategory = obj.response.events
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
}

extension EventsByCategoryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventByCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "EventsByCategoryCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier, for: indexPath) as! EventsByCategoryCell
        if let urlString = eventByCategory[indexPath.row].photo {
            cell.eventImage.image = takeImage(url: urlString)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let certifier = "PopularDetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! PopularDetailVC
        vc.eventId = eventByCategory[indexPath.row].id
        if let urlString = eventByCategory[indexPath.row].photo {
            vc.eventImg = takeImage(url: urlString)
        } else {
            vc.eventImg = #imageLiteral(resourceName: "Noimage")
        }
        vc.eventTitle = eventByCategory[indexPath.row].name
        present(vc, animated: true, completion: nil)
    }
}
