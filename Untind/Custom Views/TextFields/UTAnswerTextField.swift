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
    
    @IBInspectable var maxCharacters : Int = 10
    @IBInspectable var themeColor : UIColor = UIColor(red: 33, green: 208, blue: 185, alpha: 1) {
        didSet {
            quoteMark.tintColor = themeColor
        }
    }
    
    @IBInspectable var hasQuestionMark : Bool = false {
        didSet {
            questionMark.isHidden = !hasQuestionMark
        }
    }
    
    @IBInspectable var shouldHideLines : Bool = true {
        didSet {
            for (index,line) in lines.enumerated() {
                if index <= numberOfLines {
                    line.alpha = 1
                } else {
                    if shouldHideLines {
                        line.alpha = 1 - 0.2 * CGFloat(index - numberOfLines)
                    } else {
                        line.alpha = 1
                    }
                }
            }
        }
    }
    
    
    var textView : UITextView!
    var quoteMark : UIImageView!
    var questionMark : UIImageView!
    var lines : [UIView] = []
    var delegate : UITextViewDelegate?
    var charactersLabel : UILabel!
    
    private var lineSpacing : CGFloat = 37
    
    private var numberOfLines : Int = 0 {
        didSet {
            placeCharactersCounter()
            for (index,line) in lines.enumerated() {
                if index <= numberOfLines {
                    line.alpha = 1
                } else {
                    if shouldHideLines {
                        line.alpha = 1 - 0.2 * CGFloat(index - numberOfLines)
                    } else {
                        line.alpha = 1
                    }
                }
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialInit()
    }
    
    func initialInit() {
        self.clipsToBounds = false
        backgroundColor = UIColor.clear
        textView = UITextView(frame: CGRect.zero)
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        self.activateConstraints( [
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)])
        
        textView.textAlignment = .left
        textView.delegate = self
        textView.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textView.contentInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        
        let paraStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 18
        paraStyle.firstLineHeadIndent = 20
        
        textView.typingAttributes = [NSAttributedString.Key.foregroundColor : UIColor(red: 55, green: 73, blue: 85, alpha: 1), NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 16)!, NSAttributedString.Key.paragraphStyle : paraStyle]
        
        quoteMark = UIImageView(image: UIImage(named: "quote-icon"))
        quoteMark.tintColor = themeColor
        quoteMark.translatesAutoresizingMaskIntoConstraints = false
        addSubview(quoteMark)
        self.activateConstraints([
            quoteMark.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2),
            quoteMark.topAnchor.constraint(equalTo: self.topAnchor, constant: 5)])
        
        questionMark = UIImageView(image: UIImage(named: "question-mark"))
        questionMark.tintColor = themeColor
        questionMark.translatesAutoresizingMaskIntoConstraints = false
        addSubview(questionMark)
        self.activateConstraints( [
            questionMark.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            questionMark.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)])
        
        if hasQuestionMark == true {
            questionMark.isHidden = false
        } else {
            questionMark.isHidden = true
        }
        
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
        charactersLabel.text = "( \(self.textView.text.count) / \(maxCharacters) characters)"
        charactersLabel.sizeToFit()
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
                if shouldHideLines == true {
                    lineView.alpha = CGFloat(1.0 - (0.2 * Double(lines.count)))
                } else {
                    lineView.alpha = 1
                }
                addSubview(lineView)
                lines.append(lineView)
                currentLineY += lineSpacing
            }
            return
        }
        
        var currentLineY = lineSpacing
        for (index,line) in lines.enumerated() {
            var lineWidth = frame.size.width - 4
            if index == 0 || (index == lines.count-1 && hasQuestionMark){
                lineWidth = frame.size.width-26
            }
            
            line.frame = CGRect(x: index == 0 ? 26 : 0, y: currentLineY, width: lineWidth, height: 0.5)
            if index > numberOfLines && shouldHideLines {
                line.alpha = CGFloat(1 - (0.2 * Double(index) - Double(numberOfLines)))
            }
            
            currentLineY += lineSpacing
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.textViewDidEndEditing?(textView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange?(textView)
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
        
        return changedText.count <= maxCharacters && delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }
}
