import UIKit

class EventCells: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDateStartLabel: UILabel!
    @IBOutlet weak var eventDateEndLabel: UILabel!
    @IBOutlet weak var eventTimeStartLabel: UILabel!
    @IBOutlet weak var eventTimeEndLabel: UILabel!
    @IBOutlet weak var eventPlaceLabel: UILabel!
    
    @IBOutlet weak var willGoingLabel: UILabel!
    @IBOutlet weak var wentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
