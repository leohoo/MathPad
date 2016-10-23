//
//  BinaryOperation.swift
//  MathPad
//
//  Created by Wei Liu on 2016/10/19.
//  Copyright © 2016 Wei Liu. All rights reserved.
//

import Foundation

class BinaryOperation : Question {
    var operand1: Int32 = 0;
    var operand2: Int32 = 0;
    
    func Operator() -> String {
        return "?"
    }
    
    override func equals(_ q: Question) -> Bool {
        if q is BinaryOperation {
            let b = q as! BinaryOperation;
            return operand1 == b.operand1 && operand2 == b.operand2 && Operator() == b.Operator();
        }
        
        return false;
    }

}
