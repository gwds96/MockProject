import UIKit

class BrowseVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let urlCategory = URL(string: urlMain + "listCategories")!
    
    var categories = [Categories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(#imageLiteral(resourceName: "background news"), for: .default)
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.3
        requestData(urlRequest: URLRequest(url: urlCategory)) { (obj: MainCategory) in
            self.categories = obj.response.categories
            DispatchQueue.main.async {
                self.animateTable()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateTable()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let certifier = "SearchVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! SearchVC
        vc.modalTransitionStyle = .crossDissolve
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
        vc.categoryTitle = self.categories[indexPath.row].name
        vc.categoryId = self.categories[indexPath.row].id
        present(vc, animated: true, completion: nil)
    }
    
    func animateTable() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 0.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
        
    }
}
