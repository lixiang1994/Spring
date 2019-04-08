//
//  ViewController.swift
//  Demo
//
//  Created by 李响 on 2019/3/30.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var animationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func animationAction(_ sender: UITapGestureRecognizer) {
        animationView.spring
            .opacity(0.0)
            .scale(0.8, 0.8)
            .duration(2)
            .curve(.easeOutQuad)
            .animate()
    }
}
