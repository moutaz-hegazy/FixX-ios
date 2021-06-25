import UIKit

class ChatLogsTableViewController: UITableViewController {
    
    let cellSpacingHeight: CGFloat = 10
    var contacts = [ContactInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chat Logs"
        
        FirestoreService.shared.fetchChatUsersTest { [weak self](conts) in
            self?.contacts = conts
            self?.tableView.reloadData()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 80
        
        let chatLogCell = UINib(nibName: "ChatLogsCustomCell", bundle: nil)
        self.tableView.register(chatLogCell, forCellReuseIdentifier: "chatlogscustomcell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatlogscustomcell", for: indexPath) as! ChatLogsCustomCell
        
        cell.displayInfo(for: contacts[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let logVC = UIStoryboard(name: "ChatInbox", bundle: nil).instantiateViewController(identifier: "ChatInboxVC") as? ChatInboxViewController{
            if let contact = (tableView.cellForRow(at: indexPath) as? ChatLogsCustomCell)?.contact{
                logVC.contact = contact
                logVC.channel = contacts[indexPath.row].channel
                navigationController?.pushViewController(logVC, animated: true)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    

}
