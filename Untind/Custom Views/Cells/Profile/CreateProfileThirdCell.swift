//
//  CreateProfileThirdCell.swift
//  Untind
//
//  Created by Mihai Honceriu on 25/03/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit
import MultiSlider

class CreateProfileThirdCell: UICollectionViewCell {

    @IBOutlet weak var multiSlider: MultiSlider!
    @IBOutlet weak var menFilterButton: UIButton!
    @IBOutlet weak var womenFilterButton: UIButton!
    weak var delegate : CreateProfileDelegate?
    private var selectedUserSettings: UserSettings = UserSettings()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        multiSlider.valueLabelPosition = .top
        multiSlider.valueLabels.forEach { (textfield) in
            textfield.textColor = UIColor.darkBlue
            textfield.font = UIFont.helveticaNeue(weight: .medium, size: 14)
        }
        multiSlider.addTarget(self, action: #selector(sliderChanged(slider:)), for: .valueChanged)
    }

    @IBAction func didTapMenFilter(_ sender: Any) {
        menFilterButton.isSelected = !menFilterButton.isSelected
        selectedUserSettings.prefferedGender = menFilterButton.isSelected ? ( womenFilterButton.isSelected ? .both : .male) : .male
    }
    
    @IBAction func didTapWomenFilter(_ sender: Any) {
        womenFilterButton.isSelected = !womenFilterButton.isSelected
        selectedUserSettings.prefferedGender = womenFilterButton.isSelected ? ( menFilterButton.isSelected ? .both : .female) : .female

    }
    
   @objc func sliderChanged(slider: MultiSlider) {
        selectedUserSettings.ageRange = (Int(slider.value[0]), Int(slider.value[1]))
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        delegate?.selected(userSettings: selectedUserSettings)
        delegate?.didTapNext()
    }
}
