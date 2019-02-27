import UIKit
import Foundation

class NewsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    var urlNews = URLComponents(string: urlMain + "listNews")!
    
    var news = [News]()
    var pageIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinActivity.startAnimating()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.3
        loadData()
    }
    
    func loadData() {
        urlNews.queryItems = [URLQueryItem(name: "pageIndex", value: "\(pageIndex)"), URLQueryItem(name: "pageSize", value: "10")]
        let request = URLRequest(url: urlNews.url!)
        requestData(urlRequest: request) { (obj: MainNews) in
            self.news = obj.response.news
            DispatchQueue.main.async {
                self.spinActivity.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
        // MARK: - load more data
    func loadMoreData() {
        urlNews.queryItems = [URLQueryItem(name: "pageIndex", value: "\(pageIndex)"), URLQueryItem(name: "pageSize", value: "10")]
        let request = URLRequest(url: urlNews.url!)
        requestData(urlRequest: request) { (obj: MainNews) in
            self.news += obj.response.news 
            DispatchQueue.main.async {
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
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if indexPath.row == pageIndex * 10 - 1 {
                pageIndex += 1
                loadMoreData()
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 400
        }
        
}
