//
//  SubstractionQuestion.swift
//  MathPad
//
//  Created by Wei Liu on 2016/10/21.
//  Copyright © 2016 Wei Liu. All rights reserved.
//

import Foundation

class SubstractionQuestion: IntBinaryOperation {
    override func Operator() -> String {
        return "-"
    }
    
    override func checkAnswer(_ answer:String? = nil) ->Bool {
        if answer != nil && !answer!.isEmpty {
            userAnswer = answer!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        let check = (String(operand1-operand2) == userAnswer)
        return check
    }
}
