import UIKit
import Foundation

class NewsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let urlString = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listNews")!
    
    var news = [News]()
    
    override func viewDidLoad() {
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.3
        requestData(urlRequest: URLRequest(url: urlString)) { (obj: MainNews) in
            DispatchQueue.main.async {
                self.news = obj.response.news
                self.tableView.reloadData()
            }
        }
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
            cell.thumbImage.cacheImage(urlImage: news[indexPath.row].thumb_img!)
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
