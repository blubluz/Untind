//
//  UTPageControl.swift
//  Untind
//
//  Created by Honceriu Mihai on 30/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

@IBDesignable
class UTPageControl: UIView {

    @IBInspectable var numberOfPages: Int = 3 {
        didSet {
            for dot in dots {
                dot.removeFromSuperview()
            }
            dots = []
            dotsWidthConstraints = []
            pageControlWidthConstraint?.constant =  2 * 6 * CGFloat(numberOfPages)
            setupDots()
        }
    }
    
    private var _selectedPageIndex: Int?
    var selectedPageIndex: Int!  {
        get {
            return dots.lastIndex(where: { (view) -> Bool in
                return view.backgroundColor == UIColor.white
            })
        }
        set {
            dots[self.correctLeftToRight[newValue]].backgroundColor = UIColor.white
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveLinear, animations: {
                
                self.dotsWidthConstraints[self.correctLeftToRight[newValue]].constant = 54
                if self._selectedPageIndex != nil {
                    self.dotsWidthConstraints[self.correctLeftToRight[self._selectedPageIndex!]].constant = 6
                    self.dots[self.correctLeftToRight[self._selectedPageIndex!]].backgroundColor = UIColor(red: 128, green: 75, blue: 66, alpha: 1)
                }
                self.layoutIfNeeded()
            }, completion: {
                success in
                self._selectedPageIndex = newValue
            })
        }
    }
    
    private var dots : [UIView]! = []
    private var dotsWidthConstraints : [NSLayoutConstraint]! = []
    private var pageControlWidthConstraint : NSLayoutConstraint?
    private var correctLeftToRight : [Int] {
        var array : [Int] = []
        for i in stride(from: numberOfPages-1, to: 0, by: -2) {
            array.append(i)
        }
        
        
        for i in stride(from: 0, through: numberOfPages, by: 2) {
            array.append(i)
        }
        
        return array
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDots()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDots()
    }
    
    private func setupDots() {
        self.backgroundColor = UIColor.clear
        if pageControlWidthConstraint == nil {
            pageControlWidthConstraint = widthAnchor.constraint(equalToConstant: 2 * 6 * CGFloat(numberOfPages))
            self.activateConstraints(constraints: [self.heightAnchor.constraint(equalToConstant: 6),
                                                   pageControlWidthConstraint!])
        }
        
        for i in 0..<numberOfPages {
            var dot : UIView
            dot = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
            dot.layer.cornerRadius = 3
            dot.backgroundColor = UIColor(red: 128, green: 75, blue: 66, alpha: 1)
            dot.translatesAutoresizingMaskIntoConstraints = false
            addSubview(dot)
            let widthConstraint = dot.widthAnchor.constraint(equalToConstant: 6)
            dotsWidthConstraints.append(widthConstraint)
            dots.append(dot)
            
            if i == 0{
                self.activateConstraints(constraints: [
                    dot.centerXAnchor.constraint(equalTo: centerXAnchor, constant: numberOfPages % 2 == 0 ? 3 : 0),
                    dot.centerYAnchor.constraint(equalTo: centerYAnchor),
                    widthConstraint,
                    dot.heightAnchor.constraint(equalToConstant: 6)])
                
            } else {
                var constraint : NSLayoutConstraint?
                if i == 1 {
                    constraint = dot.trailingAnchor.constraint(equalTo: dots[0].leadingAnchor, constant: -6)
                } else {
                    if i%2 == 0 {
                        constraint = dot.leadingAnchor.constraint(equalTo: dots[i-2].trailingAnchor, constant: 6)
                    } else {
                        constraint = dot.trailingAnchor.constraint(equalTo: dots[i-2].leadingAnchor, constant: -6)
                    }
                }
                self.activateConstraints(constraints: [constraint!,
                    dot.centerYAnchor.constraint(equalTo: centerYAnchor),
                    widthConstraint,
                    dot.heightAnchor.constraint(equalToConstant: 6)])
            }
            self.layoutIfNeeded()
        }
    }

}
