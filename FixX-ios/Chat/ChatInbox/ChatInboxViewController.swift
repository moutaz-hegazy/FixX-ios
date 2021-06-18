import UIKit

class ChatInboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userSwitcher = true
    var logsArray: Array<User> = []
    
    
    let cellSpacingHeigh: CGFloat = 5

    
    @IBOutlet weak var chatLogTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.chatLogTableView.delegate = self
        self.chatLogTableView.dataSource = self
        
        self.chatLogTableView.rowHeight = 100
        
        let rightChatLogCell = UINib(nibName: "RightMessageCustomCell", bundle: nil)
        self.chatLogTableView.register(rightChatLogCell, forCellReuseIdentifier: "right")
        let leftChatLogCell = UINib(nibName: "LeftMessageCustomCell", bundle: nil)
        self.chatLogTableView.register(leftChatLogCell, forCellReuseIdentifier: "left")
        
        sendButton.layer.cornerRadius = 20
        chatTextField.layer.cornerRadius = 20
    }
    
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        var userImage = UIImage(named: "square.png")
        var chatMessage = String.init(chatTextField.text!)
        var userObject = User.init(userAvatar: userImage!, userMessage: chatMessage)
        if (chatMessage != nil){
            userSwitcher = !userSwitcher
            logsArray.append(userObject)
            self.chatLogTableView.reloadData()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logsArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var R_cell = tableView.dequeueReusableCell(withIdentifier: "right", for: indexPath) as! RightMessageCustomCell
        var L_cell = tableView.dequeueReusableCell(withIdentifier: "left", for: indexPath) as! LeftMessageCustomCell

        if(userSwitcher){//chatlogcustomcell
            R_cell.R_Avatar.image = UIImage(named: "square.png")
            R_cell.R_Avatar.layer.masksToBounds = true
            R_cell.R_Avatar.layer.cornerRadius = R_cell.R_Avatar.bounds.width/2
            R_cell.R_Avatar.layer.borderWidth = 1
            R_cell.R_Avatar.layer.borderColor = UIColor.blue.cgColor
            R_cell.R_Message.text = chatTextField.text
            R_cell.R_Message.isEditable = false
            return R_cell
        }else{
            L_cell.L_Avatar.image = UIImage(named: "square.png")
            L_cell.L_Avatar.layer.masksToBounds = true
            L_cell.L_Avatar.layer.cornerRadius = L_cell.L_Avatar.bounds.width/2
            L_cell.L_Avatar.layer.borderWidth = 1
            L_cell.L_Avatar.layer.borderColor = UIColor.blue.cgColor
            L_cell.L_Message.text = chatTextField.text
            L_cell.L_Message.isEditable = false
            return L_cell
        }
    }
        
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeigh
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
