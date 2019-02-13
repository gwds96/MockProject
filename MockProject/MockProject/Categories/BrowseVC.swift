import UIKit

class BrowseVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let urlCategory = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/listCategories")!
    
    var categories = [Categories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background category"))
        tableView.backgroundView?.alpha = 0.6
        requestData(urlRequest: URLRequest(url: urlCategory)) { (obj: MainCategory) in
            DispatchQueue.main.async {
                self.categories = obj.response.categories
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let certifier = "SearchVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! SearchVC
        present(vc, animated: true, completion: nil)
    }
}

extension BrowseVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "BrowseCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! BrowseCell
        cell.backgroundColor = nil
        cell.categoryLabel.text = categories[indexPath.row].name ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let certifier = "EventsByCategoryVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! EventsByCategoryVC
        vc.categoryId = self.categories[indexPath.row].id
        present(vc, animated: true, completion: nil)
    }
}
