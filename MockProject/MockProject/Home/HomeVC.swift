import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var newsButton: UIButton!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var colorLabel = UILabel()
    
    var newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsVC") as! NewsVC
    
    var popularVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PopularVC") as! PopularVC
    
    lazy var subViews: [UIViewController] = {
        return [newVC, popularVC]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        popularVC.presentDelegate = self
        scrollView.contentSize = CGSize(width: self.view.bounds.width * 2, height: self.scrollView.frame.height)
        setupViewForScrollView([subViews[0].view, subViews[1].view])
        
        colorLabel.frame = CGRect(x: 0, y: newsButton.bounds.height + 20, width: view.bounds.width/2, height: 5)
        colorLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        view.addSubview(colorLabel)
        newsButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        popularButton.setTitleColor(UIColor.gray, for: .normal)
    }
    
    func setupViewForScrollView(_ subViews: [UIView]) {
        for i in 0..<subViews.count {
            subViews[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: self.scrollView.frame.height)
            self.scrollView.addSubview(subViews[i])
        }
    }
    
    // MARK: - Click news
    @IBAction func newsButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.newsButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            self.popularButton.setTitleColor(UIColor.gray, for: .normal)
            self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.scrollView.frame.height), animated: true)
        }
    }
    
    // MARK: - Click popular
    @IBAction func popularButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.popularButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            self.newsButton.setTitleColor(UIColor.gray, for: .normal)
            self.scrollView.scrollRectToVisible(CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.scrollView.frame.height), animated: true)
        }
    }
    
}

extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        colorLabel.frame = CGRect(x: scrollView.contentOffset.x/2, y: newsButton.bounds.height + 20, width: view.bounds.width/2, height: 5)
        if scrollView.contentOffset.x > view.bounds.width/2 {
            self.popularButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            self.newsButton.setTitleColor(UIColor.gray, for: .normal)
        } else {
            self.newsButton.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
            self.popularButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
}

extension HomeVC: PresentDelegate {
    func present(_ events: Events) {
        let certifier = "PopularDetailVC"
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: certifier)
            as! PopularDetailVC
        if let urlString = events.photo {
            vc.eventUrlImgString = urlString
        }
        vc.eventTitle = events.name
        vc.eventId = events.id
        vc.venue_id = String(events.venue.id!)
        present(vc, animated: true, completion: nil)
    }
    
}
