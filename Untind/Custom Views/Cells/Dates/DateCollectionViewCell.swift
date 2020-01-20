//
//  DateTableViewCell.swift
//  Untind
//
//  Created by Mihai Honceriu on 16/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

enum DateCellTestType {
    case newDateRequest
    case upcomingDate
    case activeDate1
    case activeDate2
    case pendingInvite
    case pendingResponse
}

protocol DateDelegate : NSObject {
    func didTapRejectDate(date: UTDate)
    func didTapAcceptDate(date: UTDate)
    func didTapCancelDate(date: UTDate)
    func didTapRescheduleDate(date: UTDate)
    func didTapDate(date: UTDate)
    func didTapUserProfile(profile: Profile)
}

extension DateDelegate {
    func didTapDate(date: UTDate) {
        
    }
}

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateSentLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var turnCellButton: UIButton!
    @IBOutlet weak var cancelDateButton: UIButton!
    @IBOutlet weak var acceptDateButton: UIButton!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var dateButtonsStackView: UIStackView!
    @IBOutlet weak var flippedContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelDateView: UIView!
    @IBOutlet weak var rescheduleDateView: UIView!
    @IBOutlet weak var flippedTurnButton: BiggerTapSizeButton!
    weak var delegate : DateDelegate?
    var isFlipped : Bool = false
    var date : UTDate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10.0
        flippedContainerView.layer.cornerRadius = 10.0
        
        flippedTurnButton.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
    }
    
    @discardableResult
    func update(with date: UTDate) -> DateCollectionViewCell {
        self.date = date
        configureForStatus(date.myRelationshipStatus)
        switch date.myRelationshipStatus {
        case .shouldAnswerDateRequest:
            titleLabel.attributedText = NSAttributedString(string: "\(date.invitee!.username), \(date.invitee!.gender.shortGender) \(date.invitee!.age)").boldAppearenceOf(string: date.invitee!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: titleLabel.font.pointSize), color: UIColor.darkBlue)
            descriptionLabel.text = "sent you a date request"
        case .dateScheduled:
            let titleMessage = date.invitee?.uid == UTUser.loggedUser?.userProfile?.uid ? "You invited \(date.invited?.username ?? "")." : "\(date.invitee?.username ?? "") invited you."
            titleLabel.attributedText = NSAttributedString(string: titleMessage).boldAppearenceOf(string: date.invitee?.uid == UTUser.loggedUser?.userProfile?.uid ? date.invited!.username : date.invitee!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: titleLabel.font.pointSize), color: UIColor.darkBlue)
            descriptionLabel.attributedText = NSAttributedString(string: "Date starting in \(date.dateTime?.timeLeftString() ?? "-")").boldAppearenceOf(string: date.dateTime?.timeLeftString(), withBoldFont: UIFont.helveticaNeue(weight: .bold, size: descriptionLabel.font.pointSize), color: UIColor.darkBlue)
        case .dateStarted:
            titleLabel.attributedText = NSAttributedString(string: "\(date.invitee!.username), \(date.invitee!.gender.shortGender) \(date.invitee!.age), is on a date with you").boldAppearenceOf(string: date.invitee!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: titleLabel.font.pointSize), color: UIColor.darkBlue)
            descriptionLabel.attributedText = NSAttributedString(string: "Date ends in \(date.dateTime?.addingTimeInterval(15 * 60).timeLeftString() ?? "-")").boldAppearenceOf(string: date.dateTime?.addingTimeInterval(15 * 60).timeLeftString() ?? "-", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: descriptionLabel.font.pointSize), color: UIColor.darkBlue)
        case .chatStarted:
        titleLabel.attributedText = NSAttributedString(string: "\(date.invitee!.username),\(date.invitee!.gender.shortGender) \(date.invitee!.age)").boldAppearenceOf(string: date.invitee!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: titleLabel.font.pointSize), color: UIColor.darkBlue)
        descriptionLabel.text = "This is a message"
        case .waitingDateAnswer:
            if date.invited!.uid == UTUser.loggedUser?.userProfile?.uid {
                self.titleLabel.attributedText = NSAttributedString(string: "\(date.invitee!.username), \(date.invitee!.gender.shortGender) \(date.invitee!.age) invited you").boldAppearenceOf(string: date.invitee!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
            } else {
                self.titleLabel.attributedText = NSAttributedString(string: "You invited \(date.invited!.username), \(date.invited!.gender.shortGender) \(date.invited!.age)").boldAppearenceOf(string: date.invited!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
            }
            descriptionLabel.text = "awaiting a response"
        case .waitingDateResult:
                if date.invited!.uid == UTUser.loggedUser?.userProfile?.uid {
                    self.titleLabel.attributedText = NSAttributedString(string: "\(date.invitee!.username), \(date.invitee!.gender.shortGender) \(date.invitee!.age) dated you").boldAppearenceOf(string: date.invitee!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
                } else {
                    self.titleLabel.attributedText = NSAttributedString(string: "You dated \(date.invited!.username), \(date.invited!.gender.shortGender) \(date.invited!.age)").boldAppearenceOf(string: date.invitee!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
                    
                }
            self.descriptionLabel.text = "awaiting their feedback"
        case .shouldGiveDateResult:
            if date.invited!.uid == UTUser.loggedUser?.userProfile?.uid {
                self.titleLabel.attributedText = NSAttributedString(string: "\(date.invitee!.username), \(date.invitee!.gender.shortGender) \(date.invitee!.age) dated you").boldAppearenceOf(string: date.invitee!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
            } else {
                self.titleLabel.attributedText = NSAttributedString(string: "You dated \(date.invited!.username), \(date.invited!.gender.shortGender) \(date.invited!.age)").boldAppearenceOf(string: date.invited!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
                
            }
            self.descriptionLabel.text = "waiting for your feedback"
        case .dateRequestExpired:
            if date.invited!.uid == UTUser.loggedUser?.userProfile?.uid {
                self.titleLabel.attributedText = NSAttributedString(string: "\(date.invitee!.username), \(date.invitee!.gender.shortGender) \(date.invitee!.age) invited you").boldAppearenceOf(string: date.invitee!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
                self.descriptionLabel.text = "Date request expired. You did not answer."
            } else {
                self.titleLabel.attributedText = NSAttributedString(string: "You invited \(date.invited!.username), \(date.invited!.gender.shortGender) \(date.invited!.age)").boldAppearenceOf(string: date.invited!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
                self.descriptionLabel.text = "Date request expired. They did not answer."
            }
        case .dateFailed:
            if date.invited!.uid == UTUser.loggedUser?.userProfile?.uid {
                        self.titleLabel.attributedText = NSAttributedString(string: "\(date.invitee!.username), \(date.invitee!.gender.shortGender) \(date.invitee!.age) invited you").boldAppearenceOf(string: date.invitee!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
                        self.descriptionLabel.text = "Date request failed."
                    } else {
                        self.titleLabel.attributedText = NSAttributedString(string: "You invited \(date.invited!.username), \(date.invited!.gender.shortGender) \(date.invited!.age)").boldAppearenceOf(string: date.invited!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
                        self.descriptionLabel.text = "Date request failed."
                    }
        case .heRejected:
            if date.invited!.uid == UTUser.loggedUser?.userProfile?.uid {
                        self.titleLabel.attributedText = NSAttributedString(string: "\(date.invitee!.username), \(date.invitee!.gender.shortGender) \(date.invitee!.age) invited you").boldAppearenceOf(string: date.invitee!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
                        self.descriptionLabel.text = "Date request cancelled."
                    } else {
                        self.titleLabel.attributedText = NSAttributedString(string: "You invited \(date.invited!.username), \(date.invited!.gender.shortGender) \(date.invited!.age)").boldAppearenceOf(string: date.invited!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
                        self.descriptionLabel.text = "Date request rejected."
                    }
        case .youRejected:
            if date.invited!.uid == UTUser.loggedUser?.userProfile?.uid {
                    self.titleLabel.attributedText = NSAttributedString(string: "\(date.invitee!.username), \(date.invitee!.gender.shortGender) \(date.invitee!.age) invited you").boldAppearenceOf(string: date.invitee!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
                    self.descriptionLabel.text = "Date request cancelled."
                } else {
                    self.titleLabel.attributedText = NSAttributedString(string: "You invited \(date.invited!.username), \(date.invited!.gender.shortGender) \(date.invited!.age)").boldAppearenceOf(string: date.invited!.username, withBoldFont: UIFont.helveticaNeue(weight: .bold, size: self.titleLabel.font.pointSize), color: UIColor.white)
                    self.descriptionLabel.text = "Date request rejected."
                }
        
        default:
            break
        }
        return self
    }
    
    func configureForStatus(_ status: UTDate.RelationshipStatus) {
        switch status {
        case .shouldAnswerDateRequest:
            turnCellButton.isHidden = true
            dateSentLabel.isHidden = true
        case .dateScheduled:
            cancelDateButton.isHidden = true
            acceptDateButton.isHidden = true
            rescheduleDateView.isHidden = true
            dateSentLabel.isHidden = true
        case .dateStarted:
            cancelDateButton.isHidden = true
            acceptDateButton.isHidden = true
            dateSentLabel.isHidden = true
            turnCellButton.isHidden = true
            titleButton.isEnabled = false
            containerView.backgroundColor = UIColor(red: 253, green: 255, blue: 247, alpha: 1)
        case .chatStarted:
            cancelDateButton.isHidden = true
            acceptDateButton.isHidden = true
            turnCellButton.isHidden = true
            titleButton.isEnabled = false
            descriptionLabel.textColor = UIColor.darkBlue
            containerView.backgroundColor = UIColor(red: 246, green: 253, blue: 238, alpha: 1)
        case .dateRequestExpired:
            turnCellButton.isHidden = true
            fallthrough
        case .waitingDateAnswer,.waitingDateResult,.shouldGiveDateResult:
            cancelDateButton.isHidden = true
            acceptDateButton.isHidden = true
            dateSentLabel.isHidden = true
            containerView.backgroundColor = UIColor(red: 151, green: 172, blue: 131, alpha: 1)
            titleLabel.textColor = UIColor.white
            descriptionLabel.textColor = UIColor.white
            turnCellButton.tintColor = UIColor.white
            rescheduleDateView.isHidden = true
        default:
            return
        }
    }
    
//    @discardableResult
//    func update(with type: DateCellTestType) -> DateCollectionViewCell {
//        switch type {
//        case .newDateRequest:
//            turnCellButton.isHidden = true
//            dateSentLabel.isHidden = true
//
//
//            titleLabel.attributedText = NSAttributedString(string: "randomusername, F 24", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 14)]).boldAppearenceOf(string: "randomusername", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 14))
//            descriptionLabel.text = "sent you a date request"
//        case .upcomingDate:
//            cancelDateButton.isHidden = true
//            acceptDateButton.isHidden = true
//            dateSentLabel.isHidden = true
//            titleLabel.attributedText = NSAttributedString(string: "anotheruser, F 25, invited you", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 14), NSAttributedString.Key.foregroundColor : UIColor.darkBlue]).boldAppearenceOf(string: "anotheruser", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 14))
//            descriptionLabel.attributedText = NSAttributedString(string: "Date starting in 00:15 min", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 12), NSAttributedString.Key.foregroundColor : UIColor.gray(value: 172)]).boldAppearenceOf(string: "00:15 min", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 12), color: UIColor.darkBlue)
//        case .activeDate1:
//            cancelDateButton.isHidden = true
//            acceptDateButton.isHidden = true
//            dateSentLabel.isHidden = true
//            turnCellButton.isHidden = true
//            titleLabel.attributedText = NSAttributedString(string: "anotheruser, F 22", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 14), NSAttributedString.Key.foregroundColor : UIColor.darkBlue, ]).boldAppearenceOf(string: "anotheruser", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 14))
//            descriptionLabel.attributedText = NSAttributedString(string: "Date ends in 00:04 min", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 12), NSAttributedString.Key.foregroundColor : UIColor.gray(value: 172)]).boldAppearenceOf(string: "00:04 min", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 12), color: UIColor.darkBlue)
//        case .activeDate2:
//            cancelDateButton.isHidden = true
//            acceptDateButton.isHidden = true
//            turnCellButton.isHidden = true
//            titleLabel.attributedText = NSAttributedString(string: "anotheruser, F 22", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 14), NSAttributedString.Key.foregroundColor : UIColor.darkBlue]).boldAppearenceOf(string: "anotheruser", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 14))
//            descriptionLabel.text = "an example of last line of messsage that can contain a lot of text"
//            containerView.backgroundColor = UIColor(red: 246, green: 253, blue: 238, alpha: 1)
//        case .pendingInvite:
//            cancelDateButton.isHidden = true
//            acceptDateButton.isHidden = true
//            dateSentLabel.isHidden = true
//            titleLabel.attributedText = NSAttributedString(string: "you invited anotheruser, F 22", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 14), NSAttributedString.Key.foregroundColor : UIColor.white]).boldAppearenceOf(string: "anotheruser", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 14))
//            descriptionLabel.text = "awaiting a response"
//            descriptionLabel.textColor = UIColor.white
//            containerView.backgroundColor = UIColor(red: 151, green: 172, blue: 131, alpha: 1)
//        case .pendingResponse:
//            cancelDateButton.isHidden = true
//            acceptDateButton.isHidden = true
//            dateSentLabel.isHidden = true
//            titleLabel.attributedText = NSAttributedString(string: "you dated anotheruser, F 22", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 14), NSAttributedString.Key.foregroundColor : UIColor.white]).boldAppearenceOf(string: "anotheruser", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 14))
//            descriptionLabel.text = "awaiting their response"
//            descriptionLabel.textColor = UIColor.white
//            turnCellButton.tintColor = UIColor.white
//            containerView.backgroundColor = UIColor(red: 151, green: 172, blue: 131, alpha: 1)
//        }
//
//        return self
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelDateButton.isHidden = false
        acceptDateButton.isHidden = false
        turnCellButton.isHidden = false
        dateSentLabel.isHidden = false
        rescheduleDateView.isHidden = false
        cancelDateView.isHidden = false
        titleButton.isEnabled = true
        titleLabel.textColor = UIColor.darkBlue
        descriptionLabel.textColor = UIColor.gray(value: 172)
        turnCellButton.tintColor = UIColor(red: 111, green: 206, blue: 27, alpha: 1)
        containerView.backgroundColor = UIColor.white
    }
    
    //MARK: - Button actions
    
    @IBAction func didTapCellTitle(_ sender: Any) {
        if let invited = date?.invited, let invitee = date?.invitee {
            if invited.uid == UTUser.loggedUser?.userProfile?.uid {
                delegate?.didTapUserProfile(profile: invitee)
            } else {
                delegate?.didTapUserProfile(profile: invited)
            }
        }
    }
    
    @IBAction func didTapAcceptDate(_ sender: Any) {
        if let date = self.date {
            delegate?.didTapAcceptDate(date: date)
        }
    }
    @IBAction func didTapRejectDate(_ sender: Any) {
        if let date = self.date {
            delegate?.didTapRejectDate(date: date)
        }
    }
    @IBAction func didTapCancelDate(_ sender: Any) {
        if let date = self.date {
            delegate?.didTapCancelDate(date: date)
        }
    }
    @IBAction func didTapRescheduleDate(_ sender: Any) {
        if let date = self.date {
            delegate?.didTapRescheduleDate(date: date)
        }
    }
    
    @IBAction func didTapTurnButton(_ sender: Any) {
        if isFlipped {
            isFlipped = false
            UIView.transition(with: contentView, duration: 0.35, options: [.transitionFlipFromTop, .curveEaseInOut], animations: {
                self.containerView.alpha = 1
                self.flippedContainerView.alpha = 0
            }, completion: nil)
        } else {
            isFlipped = true
            UIView.transition(with: contentView, duration: 0.35, options: [.transitionFlipFromBottom], animations: {
                self.containerView.alpha = 0
                self.flippedContainerView.alpha = 1
            }, completion: nil)
        }
    }
    
}
