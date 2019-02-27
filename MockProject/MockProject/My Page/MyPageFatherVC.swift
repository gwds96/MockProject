import UIKit

class MyPageFatherVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var wentButton: UIButton!
    @IBOutlet weak var willGoButton: UIButton!
    @IBOutlet weak var followedButton: UIButton!

    var colorLabel = UILabel()
    
    var accountSubview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
    var wentSubview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WentVC") as! WentVC
    var willGoingSubview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WillGoVC") as! WillGoVC
    var followedSubview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FollowedVC") as! FollowedVC
    
    // MARK: - ViewController will be present
    lazy var subViews: [UIViewController] = [accountSubview, wentSubview, willGoingSubview, followedSubview]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wentSubview.presentDelegate = self
        willGoingSubview.presentDelegate = self
        
        setupViewForScrollView([subViews[0].view, subViews[1].view, subViews[2].view, subViews[3].view])
        
        colorLabel.frame = CGRect(x: 0, y: accountButton.bounds.height + 30, width: view.bounds.width/4, height: 2)
        colorLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        view.addSubview(colorLabel)
        accountButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        wentButton.setTitleColor(UIColor.gray, for: .normal)
        willGoButton.setTitleColor(UIColor.gray, for: .normal)
        followedButton.setTitleColor(UIColor.gray, for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wentSubview.loadData()
        willGoingSubview.loadData()
        followedSubview.loadData()
        
    }
    func setupViewForScrollView(_ subViews: [UIView]) {
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(subViews.count), height: self.scrollView.frame.height)
        for i in 0..<subViews.count {
            subViews[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: self.scrollView.frame.height)
            self.scrollView.addSubview(subViews[i])
        }
    }
    
    @IBAction func accountButton(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.accountButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            self.wentButton.setTitleColor(UIColor.gray, for: .normal)
            self.willGoButton.setTitleColor(UIColor.gray, for: .normal)
            self.followedButton.setTitleColor(UIColor.gray, for: .normal)
            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.scrollView.frame.height), animated: true)
        }
    }
    
    @IBAction func wentButton(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.accountButton.setTitleColor(UIColor.gray, for: .normal)
            self.wentButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            self.willGoButton.setTitleColor(UIColor.gray, for: .normal)
            self.followedButton.setTitleColor(UIColor.gray, for: .normal)
            self.scrollView.scrollRectToVisible(CGRect(x: self.view.bounds.width, y: 0, width: self.view.frame.width, height: self.scrollView.frame.height), animated: true)
        }
    }
    
    @IBAction func willGoButton(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.accountButton.setTitleColor(UIColor.gray, for: .normal)
            self.wentButton.setTitleColor(UIColor.gray, for: .normal)
            self.willGoButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            self.followedButton.setTitleColor(UIColor.gray, for: .normal)
            self.scrollView.scrollRectToVisible(CGRect(x: self.view.bounds.width * 2, y: 0, width: self.view.frame.width, height: self.scrollView.frame.height), animated: true)
        }
    }
    
    @IBAction func followedButton(_ sender: Any) {
        UIView.animate(withDuration: 0.1) {
            self.accountButton.setTitleColor(UIColor.gray, for: .normal)
            self.wentButton.setTitleColor(UIColor.gray, for: .normal)
            self.willGoButton.setTitleColor(UIColor.gray, for: .normal)
            self.followedButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            self.scrollView.scrollRectToVisible(CGRect(x: self.view.bounds.width * 3, y: 0, width: self.view.frame.width, height: self.scrollView.frame.height), animated: true)
        }
    }
    
}

// MARK: - Color for Button
extension MyPageFatherVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        colorLabel.frame = CGRect(x: scrollView.contentOffset.x/4, y: accountButton.bounds.height + 30, width: view.bounds.width/4, height: 2)
        if scrollView.contentOffset.x < view.bounds.width/2 {
            self.accountButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            self.wentButton.setTitleColor(UIColor.gray, for: .normal)
            self.willGoButton.setTitleColor(UIColor.gray, for: .normal)
            self.followedButton.setTitleColor(UIColor.gray, for: .normal)
        } else if scrollView.contentOffset.x >= view.bounds.width/2
        && scrollView.contentOffset.x < view.bounds.width * 1.5 {
            self.accountButton.setTitleColor(UIColor.gray, for: .normal)
            self.wentButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            self.willGoButton.setTitleColor(UIColor.gray, for: .normal)
            self.followedButton.setTitleColor(UIColor.gray, for: .normal)
        } else if scrollView.contentOffset.x >= view.bounds.width * 1.5
            && scrollView.contentOffset.x < view.bounds.width * 2.5 {
            self.accountButton.setTitleColor(UIColor.gray, for: .normal)
            self.wentButton.setTitleColor(UIColor.gray, for: .normal)
            self.willGoButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            self.followedButton.setTitleColor(UIColor.gray, for: .normal)
        } else {
            self.accountButton.setTitleColor(UIColor.gray, for: .normal)
            self.wentButton.setTitleColor(UIColor.gray, for: .normal)
            self.willGoButton.setTitleColor(UIColor.gray, for: .normal)
            self.followedButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        }
    }
}

extension MyPageFatherVC: PresentDelegate {
    func present(_ events: Events) {
        let certifier = "PopularDetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier) as! PopularDetailVC
        vc.eventId = events.id
        if let urlImage = events.photo {
            vc.eventUrlImgString = urlImage
        }
        vc.eventTitle = events.name
        vc.venue_id = String(events.venue.id!)
        present(vc, animated: true, completion: nil)
    }
}
