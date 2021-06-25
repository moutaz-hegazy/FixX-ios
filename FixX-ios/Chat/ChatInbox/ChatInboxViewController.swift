import UIKit
import Firebase

class ChatInboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userSwitcher = false
    var logsArray: Array<ChatMessage> = []
    
    
    let cellSpacingHeigh: CGFloat = 5
    
    var contact : Person?
    var channel : String?

    private var observer : DatabaseReference!
    
    @IBOutlet weak var chatLogTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = contact?.name
        sendButton.isUserInteractionEnabled = false
        if let ch = channel{
            FirestoreService.shared.fetchChatHistoryForChannelTest(channelName: ch) { [weak self](msg) in
                if(!msg.text.isEmpty){
                    self?.logsArray += [msg]
                    self?.chatLogTableView.reloadData()
                    if let count = self?.logsArray.count, count > 5{
                        self?.chatLogTableView.scrollToRow(at: [0,count-1], at: .bottom, animated: false)
                    }
                }
            } chatRegHandler: { [weak self](reg) in
                self?.observer = reg
            }
            
        }else{
            FirestoreService.shared.fetchChatHistoryForInstanceTest(contact: contact!.uid!) { [weak self](msg) in
                if(!msg.text.isEmpty){
                    self?.logsArray += [msg]
                    self?.chatLogTableView.reloadData()
                    
                    if let count = self?.logsArray.count, count > 5{
                        self?.chatLogTableView.scrollToRow(at: [0,count-1], at: .bottom, animated: false)
                    }
                }
            } onCompletion: { [weak self](ch) in
                self?.channel = ch
                self?.sendButton.isUserInteractionEnabled = true
            } chatRegHandler: { [weak self](reg) in
                self?.observer = reg
            }

        }
        
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
        print("Clicked")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logsArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = logsArray[indexPath.row]
        if(message.fromId == HomeScreenViewController.USER_OBJECT?.uid){
            let R_cell = tableView.dequeueReusableCell(withIdentifier: "right", for: indexPath) as! RightMessageCustomCell
            
            R_cell.displayMessage(message)
            
            return R_cell
        }else{
            let L_cell = tableView.dequeueReusableCell(withIdentifier: "left", for: indexPath) as! LeftMessageCustomCell
            
            L_cell.displayMessage(message, imgStr: contact?.profilePicture?.second, name: contact?.name ?? "none")
            
            return L_cell
        }
    }
        
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeigh
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        observer.removeAllObservers()
        print("removed")
    }
}
