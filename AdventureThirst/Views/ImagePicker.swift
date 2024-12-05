//
//  ImagePicker.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 26.11.2024.
//

import UIKit

class ImagePicker: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var imagePickerContoller: UIImagePickerController?
    var completion: ((UIImage) -> ())?
    
    func showImagePicker(in viewController: UIViewController, completion: ((UIImage)->())?) {
        self.completion = completion
        imagePickerContoller = UIImagePickerController()
        imagePickerContoller!.delegate = self
        viewController.present(imagePickerContoller!, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.completion?(image)
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
 }

