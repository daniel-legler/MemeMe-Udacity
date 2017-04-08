//
//  SentMemesTableVC2.swift
//  MemeMe
//
//  Created by Daniel Legler on 4/6/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

class SentMemesTableVC: UITableViewController {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ad.memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = ad.memes[indexPath.row]
        
        var cell = MemeTableCell()
        
        if let aCell = tableView.dequeueReusableCell(withIdentifier: "MemeCell") as? MemeTableCell {
            
            aCell.configureCell(image: meme.memeImage, top: meme.top, bottom: meme.bottom)
            
            cell = aCell
            
        } else {
            
            cell.configureCell(image: meme.memeImage, top: meme.top, bottom: meme.bottom)
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Detail", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let meme = ad.memes[indexPath.row]
                let detailVC = segue.destination as! MemeDetailVC
                detailVC.meme = meme
                detailVC.hidesBottomBarWhenPushed = true
            }
        }
    }
 
    // MARK: Swipe to Delete
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ad.memes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

}
