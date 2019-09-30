//
//  UTTextField.swift
//  Untind
//
//  Created by Honceriu Mihai on 03/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

//@IBDesignable
class UTAnswerTextField: UIView, UITextViewDelegate {

    var textField : UITextView!
    var quoteMark : UIImageView!
    var lines : [UIView] = []
    var delegate : UITextFieldDelegate?
    var charactersLabel : UILabel!
    
    private var lineSpacing : CGFloat = 37
    @IBInspectable var maxCharacters : Int = 10
    @IBInspectable var themeColor : UIColor = UIColor(red: 33, green: 208, blue: 185, alpha: 1) {
        didSet {
            quoteMark.tintColor = themeColor
        }
    }
    
    private var numberOfLines : Int = 0 {
        didSet {
            placeCharactersCounter()
            for (index,line) in lines.enumerated() {
                if index <= numberOfLines {
                    line.alpha = 1
                } else {
                    line.alpha = 1 - 0.2 * CGFloat(index - numberOfLines)
                }
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.clipsToBounds = false
        backgroundColor = UIColor.clear
        textField = UITextView(frame: CGRect.zero)
        addEdgeConstrainedSubView(view: textField)
        textField.textAlignment = .left
        textField.delegate = self
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.contentInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        textField.isScrollEnabled = false

        let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 18
        paraStyle.firstLineHeadIndent = 20
        
        textField.typingAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 55, green: 73, blue: 85, alpha: 1), NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 16)!, NSAttributedString.Key.paragraphStyle : paraStyle]
        
        quoteMark = UIImageView(image: UIImage(named: "quote-icon"))
        quoteMark.tintColor = themeColor
        
        addSubview(quoteMark)
        self.activateConstraints(constraints: [
            quoteMark.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            quoteMark.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)])
        
        charactersLabel = UILabel(frame: .zero)
        charactersLabel.font = UIFont(name: "HelveticaNeue", size: 10)
        charactersLabel.text = "( 0 / \(maxCharacters) characters)"
        charactersLabel.textColor = UIColor(red: 88, green: 88, blue: 88, alpha: 1)
        charactersLabel.sizeToFit()
        addSubview(charactersLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calculateLines()
        placeCharactersCounter()
        charactersLabel.text = "( 0 / \(maxCharacters) characters)"
    }
    
    private func placeCharactersCounter() {
        guard lines.count > numberOfLines-1 else {
            return
        }
        
        let currentLineFrame = lines[max(0,numberOfLines-1)].frame
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.charactersLabel.frame = CGRect(x: currentLineFrame.origin.x+currentLineFrame.size.width-self.charactersLabel.frame.width, y: currentLineFrame.origin.y + 6, width: self.charactersLabel.frame.width, height: self.charactersLabel.frame.height)

        }, completion: nil)
    }
    
    private func calculateLines() {
        
        guard lines.count > 0 else {
            var currentLineY = lineSpacing
            while currentLineY <= frame.size.height {
                let lineView = UIView(frame: CGRect(x: lines.count == 0 ? 26 : 0, y: currentLineY, width: lines.count == 0 ? frame.size.width-26 : frame.size.width - 4, height: 0.5))
                lineView.backgroundColor = themeColor
                lineView.alpha = CGFloat(1.0 - (0.2 * Double(lines.count)))
                addSubview(lineView)
                lines.append(lineView)
                currentLineY += lineSpacing
            }
            return
        }
        
        var currentLineY = lineSpacing
        for (index,line) in lines.enumerated() {
            line.frame = CGRect(x: index == 0 ? 26 : 0, y: currentLineY, width: index == 0 ? frame.size.width-26 : frame.size.width - 4, height: 0.5)
            if index > numberOfLines {
                line.alpha = CGFloat(1 - (0.2 * Double(index) - Double(numberOfLines)))
            }
            
            currentLineY += lineSpacing
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let layoutManager = textView.layoutManager
        var numberOfLines : Int = 0
        var index : Int = 0
        var range = NSRange(location: 0, length: 0)
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        
        while index < numberOfGlyphs {
            
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &range)
            index = NSMaxRange(range)
            numberOfLines = numberOfLines + 1
        }
        
        self.numberOfLines = numberOfLines
        
        charactersLabel.text = "( \(textView.text.count) / \(maxCharacters) characters)"
        charactersLabel.sizeToFit()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        if changedText.count > maxCharacters {
            self.charactersLabel.shake()
        }
        
        return changedText.count <= maxCharacters
    }
}
