//
//  AcceptDatePopup.swift
//  Untind
//
//  Created by Honceriu Mihai on 06/01/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import SVProgressHUD
protocol DatePopupDelegate : NSObject {
    func didAcceptDate(date: UTDate)
}
class AcceptDatePopup: UIViewController {

    var didAnimate : Bool = false
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var illustrationImageView: UIImageView!
    @IBOutlet weak var rescheduleButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var orangeBackground: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    weak var delegate : DatePopupDelegate?
    var date : UTDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                                            
        rescheduleButton.layer.shadowRadius = 12
        rescheduleButton.layer.shadowOffset = CGSize(width: 3.0, height: 6.0)
        rescheduleButton.layer.shadowOpacity = 0.4
        
        let messageString = NSAttributedString(string: "You will be set up for a date with \n\(date?.invitee?.username ?? "") once you confirm their \nproposed date and time:").boldAppearenceOf(string: date?.invitee?.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 12), color: UIColor.darkGray).withLineSpacing(5)
        
        messageLabel.attributedText = messageString
        dateTimeLabel.text = ""
        confirmButton.setAttributedTitle(NSAttributedString(string: "OK, LETS DO THIS!").boldAppearenceOf(string: "OK", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 16), color: UIColor.teal2), for: .normal)
        
        
    }
    
    static func instantiate() -> AcceptDatePopup {
          let vc = AcceptDatePopup(nibName: "AcceptDatePopup", bundle: nil)
          return vc
    }
    
    @objc func dismissKeyboard() {
           //Causes the view (or one of its embedded text fields) to resign the first responder status.
           view.endEditing(true)
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
        } else {
            orangeBackground.alpha = 0
            self.containerView.transform = CGAffineTransform.identity
            self.view.backgroundColor = UIColor(red: 33, green: 208, blue: 185, alpha: 0.89)
        }
    }
    
    // MARK: - Button actions
    @IBAction func closeButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.containerView.transform  = CGAffineTransform(translationX: 0, y: 800)
            self.illustrationImageView.transform  = CGAffineTransform(translationX: 0, y: 800)
            self.view.alpha = 0
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
            
        }
    }
    @IBAction func confirmButtonTapped(_ sender: Any) {
        SVProgressHUD.show()
        date?.answer(didAccept: true, completion: { (error, date) in
            if error != nil {
                let title = "Oops"
                let message = NSAttributedString(string: "There was an error: \(error?.localizedDescription ?? "")")
                let alert = UTAlertController(title: title, message: message, backgroundColor: UIColor.teal2, backgroundAlpha: 1)
                let action = UTAlertAction(title: "Dismiss", color: UIColor.teal2)
                alert.addNewAction(action: action)
                self.present(alert, animated: true, completion: nil)
            } else {
                let title = "All set, Get ready!"
                let message = NSAttributedString(string: "You have accepted a date with \(date?.invitee?.username ?? ""), \(date?.dateTime?.toFormattedString() ?? ""). This will show up on your upcoming dates. Good luck!").boldAppearenceOf(string: date?.invitee?.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: UTAlertController.messageFont.pointSize)).boldAppearenceOf(string: date?.dateTime?.toFormattedString() , withBoldFont: UIFont.helveticaNeue(weight: .bold, size: UTAlertController.messageFont.pointSize))
                let alert = UTAlertController(title: title, message: message, backgroundColor: UIColor.teal2, backgroundAlpha: 1)
                let action = UTAlertAction(title: "Dismiss", {
                    self.dismiss(animated: false, completion: nil)
                }, color: UIColor.teal2)
                alert.addNewAction(action: action)
                self.present(alert, animated: true, completion: nil)
            }
        })
     }
     
     @IBAction func rescheduleButtonTapped(_ sender: Any) {
         let vc = RescheduleDatePopup.instantiate()
         vc.date = self.date
         UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
             self.view.backgroundColor = UIColor.clear
             self.orangeBackground.alpha = 0.89
             self.containerView.transform = CGAffineTransform(translationX: -450, y: -100).rotated(by: -CGFloat.pi/5)
         }) { (completed) in self.navigationController?.pushViewController(vc, animated: false)
         }
         
     }
}

extension AcceptDatePopup : SwipeableViewDelegate {
    func didTap(view: SwipeableView) {
        
    }
    
    func didBeginSwipe(onView view: SwipeableView) {
        
    }
    
    func didEndSwipe(onView view: SwipeableView) {
        
    }
    
    func didSwipe(onView view: SwipeableView, percent: CGFloat) {
        
    }
    
    func didSwipeAway(onView view: SwipeableView) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.view.alpha = 0
        }) { (finished) in
            self.dismiss(animated: false, completion: nil)
            
        }
    }
    
 
}
