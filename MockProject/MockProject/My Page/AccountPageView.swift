import UIKit

class AccountPageView: UIPageViewController {
    
    var currentIndex = 0
    lazy var subViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as! LogInVC,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([subViewControllers[currentIndex]], direction: .forward, animated: true, completion: nil)
    }
    
    func moveToPage(_ index: Int) {
        self.currentIndex = index
    }
}
