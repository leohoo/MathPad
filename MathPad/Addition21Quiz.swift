//
//  Addition21Quiz.swift
//  MathPad
//
//  Created by Wei Liu on 2016/10/20.
//  Copyright © 2016 Wei Liu. All rights reserved.
//

import Foundation

class Addition21Quiz : Quiz {
    override init() {
        super.init()
        for _ in 0..<numOfQuestions {
            let q = AdditionQuestion();
            q.rand(1...99, 1...9);
            
            while has(q) {
                q.rand(1...99, 1...9);
            }
            questions.append(q);
        }
    }
}
