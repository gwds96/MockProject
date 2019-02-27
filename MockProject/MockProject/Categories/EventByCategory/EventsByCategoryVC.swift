import UIKit

class EventsByCategoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    @IBOutlet weak var byPopularityButton: UIButton!
    @IBOutlet weak var byDateButton: UIButton!
    
    var categoryTitle: String?
    var categoryId: Int?
    var eventByCategory = [Events]()
    var pageIndex = 1
    
    var urlEventsByCategory = URLComponents(string: urlMain + "listEventsByCategory")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "EventCells", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EventCells")
        
        spinActivity.startAnimating()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.3
        byPopularityButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        byPopularityButton.backgroundColor = #colorLiteral(red: 0.7080775037, green: 0.9142266504, blue: 0.9142266504, alpha: 0.6)
        byDateButton.setTitleColor(UIColor.gray, for: .normal)
        byDateButton.backgroundColor = #colorLiteral(red: 0.7080775037, green: 0.9142266504, blue: 0.9142266504, alpha: 0.6)
        
        urlEventsByCategory.queryItems = [URLQueryItem(name: "category_id", value: "\(categoryId!)"), URLQueryItem(name: "pageIndex", value: "\(pageIndex)"), URLQueryItem(name: "pageSize", value: "10")]
        let request = URLRequest(url: urlEventsByCategory.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            self.eventByCategory = obj.response.events ?? []
            self.eventByCategory = self.eventByCategory.sorted(by: { $0.going_count! > $1.going_count! })
            DispatchQueue.main.async {
                self.categoryTitleLabel.text = "\(self.categoryTitle!) (\(self.eventByCategory.count))"
                self.spinActivity.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    func loadMoreData() {
        urlEventsByCategory.queryItems = [URLQueryItem(name: "category_id", value: "\(categoryId!)"), URLQueryItem(name: "pageIndex", value: "\(pageIndex)"), URLQueryItem(name: "pageSize", value: "10")]
        let request = URLRequest(url: urlEventsByCategory.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            self.eventByCategory += obj.response.events ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var urlEventsByCategory = URLComponents(string: urlMain + "listEventsByCategory")!
        urlEventsByCategory.queryItems = [URLQueryItem(name: "category_id", value: "\(categoryId!)")]
        let request = URLRequest(url: urlEventsByCategory.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            self.eventByCategory = obj.response.events ?? []
            DispatchQueue.main.async {
            if self.byPopularityButton.titleColor(for: .normal) == #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) {
            self.eventByCategory = self.eventByCategory.sorted(by: { $0.going_count! > $1.going_count! })
            } else {
                self.eventByCategory = self.eventByCategory.sorted(by: { convertDateToDouble($0.schedule_start_date!) > convertDateToDouble($1.schedule_start_date!) })
            }
                self.categoryTitleLabel.text = "\(self.categoryTitle!) (\(self.eventByCategory.count))"
                self.spinActivity.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func byPopularityButton(_ sender: Any) {
        byPopularityButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        byDateButton.setTitleColor(UIColor.gray, for: .normal)
        eventByCategory = eventByCategory.sorted(by: { $0.going_count! > $1.going_count! })
        tableView.reloadData()
    }
    
    @IBAction func byDateButton(_ sender: Any) {
        byDateButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        byPopularityButton.setTitleColor(UIColor.gray, for: .normal)
        eventByCategory = eventByCategory.sorted(by: { convertDateToDouble($0.schedule_start_date!) > convertDateToDouble($1.schedule_start_date!) })
        tableView.reloadData()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EventsByCategoryVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventByCategory.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "EventCells"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! EventCells
        
        cell.selectionStyle = .none
        
        cell.backgroundColor = nil
        if let urlString = eventByCategory[indexPath.row].photo {
            cell.eventImage.cacheImage(urlImage: urlString)
        } else {
            cell.eventImage.image = #imageLiteral(resourceName: "Noimage")
        }
        cell.eventTitleLabel.text = eventByCategory[indexPath.row].name
        cell.eventDateStartLabel.text = "🗓 \(eventByCategory[indexPath.row].schedule_start_date ?? "")"
        cell.eventDateEndLabel.text = "To  \(eventByCategory[indexPath.row].schedule_end_date ?? "")"
        cell.eventTimeStartLabel.text = "⏰ \(eventByCategory[indexPath.row].schedule_start_time ?? "")"
        cell.eventTimeEndLabel.text = "To  \(eventByCategory[indexPath.row].schedule_end_time ?? "")"
        cell.eventPlaceLabel.text = "📍 \(eventByCategory[indexPath.row].venue.name ?? "")"
        cell.willGoingLabel.text = String(eventByCategory[indexPath.row].going_count ?? 0)
        cell.wentLabel.text = String(eventByCategory[indexPath.row].went_count ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == pageIndex * 10 - 1 {
            pageIndex += 1
            loadMoreData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // MARK: Get detail of the event
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let certifier = "PopularDetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! PopularDetailVC
        vc.eventId = eventByCategory[indexPath.row].id
        if let urlString = eventByCategory[indexPath.row].photo {
            vc.eventUrlImgString = urlString
        }
        vc.eventTitle = eventByCategory[indexPath.row].name
        vc.venue_id = String(eventByCategory[indexPath.row].venue.id!)
        present(vc, animated: true, completion: nil)
    }
}
