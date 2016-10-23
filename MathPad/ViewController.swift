//
//  ViewController.swift
//  MathPad
//
//  Created by Wei Liu on 2016/10/11.
//  Copyright © 2016 Wei Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    enum QuizType {
        case Addition1, Addition2, Substraction, Multiplication
    }
    
    var quizType:QuizType = .Addition1
    
    var quiz = Quiz()
    var currentQuestion = 0
    let cosmosIcon = UIImage(named: "cosmos")

    @IBOutlet var progressIcon: [UIImageView] = [];
    @IBOutlet var questionView: QuestionView?=nil;
    @IBOutlet var inputPad: InputPad? = nil;
    @IBOutlet var status: UILabel? = nil
    @IBAction func newQuiz() {
        switch quizType {
        case .Addition1:
            quiz = AdditionQuiz();
            
        case .Addition2:
            quiz = Addition21Quiz();
            
        case .Substraction:
            quiz = SubstractionQuiz();
            
        case .Multiplication:
            quiz = MultiplicationQuiz();
        }
        
        currentQuestion = 0
        dispQuiz(quiz: quiz);
        inputPad?.reset()
        if clockTimer != nil {
            clockTimer?.invalidate()
            clockTimer = nil
        }
        clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        seconds = 0;
        updateProgress(0);
    }
    
    @IBAction func quit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var clockTimer:Timer? = nil;
    var seconds:Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        newQuiz()
        
        inputPad?.onRecognized = { (recognized:String)->Void in self.onRecognized(recognized) }
        inputPad?.onCrossed = { self.onCrossed() }
        
        for v in progressIcon {
            v.contentMode = .scaleAspectFit
        }
    }
    
    func tick() {
        seconds = seconds+1;
        status?.text = NSString(format: "%d/%d   %02d:%02d", currentQuestion+1, quiz.questions.count, seconds/60, seconds%60) as String;
    }
    
    func updateProgress(_ prog: Int) {
        DispatchQueue.main.async {
            for i in 0...self.progressIcon.count-1 {
                if i < prog {
                    self.progressIcon[i].image = self.cosmosIcon;
                } else {
                    self.progressIcon[i].image = nil;
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape;
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func dispQuiz(quiz : Quiz) {
        questionView?.q = quiz.questions[currentQuestion];
        self.questionView?.setNeedsDisplay()
    }
    
    func onCrossed() {
        self.questionView?.setNeedsDisplay()
        self.questionView?.q.userAnswer = "";
    }
    
    func onRecognized(_ recognized:String) {
        let check = quiz.questions[currentQuestion].checkAnswer(recognized)
        DispatchQueue.main.async {
            self.questionView?.setNeedsDisplay()
        }

        if check {
            inputPad?.reset()
            
            updateProgress(currentQuestion+1)
            
            if currentQuestion < quiz.questions.count-1 {
                let deadlineTime = DispatchTime.now() + .seconds(1)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.currentQuestion = self.currentQuestion+1
                    self.questionView?.q = self.quiz.questions[self.currentQuestion];
                    DispatchQueue.main.async {
                        self.questionView?.setNeedsDisplay()
                    }
                }
            } else {
                // finished
                clockTimer?.invalidate();
                clockTimer = nil
            }
        } else {
            DispatchQueue.main.async {
                self.shake(view: self.questionView!)
            }
        }
    }
    
    func shake(view: UIView, translate:CGFloat=30) {
        NSLog("shake")
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x:view.center.x - translate, y:view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x:view.center.x + translate, y:view.center.y))
        view.layer.add(animation, forKey: "position")
    }
}

