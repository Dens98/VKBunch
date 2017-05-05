//
//  SearchViewController.swift
//  VKBunch
//
//  Created by Denis Shustin on 03.05.17.
//  Copyright © 2017 Denis Shustin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var idPersonA: UITextField!
    @IBOutlet weak var idPersonB: UITextField!
    @IBOutlet weak var RapSlow: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func getIdPersonA () -> Int {
        var id = Int(String(describing: idPersonA))
        return id!
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
    }
    
}
