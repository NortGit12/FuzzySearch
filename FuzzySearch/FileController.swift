//
//  FileController.swift
//  FuzzySearch
//
//  Created by Jeff Norton on 9/1/16.
//  Copyright © 2016 JCN. All rights reserved.
//

import Foundation

class FileController {
    
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let sharedController = FileController()
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    func parseJSONFileToArrayOfWords(filename: String) -> [String]? {
        
        var wordsArray: [String]?
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: ".json") {
            
            if let jsonData = (try? NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)) {
                
                if let jsonResult = (try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)) as? [String : AnyObject] {
                    
                    wordsArray = convertStringDictionaryToWordsArray(jsonResult)
                    
                    print("\nwordsArray = \(wordsArray)")
                }
            }
        }
        
        return wordsArray
    }
    
//    func parseJSONFile2(filename: String) -> [String : AnyObject]? {
//        
//        guard let masterDataURL: NSURL = NSBundle.mainBundle().URLForResource(filename, withExtension: "json")
//            , jsonData: NSData = NSData(contentsOfURL: masterDataURL)
//            , jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: ) as? NSDictionary
//            else {
//                
//                NSLog("The file could not be parsed into a dictionary")
//                return nil
//            }
//        
//    }
    
    func convertStringDictionaryToWordsArray(stringDictionary: [String : AnyObject]) -> [String] {
        
        var wordsArray = [String]()
        for (key, value) in stringDictionary {
            
            wordsArray.append(key)
            
            guard let stringValue = value as? String else { break }
            
            let valueWordsArray = stringValue.characters.split{ $0 == " " }.map(String.init)
            
            for word in valueWordsArray {
                
                wordsArray.append(word)
            }
        }
        
        return wordsArray
    }
}