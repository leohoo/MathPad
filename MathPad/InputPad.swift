//
//  InputPad.swift
//  MathPad
//
//  Created by Wei Liu on 2016/10/14.
//  Copyright © 2016 Wei Liu. All rights reserved.
//

import UIKit
import Foundation
import TesseractOCR

public extension UIImage {
    public convenience init?(path: UIBezierPath, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        UIColor.clear.setFill()
        
        UIRectFill(rect)
        UIColor.darkGray.setStroke()
        
        path.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

class Stroke {
    var pnts: [CGPoint] = []
    
    var count: Int {
        get {
            return pnts.count;
        }
    }
    
    func add(_ point: CGPoint) {
        pnts.append(point);
    }
    
    subscript(_ i: Int) -> CGPoint {
        return pnts[i]
    }
}

class InputPad: UIView, G8TesseractDelegate {
    var strokes: [Stroke] = []
    var path: UIBezierPath = UIBezierPath();
    var image: UIImage? = nil
    var shouldCancel: Bool = false;
    var tesseract:G8Tesseract = G8Tesseract(language:"eng");
    var onRecognized:((String)->Void)? = nil;
    var onCrossed:(()->Void)? = nil;
    
    func reset() {
        image = nil
        path = UIBezierPath()
        path.lineWidth = 10;
        strokes = [];
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
        
        print("RESET\n");
    }
    
    init() {
        super.init(frame: CGRect.zero);
        self.isMultipleTouchEnabled = false;
        reset()
        tesseract.delegate = self;
        tesseract.charWhitelist = "01234567890";
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isMultipleTouchEnabled = false;
        reset()
        tesseract.delegate = self;
        tesseract.charWhitelist = "01234567890";
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        shouldCancel = true
        if let touch: UITouch = touches.first {
            let s = Stroke();
            strokes.append(s);
            let p = touch.location(in: self)
            s.add(p);
            path.move(to: p)
            
            //            NSLog("Begin: (%.1f, %.1f)", p.x, p.y)
        }
        super.touchesBegan(touches , with:event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if strokes.isEmpty {
            return
        }
        
        if let touch: UITouch = touches.first {
            let s = strokes.last!;
            let p = touch.location(in: self)
            //            NSLog("Moved: (%.1f, %.1f)", p.x, p.y)
            s.add(p)
            path.addLine(to: p)
            
            image = UIImage(path: path, size: self.frame.size)
            self.setNeedsDisplay()
        }
    }
    
    var timer:Timer? = nil
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isCross() {
            reset()
            onCrossed!()
            return
        }
        
        if timer != nil {
            timer?.invalidate();
        }
        
//        let recognize = #selector(tesseractRecognize) 
        let recognize = #selector(InputPad.seshat)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: recognize, userInfo: nil, repeats: false)
    }
    
    func tesseractRecognize() {
        shouldCancel = false;
        tesseract.image = image;
        tesseract.recognize();
        shouldCancel = false;
        
        NSLog("Recognized: %@", tesseract.recognizedText);
        
        if !tesseract.recognizedText.isEmpty {
            onRecognized!(tesseract.recognizedText);
        }
    }
    
    func seshat() {
        timer = nil;
        let ink = scgink()
//        print(ink);
        recognize(ink)
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.clear.setFill()
        UIRectFill(rect);
        if image != nil {
            image?.draw(in: rect)
        }
    }
    
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        return shouldCancel; // return true if you need to interrupt tesseract before it finishes
    }
    
    func scgink() -> String {
        var ink = "SCG_INK\n"
        ink += String(strokes.count) + "\n"
        for s in strokes {
            ink += String(s.count) + "\n"
            for i in 0...s.count-1 {
                ink += "\(s[i].x)  \(s[i].y)\n"
            }
        }
        return ink
    }
    
    var reqSeq = 0;
    func recognize(_ ink:String) {
        self.reqSeq = self.reqSeq + 1
        let reqNo = self.reqSeq
        
        var request = URLRequest(url: URL(string: "http://liu.easyjp.com/m/seshat.php")!)
        request.httpMethod = "POST"
        let postString = ink
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if reqNo != self.reqSeq {
                NSLog("Req#%d ignored!", reqNo);
                return; // ignore outdated request
            }
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)?
                .trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
            
            print("responseString = \(responseString)")
            if !self.strokes.isEmpty {
                self.onRecognized!(responseString!)
            }
        }
        task.resume()
    }
    
    func isCross() ->Bool {
        if strokes.isEmpty {
            return false;
        }
        
        let s = strokes.last!;
        
        let width = self.frame.width
        let height = self.frame.height
        var xmin: CGFloat = width, ymin: CGFloat = height
        var xmax: CGFloat = 0, ymax: CGFloat = 0
        
        for p in s.pnts {
            if xmin>p.x { xmin = p.x }
            if xmax<p.x { xmax = p.x }
            if ymin>p.y { ymin = p.y }
            if ymax<p.y { ymax = p.y }
        }
        
        let screenSize: CGRect = UIScreen.main.bounds
        let xlen = xmax - xmin
        return xlen / (ymax - ymin) > 4 && xlen > 0.3 * screenSize.width
    }
}
