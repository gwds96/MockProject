import UIKit
import Foundation

// MARK: - convert HTML to String
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

// MARK: - cache Image
let nsCacheImage = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func cacheImage(urlImage: String) {
        image = #imageLiteral(resourceName: "Noimage")
        if let imageFromCache = nsCacheImage.object(forKey: urlImage as AnyObject) {
            image = imageFromCache as? UIImage
        }
            else {
            guard let url = URL(string: urlImage) else { return }
            do {
            let dataImage = try Data(contentsOf: url)
            let img = UIImage(data: dataImage)!
            nsCacheImage.setObject(img, forKey: urlImage as AnyObject)
            image = img
            } catch let error {
                print(error)
            }
        }
    }
}
