//
//  DatesViewController.swift
//  Untind
//
//  Created by Mihai Honceriu on 16/12/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class DatesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var dates : [UntindDate] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 40)
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(DateTableHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.register(UINib(nibName: "ContainerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ContainerCollectionViewCell")
        collectionView.register(UINib(nibName: "DateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DateCollectionViewCell")
        // Makes header stay visible while scrolling
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.sectionHeadersPinToVisibleBounds = true
//        }
    }
    
    func loadData() {
        guard let userId = UTUser.loggedUser?.userProfile?.uid else {
            return
        }
        
        UntindDate.fetch(forUserId: userId) { (error, dates) in
            if let error = error {
                self.present(UTAlertController(title: "Oops", message: "There was an error loading dates: \(error.localizedDescription)"), animated: true, completion: nil)
            } else {
                self.dates = dates
            }
        }
    }
}

extension DatesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as! DateTableHeader
        switch indexPath.section {
        case 0:
            headerView.titleLabel.text = "3 DATE REQUESTS"
        case 1:
            headerView.titleLabel.text = "2 UPCOMING DATES"
        case 2:
            headerView.titleLabel.text = "3 ACTIVE DATES"
        case 3:
            headerView.titleLabel.text = "3 PENDING DATES"
        default:
            break
        }

        headerView.frame.size.height = 35

        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 3
        case 3:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContainerCollectionViewCell", for: indexPath) as! ContainerCollectionViewCell
        cell.configureWithType(type: .newDateRequest)
        cell.delegate = self
        return cell
        case 1:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContainerCollectionViewCell", for: indexPath) as! ContainerCollectionViewCell
        cell.configureWithType(type: .upcomingDate)
        return cell
        case 2:
            var cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell)
            if indexPath.row == 0 {
                cell = cell.update(with: .activeDate1)
            } else {
                cell = cell.update(with: .activeDate2)
            }
            return cell
        case 3:
            var cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell)
            if indexPath.row == 0 {
                cell = cell.update(with: .pendingInvite)
            } else {
                cell = cell.update(with: .pendingResponse)
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 || indexPath.section == 1 {
            return CGSize(width: min(UIScreen.main.bounds.size.width, 420), height: 82)

        }
        
        return CGSize(width: min((UIScreen.main.bounds.size.width - 50), 420), height: 82)
      }
}

extension DatesViewController : DateDelegate {
    func didTapRejectDate(date: UntindDate) {
        
    }
    
    func didTapAcceptDate(date: UntindDate) {
        let nav = UINavigationController(rootViewController: AcceptDatePopup.instantiate())
        nav.modalPresentationStyle = .overCurrentContext
        nav.setNavigationBarHidden(true, animated: false)
        Globals.tabBarController?.present(nav, animated: false, completion: nil)
    }
    
    func didTapCancelDate(date: UntindDate) {
        let alert = UTAlertController(title: "Decline request", message: "Are you sure you want to decline this date request?", backgroundColor: UIColor(red: 234, green: 244, blue: 223, alpha: 1), backgroundAlpha: 0.5)
        let yesAction = UTAlertAction(title: "Yes", {
            
        }, color: UIColor(red: 126, green: 211, blue: 33, alpha: 1))
        let noAction = UTAlertAction(title: "No", {
            
        }, color: UIColor.flatOrange)
        alert.addNewAction(action: yesAction)
        alert.addNewAction(action: noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didTapRescheduleDate(date: UntindDate) {
        
    }
    
    
}
