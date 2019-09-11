//
//  CreateProfileFirstCell.swift
//  Untind
//
//  Created by Honceriu Mihai on 30/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class CreateProfileFirstCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: CreateProfileDelegate?
    
    var selectedAvatarIndex = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func previousAvatarTapped(_ sender: Any) {
        selectedAvatarIndex = selectedAvatarIndex - 1
        if selectedAvatarIndex < 1 {
            selectedAvatarIndex = 50
        }
        
        avatarImageView.image = UIImage(named: "avatar-\(selectedAvatarIndex)")
        
        delegate?.selected(avatar: "avatar-\(selectedAvatarIndex)")
        
    }
    @IBAction func nextAvatarTapped(_ sender: Any) {
    
        selectedAvatarIndex = selectedAvatarIndex + 1
        if selectedAvatarIndex > 50 {
            selectedAvatarIndex = 1
        }
        
        avatarImageView.image = UIImage(named: "avatar-\(selectedAvatarIndex)")
        
        delegate?.selected(avatar: "avatar-\(selectedAvatarIndex)")
    }
    
    @IBAction func textFieldDidEndEditing(_ sender: Any) {
        delegate?.selected(name: usernameTextField.text ?? "NoName")
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if usernameTextField.text != "" {
            delegate?.selected(name: usernameTextField.text)
        }
        
        delegate?.selected(avatar: "avatar-\(selectedAvatarIndex)")
        delegate?.didTapNext()
    }
}
