//
//  Question.swift
//  MathPad
//
//  Created by Wei Liu on 2016/10/11.
//  Copyright © 2016 Wei Liu. All rights reserved.
//

import Foundation

class Question {
    var userAnswer:String = ""
    
    func equals(_ q: Question) -> Bool {
        return false;
    }
    
    func checkAnswer(_ answer:String? = nil) -> Bool {
        return false;
    }
    
    func toString() -> String {
        return "";
    }
}

extension String {
    init(_ q:Question) {
        self = q.toString();
    }
}
