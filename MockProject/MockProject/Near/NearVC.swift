import UIKit
import MapKit
import CoreLocation

class NearVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var long = Double()
    var lat = Double()
    
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
    
    // MARK: Display to your location
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            mapView.showsUserLocation = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: Button get your location
    @IBAction func myLocationButton(_ sender: Any) {
        centerMapOnLocation(location: CLLocation(latitude: lat, longitude: long))
        getEventNear()
    }
    
    // MARK: Get nearly events
    func getEventNear() {
        urlNear.queryItems = [URLQueryItem(name: "radius", value: "2000"), URLQueryItem(name: "longitue", value: "\(long)"), URLQueryItem(name: "latitude", value: "\(lat)")]
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
                self.nearEvents = obj.response.events ?? []
                for i in 0..<self.nearEvents.count {
                    let place = Artwork(title: self.nearEvents[i].name ?? "", locationName: self.nearEvents[i].venue.name ?? "", discipline: self.nearEvents[i].venue.description ?? "", coordinate: CLLocationCoordinate2D(latitude: Double(self.nearEvents[i].venue.geo_lat!)!, longitude: Double(self.nearEvents[i].venue.geo_long!)!))
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(place)
                    }
                }
                DispatchQueue.main.async {
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
extension NearVC: UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let certifier = "PopularDetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! PopularDetailVC
        vc.eventId = nearEvents[indexPath.row].id
        if let urlImage = nearEvents[indexPath.row].photo {
            vc.eventImg = takeImage(url: urlImage)
        } else {
            vc.eventImg = #imageLiteral(resourceName: "Noimage")
        }
        vc.eventTitle = nearEvents[indexPath.row].name
        vc.venue_id = String(nearEvents[indexPath.row].venue.id!)
        present(vc, animated: true, completion: nil)
    }
    
}
