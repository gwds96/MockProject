import UIKit
import Foundation

protocol PresentDelegate: class {
    func present(_ events: Events)
}

class PopularVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinActivity: UIActivityIndicatorView!
    
    var urlEvents = URLComponents(string: urlMain + "listPopularEvents")!
    var pageIndex = 1
    
    weak var presentDelegate: PresentDelegate?
    
    var events = [Events]()
    
    // MARK: - Instance for coredata
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var eventsCoreData = [EventData]()
    var haveConection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        let nib = UINib.init(nibName: "EventCells", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "EventCells")
        
        spinActivity.startAnimating()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.3
        
        urlEvents.queryItems = [URLQueryItem(name: "pageIndex", value: "\(pageIndex)"), URLQueryItem(name: "pageSize", value: "10")]
        let request = URLRequest(url: urlEvents.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            self.events = obj.response.events ?? []
            
            self.deleteEntity()
            for event in self.events {
                let newEventData = EventData(context: self.context)
                newEventData.name = event.name
                newEventData.schedule_end_date = event.schedule_end_date
                newEventData.schedule_end_time = event.schedule_end_time
                newEventData.schedule_start_date = event.schedule_start_date
                newEventData.schedule_start_time = event.schedule_start_time
                newEventData.going_count = String(event.going_count!)
                newEventData.went_count = String(event.went_count!)
                newEventData.venue = event.venue.name
                if let photoUrl = URL(string: event.photo ?? "") {
                let data = try? Data(contentsOf: photoUrl)
                    newEventData.photo = data
                }
                DispatchQueue.main.async {
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            }
            
            self.haveConection = true
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.spinActivity.stopAnimating()
                
            }
        }
    }
    
    // MARK: - fetch data from memory
    func fetchData() {
        do {
            eventsCoreData = try context.fetch(EventData.fetchRequest())
            haveConection = false
            DispatchQueue.main.async {
                self.spinActivity.stopAnimating()
                self.tableView.reloadData()
            }
        } catch {
            print("Have some error is \(error)")
        }

    }
    
    // MARK: - Delete Data's entity
    func deleteEntity() {
        do {
            for entity in eventsCoreData {
                context.delete(entity)
            }
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            }
    }
    
        // MARK: - load more data
    func loadMoreData() {
        urlEvents.queryItems = [URLQueryItem(name: "pageIndex", value: "\(pageIndex)"), URLQueryItem(name: "pageSize", value: "10")]
        let request = URLRequest(url: urlEvents.url!)
        requestData(urlRequest: request) { (obj: MainEvent) in
            self.haveConection = true
            self.events += obj.response.events ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
}

extension PopularVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if haveConection {
        return events.count
        } else {
            return eventsCoreData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "EventCells"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! EventCells
        
        cell.selectionStyle = .none
        
        cell.backgroundColor = nil
        if haveConection {
        if let urlString = events[indexPath.row].photo {
            cell.eventImage.cacheImage(urlImage: urlString)
        }
        cell.eventTitleLabel.text = events[indexPath.row].name
        cell.eventDateStartLabel.text = "🗓 \(events[indexPath.row].schedule_start_date ?? "")"
        cell.eventDateEndLabel.text = "To  \(events[indexPath.row].schedule_end_date ?? "")"
        cell.eventTimeStartLabel.text = "⏰ \(events[indexPath.row].schedule_start_time ?? "")"
        cell.eventTimeEndLabel.text = "To  \(events[indexPath.row].schedule_end_time ?? "")"
        cell.eventPlaceLabel.text = "📍 \(events[indexPath.row].venue.name ?? "")"
        cell.willGoingLabel.text = String(events[indexPath.row].going_count ?? 0)
        cell.wentLabel.text = String(events[indexPath.row].went_count ?? 0)
        } else {
            cell.eventTitleLabel.text = eventsCoreData[indexPath.row].name
            cell.eventDateStartLabel.text = "🗓 \(eventsCoreData[indexPath.row].schedule_start_date ?? "")"
            cell.eventDateEndLabel.text = "To  \(eventsCoreData[indexPath.row].schedule_end_date ?? "")"
            cell.eventTimeStartLabel.text = "⏰ \(eventsCoreData[indexPath.row].schedule_start_time ?? "")"
            cell.eventTimeEndLabel.text = "To  \(eventsCoreData[indexPath.row].schedule_end_time ?? "")"
            cell.eventPlaceLabel.text = "📍 \(eventsCoreData[indexPath.row].venue ?? "")"
            cell.willGoingLabel.text = eventsCoreData[indexPath.row].going_count
            cell.wentLabel.text = eventsCoreData[indexPath.row].went_count
            if let data = eventsCoreData[indexPath.row].photo {
                cell.eventImage.image = UIImage(data: data)
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if haveConection {
        presentDelegate?.present(events[indexPath.row])
        } else {
            let alert = UIAlertController(title: "No conection", message: "Please conect internet for using", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}
