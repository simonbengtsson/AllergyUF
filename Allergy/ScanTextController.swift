//
//  ViewController.swift
//  Allergy
//
//  Created by Tim Johansson on 2018-01-06.
//  Copyright © 2018 Tim Johansson. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController {

    @IBOutlet weak var wordMatchesLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let allergyListKey = "allergyListKey"
    var allergyList = [String]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tempallergyList = defaults.object(forKey: allergyListKey) {
            allergyList = tempallergyList as! [String]
        }
        textView.text = ""
        wordMatchesLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takeImage(_ sender: Any) {
        presentImagePicker()
    }
    
    // Tesseract Image Recognition
    func performImageRecognition(_ image: UIImage) {
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.engineMode = .tesseractCubeCombined
            tesseract.pageSegmentationMode = .auto
            tesseract.image = image.g8_blackAndWhite()
            tesseract.recognize()
            textView.text = tesseract.recognizedText
            presentUserFeedback(scannedText: tesseract.recognizedText)
        }
        activityIndicator.stopAnimating()
    }
    
    func presentUserFeedback(scannedText: String) {
        let result = getWordMatches(scannedText: scannedText)
        wordMatchesLabel.text = "MATCHES: "
        for word in result {
            print("CONTAINS WORD: \(word)")
            wordMatchesLabel.text?.append(" \(word)")
        }
    }
    
    func getWordMatches(scannedText: String) -> [String] {
        var wordMatches = [String]()

        for word in allergyList {
            let lowerCasedWord = word.lowercased()
            let lowercaseScannedText = scannedText.lowercased()
            if lowercaseScannedText.contains(lowerCasedWord) {
                wordMatches.append(lowerCasedWord)
            }
        }
        return wordMatches
    }
}

extension ViewController: UINavigationControllerDelegate {
}

extension ViewController: UIImagePickerControllerDelegate {
    func presentImagePicker() {
        let imagePickerActionSheet = UIAlertController(title: "Upload Image",
                                                       message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                                             style: .default) { (alert) -> Void in
                                                let imagePicker = UIImagePickerController()
                                                imagePicker.delegate = self
                                                imagePicker.sourceType = .camera
                                                self.present(imagePicker, animated: true)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        let libraryButton = UIAlertAction(title: "Choose Existing",
                                          style: .default) { (alert) -> Void in
                                            let imagePicker = UIImagePickerController()
                                            imagePicker.delegate = self
                                            imagePicker.sourceType = .photoLibrary
                                            self.present(imagePicker, animated: true)
        }
        imagePickerActionSheet.addAction(libraryButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        imagePickerActionSheet.addAction(cancelButton)
        
        present(imagePickerActionSheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let scaledImage = selectedPhoto.scaleImage(640) {
            
            activityIndicator.startAnimating()
            
            dismiss(animated: true, completion: {
                self.performImageRecognition(scaledImage)
            })
        }
    }
}

// MARK: - UIImage extension
extension UIImage {
    func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            let scaleFactor = size.height / size.width
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            let scaleFactor = size.width / size.height
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}

