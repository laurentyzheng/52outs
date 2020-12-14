//
//  File.swift
//  52outs
//
//  Created by Laurent Zheng on 2020-10-21.
//  Copyright © 2020 Laurent Zheng. All rights reserved.
//

import UIKit

class imagePicker: NSObject{
    
    static let shared = imagePicker()
    
    fileprivate var currentVC: UIViewController!
        
        //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    
    func photoLibrary()
        {
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self;
                myPickerController.sourceType = .photoLibrary
                currentVC.present(myPickerController, animated: true, completion: nil)
            }
        }
    
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Use Default Blackscreen", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            Settings.defaults.set(true, forKey: "defaultBlackScreen")
            Settings().statusChange()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
}

extension imagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:  [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        Settings.defaults.set(false, forKey: "defaultBlackScreen")
            if let editedImage = info[.editedImage] as? UIImage {
                selectedImage = editedImage
                imageHandler().storeImage(selectedImage!)
                picker.dismiss(animated: true, completion: nil)
            } else if let originalImage = info[.originalImage] as? UIImage {
                selectedImage = originalImage
                imageHandler().storeImage(selectedImage!)
                picker.dismiss(animated: true, completion: nil)
            } else {
                print("something went wrong")
            }
    }
    
}

