//
//  SearchResultsTableViewController.swift
//  FuzzySearch
//
//  Created by Jeff Norton on 9/1/16.
//  Copyright © 2016 JCN. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    var sourceTableViewController: UITableViewController?
    var wordsArray: [String]?
    
    //==================================================
    // MARK: - General
    //==================================================

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //==================================================
    // MARK: - Table view data source
    //==================================================

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return wordsArray?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell", forIndexPath: indexPath)

        guard let words = wordsArray else { return UITableViewCell() }
        let word = words[indexPath.row]
        cell.textLabel?.text = word

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
