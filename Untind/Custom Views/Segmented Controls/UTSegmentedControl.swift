//
//  UTSegmentedControl.swift
//  Untind
//
//  Created by Honceriu Mihai on 11/10/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

@IBDesignable class UTSegmentedControl: UIView {
    
    @IBInspectable var selectedBackgroundColor : UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    @IBInspectable var selectedTextColor : UIColor = UIColor(red: 81, green: 81, blue: 81, alpha: 1)
    @IBInspectable var unselectedTextColor : UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    
    @IBInspectable var sectionOneText : String = "Section 1"
    @IBInspectable var sectionTwoText : String = "Section 2"
    
    @IBInspectable var font : UIFont = UIFont(name: "HelveticaNeue-Medium", size: 16)!
    
    private var isInterfaceBuilder : Bool = false
    
    private var leftButton : UIButton
    private var rightButton : UIButton
    private var buttonsStackView : UIStackView
    private var selectedView : UIView
    private var selectedViewLeadingConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        leftButton = UIButton()
        rightButton = UIButton()
        buttonsStackView = UIStackView(arrangedSubviews: [leftButton, rightButton])
        selectedView = UIView()
        
        super.init(frame: frame)
        layer.cornerRadius = 30
        
        leftButton.titleLabel?.font = self.font
        leftButton.setTitle(sectionOneText, for: .normal)
        leftButton.addTarget(self, action: #selector(didTapSectionOne), for: .touchUpInside)
        
        rightButton.titleLabel?.font = self.font
        rightButton.setTitle(sectionOneText, for: .normal)
        rightButton.addTarget(self, action: #selector(didTapSectionTwo), for: .touchUpInside)
        
        
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.alignment = .fill
        
        addSubview(buttonsStackView)
        activateConstraints(constraints: [
            buttonsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: self.topAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        
        addSubview(selectedView)
        
        selectedViewLeadingConstraint =  selectedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2)
        activateConstraints(constraints: [selectedView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
                                          selectedViewLeadingConstraint!,
                                          selectedView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2)])
        
        selectedView.activateConstraints(constraints: [selectedView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -2)])
    }
    
    required init?(coder: NSCoder) {
        leftButton = UIButton()
        rightButton = UIButton()
        buttonsStackView = UIStackView(arrangedSubviews: [leftButton, rightButton])
        selectedView = UIView()
        
        super.init(coder: coder)
        layer.cornerRadius = 30
        
        leftButton.titleLabel?.font = self.font
        leftButton.setTitle(sectionOneText, for: .normal)
        leftButton.addTarget(self, action: #selector(didTapSectionOne), for: .touchUpInside)
        
        rightButton.titleLabel?.font = self.font
        rightButton.setTitle(sectionOneText, for: .normal)
        rightButton.addTarget(self, action: #selector(didTapSectionTwo), for: .touchUpInside)
        
        
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.alignment = .fill
        
        addSubview(buttonsStackView)
        activateConstraints(constraints: [
            buttonsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: self.topAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        
        addSubview(selectedView)
        
        selectedViewLeadingConstraint =  selectedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2)
        activateConstraints(constraints: [selectedView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
                                          selectedViewLeadingConstraint!,
                                          selectedView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2)])
        
        selectedView.activateConstraints(constraints: [selectedView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -2)])
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        isInterfaceBuilder = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if !isInterfaceBuilder {
            
        }
    }
    private func render() {
        
    }
    
    private func setup() {
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let completionPercentage = min((scrollView.contentOffset.x * 100) / scrollView.frame.size.width, 100)
        
        selectedViewLeadingConstraint?.constant = max((selectedView.frame.size.width/2 - 2) * completionPercentage/100,2)
         
        let firstButtonColor = UIColor.fadeFromColor(fromColor: selectedTextColor, toColor: unselectedTextColor, withPercentage: completionPercentage/100)
            leftButton.setTitleColor(firstButtonColor, for: .normal)
            
        let secondButtonColor = UIColor.fadeFromColor(fromColor: unselectedTextColor, toColor: selectedTextColor, withPercentage: completionPercentage/100)
            rightButton.setTitleColor(secondButtonColor, for: .normal)

    }
  
    
    @objc func didTapSectionOne() {
        
    }
    
    @objc func didTapSectionTwo() {
           
    }
    

}
