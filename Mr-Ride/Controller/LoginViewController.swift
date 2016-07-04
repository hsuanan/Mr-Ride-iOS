//
//  LoginViewController.swift
//  Mr-Ride
//
//  Created by Hsin An Hsu on 6/27/16.
//  Copyright © 2016 AppWorks School HsinAn Hsu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        heightAndWeightTextFieldSetup()
        
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
        
    }
    
    //Mark: textField
    
    func heightAndWeightTextFieldSetup() {
        heightTextField.delegate = self
        weightTextField.delegate = self
        heightTextField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        weightTextField.keyboardType = UIKeyboardType.NumbersAndPunctuation
    }
    //textFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        heightTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // read the information entered into the text field and do something with it
    }

    //Mark: Setup
    
    func setup() {
        
        view.backgroundColor = UIColor.mrLightblueColor()
    
        let gradient = CAGradientLayer()
        let color1 = UIColor.mrLightblueColor().colorWithAlphaComponent(1)
        let color2 = UIColor.mrPineGreen50Color().colorWithAlphaComponent(0.5)
        gradient.frame = backgroundImage.bounds
        gradient.colors = [color1.CGColor,color2.CGColor]
        backgroundImage.layer.insertSublayer(gradient, atIndex: 0)
        
        
        titleLabel.font = UIFont.mrTextStyle24Font()
        titleLabel.textColor = UIColor.mrWhiteColor()
        titleLabel.text = "MR. Ride"
        letterSpacing(titleLabel.text!, letterSpacing: -1.4, label: titleLabel)
        
        titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
        titleLabel.layer.shadowOpacity = 0.25
        titleLabel.layer.shadowRadius = 2
        titleLabel.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
    }
    
    func letterSpacing(text: String, letterSpacing: Double, label: UILabel){
        let attributedText = NSMutableAttributedString (string: text)
        attributedText.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSMakeRange(0, attributedText.length))
        label.attributedText = attributedText
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
