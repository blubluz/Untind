//
//  SendDatePopup.swift
//  Untind
//
//  Created by Mihai Honceriu on 10/01/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class SendDatePopup: UIViewController {

    @IBOutlet weak var pickerView: UTPickerView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    let datePickerValues = ["Today", "Tommorow", "Wednesday"]
    var didAnimate : Bool = false
    @IBOutlet weak var closeButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureExamplePicker()
        
        hourTextField.backgroundColor = UIColor.white
        minutesTextField.backgroundColor = UIColor.white
        hourTextField.layer.cornerRadius = 10
        minutesTextField.layer.cornerRadius = 10
        hourTextField.layer.borderColor = UIColor(red: 140, green: 195, blue: 244, alpha: 1).cgColor
        minutesTextField.layer.borderColor = UIColor(red: 140, green: 195, blue: 244, alpha: 1).cgColor
        hourTextField.layer.borderWidth = 2
        minutesTextField.layer.borderWidth = 2
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
        
        KeyboardAvoiding.avoidingView = self.containerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           if !didAnimate {
               didAnimate = true
               containerView.transform  = CGAffineTransform(translationX: 0, y: 800)
               illustrationImageView.transform  = CGAffineTransform(translationX: 0, y: 800)
               
               UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                   self.containerView.transform = CGAffineTransform.identity
                   self.illustrationImageView.transform = CGAffineTransform.identity
               }, completion: nil)
               
               UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
               }, completion: nil)
           }
    }
    
    //MARK: - Helper functions
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    static func instantiate() -> SendDatePopup {
        let vc = SendDatePopup(nibName: "SendDatePopup", bundle: nil)
        return vc
    }
    
    fileprivate func configureExamplePicker() {
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.secondaryColor = UIColor(red: 140, green: 195, blue: 244, alpha: 1)
           pickerView.scrollingStyle = .default
           pickerView.selectionStyle = .none
           pickerView.currentSelectedRow = 1
       }
    
    //MARK: - Buttons actions
       @IBAction func closeButtonTapped(_ sender: Any) {
              UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    self.containerView.transform  = CGAffineTransform(translationX: 0, y: 800)
                    self.illustrationImageView.transform  = CGAffineTransform(translationX: 0, y: 800)
                    self.view.alpha = 0
                }) { (finished) in
                    self.dismiss(animated: false, completion: nil)
                    
                }
       }
}


extension SendDatePopup : PickerViewDataSource, PickerViewDelegate {
    // MARK: - PickerViewDataSource
    
    func pickerViewNumberOfRows(_ pickerView: UTPickerView) -> Int {
        return datePickerValues.count
    }
    
    func pickerView(_ pickerView: UTPickerView, titleForRow row: Int) -> String {
        return datePickerValues[row]
    }
    
    // MARK: - PickerViewDelegate
    
    func pickerViewHeightForRows(_ pickerView: UTPickerView) -> CGFloat {
        return 35.0
    }
    
    func pickerView(_ pickerView: UTPickerView, didSelectRow row: Int) {
        print(datePickerValues[row] )
    }
}
