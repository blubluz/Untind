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
            resetLayout()
        }
    }
    
    @IBInspectable var unselectedDotWidth: CGFloat = 6 {
        didSet {
            resetLayout()
        }
    }
    
    @IBInspectable var selectedDotWidth: CGFloat = 54 {
        didSet {
            resetLayout()
        }
    }
    
    @IBInspectable var dotSpacing: CGFloat = 6 {
        didSet {
            resetLayout()
        }
    }
    
    @IBInspectable var unselectedDotsColor: UIColor = UIColor.defaultColorPageControlUnselected {
        didSet {
            resetLayout()
        }
    }
    
    @IBInspectable var selectedDotsColor: UIColor  = UIColor.white {
        didSet {
            resetLayout()
        }
    }
    
    private var _selectedPageIndex: Int?
    var selectedPageIndex: Int!  {
        get {
            return _selectedPageIndex ?? 0
        }
        set {
            guard newValue != self._selectedPageIndex else {
                return
            }
            dots[self.correctLeftToRight[newValue]].backgroundColor = UIColor.white
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: .curveLinear, animations: {
                
                self.dotsWidthConstraints[self.correctLeftToRight[newValue]].constant = self.selectedDotWidth
                if self._selectedPageIndex != nil {
                    self.dotsWidthConstraints[self.correctLeftToRight[self._selectedPageIndex!]].constant = self.unselectedDotWidth
                    self.dots[self.correctLeftToRight[self._selectedPageIndex!]].backgroundColor = self.unselectedDotsColor
                }
                self.layoutIfNeeded()
            }, completion: {
                success in
                self.layoutIfNeeded()
                self._selectedPageIndex = newValue
            })
        }
    }
    
    private var dots : [UIView]! = []
    private var dotsWidthConstraints : [NSLayoutConstraint]! = []
    private var pageControlWidthConstraint : NSLayoutConstraint?
    private var correctLeftToRight : [Int] {
        var array : [Int] = []
        for i in stride(from: numberOfPages%2==0 ? numberOfPages-1:numberOfPages-2, to: 0, by: -2) {
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
            pageControlWidthConstraint = widthAnchor.constraint(equalToConstant: 2 * self.unselectedDotWidth * CGFloat(max(0,numberOfPages-1)) + selectedDotWidth)
            self.activateConstraints([self.heightAnchor.constraint(equalToConstant: 6),
                                                   pageControlWidthConstraint!])
        }
        
        for i in 0..<numberOfPages {
            var dot : UIView
            dot = UIView(frame: CGRect(x: 0, y: 0, width: self.unselectedDotWidth, height: 6))
            dot.layer.cornerRadius = 3
            dot.backgroundColor = self.unselectedDotsColor
            dot.translatesAutoresizingMaskIntoConstraints = false
            addSubview(dot)
            let widthConstraint = dot.widthAnchor.constraint(equalToConstant: self.unselectedDotWidth)
            dotsWidthConstraints.append(widthConstraint)
            dots.append(dot)
            
            if i == 0{
                self.activateConstraints( [
                    dot.centerXAnchor.constraint(equalTo: centerXAnchor, constant: numberOfPages % 2 == 0 ? 3 : 0),
                    dot.centerYAnchor.constraint(equalTo: centerYAnchor),
                    widthConstraint,
                    dot.heightAnchor.constraint(equalToConstant: 6)])
                
            } else {
                var constraint : NSLayoutConstraint?
                if i == 1 {
                    constraint = dot.trailingAnchor.constraint(equalTo: dots[0].leadingAnchor, constant: -dotSpacing)
                } else {
                    if i%2 == 0 {
                        constraint = dot.leadingAnchor.constraint(equalTo: dots[i-2].trailingAnchor, constant: dotSpacing)
                    } else {
                        constraint = dot.trailingAnchor.constraint(equalTo: dots[i-2].leadingAnchor, constant: -dotSpacing)
                    }
                }
                self.activateConstraints( [constraint!,
                    dot.centerYAnchor.constraint(equalTo: centerYAnchor),
                    widthConstraint,
                    dot.heightAnchor.constraint(equalToConstant: 6)])
            }
            
            self.layoutIfNeeded()
        }
    }
    
    private func resetLayout() {
        for dot in dots {
            dot.removeFromSuperview()
        }
        dots = []
        dotsWidthConstraints = []
        pageControlWidthConstraint?.constant =  (dotSpacing + unselectedDotWidth) * CGFloat(max(0,numberOfPages-1)) + selectedDotWidth
        setupDots()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var completionPercentage = (scrollView.contentOffset.x - (CGFloat(_selectedPageIndex!) * scrollView.frame.size.width))/scrollView.frame.size.width
        
        if completionPercentage > 1 {
            completionPercentage = 1
        } else if completionPercentage < -1 {
            completionPercentage = -1
        }
        let nextPageIndex = completionPercentage > 0 ? min(_selectedPageIndex!+1,numberOfPages-1) : max(_selectedPageIndex!-1,0)
        let selecteddotTransitionColor = UIColor.fadeFromColor(fromColor: unselectedDotsColor, toColor: selectedDotsColor, withPercentage: abs(completionPercentage))
        let selectedTransitionWidth =  unselectedDotWidth + ((selectedDotWidth-unselectedDotWidth) * (abs(completionPercentage)))
        let unselectedTransitionWidth =  selectedDotWidth - ((selectedDotWidth-unselectedDotWidth) * (abs(completionPercentage)))
        let unselectedDotTransitionColor = UIColor.fadeFromColor(fromColor: selectedDotsColor, toColor: unselectedDotsColor, withPercentage: abs(completionPercentage))


        dots[correctLeftToRight[nextPageIndex]].backgroundColor = selecteddotTransitionColor
        dotsWidthConstraints[correctLeftToRight[nextPageIndex]].constant = selectedTransitionWidth
        if _selectedPageIndex != nil {
            dotsWidthConstraints[correctLeftToRight[_selectedPageIndex!]].constant = unselectedTransitionWidth
            dots[correctLeftToRight[_selectedPageIndex!]].backgroundColor = unselectedDotTransitionColor
        }
        if completionPercentage == 1 || completionPercentage == -1 {
            _selectedPageIndex = nextPageIndex
        }
        
        self.layoutIfNeeded()
    }
}
