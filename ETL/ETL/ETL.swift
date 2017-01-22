//
//  ETL.swift
//  ETL
//
//  Created by Dongyoon Kang on 2017. 1. 21..
//  Copyright © 2017년 Dongyoon Kang. All rights reserved.
//

import Foundation

class ETL {
    //class func transform(oldvalue: [Int:[String]]) -> [String:Int] {
    class func transform(oldValue : Dictionary<Int, Array<String>>) -> [String:Int] {

        var newValue = [String: Int]()
        
        for (key, value) in oldValue {
            for str in value {
                newValue[str.lowercased()] = key
            }
            
        }
        
        return newValue
    }
    
}
