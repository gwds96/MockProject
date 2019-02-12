import UIKit

class MainTabBar: UITabBarController {
    
    static let instance = MainTabBar()
    
    let keyChain = KeychainSwift()
    
    // MARK: Tabs for Tabbar
    var subViewControllers: [String: UIViewController] = {
        return ["homeVC":
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC,
                "nearVC": UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NearVC") as! NearVC,
                "categoriesVC": UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BrowseVC") as! BrowseVC,
            "loginVC": UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC") as! LogInVC,
            "mypageVC": UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyPageFatherVC") as! MyPageFatherVC
        ]
    }()
    
    lazy var homeVC = subViewControllers["homeVC"]
    lazy var nearVC = subViewControllers["nearVC"]
    lazy var categoriesVC = subViewControllers["categoriesVC"]
    lazy var loginVC = subViewControllers["loginVC"]
    lazy var mypage = subViewControllers["mypageVC"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = #colorLiteral(red: 0.5838350723, green: 0.9869053812, blue: 1, alpha: 0.8413955479)
        
        homeVC!.tabBarItem.title = "Home"
        nearVC!.tabBarItem.title = "Near"
        categoriesVC!.tabBarItem.title = "Browse"
        loginVC!.tabBarItem.title = "Login"
        mypage?.tabBarItem.title = "My Page"
        
        homeVC!.tabBarItem.image = #imageLiteral(resourceName: "icons8-home-50 (1)")
        nearVC!.tabBarItem.image = #imageLiteral(resourceName: "icons8-near-me-50 (1)")
        categoriesVC!.tabBarItem.image = #imageLiteral(resourceName: "icons8-search-property-50 (1)")
        loginVC!.tabBarItem.image = #imageLiteral(resourceName: "icons8-password-1-50 (1)")
        mypage?.tabBarItem.image = #imageLiteral(resourceName: "icons8-male-user-50 (1)")
        
        updateStateTabbar()
    }
    
    func updateStateTabbar() {
        if keyChain.get("token") != nil {
            viewControllers = [homeVC!, nearVC!, categoriesVC!, mypage!]
        } else {
            viewControllers = [homeVC!, nearVC!, categoriesVC!, loginVC!]
        }
    }
}
