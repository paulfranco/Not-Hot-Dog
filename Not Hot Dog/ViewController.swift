//
//  ViewController.swift
//  Not Hot Dog
//
//  Created by Paul Franco on 9/19/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func cameraButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showPhotoSegue", sender: nil)
    }
}

