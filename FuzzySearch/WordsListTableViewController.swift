//
//  WordsListTableViewController.swift
//  FuzzySearch
//
//  Created by Jeff Norton on 9/1/16.
//  Copyright © 2016 JCN. All rights reserved.
//

import UIKit

extension String {
    
    func containsSearchTerm(term: String) -> Bool {
        
        return self.lowercaseString.containsString(term)
    }
    
    func containsFuzzySearchTerm(term: String) -> Bool {
        
        return true
    }
}

class WordsListTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    var searchController: UISearchController?
    var fuzzySearch = FuzzySearch()
    let fuzzinessQuality = 0.8
    var wordsArray: [String]?
    
    //==================================================
    // MARK: - General
    //==================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchController()

        self.wordsArray = FileController.sharedController.parseJSONFileToArrayOfWords("dictionary_small")
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.wordsArray?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("wordsListCell", forIndexPath: indexPath)

        guard let words = wordsArray else { return UITableViewCell() }
        let word = words[indexPath.row]
        cell.textLabel?.text = word

        return cell
    }
    
    //==================================================
    // MARK: - SearchController
    //==================================================
    
    func setupSearchController() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let resultsController = storyboard.instantiateViewControllerWithIdentifier("searchResultsTableViewController")
        
        guard let searchResultsTableViewController = resultsController as? SearchResultsTableViewController else { return }
        searchResultsTableViewController.sourceTableViewController = self
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.searchResultsUpdater = self
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.searchBar.placeholder = "Search words..."
        searchController?.searchBar.delegate = self
        searchController?.definesPresentationContext = true
        tableView.tableHeaderView = searchController?.searchBar
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        guard let searchTermLowercase = searchController.searchBar.text?.lowercaseString
            , searchResultsController = searchController.searchResultsController as? SearchResultsTableViewController
            , words = wordsArray
            else { return }
        
        // All results containing the lowercase search term
//        let filteredContainsWordsArray = Array(Set(words.filter({ $0.containsSearchTerm(searchTermLowercase) })))
        
        // Only "fuzzy" results that above a certain quality threshold of matching
        var filteredFuzzyWordsArray = [String]()
        for word in words {
            
            let matchQuality = Double(fuzzySearch.JaroWinklerDistance(searchTermLowercase, in_s2: word))
            if matchQuality >= self.fuzzinessQuality {
                
                filteredFuzzyWordsArray.append(word)
            }
        }
        
        filteredFuzzyWordsArray = Array(Set(Array(filteredFuzzyWordsArray)))
        
        // Only using the fuzzy ones
        searchResultsController.wordsArray = filteredFuzzyWordsArray
        searchResultsController.tableView.reloadData()
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
