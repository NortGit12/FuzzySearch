//
//  FuzzySearch.swift
//  FuzzySearch
//
//  Created by Jeff Norton on 9/1/16.
//  Copyright © 2016 JCN. All rights reserved.
//

import Foundation

class FuzzySearch {
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    /*
     URL = https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance
     
     In computer science and statistics, the Jaro–Winkler distance (Winkler, 1990) is a measure of similarity between two strings. It is a variant of the Jaro distance metric (Jaro, 1989, 1995), a type of string edit distance, and was developed in the area of record linkage (duplicate detection) (Winkler, 1990). The higher the Jaro–Winkler distance for two strings is, the more similar the strings are. The Jaro-Winkler similarity (for equation see below) is given by 1 - Jaro Winkler distance. The Jaro–Winkler distance metric is designed and best suited for short strings such as person names. The score is normalized such that 0 equates to no similarity and 1 is an exact match.
     */
    
    private func sort(s1: String, s2: String) -> (String, String) {
        
        if s1.characters.count <= s2.characters.count {
            return (s1, s2)
        }
        
        return (s2, s1)
    }
    
    func JaroWinklerDistance(in_s1:String, in_s2:String) -> Float {
        
        let (s1, s2) = self.sort(in_s1.lowercaseString, s2: in_s2.lowercaseString)
        
        if s1.characters.count == 1 || s2.characters.count == 1 {
            return 0
        }
        
        let window = floor(Float(max(s1.characters.count, s2.characters.count)) / 2 - 1)
        
        let s1_characters_array = Array(s1.characters)
        let s2_characters_array = Array(s2.characters)
        
        var m = 0, t = 0, l = 0
        var idx = 0
        
        for char1 in s1.characters {
            
            if char1 == s2_characters_array[idx] {
                
                m += 1
                
                if idx == l && idx < 4 {
                    
                    l += 1
                }
            } else {
                
                if s2_characters_array.contains(char1) {
                    
                    let gap = s2_characters_array.indexOf(char1)! - idx
                    
                    if gap <= Int(window) {
                        
                        m += 1
                        
                        for k in idx..<s1_characters_array.count {
                            
                            if s2_characters_array.indexOf(s1_characters_array[k]) <= idx {
                                
                                t += 1
                            }
                        }
                    }
                }
            }
            
            idx += 1
        }
        
        //    let distanceFirst = Float(m)/Float(countElements(s1)) + Float(m)/Float(countElements(s2))
        let distanceFirst = Float(m)/Float(s1.characters.count) + Float(m)/Float(s2.characters.count)
        let distanceSecond = (Float(m)-floor(Float(t)/Float(2)))/Float(m)
        let distance = (distanceFirst + distanceSecond) / Float(3)
        let jwd = distance + (Float(l) * Float(0.1) * (Float(1) - distance))
        
        return jwd
    }
}