//
//  PreviewViewController.swift
//  Not Hot Dog
//
//  Created by Paul Franco on 9/19/20.
//

import UIKit
import CoreML
import Vision

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var resultPhoto: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //photo.image = self.image
        
        detectPhoto(image: photo.image!)

    }
    
    func detectPhoto(image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            fatalError("could not convert image")
        }
        // Load Model
        guard let model = try? VNCoreMLModel(for: SqueezeNet().model) else {
            fatalError("Cant Load the ML Model")
        }
        let request = VNCoreMLRequest(model: model) { (VNRequest, error) in
            print(VNRequest.results?.first)
            guard let results = VNRequest.results as? [VNClassificationObservation], let firstResult = results.first else {
                fatalError("Unexpected results")
            }
            print(results.first?.confidence)
            print(results.first?.identifier)
            
            DispatchQueue.main.async {
                let imageName = firstResult.identifier.contains("hotdog") ? "ishotdog" : "nothotdog"
                
                self.resultPhoto.image = UIImage(named: imageName)
//                if firstResult.identifier.contains("hotdog") {
//                    print("HOTDOG")
//                    self.resultPhoto.image = UIImage(named: "ishotdog")
//                } else {
//                    print("NOT HOTDOG")
//                    self.resultPhoto.image = UIImage(named: "nothotdog")
//
//                }
                
            }
            
        }
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
