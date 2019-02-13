import UIKit

class PopularDetailVC: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var titleEventLabel: UILabel!
    @IBOutlet weak var detailEventLabel: UILabel!
    @IBOutlet weak var linkEventLabel: UILabel!
    @IBOutlet weak var numberGoingLabel: UILabel!
    @IBOutlet weak var numberWentLabel: UILabel!
    @IBOutlet weak var constentView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var locationEventLabel: UILabel!
    @IBOutlet weak var contactEventLabel: UILabel!
    @IBOutlet weak var addressEventLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var willGoButton: UIButton!
    @IBOutlet weak var haveWentButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let keyChain = KeychainSwift()
    
    var eventId: Int?
    var eventTitle: String?
    var eventUrlImgString: String?
    var venue_id: String?
    var status = 0
    
    var venueIdArray: [Int] = []
    var eventGoIdArray: [Int] = []
    var eventWentIdArray: [Int] = []
    
    override func viewDidLoad() {
        backgroundImage.cacheImage(urlImage: eventUrlImgString ?? "")
        backgroundImage.alpha = 0.1
        mainScrollView.backgroundColor = nil
        constentView.backgroundColor = nil
        
        cancelButton.setTitleColor(UIColor.red, for: .normal)
        cancelButton.layer.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.3857020548)
        cancelButton.layer.cornerRadius = 5
        followButton.layer.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.3857020548)
        followButton.layer.cornerRadius = 5
        willGoButton.layer.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.3857020548)
        willGoButton.layer.cornerRadius = 5
        haveWentButton.layer.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.3857020548)
        haveWentButton.layer.cornerRadius = 5
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    // MARK: - Func for Show and Load Data
    func loadData() {
        // MARK: Check for hiding or showing buttons
        if keyChain.get("token") == nil {
            followButton.isHidden = true
            willGoButton.isHidden = true
            haveWentButton.isHidden = true
            cancelButton.isHidden = true
        } else {
            followButton.isHidden = false
            willGoButton.isHidden = false
            haveWentButton.isHidden = false
            cancelButton.isHidden = false
            
            // MARK: - Check followed or not
            var urlFollowed = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listVenueFollowed")!
            urlFollowed.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")")]
            let requestFollowed = URLRequest(url: urlFollowed.url!)
            requestData(urlRequest: requestFollowed) { (obj: MainEvent) in
                for venue in obj.response.venues ?? [] {
                    self.venueIdArray.append(venue.id!)
                }
            }
            
            // MARK: - Check Went or not
            var urlWent = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listMyEvents")!
            urlWent.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")"), URLQueryItem(name: "status", value: "2")]
            let requestWent = URLRequest(url: urlWent.url!)
            requestData(urlRequest: requestWent) { (obj: MainEvent) in
                self.eventWentIdArray = []
                for event in obj.response.events ?? [] {
                    self.eventWentIdArray.append(event.id)
                }
            }
            
            // MARK: - Check Will go or not
            var urlWillGo = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listMyEvents")!
            urlWillGo.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")"), URLQueryItem(name: "status", value: "1")]
            let requestWillGo = URLRequest(url: urlWillGo.url!)
            requestData(urlRequest: requestWillGo) { (obj: MainEvent) in
                self.eventGoIdArray = []
                for event in obj.response.events ?? [] {
                    self.eventGoIdArray.append(event.id)
                }
            }
        }
        
        // MARK: - Show detail for the event
        let urlDetailEvents = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/getDetailEvent?event_id=" + "\(String(eventId!))")!
        requestData(urlRequest: URLRequest(url: urlDetailEvents)) { (obj: MainEventDetail) in
            DispatchQueue.main.async {
                self.titleEventLabel.text = self.eventTitle
                self.eventImage.cacheImage(urlImage: self.eventUrlImgString ?? "")
                self.detailEventLabel.text = obj.response.events.description_raw?.htmlToString
                self.linkEventLabel.text = obj.response.events.link
                self.numberGoingLabel.text = String(obj.response.events.going_count!)
                self.numberWentLabel.text = String(obj.response.events.went_count!)
                self.locationEventLabel.text = obj.response.events.venue.name
                self.contactEventLabel.text = obj.response.events.venue.contact_phone
                self.addressEventLabel.text = obj.response.events.venue.contact_address
                
                // MARK: - Set status for the buttons
                if self.venueIdArray.contains(obj.response.events.venue.id!) {
                    self.followButton.setTitle("Followed", for: .normal)
                    self.followButton.backgroundColor = #colorLiteral(red: 0.0775340572, green: 0.2096011639, blue: 0.3246611953, alpha: 0.3)
                    self.followButton.setTitleColor(UIColor.red, for: .normal)
                } else {
                    self.followButton.setTitle("Follow", for: .normal)
                    self.followButton.setTitleColor(UIColor.blue, for: .normal)
                }
                
                if self.eventGoIdArray.contains(obj.response.events.id) {
                    self.willGoButton.backgroundColor = #colorLiteral(red: 0.0775340572, green: 0.2096011639, blue: 0.3246611953, alpha: 0.3)
                    self.willGoButton.setTitleColor(UIColor.red, for: .normal)
                } else {
                    self.willGoButton.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.3857020548)
                    self.willGoButton.setTitleColor(UIColor.blue, for: .normal)
                }
                
                if self.eventWentIdArray.contains(obj.response.events.id) {
                    self.haveWentButton.backgroundColor = #colorLiteral(red: 0.0775340572, green: 0.2096011639, blue: 0.3246611953, alpha: 0.3)
                    self.haveWentButton.setTitleColor(UIColor.red, for: .normal)
                } else {
                    self.haveWentButton.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.3857020548)
                    self.haveWentButton.setTitleColor(UIColor.blue, for: .normal)
                }
            }
        }
    }
    
    // MARK: - Func reload count went and will go
    func reloadData() {
        let urlDetailEvents = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/getDetailEvent?event_id=" + "\(String(eventId!))")!
        requestData(urlRequest: URLRequest(url: urlDetailEvents)) { (obj: MainEventDetail) in
            DispatchQueue.main.async {
                self.numberGoingLabel.text = String(obj.response.events.going_count!)
                self.numberWentLabel.text = String(obj.response.events.went_count!)
            }
        }
    }
    
    // MARK: - Func follow the venue
    func doFollowVenue() {
        let urlFollowVenue = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/doFollowVenue")!
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
        let urlUpdateEvents = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/doUpdateEvent")!
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
                        self.haveWentButton.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.3857020548)
                        self.willGoButton.setTitleColor(UIColor.red, for: .normal)
                        self.haveWentButton.setTitleColor(UIColor.blue, for: .normal)
                    } else if self.status == 2 {
                        self.haveWentButton.backgroundColor = #colorLiteral(red: 0.0775340572, green: 0.2096011639, blue: 0.3246611953, alpha: 0.3)
                        self.willGoButton.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.3857020548)
                        self.haveWentButton.setTitleColor(UIColor.red, for: .normal)
                        self.willGoButton.setTitleColor(UIColor.blue, for: .normal)
                    } else {
                        self.haveWentButton.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.3857020548)
                        self.willGoButton.backgroundColor = #colorLiteral(red: 0.8133895397, green: 0.9217470288, blue: 0.9522448182, alpha: 0.3857020548)
                        self.haveWentButton.setTitleColor(UIColor.blue, for: .normal)
                        self.willGoButton.setTitleColor(UIColor.blue, for: .normal)
                    }
                    self.reloadData()
                }
            }
        }
    }
    
    // MARK: - Do back to list events
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Do follow venue
    @IBAction func followButton(_ sender: Any) {
        doFollowVenue()
    }
    
    // MARK: - Do click will go
    @IBAction func willGoButton(_ sender: Any) {
            status = 1
            doUpdateEvent()
        
    }
    
    // MARK: - Do click have went
    @IBAction func wentButton(_ sender: Any) {
            status = 2
            doUpdateEvent()
    }
    
    // MARK: - Do click cancel
    @IBAction func cancelButton(_ sender: Any) {
        status = 0
        doUpdateEvent()
    }
}
