//
//  FiltersViewController.swift
//  Untind
//
//  Created by Mihai Honceriu on 27/03/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import UIKit
import MultiSlider
class FiltersViewController: UIViewController {

    
    @IBOutlet weak var multiSlider: MultiSlider!
    @IBOutlet weak var menFilterButton: UIButton!
    @IBOutlet weak var womenFilterButton: UIButton!
    weak var delegate : CreateProfileDelegate?
    private var selectedUserSettings: UserSettings = UserSettings()
    
    @IBOutlet weak var containerView: UIView!
    
    private var didApplyCosmetics : Bool = false
    private var blurEffectView : UIVisualEffectView?
    
    //MARK: - Helper methods
    static func instantiate(withUserSettings userSettings : UserSettings) -> FiltersViewController {
           let vc = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
        vc.selectedUserSettings = userSettings
           return vc
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        multiSlider.valueLabelPosition = .top
        multiSlider.valueLabels.forEach { (textfield) in
            textfield.textColor = UIColor.darkBlue
            textfield.font = UIFont.helveticaNeue(weight: .medium, size: 14)
        }
        multiSlider.addTarget(self, action: #selector(sliderChanged(slider:)), for: .valueChanged)
        
        switch selectedUserSettings.prefferedGender {
        case .male, .both:
            self.menFilterButton.isSelected = true
            fallthrough
        case .female, .both:
            self.womenFilterButton.isSelected = true
        }
        
        self.multiSlider.value[0] = CGFloat(selectedUserSettings.ageRange.0)
        self.multiSlider.value[1] = CGFloat(selectedUserSettings.ageRange.1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didApplyCosmetics {
            didApplyCosmetics = true
            containerView.layer.cornerRadius = 12
            containerView.clipsToBounds = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        containerView.transform = CGAffineTransform(translationX: 0, y: 800)
        applyBlurEffect()
        UIView.animate(withDuration: 0.4) {
            self.blurEffectView?.alpha = 1
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.containerView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    //MARK: - Cosmetics
    func applyBlurEffect() {
        self.view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.blurEffectView = blurEffectView
        view.addSubview(blurEffectView)
        for subview in view.subviews {
            if subview is UIVisualEffectView {
                continue
            }
            view.bringSubviewToFront(subview)
        }
    }
    
    //Mark: - Actions
    @IBAction func closeButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.blurEffectView?.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 800)
        }) { (completed) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func didTapMenFilter(_ sender: Any) {
        if menFilterButton.isSelected && !womenFilterButton.isSelected {
            return
        }
          menFilterButton.isSelected = !menFilterButton.isSelected
          selectedUserSettings.prefferedGender = menFilterButton.isSelected ? ( womenFilterButton.isSelected ? .both : .male) : .female
      }
      
      @IBAction func didTapWomenFilter(_ sender: Any) {
        if womenFilterButton.isSelected && !menFilterButton.isSelected {
            return
        }
        
          womenFilterButton.isSelected = !womenFilterButton.isSelected
          selectedUserSettings.prefferedGender = womenFilterButton.isSelected ? ( menFilterButton.isSelected ? .both : .female) : .male

      }
      
     @objc func sliderChanged(slider: MultiSlider) {
          selectedUserSettings.ageRange = (Int(slider.value[0]), Int(slider.value[1]))
      }
      
      @IBAction func confirmButtonTapped(_ sender: Any) {
        UTUser.loggedUser?.userProfile?.settings = selectedUserSettings
        UTUser.loggedUser?.saveUserProfile(locally: true)
        UIView.animate(withDuration: 0.25, animations: {
                    self.blurEffectView?.alpha = 0
                    self.containerView.transform = CGAffineTransform(translationX: 0, y: 800)
                }) { (completed) in
                    self.dismiss(animated: false, completion: nil)
                }
//          delegate?.selected(userSettings: selectedUserSettings)
//          delegate?.didTapNext()
      }

}
