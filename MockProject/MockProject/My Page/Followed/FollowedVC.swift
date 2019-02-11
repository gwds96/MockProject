import UIKit
import MapKit

class FollowedVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var closeMapButton: UIButton!
    
    let keyChain = KeychainSwift()
    var urlFollowed = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listVenueFollowed")!
    var venue = [Venue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isHidden = true
        closeMapButton.isHidden = true
        loadData()
    }
    
    // MARK: Load data from server for tableView
    func loadData() {
        urlFollowed.queryItems = [URLQueryItem(name: "token", value: "\(keyChain.get("token") ?? "")")]
        let request = URLRequest(url: urlFollowed.url!)
        let task = URLSession.shared.dataTask(with: request) {(result, response, error) in
            guard
                let data = result,
                error == nil else {
                    return
            }
            do {
                guard let obj = try? JSONDecoder().decode(MainEvent.self, from: data) else {
                    return
                }
                self.venue = obj.response.venues ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func closeMapButton(_ sender: Any) {
        mapView.isHidden = true
        closeMapButton.isHidden = true
    }
}



// MARK: TableView for list followed event places ViewController
extension FollowedVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "FollowedCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! FollowedCell
        cell.nameLabel.text = venue[indexPath.row].name
        cell.localLabel.text = "\(venue[indexPath.row].description ?? ""), \(venue[indexPath.row].geo_area!)"
        cell.phoneLabel.text = venue[indexPath.row].contact_phone
        cell.addressLabel.text = venue[indexPath.row].contact_address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        centerMapOnLocation(location: CLLocation(latitude: Double(self.venue[indexPath.row].geo_lat!)!, longitude: Double(self.venue[indexPath.row].geo_long!)!))
        mapView.isHidden = false
        closeMapButton.isHidden = false
        for i in 0..<self.venue.count {
            let place = Artwork(title: self.venue[i].name ?? "", locationName: self.venue[i].name ?? "", discipline: self.venue[i].description ?? "", coordinate: CLLocationCoordinate2D(latitude: Double(self.venue[i].geo_lat!)!, longitude: Double(self.venue[i].geo_long!)!))
            self.mapView.addAnnotation(place)
        }
    }
}
