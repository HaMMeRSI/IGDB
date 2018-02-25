import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class FireBaseModel {
    let ref:DatabaseReference?
    var storageRef = Storage.storage().reference();
    
    init(){
        ref = Database.database().reference()
    }
    
    func saveImageToFirebase(image:UIImage, name:(String),
                             callback:@escaping (String?)->Void){
        let filesRef = storageRef.child("images/"+name+".jpg")
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            filesRef.putData(data, metadata: nil) { metadata, error in
                if (error != nil) {
                    callback(nil)
                } else {
                    let downloadURL = metadata!.downloadURL()
                    callback(downloadURL?.absoluteString)
                }
            }
        }
    }
    
    func downloadImage(name:String, callback:@escaping (UIImage?)->Void) {
        let islandRef = storageRef.child("images/"+name+".jpg")
        //let httpsReference = storage.reference(forURL: "https://firebasestorage.googleapis.com/b/bucket/o/images%20stars.jpg")
        islandRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if (error != nil) {
                callback(nil)
            } else {

                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
}

