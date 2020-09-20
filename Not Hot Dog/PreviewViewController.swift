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
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var resultPhoto: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
        
        detectPhoto(image: photo.image!)
        shareButton.layer.cornerRadius = 8
        shareButton.layer.borderWidth = 2
        shareButton.layer.borderColor = UIColor.white.cgColor
        shareButton.clipsToBounds = true
        
        view.showLoadingView(inView: view)
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
            
            guard let results = VNRequest.results as? [VNClassificationObservation], let firstResult = results.first else {
                fatalError("Unexpected results")
            }
            
            
            DispatchQueue.main.async {
                let imageName = firstResult.identifier.contains("hotdog") ? "ishotdog" : "nothotdog"
                
                self.resultPhoto.image = UIImage(named: imageName)
                self.view.hideLoadingView()
                self.cancelBtn.isHidden = false
                self.shareButton.isHidden = false
                
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

    @IBAction func shareButtonPressed(_ sender: UIButton) {
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

var loadingView = UIView()
var animateImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

extension UIView {
    func showLoadingView(inView v: UIView) {
        loadingView.frame = CGRect(x: 0, y: 0, width: v.frame.size.width, height: v.frame.size.height)
        
        loadingView.backgroundColor = UIColor.white
        loadingView.alpha = 0.9
        let nameArray: [String] = ["i0", "i1", "i2", "i3", "i4", "i5", "i6", "i7","i8", "i9", "i10", "i11","i12", "i13", "i14", "i15","i16", "i17", "i18", "i19","i20", "i21", "i22", "i23","i24", "i25", "i26", "i27", "i28", "i29", "i30"]
        
        var photos: [UIImage] = []
        
        for name in nameArray {
            photos.append(UIImage(named: name)!)
        }
        
        animateImg.animationImages = photos
        animateImg.center = loadingView.center
        animateImg.animationDuration = 0.8
        loadingView.addSubview(animateImg)
        animateImg.startAnimating()
        v.addSubview(loadingView)
    }
    
    func hideLoadingView() {
        loadingView.removeFromSuperview()
    }
}
