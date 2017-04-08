//
//  MemeCollectionCell.swift
//  MemeMe
//
//  Created by Daniel Legler on 4/6/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

class MemeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!

    
    
    func configureCell(image: UIImage){
        memeImageView.image = image
    }

}
