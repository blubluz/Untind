//
//  CreateProfileSecondCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 01/09/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

protocol CreateProfileDelegate: class {
    func didTapNext()
    func didTapBack()
    func selected(name: String?)
    func selected(avatar: String?)
    func selected(gender: Gender?)
    func selected(age: Int?)
    func selected(userSettings: UserSettings?)
}

class CreateProfileSecondCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var ageTextField: UITextField!
    weak var delegate: CreateProfileDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        maleButton.imageView?.contentMode = .scaleAspectFit
        femaleButton.imageView?.contentMode = .scaleAspectFit
        
        ageTextField.layer.cornerRadius = 12
        ageTextField.layer.borderWidth = 2
        ageTextField.layer.borderColor = UIColor.flatOrange.cgColor
        
        maleButton.imageView?.contentMode = .redraw
        femaleButton.imageView?.contentMode = .redraw
    }

    @IBAction func didTapMaleButton(_ sender: Any) {
        maleButton.setImage(UIImage(named: "male-icon-selected"), for: .normal)
        femaleButton.setImage(UIImage(named: "woman-icon"), for: .normal)
        delegate?.selected(gender: .male)
        
    }
    
    @IBAction func didTapFemaleButton(_ sender: Any) {
        maleButton.setImage(UIImage(named: "male-icon"), for: .normal)
        femaleButton.setImage(UIImage(named: "female-icon-selected"), for: .normal)
        delegate?.selected(gender: .female)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.didTapBack()
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        if let ageString = ageTextField.text, ageString != "" {
            delegate?.selected(age: Int(ageString))
        }
        
        delegate?.didTapNext()
    }
    
}
