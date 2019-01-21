import UIKit

class BrowseVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let urlCategory = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listCategories")!
    
    var categories = [Categories]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let task = URLSession.shared.dataTask(with: urlCategory) {(data, response, error) in
            guard
            let data = data,
                error == nil else {
                    return
            }
            do {
                guard let obj = try? JSONDecoder().decode(MainCategory.self, from: data) else {
                    return
                }
                DispatchQueue.main.async {
                    self.categories = obj.response.categories
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
}

extension BrowseVC: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "BrowseCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier, for: indexPath) as! BrowseCell
        cell.categoryLabel.text = categories[indexPath.row].name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}
