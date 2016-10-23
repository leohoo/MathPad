//
//  AdditionQuiz.swift
//  MathPad
//
//  Created by Wei Liu on 2016/10/19.
//  Copyright © 2016 Wei Liu. All rights reserved.
//

import Foundation

class AdditionQuiz : Quiz {
    override init() {
        super.init()
        for _ in 0...9 {
            let q = AdditionQuestion();
            q.rand();
            
            while has(q) {
                q.rand();
            }
            questions.append(q);
        }
    }
}
