import UIKit

class BrowseVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let urlCategory = URL(string: urlMain + "listCategories")!
    
    var categories = [Categories]()
    
    // MARK: - Instance for core data
    var categoriesData = [CategoriesData]()
    var haveConection = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        navigationBar.setBackgroundImage(#imageLiteral(resourceName: "background news"), for: .default)
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "background news"))
        tableView.backgroundView?.alpha = 0.3
        requestData(urlRequest: URLRequest(url: urlCategory)) { (obj: MainCategory) in
            self.haveConection = true
            self.categories = obj.response.categories
            
            self.deleteEntity()
            for item in self.categories {
                let categoryData = CategoriesData(context: self.context)
                categoryData.item = item.name
                DispatchQueue.main.async {
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    
    // MARK: - fetch Data from memory
    func fetchData() {
        do {
            categoriesData = try context.fetch(CategoriesData.fetchRequest())
            DispatchQueue.main.async {
                self.animateTable()
            }
        } catch {
            print("some error is \(error)")
        }
    }
    
    // MARK: - delete Entity
    func deleteEntity() {
        do {
            for category in categoriesData {
                context.delete(category)
            }
            DispatchQueue.main.async {
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
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
        if haveConection {
            return categories.count
        } else {
            return categoriesData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let certifier = "BrowseCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: certifier) as! BrowseCell
        cell.backgroundColor = nil
        if haveConection {
            cell.categoryLabel.text = categories[indexPath.row].name ?? ""
        } else {
            cell.categoryLabel.text = categoriesData[indexPath.row].item
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if haveConection {
            let certifier = "EventsByCategoryVC"
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! EventsByCategoryVC
            vc.categoryTitle = self.categories[indexPath.row].name
            vc.categoryId = self.categories[indexPath.row].id
            present(vc, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "No conection", message: "Please make sure that you have conection", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
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
