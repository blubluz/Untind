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

class CreateProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CreateProfileDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UTPageControl!
    
    var currentUser = UTUser(user: Auth.auth().currentUser!, profile: Profile())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "CreateProfileFirstCell", bundle: nil), forCellWithReuseIdentifier: "CreateProfileFirstCell")
        collectionView.register(UINib(nibName: "CreateProfileSecondCell", bundle: nil), forCellWithReuseIdentifier: "CreateProfileSecondCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        pageControl.numberOfPages = 2
        
        
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
        return 2
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
        default:
            return 315
        }
    }

    func cellHeight(for section: Int) -> CGFloat {
        switch section {
        case 0:
            return min(UIScreen.main.bounds.height * 0.8, 570)
        case 1:
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
    func selected(age: Int) {
        currentUser.userProfile?.age = age
    }
    
    func selected(avatar: String) {
        currentUser.userProfile?.avatarType = avatar
    }
    
    func selected(name: String) {
        currentUser.userProfile?.username = name
    }
    
    func selected(gender: Gender) {
        currentUser.userProfile?.gender = gender
    }
    
    func didTapNext() {
        
        if pageControl.selectedPageIndex == 1 {
            let age = currentUser.userProfile?.age ?? 18
            currentUser.userProfile?.settings.ageRange = (min(age - 4,18),age + 4)
            
            let gender = currentUser.userProfile?.gender
            currentUser.userProfile?.settings.prefferedGender = gender == .female ? .male : .female
            
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                currentUser.userProfile?.uuid = uuid
            } else {
                currentUser.userProfile?.uuid = "NoUUID_Simulator?"
            }
            
            let db = Firestore.firestore()
            
            let documentPath = db.collection("UserProfiles").document(UTUser.loggedUser!.user.uid)
            documentPath.setData(currentUser.userProfile!.jsonValue()) { [weak self] (error) in
                
                if error == nil {
                    UTUser.loggedUser?.userProfile = self?.currentUser.userProfile
                    self?.currentUser.saveUserProfile(locally: true)
                    
                    //Go to tab bar controller
                    let tabBarController = UIStoryboard.main.instantiateViewController(withIdentifier: "TabBarViewController")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = tabBarController
                    
                } else {
                    print("Error saving user profile on FireBase")
                }
            }
            //We are at the last page
            //Create account
            
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
}
