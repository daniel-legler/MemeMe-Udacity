//
//  MemeDetailVC.swift
//  MemeMe
//
//  Created by Daniel Legler on 4/7/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {

    var meme: Meme?
    
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let meme = self.meme {
            if let image = meme.memeImage {
                memeImage.image = image
            }
        }
    }
}
