import UIKit

protocol ColorForButtonDelegate: class {
    func chooseColor(_ index: Int)
}

class MyPagePageView: UIPageViewController {
    
    // MARK: - ViewController will be present
    let subViewController: [UIViewController] = {
        return [UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AccountVC") as! AccountVC,
                UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WentVC") as! WentVC,
                UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WillGoVC") as! WillGoVC,
                UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FollowedVC") as! FollowedVC]
    }()
    var currentIndex = 0
    
    weak var colorDelegate: ColorForButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        setViewControllers([subViewController[currentIndex]], direction: .forward, animated: true, completion: nil)
        colorDelegate?.chooseColor(currentIndex)
    }
    
}

// MARK: - Set up for PageViewController
extension MyPagePageView: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewController.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        currentIndex = subViewController.index(of: viewController) ?? 0
        colorDelegate?.chooseColor(currentIndex)
        if currentIndex == 0 {
            return nil
        }
        return subViewController[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        currentIndex = subViewController.index(of: viewController) ?? subViewController.count
        colorDelegate?.chooseColor(currentIndex)
        if currentIndex == subViewController.count - 1 {
            return nil
        }
        return subViewController[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed == true {
            let preIndex = subViewController.index(of: previousViewControllers[0])
            currentIndex += (currentIndex > preIndex!) ? 1 : -1
        }
    }
    
    // MARK: - Move Page by Button
    func moveToPage(_ index: Int) {
        if index < currentIndex {
            currentIndex = index
            colorDelegate?.chooseColor(currentIndex)
            setViewControllers([subViewController[index]], direction: .reverse, animated: true, completion: nil)
        } else if index > currentIndex {
            currentIndex = index
            colorDelegate?.chooseColor(currentIndex)
            setViewControllers([subViewController[index]], direction: .forward, animated: true, completion: nil)
        }
    }

}
