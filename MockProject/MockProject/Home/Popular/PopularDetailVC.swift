import UIKit

class PopularDetailVC: UIViewController {

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
    
    var eventId: Int?
    var eventTitle: String?
    var eventImg: UIImage?
    
    var contentRect = CGRect.zero
    
    override func viewDidLoad() {
        let urlDetailEvents = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/getDetailEvent?event_id=" + "\(String(eventId!))")!
        let task = URLSession.shared.dataTask(with: urlDetailEvents) {(result, response, error) in
            guard
                let data = result,
                error == nil else {
                    return
            }
            do {
                guard let obj = try? JSONDecoder().decode(MainEventDetail.self, from: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.titleEventLabel.text = self.eventTitle
                    self.eventImage.image = self.eventImg
                    self.detailEventLabel.text = obj.response.events.description_raw?.htmlToString
                    self.linkEventLabel.text = obj.response.events.link
                    self.numberGoingLabel.text = String(obj.response.events.going_count!)
                    self.numberWentLabel.text = String(obj.response.events.went_count!)
                    self.locationEventLabel.text = obj.response.events.venue.name
                    self.contactEventLabel.text = obj.response.events.venue.contact_phone
                    self.addressEventLabel.text = obj.response.events.venue.contact_address
                }
            }
        }
        task.resume()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
