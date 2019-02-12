import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var container: UIView!
    var page: HomePageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsButton.setTitleColor(UIColor.blue, for: .normal)
        newsButton.backgroundColor = #colorLiteral(red: 0.7305393777, green: 1, blue: 0.9652253821, alpha: 0.4)
        popularButton.setTitleColor(UIColor.black, for: .normal)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cellIdentifier = "HomePageView"
        if let vc = segue.destination as? HomePageView,
            segue.identifier == cellIdentifier {
            self.page = vc
            vc.delegateB = self
        }
    }
    
    // MARK: Click news
    @IBAction func newsButton(_ sender: UIButton) {
        page.moveToPage(0)
    }
    
    // MARK: Click popular
    @IBAction func popularButton(_ sender: UIButton) {
        page.moveToPage(1)
        
    }
}

// MARK: Set color for buttons use Delegate
extension HomeVC: ButtonDelegate {
    func colorOfButton(_ number: Int) {
        let color0: UIColor = (number == 0) ? .blue : .black
        let backgroundColor0: UIColor = (number == 0) ? #colorLiteral(red: 0.7305393777, green: 1, blue: 0.9652253821, alpha: 0.4) : .white
        newsButton.setTitleColor(color0, for: .normal)
        newsButton.backgroundColor = backgroundColor0
        let color1: UIColor = (number == 1) ? .blue : .black
        let backgroundColor1: UIColor = (number == 1) ? #colorLiteral(red: 1, green: 0.8572274131, blue: 0.9413912327, alpha: 0.4) : .white
        popularButton.setTitleColor(color1, for: .normal)
        popularButton.backgroundColor = backgroundColor1
    }
    
}
