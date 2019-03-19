import UIKit

class PopularDetailVC: UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var titleEventLabel: UILabel!
    @IBOutlet weak var detailEventLabel: UILabel!
    @IBOutlet weak var linkEventButton: UIButton!
    @IBOutlet weak var numberGoingLabel: UILabel!
    @IBOutlet weak var numberWentLabel: UILabel!
    @IBOutlet weak var constentView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var venueEventLabel: UILabel!
    @IBOutlet weak var topVenueLabel: UILabel!
    @IBOutlet weak var contactEventLabel: UILabel!
    @IBOutlet weak var locationEventLabel: UILabel!
    @IBOutlet weak var genreEventLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var willGoButton: UIButton!
    @IBOutlet weak var haveWentButton: UIButton!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var minimize: Bool = true
    
    let keyChain = KeychainSwift()
    
    var eventId: Int?
    var eventTitle: String?
    var eventUrlImgString: String?
    var venue_id: String?
    var status = 0
    var detail = String()
    
    var venueIdArray: [Int] = []
    var eventGoIdArray: [Int] = []
    var eventWentIdArray: [Int] = []
    
    var nearEvents = [Events]()
    var long = Double()
    var lat = Double()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinActivity.startAnimating()
        backgroundImage.image = #imageLiteral(resourceName: "background news")
        backgroundImage.alpha = 0.3
        collectionView.layer.cornerRadius = 10
        mainScrollView.backgroundColor = nil
        constentView.backgroundColor = nil
        
        collectionView.layer.borderWidth = 0.2
        collectionView.layer.borderColor = UIColor.cyan.cgColor
        
        followButton.layer.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.75)
        followButton.layer.cornerRadius = 5
        willGoButton.layer.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.75)
        willGoButton.layer.cornerRadius = 5
        haveWentButton.layer.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.75)
        haveWentButton.layer.cornerRadius = 5

        loadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK: - Func for Show and Load Data
    func loadData() {
        
        // MARK: Check for hiding or showing buttons
        if keyChain.get("token") == nil {
            followButton.isHidden = true
            willGoButton.isHidden = true
            haveWentButton.isHidden = true
        } else {
            followButton.isHidden = false
            willGoButton.isHidden = false
            haveWentButton.isHidden = false
            
            // MARK: - Check followed or not
            var urlFollowed = URLComponents(string: urlMain + "listVenueFollowed")!
            urlFollowed.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")")]
            let requestFollowed = URLRequest(url: urlFollowed.url!)
            requestData(urlRequest: requestFollowed) { (obj: MainEvent) in
                self.venueIdArray = []
                for venue in obj.response.venues ?? [] {
                    self.venueIdArray.append(venue.id!)
                }
            }
            
            // MARK: - Check Went or not
            var urlWent = URLComponents(string: urlMain + "listMyEvents")!
            urlWent.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")"),
                                  URLQueryItem(name: "status", value: "2")]
            let requestWent = URLRequest(url: urlWent.url!)
            requestData(urlRequest: requestWent) { (obj: MainEvent) in
                self.eventWentIdArray = []
                for event in obj.response.events ?? [] {
                    self.eventWentIdArray.append(event.id)
                }
            }
            
            // MARK: - Check Will go or not
            var urlWillGo = URLComponents(string: urlMain + "listMyEvents")!
            urlWillGo.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")"),
                                    URLQueryItem(name: "status", value: "1")]
            let requestWillGo = URLRequest(url: urlWillGo.url!)
            requestData(urlRequest: requestWillGo) { (obj: MainEvent) in
                    self.eventGoIdArray = []
                for event in obj.response.events ?? [] {
                        self.eventGoIdArray.append(event.id)
                }
            }
        }
        
        // MARK: - Show detail for the event
        let urlDetailEvents = URL(string: urlMain + "getDetailEvent?event_id=" + "\(String(eventId!))")!
        requestData(urlRequest: URLRequest(url: urlDetailEvents)) { (obj: MainEventDetail) in
            self.detail = obj.response.events.description_raw!
            self.long = Double(obj.response.events.venue.geo_long!)!
            self.lat = Double(obj.response.events.venue.geo_lat!)!
            DispatchQueue.main.async {
                self.titleEventLabel.text = self.eventTitle
                self.eventImage.cacheImage(urlImage: self.eventUrlImgString ?? "")
                self.dateLabel.text = obj.response.events.schedule_start_date
                self.detailEventLabel.text = obj.response.events.description_raw?.htmlToString
                self.linkEventButton.setTitle(obj.response.events.link, for: .normal)
                self.numberGoingLabel.text = String(obj.response.events.going_count!)
                self.numberWentLabel.text = String(obj.response.events.went_count!)
                self.venueEventLabel.text = obj.response.events.venue.name
                self.topVenueLabel.text = obj.response.events.venue.name
                self.contactEventLabel.text = obj.response.events.venue.contact_phone
                self.locationEventLabel.text = obj.response.events.venue.contact_address
                self.genreEventLabel.text = obj.response.events.category?.name
                
                // MARK: - Set status for the buttons
                if self.venueIdArray.contains(obj.response.events.venue.id!) {
                    self.followButton.setTitle("Followed", for: .normal)
                    self.followButton.backgroundColor = #colorLiteral(red: 0.0775340572, green: 0.2096011639, blue: 0.3246611953, alpha: 0.3)
                    self.followButton.setTitleColor(UIColor.red, for: .normal)
                } else {
                    self.followButton.setTitle("Follow this", for: .normal)
                    self.followButton.setTitleColor(UIColor.blue, for: .normal)
                }
                
                if self.eventGoIdArray.contains(obj.response.events.id) {
                    self.willGoButton.backgroundColor = #colorLiteral(red: 0.0775340572, green: 0.2096011639, blue: 0.3246611953, alpha: 0.3)
                    self.willGoButton.setTitleColor(UIColor.red, for: .normal)
                } else {
                    self.willGoButton.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.75)
                    self.willGoButton.setTitleColor(UIColor.blue, for: .normal)
                }
                
                if self.eventWentIdArray.contains(obj.response.events.id) {
                    self.haveWentButton.backgroundColor = #colorLiteral(red: 0.0775340572, green: 0.2096011639, blue: 0.3246611953, alpha: 0.3)
                    self.haveWentButton.setTitleColor(UIColor.red, for: .normal)
                } else {
                    self.haveWentButton.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.75)
                    self.haveWentButton.setTitleColor(UIColor.blue, for: .normal)
                }
                // MARK: - get coordinate for nearly events
                self.getEventNear(self.long, self.lat)
                
                self.spinActivity.stopAnimating()

            }
        }
    }
    
    // MARK: - Func reload count went and will go
    func reloadData() {
        let urlDetailEvents = URL(string: urlMain + "getDetailEvent?event_id=" + "\(String(eventId!))")!
        requestData(urlRequest: URLRequest(url: urlDetailEvents)) { (obj: MainEventDetail) in
            DispatchQueue.main.async {
                self.numberGoingLabel.text = String(obj.response.events.going_count!)
                self.numberWentLabel.text = String(obj.response.events.went_count!)
            }
        }
    }
    
    // MARK: - Func follow the venue
    func doFollowVenue() {
        let urlFollowVenue = URL(string: urlMain + "doFollowVenue")!
        let params = ["venue_id": "\(venue_id ?? "")", "token": "\(keyChain.get("token") ?? "")"]
        var request = URLRequest(url: urlFollowVenue)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        requestData(urlRequest: request) { (obj: Account) in
            DispatchQueue.main.async {
                if obj.status == 1 {
                    self.followButton.setTitle("Followed", for: .normal)
                    self.followButton.setTitleColor(UIColor.red, for: .normal)
                    self.followButton.backgroundColor = #colorLiteral(red: 0.0775340572, green: 0.2096011639, blue: 0.3246611953, alpha: 0.3)
                }
            }
        }
    }
    
    // MARK: - Do update event: will go or have went
    func doUpdateEvent() {
        let urlUpdateEvents = URL(string: urlMain + "doUpdateEvent")!
        let params = ["event_id": "\(eventId!)", "token": "\(keyChain.get("token") ?? "")", "status": "\(status)"]
        var request = URLRequest(url: urlUpdateEvents)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        requestData(urlRequest: request) { (obj: Account) in
            DispatchQueue.main.async {
                if obj.status == 1 {
                    if self.status == 1 {
                        self.willGoButton.backgroundColor = #colorLiteral(red: 0.0775340572, green: 0.2096011639, blue: 0.3246611953, alpha: 0.3)
                        self.haveWentButton.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.75)
                        self.willGoButton.setTitleColor(UIColor.red, for: .normal)
                        self.haveWentButton.setTitleColor(UIColor.blue, for: .normal)
                    } else if self.status == 2 {
                        self.haveWentButton.backgroundColor = #colorLiteral(red: 0.0775340572, green: 0.2096011639, blue: 0.3246611953, alpha: 0.3)
                        self.willGoButton.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.75)
                        self.haveWentButton.setTitleColor(UIColor.red, for: .normal)
                        self.willGoButton.setTitleColor(UIColor.blue, for: .normal)
                    } else {
                        self.haveWentButton.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.75)
                        self.willGoButton.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.75)
                        self.haveWentButton.setTitleColor(UIColor.blue, for: .normal)
                        self.willGoButton.setTitleColor(UIColor.blue, for: .normal)
                    }
                    self.reloadData()
                }
            }
        }
    }
    
    // MARK: - Do expand or collapse detail
    @IBAction func viewDetail(_ sender: Any) {
        minimize.toggle()
        if minimize {
            detailEventLabel.setContentCompressionResistancePriority(.init(749), for: .vertical)
        } else {
            detailEventLabel.setContentCompressionResistancePriority(.init(751), for: .vertical)
        }
    }
    
    // MARK: - Do back to list events
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Do open link
    @IBAction func openLinkButton(_ sender: Any) {
        guard let url = URL(string: linkEventButton.title(for: .normal)!) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - Do call contact
    @IBAction func getPhoneCall(_ sender: Any) {
        guard let number = URL(string: "tel://\(contactEventLabel.text ?? "")") else { return }
        UIApplication.shared.open(number)
    }
    
    // MARK: - Do follow venue
    @IBAction func followButton(_ sender: Any) {
        doFollowVenue()
    }
    
    // MARK: - Do click will go
    @IBAction func willGoButton(_ sender: Any) {
        if willGoButton.backgroundColor == #colorLiteral(red: 0.0775340572, green: 0.2096011639, blue: 0.3246611953, alpha: 0.3) {
            status = 0
        } else {
            status = 1
        }
            doUpdateEvent()
        
    }
    
    // MARK: - Do click have went
    @IBAction func wentButton(_ sender: Any) {
        if haveWentButton.backgroundColor == #colorLiteral(red: 0.0775340572, green: 0.2096011639, blue: 0.3246611953, alpha: 0.3) {
            status = 0
        } else {
            status = 2
        }
            doUpdateEvent()
    }
    
}

// MARK: - Collection nearly events
extension PopularDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let certifier = "DetailCollectionCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: certifier, for: indexPath) as! DetailCollectionCell
        if let urlImage = nearEvents[indexPath.row].photo {
        cell.eventImage.cacheImage(urlImage: urlImage)
        }
        cell.eventNameLabel.text = nearEvents[indexPath.row].name
        cell.eventDetailLabel.text = nearEvents[indexPath.row].description_raw?.htmlToString
        cell.eventDateLabel.text = nearEvents[indexPath.row].schedule_start_date
        cell.eventWillGoLabel.text = "- \(String(nearEvents[indexPath.row].going_count!)) will going"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let certifier = "PopularDetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier)
            as! PopularDetailVC
        if let urlString = nearEvents[indexPath.row].photo {
            vc.eventUrlImgString = urlString
        }
        vc.eventTitle = nearEvents[indexPath.row].name
        vc.eventId = nearEvents[indexPath.row].id
        vc.venue_id = String(nearEvents[indexPath.row].venue.id!)
        present(vc, animated: true, completion: nil)
        
    }
    
    // MARK: - Get nearly events
    func getEventNear(_ long: Double, _ lat: Double) {
        var urlNear = URLComponents(string: urlMain + "listNearlyEvents")!
        urlNear.queryItems = [URLQueryItem(name: "radius", value: "2000"), URLQueryItem(name: "longitue", value: "\(long)"), URLQueryItem(name: "latitude", value: "\(lat)")]
        let request = URLRequest(url: urlNear.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            self.nearEvents = obj.response.events ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

}
