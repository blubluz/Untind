//
//  SendDatePopup.swift
//  Untind
//
//  Created by Mihai Honceriu on 10/01/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import SVProgressHUD

class SendDatePopup: UIViewController {

    @IBOutlet weak var pickerView: UTPickerView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIView!
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    
    let datePickerValues = ["Today", "Tommorow", Date.tomorrow.dayAfter.dayName]
    var selectedPickerValue : Int = 0
    var didAnimate : Bool = false
    var invitedPerson : Profile?
    weak var delegate : DatePopupDelegate?
    
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
        
        hourTextField.delegate = self
        minutesTextField.delegate = self
        
        messageLabel.attributedText = NSAttributedString(string: "Lets set up a date with \(invitedPerson?.username ?? ""). \n To begin, pick up a day and a time slot and they will be notified. Good luck!").boldAppearenceOf(string: invitedPerson?.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 12), color: UIColor.darkGray).withLineSpacing(5)
        
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(self,
                  selector: #selector(keyboardWillDisappear),
                  name: UIResponder.keyboardWillHideNotification,
                  object: nil)
        
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
    
    // MARK: - Keyboard Handling
    @objc func keyboardWillAppear(_ notification : Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                self.containerBottomConstraint.constant = 303
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            containerBottomConstraint.constant = 303
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc func keyboardWillDisappear(_ notification : Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                self.containerBottomConstraint.constant = 53
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            containerBottomConstraint.constant = 53
            self.view.layoutIfNeeded()
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
    
    @IBAction func sendRequestTapped(_ sender: Any) {
        var selectedDate = Date()
        if selectedPickerValue == 1 {
            selectedDate = Date.tomorrow
        } else if selectedPickerValue == 2 {
            selectedDate = Date.tomorrow.dayAfter
        }
        
        guard hourTextField.text?.count ?? 0 > 0, minutesTextField.text?.count ?? 0 > 0, let profile = self.invitedPerson else {
            
            return
        }
        
        if let hour = Int(hourTextField.text!), let minute = Int(minutesTextField.text!), let date = Date.with(year: selectedDate.year, month: selectedDate.month, day: selectedDate.day, hour: hour, minute: minute) {
            SVProgressHUD.show()
            profile.inviteOnDate(date: date) { (error, success, date) in
                SVProgressHUD.dismiss()
                if let error = error {
                    self.present(UTAlertController(title: "Oops", message: "\(error.localizedDescription)"), animated: true, completion: nil)
                } else {
                    if success == true {
                        if let date = date {
                            self.delegate?.didEdit(date: date)
                        }
                        
                        let alert = UTAlertController(title: "Success!!", message: NSAttributedString(string: "Your date request was successfully sent to \(profile.username). You can track their response in your dates.").boldAppearenceOf(string: profile.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: UTAlertController.messageFont.pointSize), color: UIColor.darkBlue), backgroundColor: UIColor(red: 142, green: 196, blue: 246, alpha: 1), backgroundAlpha: 1)
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
        selectedPickerValue = row
    }
}

//MARK: - TextFieldDelegate
extension SendDatePopup : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == hourTextField {
            minutesTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let swiftRange = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: swiftRange, with: string)
        if let numericValue = Int(newText) {
            if textField == hourTextField {
                if numericValue < 0 || numericValue>23 {
                    return false
                }
                return true
            }
            if textField == minutesTextField {
                if numericValue < 0 || numericValue > 59 {
                    return false
                }
                return true
            }
            return true
        } else {
            if newText == "" {
                return true
            } else {
                return false
            }
        }
    }
}
