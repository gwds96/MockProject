import UIKit
import MapKit
import CoreLocation

class NearVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var long: Double?
    var lat: Double?
    
    //    var popularConform: PopularVC?
    var nearEvents = [Events]()
    
    let locationManager = CLLocationManager()
    
    var urlNear = URLComponents(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listNearlyEvents")!
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    // MARK: Func cache image
    func takeImage(url: String) -> UIImage {
        var image: UIImage? = nil
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            image = imageFromCache
            return image!
        }
        
        if let urlImage = URL(string: url) {
            do {
                let dataImage = try Data(contentsOf: urlImage)
                let img = UIImage(data: dataImage)!
                imageCache.setObject(img, forKey: url as AnyObject)
                image = img
                return image!
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return UIImage.init(named: "Noimage")!
    }
    
    // MARK:
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthorizationStatus()
        getEventNear()
    }
    
    // MARK: Get nearly events
    func getEventNear() {
        urlNear.queryItems = [URLQueryItem(name: "radius", value: "2000"), URLQueryItem(name: "longitue", value: "\(long ?? 105.781000)"), URLQueryItem(name: "latitude", value: "\(lat ?? 21.017992)")]
        let request = URLRequest(url: urlNear.url!)
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
                DispatchQueue.main.async {
                    self.nearEvents = obj.response.events ?? []
                    self.collectionView.reloadData()
                }
            }
        }
        task.resume()
    }
}

extension NearVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            long = location.coordinate.longitude
            lat = location.coordinate.latitude
        }
    }
}

// MARK: Show nearly events
extension NearVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let certifier = "NearCollectionCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: certifier, for: indexPath) as! NearCollectionCell
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.nameEventLabel.text = nearEvents[indexPath.row].name
        cell.dateLabel.text = nearEvents[indexPath.row].schedule_start_date
        cell.timeLabel.text = nearEvents[indexPath.row].schedule_start_time
        if let urlImage = nearEvents[indexPath.row].photo {
            cell.eventImage.image = takeImage(url: urlImage)
        } else {
            cell.eventImage.image = #imageLiteral(resourceName: "Noimage")
        }
        return cell
    }
    
    
}
