//
//  ChatWindowViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/27/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView

class ChatWindowViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

    let me = Sender(senderId: HomeScreenViewController.USER_OBJECT!.uid!,
                    displayName: HomeScreenViewController.USER_OBJECT!.name)
    
    var contact : Sender?
    
    var person : Person?
    var channel : String?
    
    private var observer : DatabaseReference?
    private var canSend = false
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = person?.name
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.delegate = self
        
        contact = Sender(senderId: person!.uid!, displayName: person!.name)
        
        if let ch = channel{
            FirestoreService.shared.fetchChatHistoryForChannelTest(channelName: ch) { [unowned self](msg) in
                if(!msg.text.isEmpty){
                    self.messages += [self.createChatMessage(from: msg)]
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            } chatRegHandler: { [weak self](reg) in
                self?.observer = reg
            }
            
        }else{
            FirestoreService.shared.fetchChatHistoryForInstanceTest(contact: person!.uid!) { [unowned self](msg) in
                if(!msg.text.isEmpty){
                    self.messages += [self.createChatMessage(from: msg)]
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
            } onCompletion: { [weak self](ch) in
                self?.channel = ch
                self?.canSend = true
            } chatRegHandler: { [weak self](reg) in
                self?.observer = reg
            }

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        observer?.removeAllObservers()
    }
    
    func currentSender() -> SenderType {
        return me
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if(message.sender.senderId == me.senderId){
            if let image = HomeScreenViewController.USER_OBJECT?.profilePicture?.second,
               !image.isEmpty{
                avatarView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
            }
        }else{
            if let image = person?.profilePicture?.second,
               !image.isEmpty{
                avatarView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "placeholder.png"))
            }
        }
    }
    
    private func createChatMessage(from msg:ChatMessage) -> Message{
        let interval = TimeInterval(msg.timestamp)
        if(msg.fromId == me.senderId){
            return Message(sender: me,
                           messageId: String(messages.endIndex + 1),
                           sentDate: Date(timeIntervalSince1970: TimeInterval(interval)),
                           kind: .text(msg.text))
        }else{
            return Message(sender: contact!,
                           messageId: String(messages.endIndex + 1),
                           sentDate: Date(timeIntervalSince1970: TimeInterval(interval)),
                           kind: .text(msg.text))
        }
    }
}

extension ChatWindowViewController: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if canSend{
            inputBar.inputTextView.text = ""
            FirestoreService.shared.sendChatMessageTest(channel: channel!, msg: ChatMessage(text: text, fromId: HomeScreenViewController.USER_OBJECT!.uid!, timestamp: Int64(Date().timeIntervalSince1970) * 1000))
        }
    }
}

struct Sender : SenderType{
    var senderId: String
    var displayName: String
}

struct Message : MessageType{
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
