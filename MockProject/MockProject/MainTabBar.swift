import UIKit

class MainTabBar: UITabBarController {
    
    static let instance = MainTabBar()
    
    let keyChain = KeychainSwift()
    
    var subViewControllers: [String: UIViewController] = {
        return ["homeVC":
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC,
                "nearVC": UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NearVC") as! NearVC,
                "categoriesVC": UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowseVC") as! BrowseVC,
            "loginVC": UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as! LogInVC,
            "accountVC": UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
        ]
    }()
    
    lazy var homeVC = subViewControllers["homeVC"]
    lazy var nearVC = subViewControllers["nearVC"]
    lazy var categoriesVC = subViewControllers["categoriesVC"]
    lazy var loginVC = subViewControllers["loginVC"]
    lazy var accountVC = subViewControllers["accountVC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeVC!.tabBarItem.title = "Home"
        nearVC!.tabBarItem.title = "Near"
        categoriesVC!.tabBarItem.title = "Browse"
        loginVC!.tabBarItem.title = "Login"
        accountVC!.tabBarItem.title = "My Page"
        
        homeVC!.tabBarItem.image = #imageLiteral(resourceName: "icons8-home-50 (1)")
        nearVC!.tabBarItem.image = #imageLiteral(resourceName: "icons8-near-me-50 (1)")
        categoriesVC!.tabBarItem.image = #imageLiteral(resourceName: "icons8-search-property-50 (1)")
        loginVC!.tabBarItem.image = #imageLiteral(resourceName: "icons8-password-1-50 (1)")
        accountVC!.tabBarItem.image = #imageLiteral(resourceName: "icons8-male-user-50 (1)")
        
        updateStateTabbar()
    }
    
    func updateStateTabbar() {
        if keyChain.get("token") != nil {
            viewControllers = [homeVC!, nearVC!, categoriesVC!, accountVC!]
        } else {
            viewControllers = [homeVC!, nearVC!, categoriesVC!, loginVC!]
        }
    }
}
