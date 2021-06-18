import Foundation
import UIKit

class User{
    var userAvatar: UIImage?
    var userMessage: String?
    
    init(){
        userAvatar = nil
        userMessage = nil
    }
    
    init(userAvatar: UIImage, userMessage: String){
        self.userAvatar = userAvatar
        self.userMessage = userMessage
    }
}

