import UIKit
import Foundation

class NewsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let urlString = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listNews")!
    
    var news = [News]()
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    // MARK: Func cache image
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
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.2
        let task = URLSession.shared.dataTask(with: urlString) {(result, response, error) in
                guard
                    let data = result,
                    error == nil else {
                        return
                }
                do {
                    guard let obj = try? JSONDecoder().decode(MainNews.self, from: data) else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.news = obj.response.news
                        self.tableView.reloadData()
                    }
                }
        }
        task.resume()
    }
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "NewsCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! NewsCell
        cell.backgroundColor = nil
        cell.titleLabel.text = news[indexPath.row].title ?? ""
        cell.feedLabel.text = news[indexPath.row].feed ?? ""
        cell.thumbImage.image = takeImage(url: news[indexPath.row].thumb_img!)
        cell.descriptionLabel.text = news[indexPath.row].description ?? ""
        cell.authorLabel.text = news[indexPath.row].author ?? ""
        if cell.authorLabel.text == "" {
            cell.autLbl.text = ""
        } else {
            cell.autLbl.text = "Tác giả:"
        }
        if let date = news[indexPath.row].publish_date?.prefix(10) {
            cell.dateLabel.text = String(date)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
