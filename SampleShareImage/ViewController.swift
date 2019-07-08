//
//  ViewController.swift
//  SampleShareImage
//
//  Created by beams001 on 2019/07/08.
//  Copyright © 2019 bms. All rights reserved.
//

import UIKit
import AssetsLibrary

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func addImage(_ sender: Any) {
        pickImageFromLibrary()
    }
    
    @IBAction func shareImage(_ sender: Any) {
        guard let image = imageView.image else {
            print("対象の画像が見つかりません")
            return
        }
        
        let data = image.pngData()
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("tmp.png")
        
        do {
            try data?.write(to: url!)
        } catch {
            // nop
        }
        
        let controller = UIDocumentInteractionController.init(url: url!)
        if !(controller.presentOpenInMenu(from: view.frame, in: view, animated: true)) {
            print("ファイルに対応するアプリがありません")
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}
