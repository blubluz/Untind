//
//  VoteButton.swift
//  Untind
//
//  Created by Honceriu Mihai on 05/11/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

enum VoteType {
    case upvote
    case downvote
}

@IBDesignable
class VoteButton: UIButton {

    lazy var outerCircleView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    lazy var thumbImage : UIImageView = {
       let imgView = UIImageView()
        imgView.image = UIImage(named: "upvote_finger")
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.isUserInteractionEnabled = false
        return imgView
    }()
    
    lazy var circleView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.teal2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    
    var voteType : VoteType = .upvote {
        didSet {
            switch voteType {
            case .upvote:
                thumbImage.image = UIImage(named: "upvote_finger")
                circleView.backgroundColor = UIColor.teal2
            case .downvote:
                thumbImage.image = UIImage(named: "downvote_finger")
                circleView.backgroundColor = UIColor.flatOrange
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        circleView.layer.cornerRadius = rect.width/2
        outerCircleView.layer.cornerRadius = rect.width/2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    func select (animated: Bool) {
        isSelected = true
        performSelection(animated: animated)
    }
    
    func deselect (animated: Bool) {
        
        isSelected = false
        performSelection(animated: animated)
    }
    
    private func performSelection(animated : Bool) {
        if isSelected == true {
            UIView.animate(withDuration: animated ? 0.4 : 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
                self.circleView.transform = CGAffineTransform.identity
            }, completion: nil)
            UIView.animate(withDuration: animated ? 0.2: 0, delay: 0.1, options: .curveLinear, animations: {
                self.outerCircleView.alpha = 0
            }, completion: nil)
        } else {
            UIView.animate(withDuration: animated ? 0.4 : 0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
                self.circleView.transform = CGAffineTransform(scaleX: 0, y: 0)
            }, completion: nil)
            UIView.animate(withDuration: animated ? 0.2 : 0, delay: 0.1, options: .curveLinear, animations: {
                self.outerCircleView.alpha = 1
            }, completion: nil)
        }
    }
    
    func setupView() {
        self.titleLabel?.text = ""
        addSubview(circleView)
        addSubview(outerCircleView)
        addSubview(thumbImage)
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: self.topAnchor),
            circleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            circleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            circleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        
            
            outerCircleView.topAnchor.constraint(equalTo: self.topAnchor),
            outerCircleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            outerCircleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            outerCircleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            thumbImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            thumbImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            thumbImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            thumbImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        ])
        
        circleView.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}
