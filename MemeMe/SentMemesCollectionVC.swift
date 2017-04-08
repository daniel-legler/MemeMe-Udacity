//
//  SentMemesCollectionVC.swift
//  MemeMe
//
//  Created by Daniel Legler on 4/6/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCell"

class SentMemesCollectionVC: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MemeCollectionCell")
        
        adjustLayout(size: self.view.frame.size)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        adjustLayout(size: size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView?.reloadData()
    }

    func adjustLayout(size: CGSize){
        guard flowLayout != nil else { return }
        let space: CGFloat = 3.0
        let dimension: CGFloat = size.width >= size.height ? (size.width - (5 * space)) / 6.0 : (size.width - (2 * space)) / 3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ad.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let meme = ad.memes[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as?
            MemeCollectionCell {
            
            cell.configureCell(image: meme.memeImage)
            
            return cell
        
        } else {
            
            let cell = MemeCollectionCell()
            cell.configureCell(image: meme.memeImage)
            return cell
        }
        
    }
    
    // MARK: - Navigation
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CollectionDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CollectionDetail" {
            if let indexPath = collectionView?.indexPathsForSelectedItems?[0] {
                let meme = ad.memes[indexPath.row]
                let detailVC = segue.destination as! MemeDetailVC
                detailVC.meme = meme
                detailVC.hidesBottomBarWhenPushed = true
                
            }
        }
    }
    
}
