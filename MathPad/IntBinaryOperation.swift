//
//  IntBinaryOperation.swift
//  MathPad
//
//  Created by Wei Liu on 2016/10/21.
//  Copyright © 2016 Wei Liu. All rights reserved.
//

import Foundation

class IntBinaryOperation : BinaryOperation {
    func rand(_ range1: ClosedRange<Int32>=1...9, _ range2: ClosedRange<Int32>=1...9) {
        operand1 = (Int32)(arc4random() % UInt32(range1.count)) + range1.lowerBound;
        operand2 = (Int32)(arc4random() % UInt32(range2.count)) + range2.lowerBound;
    }
    
    override func toString() -> String {
        return NSString(format: "%d%@%d = %@", operand1, Operator(), operand2, userAnswer) as String
    }
}
