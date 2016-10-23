//
//  QuizSelection.swift
//  MathPad
//
//  Created by Wei Liu on 2016/10/20.
//  Copyright © 2016 Wei Liu. All rights reserved.
//

import UIKit

class QuizSelection: UIViewController {
    @IBAction func selectQuiz(view : UIView) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "QuizViewController") as! ViewController
        
        switch(view.tag) {
        case 1:
            controller.quizType = .Addition1
        case 2:
            controller.quizType = .Addition2
        case 3:
            controller.quizType = .Substraction
        case 4:
            controller.quizType = .Multiplication
        default:
            controller.quizType = .Addition1
        }
        
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape;
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
