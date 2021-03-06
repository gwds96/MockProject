import UIKit
import MapKit

class FollowedVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var closeMapButton: UIButton!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    let keyChain = KeychainSwift()
    var urlFollowed = URLComponents(string: urlMain + "listVenueFollowed")!
    var venue = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinActivity.startAnimating()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background local"))
        tableView.backgroundView?.alpha = 0.2
        
        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        closeMapButton.isHidden = true
        mapView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: view.bounds.height)
    }
    
    // MARK: - Load data from server for tableView
    func loadData() {
        urlFollowed.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")")]
        let request = URLRequest(url: urlFollowed.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            self.venue = obj.response.venues ?? []
                DispatchQueue.main.async {
                    self.spinActivity.stopAnimating()
                    self.tableView.reloadData()
                }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func closeMapButton(_ sender: Any) {
        UIView.animate(withDuration: 0.6) {
            self.closeMapButton.isHidden = true
            self.tableView.alpha = 1
            self.mapView.center.y += self.view.bounds.height
        }
    }
}

// MARK: - TableView for list followed event places ViewController
extension FollowedVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venue.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "FollowedCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! FollowedCell
        cell.backgroundColor = nil
        cell.nameLabel.text = venue[indexPath.row].name
        cell.localLabel.text = "\(venue[indexPath.row].description ?? ""), \(venue[indexPath.row].geo_area!)"
        cell.phoneLabel.text = venue[indexPath.row].contact_phone
        cell.addressLabel.text = venue[indexPath.row].contact_address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        centerMapOnLocation(location: CLLocation(latitude: Double(self.venue[indexPath.row].geo_lat!)!, longitude: Double(self.venue[indexPath.row].geo_long!)!))
       
        UIView.animate(withDuration: 0.6) {
            self.closeMapButton.isHidden = false
            self.tableView.alpha = 0
            self.mapView.center.y -= self.view.bounds.height
        }
        
        for i in 0..<self.venue.count {
            let place = Artwork(title: self.venue[i].name ?? "", locationName: self.venue[i].geo_area ?? "", discipline: self.venue[i].description ?? "", coordinate: CLLocationCoordinate2D(latitude: Double(self.venue[i].geo_lat!)!, longitude: Double(self.venue[i].geo_long!)!))
            self.mapView.addAnnotation(place)
        }
    }
}
