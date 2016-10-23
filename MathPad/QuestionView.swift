//
//  QuestionView.swift
//  MathPad
//
//  Created by Wei Liu on 2016/10/13.
//  Copyright © 2016 Wei Liu. All rights reserved.
//

import UIKit

class QuestionView: UIView {

    var q: Question;
    
    required init?(coder aDecoder: NSCoder) {
        q = AdditionQuestion();
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
     
        let s = String(q)
        let check = q.checkAnswer()
        
        let color = check ? UIColor.blue : UIColor.black;
        let fontName = check ? "CourierNewPS-BoldMT" : "Courier New"
        let size:CGFloat = Config.digitFontSize;
        let font:UIFont = UIFont(name: fontName, size: size)!;
        let attributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color
        ];
        
        s.draw(in: rect, withAttributes: attributes);
    }
}
