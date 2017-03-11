//
//  ViewController.swift
//  Scanner
//
//  Created by Jan-Erik Revsbech on 11/03/17.
//  Copyright © 2017 Jan-Erik Revsbech. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onL1Toggle(sender: AnyObject) {
        print("Toggle");
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    

}

