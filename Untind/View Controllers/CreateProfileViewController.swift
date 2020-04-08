//
//  CreateProfileViewController.swift
//  Untind
//
//  Created by Honceriu Mihai on 30/08/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

class CreateProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CreateProfileDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UTPageControl!
    
    var currentUser : UTUser?
    
    private var selectedAvatar : String?
    private var selectedUserSettings : UserSettings?
    private var selectedAge : Int?
    private var selectedGender : Gender?
    private var selectedUsername : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "CreateProfileFirstCell", bundle: nil), forCellWithReuseIdentifier: "CreateProfileFirstCell")
        collectionView.register(UINib(nibName: "CreateProfileSecondCell", bundle: nil), forCellWithReuseIdentifier: "CreateProfileSecondCell")
        collectionView.register(UINib(nibName: "CreateProfileThirdCell", bundle: nil), forCellWithReuseIdentifier: "CreateProfileThirdCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = 3
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)

        let firstCellViewFrame = CGRect(x: (UIScreen.main.bounds.size.width - CGFloat(cellWidth(for: 0))) / 2, y: (UIScreen.main.bounds.size.height - cellHeight(for: 0))/2, width: cellWidth(for: 0), height: cellHeight(for: 0))
        let transitionRefferenceView = UIView(frame:  firstCellViewFrame)
        transitionRefferenceView.tag = 99
        view.addSubview(transitionRefferenceView)
        transitionRefferenceView.isUserInteractionEnabled = false
        view.bringSubviewToFront(collectionView)
     
        if let auth = Auth.auth().currentUser {
            currentUser = UTUser(user: auth, profile: Profile())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pageControl.selectedPageIndex = 0

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillAppear() {
        collectionView?.transform = CGAffineTransform(translationX: 0, y: -100)
    }
    
    @objc func keyboardWillDisappear() {
        collectionView?.transform = CGAffineTransform.identity
    }
    // MARK: - CollectionView Delegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateProfileFirstCell", for: indexPath) as! CreateProfileFirstCell
            cell.delegate = self
            cell.layer.cornerRadius = 40
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateProfileSecondCell", for: indexPath) as! CreateProfileSecondCell
            cell.titleLabel.attributedText = NSAttributedString(string: "Hello \(selectedUsername ?? "")!").boldAppearenceOf(string: selectedUsername ?? "", withBoldFont: UIFont.helveticaNeue(weight: .bold, size: cell.titleLabel.font.pointSize))
            
            cell.delegate = self
            cell.layer.cornerRadius = 40
            return cell
        case 2:
            let cell = collectionView.dequeue(CreateProfileThirdCell.self, for: indexPath)
            cell.delegate = self
            cell.layer.cornerRadius = 40
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset = (UIScreen.main.bounds.size.width - CGFloat(cellWidth(for: section))) / 2
        
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth(for: indexPath.section), height: cellHeight(for: indexPath.section))
    }
    
    func cellWidth(for section: Int) -> CGFloat {
        switch section {
        case 0:
            return min(UIScreen.main.bounds.width * 0.9, 315)
        case 1:
            return min(UIScreen.main.bounds.width * 0.9, 315)
        case 2:
            return min(UIScreen.main.bounds.width * 0.9, 315)
        default:
            return 315
        }
    }

    func cellHeight(for section: Int) -> CGFloat {
        switch section {
        case 0:
            return min(UIScreen.main.bounds.height * 0.8, 500)
        case 1:
            return min(UIScreen.main.bounds.height * 0.8, 470)
        case 2:
            return min(UIScreen.main.bounds.height * 0.8, 470)
        default:
            return 315
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.scrollViewDidScroll(scrollView)
       
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    //MARK: - Create Profile Delegate
    func selected(age: Int?) {
        selectedAge = age
    }
    
    func selected(avatar: String?) {
        selectedAvatar = avatar
    }
    
    func selected(name: String?) {
        selectedUsername = name
    }
    
    func selected(gender: Gender?) {
        selectedGender = gender
    }
    
    func selected(userSettings: UserSettings?) {
        selectedUserSettings = userSettings
    }
    
    func didTapNext() {
        if pageControl.selectedPageIndex == 2 {
            if validateFields() == false {
                return
            } else {
                currentUser?.userProfile?.age = selectedAge!
                currentUser?.userProfile?.avatarType = selectedAvatar!
                currentUser?.userProfile?.username = selectedUsername!
                currentUser?.userProfile?.gender = selectedGender!
                currentUser?.userProfile?.settings = selectedUserSettings!
            }
            
            //We are at the last page
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                currentUser?.userProfile?.uuid = uuid
            } else {
                currentUser?.userProfile?.uuid = "NoUUID_Simulator?"
            }
            
            currentUser?.userProfile?.uid = Auth.auth().currentUser!.uid
            
            let db = Firestore.firestore()
            
            let documentPath = db.collection("UserProfiles").document(UTUser.loggedUser!.user.uid)
            SVProgressHUD.show()
            documentPath.setData(currentUser!.userProfile!.jsonValue()) { [weak self] (error) in
                
                SVProgressHUD.dismiss()
                if error == nil {
                    UTUser.loggedUser?.userProfile = self?.currentUser?.userProfile
                    self?.currentUser?.saveUserProfile(locally: true)
                    
                    //Go to tab bar controller
                    let tabBarController = UIStoryboard.main.instantiateViewController(withIdentifier: "TabBarNavigationController") as! UINavigationController
                    Globals.mainNavigationController = tabBarController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = tabBarController
                    
                } else {
                    print("Error saving user profile on FireBase")
                }
            }
            
        } else {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: pageControl.selectedPageIndex+1), at: .centeredHorizontally, animated: true)
        }
        
    }
    
    func didTapBack() {
        if pageControl.selectedPageIndex == 0 {
            //We are at the first page
            //We can't go back
        } else {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: pageControl.selectedPageIndex-1), at: .centeredHorizontally, animated: true)
        }
    }
    
    func validateFields() -> Bool {
        guard  currentUser?.userProfile != nil else {
            return false
        }
        
        guard selectedUsername != nil && selectedUsername != "" else {
            present(
            UTAlertController.init(title: "Oops", message: "Please pick a username"), animated: true, completion: nil)
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            return false
        }
        
        guard selectedAge != nil else {
            present(UTAlertController.init(title: "Oops", message: "Please select your age"), animated: true, completion: nil)
            return false
        }
        
        guard selectedAge! >= 16 else {
            present(UTAlertController.init(title: "Oops", message: "You must be over 16 to user Untind"), animated: true, completion: nil)
            return false
        }
        
        guard selectedGender != nil else {
            present(UTAlertController.init(title: "Oops", message: "You must select your gender"), animated: true, completion: nil)
            return false
        }
        
        guard selectedAvatar != nil else {
            present(UTAlertController.init(title: "Oops", message: "You must select your avatar"), animated: true, completion: nil)
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
            return false
        }
        
        return true
    }
}
