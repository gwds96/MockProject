import UIKit

class SearchVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var currentButton: UIButton!
    @IBOutlet weak var pastButton: UIButton!
    
    let date = Date().timeIntervalSince1970
    
    var typeOfFinding = ""
    var eventBySearch = [Events]()
    var array = [Events]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "EventCells", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EventCells")
        
        hideKeyboardWhenTappedAround()
        
        navigationBar.setBackgroundImage(#imageLiteral(resourceName: "background news"), for: .default)
        searchBar.becomeFirstResponder()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.3
        
        currentButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        currentButton.backgroundColor = #colorLiteral(red: 0.7080775037, green: 0.9142266504, blue: 0.9142266504, alpha: 0.6)
        pastButton.setTitleColor(UIColor.gray, for: .normal)
        pastButton.backgroundColor = #colorLiteral(red: 0.7080775037, green: 0.9142266504, blue: 0.9142266504, alpha: 0.6)
    }
    
    func loadData() {
        var urlEventsBySearch = URLComponents(string: urlMain + "search")!
            urlEventsBySearch.queryItems = [URLQueryItem(name: "keyword", value: "\(typeOfFinding)")]
            let request = URLRequest(url: urlEventsBySearch.url!)
            requestData(urlRequest: request) { (obj: MainEvent) in
                self.eventBySearch = obj.response.events ?? []
                self.array = self.eventBySearch.filter { convertDateToDouble($0.schedule_end_date!) > Double(self.date) }
                self.array = self.array.sorted(by: { convertDateToDouble($0.schedule_start_date!) < convertDateToDouble($1.schedule_start_date!) })
                DispatchQueue.main.async {
                    self.currentButton.setTitle("Current & upcoming (\(self.array.count))", for: .normal)
                    
                    self.pastButton.setTitle("Past (\(self.eventBySearch.count - self.array.count))", for: .normal)
                    self.spinActivity.stopAnimating()
                    self.tableView.reloadData()
                }
            }
    }
    
    @IBAction func currentButton(_ sender: Any) {
        currentButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        pastButton.setTitleColor(UIColor.gray, for: .normal)
        array = eventBySearch.filter { convertDateToDouble($0.schedule_end_date!) >= Double(date) }
        array = array.sorted(by: { convertDateToDouble($0.schedule_start_date!) < convertDateToDouble($1.schedule_start_date!) })
        tableView.reloadData()
    }
    
    @IBAction func pastButton(_ sender: Any) {
        pastButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        currentButton.setTitleColor(UIColor.gray, for: .normal)
        array = eventBySearch.filter { convertDateToDouble($0.schedule_end_date!) < Double(date) }
        array = array.sorted(by: { convertDateToDouble($0.schedule_start_date!) > convertDateToDouble($1.schedule_start_date!) })
        tableView.reloadData()
    }
    
    @IBAction func backButton(_ sender: Any) {
        searchBar.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "EventCells"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! EventCells
        
        cell.selectionStyle = .none
        
        cell.backgroundColor = nil
        if let urlString = array[indexPath.row].photo {
            cell.eventImage.cacheImage(urlImage: urlString)
        } else {
            cell.eventImage.image = #imageLiteral(resourceName: "Noimage")
        }
        cell.eventTitleLabel.text = array[indexPath.row].name
        cell.eventDateStartLabel.text = "🗓 \(array[indexPath.row].schedule_start_date ?? "")"
        cell.eventDateEndLabel.text = "To  \(array[indexPath.row].schedule_end_date ?? "")"
        cell.eventTimeStartLabel.text = "⏰ \(array[indexPath.row].schedule_start_time ?? "")"
        cell.eventTimeEndLabel.text = "To  \(array[indexPath.row].schedule_end_time ?? "")"
        cell.eventPlaceLabel.text = "📍 \(array[indexPath.row].venue.name ?? "")"
        cell.willGoingLabel.text = String(array[indexPath.row].going_count ?? 0)
        cell.wentLabel.text = String(array[indexPath.row].went_count ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // MARK: Get detail of the event
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let certifier = "PopularDetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! PopularDetailVC
        vc.eventId = array[indexPath.row].id
        if let urlString = array[indexPath.row].photo {
            vc.eventUrlImgString = urlString
        }
        vc.eventTitle = array[indexPath.row].name
        vc.venue_id = String(array[indexPath.row].venue.id!)
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
            self.tableView.alpha = 0
        }
        currentButton.setTitle("Current & upcoming", for: .normal)
        pastButton.setTitle("Past", for: .normal)
        array = []
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5) {
            searchBar.showsCancelButton = false
            self.tableView.alpha = 1
        }
    }
    
}

