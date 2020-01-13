//
//  RescheduleDatePopup.swift
//  Untind
//
//  Created by Mihai Honceriu on 08/01/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class RescheduleDatePopup: UIViewController {
    
    @IBOutlet weak var pickerView: UTPickerView!
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    let datePickerValues = ["Today", "Tommorow", "Wednesday"]
    var didAnimate : Bool = false
    
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureExamplePicker()
        
        
        backButton.layer.shadowRadius = 9.0
        backButton.layer.shadowOffset = CGSize(width: 3.0, height: 4.0)
        backButton.layer.shadowOpacity = 0.2
        
        hourTextField.backgroundColor = UIColor.white
        minutesTextField.backgroundColor = UIColor.white
        hourTextField.layer.cornerRadius = 10
        minutesTextField.layer.cornerRadius = 10
        hourTextField.layer.borderColor = UIColor.flatOrange.cgColor
        minutesTextField.layer.borderColor = UIColor.flatOrange.cgColor
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
            containerView.transform = CGAffineTransform(translationX: 450, y: -180).rotated(by: CGFloat.pi/5)
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.containerView.transform = CGAffineTransform.identity
            }) { (completed) in
                
            }
        }
    }
    
    //MARK: - Helper functions
    @objc func dismissKeyboard() {
           //Causes the view (or one of its embedded text fields) to resign the first responder status.
           view.endEditing(true)
       }
    static func instantiate() -> RescheduleDatePopup {
        let vc = RescheduleDatePopup(nibName: "RescheduleDatePopup", bundle: nil)
        return vc
    }
    
    fileprivate func configureExamplePicker() {
        pickerView.dataSource = self
        pickerView.delegate = self
        
        //        pickerView.secondaryColor = UIColor(red: 140, green: 195, blue: 244, alpha: 1)
        pickerView.scrollingStyle = .default
        pickerView.selectionStyle = .none
        pickerView.currentSelectedRow = 1
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
           UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                 self.containerView.transform  = CGAffineTransform(translationX: 0, y: 800)
                 self.illustrationImageView.transform  = CGAffineTransform(translationX: 0, y: 800)
                 self.view.alpha = 0
             }) { (finished) in
                 self.dismiss(animated: false, completion: nil)
                 
             }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RescheduleDatePopup : PickerViewDataSource, PickerViewDelegate {
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
        print(datePickerValues[row])
    }
}
