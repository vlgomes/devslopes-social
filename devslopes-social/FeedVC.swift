//
//  FeedVC.swift
//  devslopes-social
//
//  Created by Vasco Gomes on 03/03/2017.
//  Copyright © 2017 Vasco Gomes. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var captionField: FancyField!
    @IBOutlet var imageAdd: CircleView!
    @IBOutlet weak var tableView: UITableView!

    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        getPosts()
    }
    
    func getPosts(){
        DataService.dataService.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = [] 
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot{
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post =  Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString){
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            
            return cell
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info [UIImagePickerControllerEditedImage] as? UIImage{
            imageAdd.image = image
            imageSelected = true
        } else {
            print("VASCO: A valid image wasn't selected")
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func postToFirebase(imgUrl: String){
        
        let post : Dictionary<String, AnyObject> = [
            "caption": captionField.text! as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        //we are creating a uid on the fly
        let firebasePost = DataService.dataService.REF_POSTS.childByAutoId()
        
        firebasePost.setValue(post)
        
        //reseting everything
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named:"add-image")
        
        tableView.reloadData()
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        
        print ("VASCO : ID removed from keychain \(keychainResult)")
        
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("VASCO: Caption must be entered!")
            let alertController = UIAlertController(title: "Alert", message:
                "Caption must be entered!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
             self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        guard let img = imageAdd.image, imageSelected == true else {
            print("VASCO: A image must be selected!")
            let alertController = UIAlertController(title: "Alert", message:
                "A image must be selected!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
             self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            
            let imgUid = NSUUID().uuidString
            let metadata =  FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.dataService.REF_POST_IMAGES.child(imgUid).put(imgData,metadata: metadata) { (metadata,error) in
                if error != nil {
                    print ("VASCO: Unable to upload image to Firebase Storage")
                }
                else {
                    print ("VASCO: Successfully uploaded image to Firebase storage")
                    let downloadURL =  metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL{
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
    }
}
