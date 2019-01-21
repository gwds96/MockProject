import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var container: UIView!
    var page: HomePageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsButton.setTitleColor(UIColor.blue, for: .normal)
        popularButton.setTitleColor(UIColor.black, for: .normal)
        newsButton.layer.borderWidth = 0.5
        newsButton.layer.borderColor = UIColor.blue.cgColor
        popularButton.layer.borderWidth = 0.5
        popularButton.layer.borderColor = UIColor.blue.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cellIdentifier = "HomePageView"
        if let vc = segue.destination as? HomePageView,
            segue.identifier == cellIdentifier {
            self.page = vc
            vc.delegateB = self
        }
    }
    
    @IBAction func newsButton(_ sender: UIButton) {
        page.moveToPage(0)
    }
    
    @IBAction func popularButton(_ sender: UIButton) {
        page.moveToPage(1)
        
    }
}

extension HomeVC: ButtonDelegate {
    
    func colorOfButton(_ number: Int) {
        let color0: UIColor = (number == 0) ? .blue : .black
        newsButton.setTitleColor(color0, for: .normal)
        let color1: UIColor = (number == 1) ? .blue : .black
        popularButton.setTitleColor(color1, for: .normal)
    }
    
}
