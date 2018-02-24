import Foundation
import Firebase
import FirebaseDatabase


class FireBaseModel {
    let ref:DatabaseReference?
    
    init(){
        
        ref = Database.database().reference()
    }
}

