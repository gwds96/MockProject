import UIKit

class WentVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let keyChain = KeychainSwift()
    var urlWent = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listMyEvents")!
    var event = [Events]()
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        urlWent.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")"), URLQueryItem(name: "status", value: "2")]
        let request = URLRequest(url: urlWent.url!)
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
                    self.event = obj.response.events ?? []
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    // MARK: Cache image
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

extension WentVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "WentCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! WentCell
        cell.nameLabel.text = event[indexPath.row].name
        cell.localLabel.text = event[indexPath.row].venue.name
        cell.dateLabel.text = event[indexPath.row].schedule_start_date
        cell.timeLabel.text = event[indexPath.row].schedule_start_time
        if let urlImage = event[indexPath.row].photo {
        cell.eventImage.image = takeImage(url: urlImage)
        } else {
            cell.eventImage.image = #imageLiteral(resourceName: "Noimage")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // MARK: Get detail for the event
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let certifier = "PopularDetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! PopularDetailVC
        vc.eventId = event[indexPath.row].id
        if let urlImage = event[indexPath.row].photo {
            vc.eventImg = takeImage(url: urlImage)
        } else {
            vc.eventImg = #imageLiteral(resourceName: "Noimage")
        }
        vc.eventTitle = event[indexPath.row].name
        present(vc, animated: true, completion: nil)
    }
}