import UIKit

class SearchVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var typeOfFinding = ""
    var eventBySearch = [Events]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(#imageLiteral(resourceName: "background news"), for: .default)
        searchBar.becomeFirstResponder()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.3
    }
    
    func loadData() {
        var urlEventsBySearch = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/search")!
            urlEventsBySearch.queryItems = [URLQueryItem(name: "keyword", value: "\(typeOfFinding)")]
            let request = URLRequest(url: urlEventsBySearch.url!)
            requestData(urlRequest: request) { (obj: MainEvent) in
                self.eventBySearch = obj.response.events ?? []
                DispatchQueue.main.async {
                    self.spinActivity.stopAnimating()
                    self.tableView.reloadData()
                }
            }
    }
    
    @IBAction func backButton(_ sender: Any) {
        searchBar.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventBySearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "SearchCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! SearchCell
        cell.backgroundColor = nil
        if let urlString = eventBySearch[indexPath.row].photo {
            cell.eventImage.cacheImage(urlImage: urlString)
        } else {
            cell.eventImage.image = #imageLiteral(resourceName: "Noimage")
        }
        cell.eventTitleLabel.text = eventBySearch[indexPath.row].name
        cell.eventDateLabel.text = "🗓 \(eventBySearch[indexPath.row].schedule_start_date ?? "")"
        cell.eventTimeLabel.text = "⏰ \(eventBySearch[indexPath.row].schedule_start_time ?? "")"
        cell.eventPlaceLabel.text = "📍 \(eventBySearch[indexPath.row].venue.name ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // MARK: Get detail of the event
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let certifier = "PopularDetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! PopularDetailVC
        vc.eventId = eventBySearch[indexPath.row].id
        if let urlString = eventBySearch[indexPath.row].photo {
            vc.eventUrlImgString = urlString
        }
        vc.eventTitle = eventBySearch[indexPath.row].name
        vc.venue_id = String(eventBySearch[indexPath.row].venue.id!)
        present(vc, animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.endEditing(true)
    }
}

// MARK: - Send data to search for POST REQUEST
extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.typeOfFinding = searchBar.text ?? ""
        if self.typeOfFinding != "" {
            spinActivity.startAnimating()
            searchBar.endEditing(true)
            loadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5) {
            searchBar.showsCancelButton = true
            self.tableView.alpha = 0.2
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5) {
            searchBar.showsCancelButton = false
            self.tableView.alpha = 1
        }
    }
    
}

