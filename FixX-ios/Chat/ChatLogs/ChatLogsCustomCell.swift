import UIKit

class ChatLogsCustomCell: UITableViewCell {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imageLbl: UILabel!
    
    var contact : Person?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func displayInfo(for contact: ContactInfo){
        FirestoreService.shared.fetchUserOnce(uid: contact.uid) { [weak self](person) in
            self?.contact = person
            if let image = person?.profilePicture?.second, !image.isEmpty{
                self?.userAvatar.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
                self?.imageLbl.isHidden = true
            }else{
                self?.userAvatar.isHidden = true
                self?.imageLbl.text = person?.name.first?.uppercased()
                self?.imageLbl.isHidden = false
            }
            
            self?.username.text = person?.name
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userAvatar.image = nil
        username.text = nil
        imageLbl.isHidden = true
    }
    
}
