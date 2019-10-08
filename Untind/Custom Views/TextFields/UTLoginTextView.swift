//
//  UTLoginTextView.swift
//  Untind
//
//  Created by Honceriu Mihai on 30/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

@IBDesignable
class UTLoginTextView: UIView {

    private var textField : UITextField!
    private var title : UILabel!
    private var underline : UIView!
    
    var text : String? {
        return textField.text
    }
    
    @IBInspectable var secureTextEntry: Bool {
        get {
            return textField.isSecureTextEntry
        }
        set {
            self.textField.isSecureTextEntry = newValue
        }
    }
    
    @IBInspectable var underlineColor: UIColor {
        
        get {
            return underline.backgroundColor!
        }
        set {
            self.underline.backgroundColor = newValue
        }
    }
    
    @IBInspectable var titleText: String {
        get {
            return title.text!
        }
        set {
            title.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    private func setupViews() {
        self.clipsToBounds = false
        backgroundColor = UIColor.clear
        
        title = UILabel(frame: CGRect.zero)
        title.textColor = UIColor(red: 60, green: 79, blue: 92, alpha: 1)
        title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
        self.activateConstraints(constraints: [
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 3),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 3),
            title.heightAnchor.constraint(equalToConstant: 15)])
        title.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        title.text = "Title"
        
        textField = UITextField(frame: CGRect.zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        self.activateConstraints(constraints: [
            textField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 3)])
        textField.borderStyle = .none
        textField.textColor = UIColor.black
        textField.font = UIFont(name: "HelveticaNeue", size: 14)


        underline = UIView(frame: .zero)
        underline.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(underline)
        self.activateConstraints(constraints: [
            underline.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 1),
            underline.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3),
            underline.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 3),
            underline.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 2)])
        underline.backgroundColor = UIColor.flatOrange
    }
}
