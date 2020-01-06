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
    func didTapRejectDate(date: UntindDate)
    func didTapAcceptDate(date: UntindDate)
    func didTapCancelDate(date: UntindDate)
    func didTapRescheduleDate(date: UntindDate)
    func didTapDate(date: UntindDate)
}

extension DateDelegate {
    func didTapDate(date: UntindDate) {
        
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
    @IBOutlet weak var dateButtonsStackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    weak var delegate : DateDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10.0
    }
    
    @discardableResult
    func update(with type: DateCellTestType) -> DateCollectionViewCell {
        switch type {
        case .newDateRequest:
            turnCellButton.isHidden = true
            dateSentLabel.isHidden = true

            
            titleLabel.attributedText = NSAttributedString(string: "randomusername, F 24", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 14)]).boldAppearenceOf(string: "randomusername", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 14))
            descriptionLabel.text = "sent you a date request"
        case .upcomingDate:
            cancelDateButton.isHidden = true
            acceptDateButton.isHidden = true
            dateSentLabel.isHidden = true
            titleLabel.attributedText = NSAttributedString(string: "anotheruser, F 25, invited you", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 14), NSAttributedString.Key.foregroundColor : UIColor.darkBlue]).boldAppearenceOf(string: "anotheruser", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 14))
            descriptionLabel.attributedText = NSAttributedString(string: "Date starting in 00:15 min", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 12), NSAttributedString.Key.foregroundColor : UIColor.gray(value: 172)]).boldAppearenceOf(string: "00:15 min", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 12), color: UIColor.darkBlue)
        case .activeDate1:
            cancelDateButton.isHidden = true
            acceptDateButton.isHidden = true
            dateSentLabel.isHidden = true
            turnCellButton.isHidden = true
            titleLabel.attributedText = NSAttributedString(string: "anotheruser, F 22", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 14), NSAttributedString.Key.foregroundColor : UIColor.darkBlue, ]).boldAppearenceOf(string: "anotheruser", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 14))
            descriptionLabel.attributedText = NSAttributedString(string: "Date ends in 00:04 min", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 12), NSAttributedString.Key.foregroundColor : UIColor.gray(value: 172)]).boldAppearenceOf(string: "00:04 min", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 12), color: UIColor.darkBlue)
        case .activeDate2:
            cancelDateButton.isHidden = true
            acceptDateButton.isHidden = true
            turnCellButton.isHidden = true
            titleLabel.attributedText = NSAttributedString(string: "anotheruser, F 22", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 14), NSAttributedString.Key.foregroundColor : UIColor.darkBlue]).boldAppearenceOf(string: "anotheruser", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 14))
            descriptionLabel.text = "an example of last line of messsage that can contain a lot of text"
            containerView.backgroundColor = UIColor(red: 246, green: 253, blue: 238, alpha: 1)
        case .pendingInvite:
            cancelDateButton.isHidden = true
            acceptDateButton.isHidden = true
            dateSentLabel.isHidden = true
            titleLabel.attributedText = NSAttributedString(string: "you invited anotheruser, F 22", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 14), NSAttributedString.Key.foregroundColor : UIColor.white]).boldAppearenceOf(string: "anotheruser", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 14))
            descriptionLabel.text = "awaiting a response"
            descriptionLabel.textColor = UIColor.white
            containerView.backgroundColor = UIColor(red: 151, green: 172, blue: 131, alpha: 1)
        case .pendingResponse:
            cancelDateButton.isHidden = true
            acceptDateButton.isHidden = true
            dateSentLabel.isHidden = true
            titleLabel.attributedText = NSAttributedString(string: "you dated anotheruser, F 22", attributes: [NSAttributedString.Key.font : UIFont.helveticaNeue(weight: .regular, size: 14), NSAttributedString.Key.foregroundColor : UIColor.white]).boldAppearenceOf(string: "anotheruser", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: 14))
            descriptionLabel.text = "awaiting their response"
            descriptionLabel.textColor = UIColor.white
            turnCellButton.tintColor = UIColor.white
            containerView.backgroundColor = UIColor(red: 151, green: 172, blue: 131, alpha: 1)
        }
        
        return self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancelDateButton.isHidden = false
        acceptDateButton.isHidden = false
        turnCellButton.isHidden = false
        dateSentLabel.isHidden = false
        turnCellButton.tintColor = UIColor(red: 111, green: 206, blue: 27, alpha: 1)
        containerView.backgroundColor = UIColor.white
    }
    
    //MARK: - Button actions
    
    @IBAction func didTapAcceptDate(_ sender: Any) {
        delegate?.didTapAcceptDate(date: UntindDate())
    }
    
}
