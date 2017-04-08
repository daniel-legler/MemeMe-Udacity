//
//  MemeTableCell.swift
//  MemeMe
//
//  Created by Daniel Legler on 4/6/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

class MemeTableCell: UITableViewCell {

    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    
    func configureCell(image: UIImage, top: String, bottom: String) {
        memeImageView.image = image
        topLabel.text = top
        bottomLabel.text = bottom
    }


}
