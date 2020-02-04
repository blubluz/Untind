//
//  WarningCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 04/02/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit

class WarningCell: UICollectionViewCell {
    
    let bubbleView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.darkBlue
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
    }()
    
    let warningImage : UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "warning-icon")
        iv.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let warningLabel : UILabel = {
       let lb = UILabel()
        lb.font = UIFont.helveticaNeue(weight: .regular, size: 14)
        lb.textColor = UIColor.white
        lb.text = "Sample warning"
        lb.backgroundColor = UIColor.clear
        lb.isUserInteractionEnabled = false
        lb.numberOfLines = 0
        return lb
    }()
    
    let stackView : UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.spacing = 10
        return sv
    }()
    
    func setupViews () {
        addSubview(bubbleView)
        addSubview(stackView)
        stackView.addArrangedSubview(warningImage)
        stackView.addArrangedSubview(warningLabel)
        
        stackView.activateConstraints([
            stackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 5),
            stackView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: 5)])
        
    }
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          setupViews()
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
          setupViews()
      }
    
    func configureWithMessage(message: NSAttributedString, hasWarningIcon: Bool = false) {
        warningLabel.attributedText = message
        if !hasWarningIcon {
            self.warningImage.isHidden = true
        } else {
            self.warningImage.isHidden = false
        }
        
        let size = CGSize(width: 250, height: CGFloat.infinity)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: message.string).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.helveticaNeue(weight: .regular, size: 16), NSAttributedString.Key.paragraphStyle : NSAttributedString.lineSpacingParagraphStyle(spacing: 5)], context: nil)
        
        
        let leftRightMaxPadding : CGFloat = 30
               
        let x : CGFloat = max((UIScreen.main.bounds.size.width - estimatedFrame.width) / 2, leftRightMaxPadding)
        self.bubbleView.frame = CGRect(x: x, y: 0, width: estimatedFrame.width, height: estimatedFrame.height + 28)

    }
}
