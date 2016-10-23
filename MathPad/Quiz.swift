//
//  Quiz.swift
//  MathPad
//
//  Created by Wei Liu on 2016/10/13.
//  Copyright © 2016 Wei Liu. All rights reserved.
//

import Foundation

class Quiz {
    var questions : [Question] = [];
    let numOfQuestions = 10;
        
    func has(_ q: Question) -> Bool {
        for p in questions {
            if p.equals(q) {
                return true;
            }
        }
        
        return false;
    }
}
