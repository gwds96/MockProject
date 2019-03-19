import UIKit
import Foundation

class NewsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    var urlNews = URLComponents(string: urlMain + "listNews")!
    
    var news = [News]()
    var pageIndex = 1
    
    // MARK: - Instance for core data
    var newsData = [NewsData]()
    var haveConection = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        spinActivity.startAnimating()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.3
        loadData()
    }
    
    // MARK: - fetch data from memory
    func fetchData() {
        do {
            newsData = try context.fetch(NewsData.fetchRequest())
            haveConection = false
            DispatchQueue.main.async {
                self.spinActivity.stopAnimating()
                self.tableView.reloadData()
            }
        } catch {
            print("some error is \(error)")
        }
    }
    
    // MARK: - delete Entity
    func deleteEntity() {
        do {
            for entity in newsData {
                context.delete(entity)
            }
            DispatchQueue.main.async {
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
    }
    
    // MARK: - load data from sever
    func loadData() {
        urlNews.queryItems = [URLQueryItem(name: "pageIndex", value: "\(pageIndex)"), URLQueryItem(name: "pageSize", value: "10")]
        let request = URLRequest(url: urlNews.url!)
        requestData(urlRequest: request) { (obj: MainNews) in
            self.news = obj.response.news
            self.haveConection = true
            
            self.deleteEntity()
            for new in self.news {
                let newData = NewsData(context: self.context)
                newData.author = new.author
                newData.date = new.publish_date
                newData.source = new.feed
                newData.title = new.title
                newData.description_raw = new.description
                if let photoUrl = URL(string: new.thumb_img ?? "") {
                    newData.photo = try? Data(contentsOf: photoUrl)
                }
            }
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
            self.haveConection = true
            self.news += obj.response.news 
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    
    // MARK: - reload data when have conectional
    func reloadWhenConection() {
        
    }
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if haveConection {
            return news.count
        } else {
            return newsData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "NewsCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! NewsCell
        cell.backgroundColor = nil
        
        if haveConection {
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
            if let date = news[indexPath.row].publish_date {
                cell.dateLabel.text = String(date)
            }
        } else {
            cell.titleLabel.text = newsData[indexPath.row].title ?? ""
            cell.feedLabel.text = newsData[indexPath.row].source ?? ""
            if let data = newsData[indexPath.row].photo {
            cell.thumbImage.image = UIImage(data: data)
            }
            cell.descriptionLabel.text = newsData[indexPath.row].description_raw ?? ""
            cell.authorLabel.text = newsData[indexPath.row].author ?? ""
            if cell.authorLabel.text == "" {
                cell.autLbl.text = ""
            } else {
                cell.autLbl.text = "Tác giả:"
            }
            if let date = newsData[indexPath.row].date {
                cell.dateLabel.text = String(date)
            }
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
