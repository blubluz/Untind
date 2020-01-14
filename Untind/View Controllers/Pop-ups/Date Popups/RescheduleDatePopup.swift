//
//  RescheduleDatePopup.swift
//  Untind
//
//  Created by Mihai Honceriu on 08/01/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import SVProgressHUD

class RescheduleDatePopup: UIViewController {
    
    @IBOutlet weak var pickerView: UTPickerView!
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    let datePickerValues = ["Today", "Tommorow", "Wednesday"]
    var didAnimate : Bool = false
    var selectedPickerValue : Int = 0

    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var sendRequestButton: UIButton!
    
    var date : UntindDate?
    
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
        
        sendRequestButton.setAttributedTitle(NSAttributedString(string: "SEND REQUEST").boldAppearenceOf(string: "SEND", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 16), color: UIColor.flatOrange), for: .normal)
        
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
    
    @IBAction func sendRequestTapped(_ sender: Any) {
        var selectedDate = Date()
            if selectedPickerValue == 1 {
                selectedDate = Date.tomorrow
            } else if selectedPickerValue == 2 {
                selectedDate = Date.tomorrow.dayAfter
            }
            
            guard hourTextField.text?.count ?? 0 > 0, minutesTextField.text?.count ?? 0 > 0 else {
                
                return
            }
            
            if let hour = Int(hourTextField.text!), let minute = Int(minutesTextField.text!), let date = Date.with(year: selectedDate.year, month: selectedDate.month, day: selectedDate.day, hour: hour, minute: minute) {
                SVProgressHUD.show()
                self.date?.invitee?.inviteOnDate(date: date) { (error, success, date) in
                    SVProgressHUD.dismiss()
                    if let error = error {
                        self.present(UTAlertController(title: "Oops", message: "There was an error: \(error.localizedDescription)"), animated: true, completion: nil)
                    } else {
                        if success == true {
                            let alert = UTAlertController(title: "Done!!", message: NSAttributedString(string: "You have suggested a different date and time to \( self.date?.invitee?.username ?? ""). You can track their response in your dates screen.").boldAppearenceOf(string:  self.date?.invitee?.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: UTAlertController.messageFont.pointSize), color: UIColor.darkBlue))
                            let action = UTAlertAction(title: "Dismiss", {
                                self.dismiss(animated: false, completion: nil)
                            }, color: UIColor(red: 142, green: 196, blue: 246, alpha: 1))
                            alert.addNewAction(action: action)
                            self.present(alert, animated: true, completion: nil)

                        }
                    }
                }
    }
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
        selectedPickerValue = row
    }
}
