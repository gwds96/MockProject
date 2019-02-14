import UIKit

class HomeVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var container: UIView!
    var page: HomePageView!
    
    var colorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorLabel.frame = CGRect(x: 0, y: newsButton.bounds.height + 20, width: view.bounds.width/2, height: 5)
        colorLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        view.addSubview(colorLabel)
        newsButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        popularButton.setTitleColor(UIColor.gray, for: .normal)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cellIdentifier = "HomePageView"
        if let vc = segue.destination as? HomePageView,
            segue.identifier == cellIdentifier {
            self.page = vc
            vc.delegateB = self
        }
    }
    
    // MARK: - Click news
    @IBAction func newsButton(_ sender: UIButton) {
        page.moveToPage(0)
    }
    
    // MARK: - Click popular
    @IBAction func popularButton(_ sender: UIButton) {
        page.moveToPage(1)
        
    }
    
}

// MARK: - Set color for buttons use Delegate
extension HomeVC: ButtonDelegate {
    func colorOfButton(_ number: Int) {
        let color0: UIColor = (number == 0) ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : .gray
        let color1: UIColor = (number == 1) ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : .gray
        UIView.animate(withDuration: 0.3) {
        self.newsButton.setTitleColor(color0, for: .normal)
        self.popularButton.setTitleColor(color1, for: .normal)
            if number == 0 {
                self.colorLabel.center.x = self.newsButton.bounds.width/2
            } else {
                self.colorLabel.center.x = self.newsButton.bounds.width * 1.5
            }
        }
    }
    
}
