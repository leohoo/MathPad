//
//  MultiplicationQuiz.swift
//  MathPad
//
//  Created by Wei Liu on 2016/10/19.
//  Copyright © 2016 Wei Liu. All rights reserved.
//

import Foundation

class MultiplicationQuiz : Quiz {
    override init() {
        super.init()
        for _ in 0..<numOfQuestions {
            let q = MultiplicationQuestion();
            q.rand();
            
            while has(q) {
                q.rand();
            }
            questions.append(q);
        }
    }
}
