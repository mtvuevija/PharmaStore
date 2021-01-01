//
//  AddNewController.swift
//  PharmaStore
//
//  Created by Michael Vu
//  Copyright © 2020 Evija Digital. All rights reserved.
//

import UIKit
import Firebase
import Foundation
import AVFoundation
import GPUImage
import TesseractOCR
import MobileCoreServices

class AddNewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var cameraView: UIImagePickerController?
    var drugImage: UIImage?
    var showImage: UIImageView?
    var activityView: UIActivityIndicatorView?
    var stackView: UIStackView?
    var stackView2: UIStackView?
    var stackView3: UIStackView?
    //var testLabel: UILabel?
    var medName: UITextField?
    var medInstruction: UITextView?
    var imageText = ""
    let suffixes = ["cillin", "olol"]
    let times = ["hour", "daily", "day", "week"]
    
    //var medName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        cameraView = UIImagePickerController()
        cameraView!.delegate = self
        
        showImage = UIImageView()
        //showImage!.isHidden = true
        showImage!.layer.cornerRadius = 25
        showImage!.isHidden = true
        
        activityView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
        activityView!.translatesAutoresizingMaskIntoConstraints = false
        activityView!.color = .black
        activityView!.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        stackView = UIStackView()
        stackView!.translatesAutoresizingMaskIntoConstraints = false
        stackView!.axis = .vertical
        
        stackView2 = UIStackView()
        stackView2!.translatesAutoresizingMaskIntoConstraints = false
        stackView2!.axis = .vertical
        stackView2!.isHidden = true
        
        stackView3 = UIStackView()
        stackView3!.translatesAutoresizingMaskIntoConstraints = false
        stackView3!.axis = .vertical
        stackView3!.isHidden = true
        
        view.addSubview(stackView!)
        view.addSubview(stackView2!)
        view.addSubview(stackView3!)
        
        NSLayoutConstraint.activate([
            stackView!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            stackView!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            stackView!.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            stackView2!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            stackView2!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            stackView2!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView3!.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            stackView3!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            stackView3!.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
        
        let camImage = UIImageView(image: UIImage(named: "camera")!)
        camImage.contentMode = .scaleAspectFit
        camImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        camImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        let selectPhoto = UIButton()
        selectPhoto.translatesAutoresizingMaskIntoConstraints = false
        selectPhoto.setTitle("Pick Image From Library", for: .normal)
        selectPhoto.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        selectPhoto.titleLabel?.numberOfLines = 1
        selectPhoto.setTitleColor(.black, for: .normal)
        selectPhoto.addTarget(self, action: #selector(selectP), for: .touchUpInside)
        
        let selectCamera = UIButton()
        selectCamera.translatesAutoresizingMaskIntoConstraints = false
        selectCamera.setTitle("Take A Picture", for: .normal)
        selectCamera.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        selectCamera.titleLabel?.numberOfLines = 1
        selectCamera.setTitleColor(.black, for: .normal)
        selectCamera.addTarget(self, action: #selector(selectC), for: .touchUpInside)
        
        stackView!.addArrangedSubview(camImage)
        stackView!.addArrangedSubview(selectPhoto)
        stackView!.addArrangedSubview(selectCamera)
        //stackView!.addArrangedSubview(activityView!)
        
        NSLayoutConstraint.activate([
            selectCamera.leadingAnchor.constraint(equalTo: stackView!.leadingAnchor),
            selectPhoto.leadingAnchor.constraint(equalTo: stackView!.leadingAnchor)
        ])
        
        stackView!.setCustomSpacing(20, after: camImage)
        stackView!.setCustomSpacing(20, after: selectPhoto)
        stackView!.setCustomSpacing(20, after: selectCamera)
        
        let medicine = UILabel()
        medicine.text = "Medicine Name"
        medicine.font = UIFont.boldSystemFont(ofSize: 16)
        medicine.textColor = .black
        
        medName = UITextField()
        medName!.translatesAutoresizingMaskIntoConstraints = false
        medName!.attributedPlaceholder = NSAttributedString(string: "Medincine Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        medName!.font = UIFont.boldSystemFont(ofSize: 20)
        medName!.textColor = .black
        medName!.layer.cornerRadius = 15
        medName!.layer.borderWidth = 5
        medName!.heightAnchor.constraint(equalToConstant: 60).isActive = true
        medName!.textAlignment = .center
        medName!.keyboardType = UIKeyboardType.numberPad
        
        let instruction = UILabel()
        instruction.text = "Drug Dosage"
        instruction.font = UIFont.boldSystemFont(ofSize: 16)
        instruction.textColor = .black
        
        medInstruction = UITextView()
        medInstruction!.translatesAutoresizingMaskIntoConstraints = false
        //medInstruction!.attributedPlaceholder = NSAttributedString(string: "Drug Dosage", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        medInstruction!.font = UIFont.boldSystemFont(ofSize: 14)
        medInstruction!.textColor = .black
        medInstruction!.layer.cornerRadius = 15
        medInstruction!.layer.borderWidth = 5
        medInstruction!.heightAnchor.constraint(equalToConstant: 60).isActive = true
        medInstruction!.textAlignment = .center
        medInstruction!.keyboardType = UIKeyboardType.numberPad
        
        let addConfirm = UIButton()
        addConfirm.translatesAutoresizingMaskIntoConstraints = false
        addConfirm.setTitle("Add Medicine", for: .normal)
        addConfirm.backgroundColor = UIColor(red: 121 / 255, green: 83 / 255, blue: 179 / 255, alpha: 1)
        addConfirm.addTarget(self, action: #selector(addMed), for: .touchUpInside)
        addConfirm.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        addConfirm.layer.cornerRadius = 25
        addConfirm.setTitleColor(.white, for: .normal)
        addConfirm.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addConfirm.titleLabel?.numberOfLines = 1
        
        stackView2!.addArrangedSubview(activityView!)
        stackView3!.addArrangedSubview(showImage!)
        stackView3!.addArrangedSubview(medicine)
        stackView3!.addArrangedSubview(medName!)
        stackView3!.addArrangedSubview(instruction)
        stackView3!.addArrangedSubview(medInstruction!)
        
        stackView3!.addArrangedSubview(addConfirm)
        
        stackView3!.setCustomSpacing(20, after: showImage!)
        stackView3!.setCustomSpacing(10, after: medicine)
        stackView3!.setCustomSpacing(20, after: medName!)
        stackView3!.setCustomSpacing(10, after: instruction)
        stackView3!.setCustomSpacing(20, after: medInstruction!)
    }
    
    @objc func selectP() {
        print("select photo")
        self.cameraView!.sourceType = .savedPhotosAlbum
        self.cameraView!.allowsEditing = false
        present(self.cameraView!, animated: true)
    }
    
    @objc func selectC() {
        print("select camera")
        self.cameraView!.sourceType = .camera
        self.cameraView!.allowsEditing = true
        present(self.cameraView!, animated: true)
    }
    
    @objc func addMed() {
        let alert = UIAlertController(title: "Not Done", message: "We weren't able to auto-fill so you must fill it in yourself.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            @unknown default:
                print("unknown")
            }
        }))
        if medName!.text?.count == 0 || medInstruction!.text?.count == 0 {
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser?.uid
            db.collection("users").document(uid!).updateData(["MedName": FieldValue.arrayUnion([self.medName!.text!]), "MedDosage": FieldValue.arrayUnion([self.medInstruction!.text!])]) { (err) in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                self.dismiss(animated: true)
            }
        }
        print("send")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Bruh")
        var newImage: UIImage

        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        }
        else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        }
        else {
            return
        }
        activityView!.startAnimating()
        self.drugImage = newImage
        self.showImage!.image = newImage
        self.showImage!.contentMode = .scaleAspectFit
        self.showImage!.heightAnchor.constraint(equalToConstant: 150).isActive = true
        self.showImage!.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.stackView2?.isHidden = false
        self.stackView?.isHidden = true
        dismiss(animated: true) {
            self.performImageRecognition(newImage)
            self.showImage!.isHidden = false
            //self.testLabel!.isHidden = false
        }
    }
    
    func performImageRecognition(_ image: UIImage) {
        let scaledImage = image.scaledImage(1000) ?? image
        let preprocessedImage = scaledImage.preprocessedImage() ?? scaledImage
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.engineMode = .tesseractCubeCombined
            tesseract.pageSegmentationMode = .auto
          
            tesseract.image = preprocessedImage
            tesseract.recognize()
            imageText = tesseract.recognizedText!
            for suf in suffixes {
                var index = (imageText.lowercased().index(of: suf)?.utf16Offset(in: imageText)) ?? -1
                if index != -1 {
                    index += suf.count
                    for i in (0..<index).reversed() {
                        if imageText[i] == " " {
                            self.medName!.text = String(imageText[i+1..<index])
                            break
                        }
                    }
                    break
                }
            }
            let index = (imageText.lowercased().index(of: "take")?.utf16Offset(in: imageText)) ?? -1
            var index2 = -1
            var num = 0
            for time in times {
                index2 = (imageText.lowercased().index(of: time)?.utf16Offset(in: imageText)) ?? -1
                if index2 != -1 {
                    num = time.count
                    break
                }
            }
            if index != -1 && index2 != -1 {
                self.medInstruction!.text = String(imageText[index..<index2+num])
            }
            self.stackView3!.isHidden = false
            self.stackView2!.isHidden = true
            self.activityView!.stopAnimating()
            print(imageText)
            print("done")
        }
    }
}

extension UIImage {
    func scaledImage(_ maxDimension: CGFloat) -> UIImage? {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        if size.width > size.height {
            scaledSize.height = size.height / size.width * scaledSize.width
        }
        else {
            scaledSize.width = size.width / size.height * scaledSize.height
        }
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    func preprocessedImage() -> UIImage? {
        let stillImageFilter = GPUImageAdaptiveThresholdFilter()
        stillImageFilter.blurRadiusInPixels = 15.0
        let filteredImage = stillImageFilter.image(byFilteringImage: self)
        return filteredImage
    }
}

extension String {
  subscript(_ i: Int) -> String {
    let idx1 = index(startIndex, offsetBy: i)
    let idx2 = index(idx1, offsetBy: 1)
    return String(self[idx1..<idx2])
  }

  subscript (r: Range<Int>) -> String {
    let start = index(startIndex, offsetBy: r.lowerBound)
    let end = index(startIndex, offsetBy: r.upperBound)
    return String(self[start ..< end])
  }

  subscript (r: CountableClosedRange<Int>) -> String {
    let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
    let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
    return String(self[startIndex...endIndex])
  }
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        ranges(of: string, options: options).map(\.lowerBound)
    }
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...]
                .range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
