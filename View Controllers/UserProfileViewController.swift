//
//  UserProfileViewController.swift
//  PeopleMon
//
//  Created by Christopher Stanley on 11/9/16.
//  Copyright © 2016 Christopher Stanley. All rights reserved.
//

import UIKit
import MBProgressHUD

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UITextField!
    
    var gestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = UserStore.shared.user {
            fullNameLabel.text = user.fullName
            
            if Utils.imageFromString(imageString: user.avatarBase64) != nil {
                avatar.image = Utils.imageFromString(imageString: user.avatarBase64)
            } else {
                avatar.image = #imageLiteral(resourceName: "default-user-icon-profile")
            }
            // Do any additional setup after loading the view.
        }
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewImage))
        avatar.addGestureRecognizer(gestureRecognizer)
    }
    
    func viewImage() {
        if let image = avatar.image {
            UserStore.shared.selectedImage = image
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageNavController")
            present(viewController, animated: true, completion: nil)
        }
    }
    
    fileprivate func showPicker(_ type: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func cameraClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Picture", message: "Choose a picture type", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.showPicker(.camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.showPicker(.photoLibrary)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: AnyObject) {
        let name = userName.text
        
        let resizedImage = Utils.resizeImage(image: avatar.image!, maxSize: Constants.avatarSize)
        let imageString = Utils.stringFromImage(image: resizedImage)
        
        let user = Account(fullName: name!, avatarBase64: imageString)
        MBProgressHUD.showAdded(to: view, animated: true)
        WebServices.shared.postObject(user) { (updatedUser, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error {
                self.present(Utils.createAlert(title: "Error", message: error), animated: true, completion: nil)
            } else {
                UserStore.shared.user?.fullName = name
                UserStore.shared.user?.avatarBase64 = imageString
                self.dismiss(animated: true, completion: nil)

            }
        }
    }
    }
    



extension UserProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            let maxSize: CGFloat = 512
            let scale = maxSize / image.size.width
            let newHeight = image.size.height * scale
            
            UIGraphicsBeginImageContext(CGSize(width: maxSize, height: newHeight))
            image.draw(in: CGRect(x: 0, y: 0, width: maxSize, height: newHeight))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            avatar.image = resizedImage
            
            avatar.isHidden = false
            if gestureRecognizer != nil {
                avatar.removeGestureRecognizer(gestureRecognizer)
            }
            addGestureRecognizer()
            
        }
    }
}
