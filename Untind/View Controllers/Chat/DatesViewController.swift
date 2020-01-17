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
    var dates : [UTDate] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var dateRequests : [UTDate] {
        return dates.filter { (date) -> Bool in
           return date.myRelationshipStatus == .shouldAnswerDateRequest
        }
    }
    
    var upcomingDates : [UTDate] {
        return dates.filter { (date) -> Bool in
            return date.myRelationshipStatus == .dateScheduled
        }
    }
    
    var activeDates : [UTDate] {
        let _dates = dates.filter { (date) -> Bool in
            return date.myRelationshipStatus == .dateStarted || date.myRelationshipStatus == .chatStarted
        }
        return _dates.sorted { (date1, date2) -> Bool in
            return date1.myRelationshipStatus == .dateStarted
        }
    }
    
    var pendingDates : [UTDate] {
        return dates.filter { (date) -> Bool in
            return date.myRelationshipStatus == .waitingDateResult || date.myRelationshipStatus == .waitingDateAnswer
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
        self.loadData()
    }
    
    func loadData() {
        guard let userId = UTUser.loggedUser?.userProfile?.uid else {
            return
        }
        
        UTDate.fetch(forUserId: userId) { (error, dates) in
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
        headerView.frame.size.height = 35
        switch indexPath.section {
        case 0:
            if dateRequests.count == 1 {
                headerView.titleLabel.text = "\(dateRequests.count) DATE REQUEST"
            } else {
                headerView.titleLabel.text = "\(dateRequests.count) DATE REQUESTS"
            }
            if dateRequests.count == 0 {
                headerView.frame.size.height = 0
            }
        case 1:
            headerView.titleLabel.text = "\(upcomingDates.count) UPCOMING DATES"
            if upcomingDates.count == 0 {
                headerView.frame.size.height = 0
            }
        case 2:
            headerView.titleLabel.text = "\(activeDates.count) ACTIVE DATES"
            if activeDates.count == 0 {
                headerView.frame.size.height = 0
            }
        case 3:
            headerView.titleLabel.text = "\(pendingDates.count) PENDING DATES"
            if pendingDates.count == 0 {
                headerView.frame.size.height = 0
            }
        default:
            break
        }

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
            return activeDates.count
        case 3:
            return pendingDates.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContainerCollectionViewCell", for: indexPath) as! ContainerCollectionViewCell
        
        cell.configureWithDates(dates: self.dateRequests)
        cell.delegate = self
        return cell
        case 1:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContainerCollectionViewCell", for: indexPath) as! ContainerCollectionViewCell
        cell.configureWithDates(dates: self.upcomingDates)
        return cell
        case 2:
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell)
            cell.update(with: self.activeDates[indexPath.row])
            return cell
        case 3:
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell)
            cell.update(with: self.pendingDates[indexPath.row])
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
    func didTapRejectDate(date: UTDate) {
        
    }
    
    func didTapAcceptDate(date: UTDate) {
        let vc = AcceptDatePopup.instantiate()
        vc.date = date
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overCurrentContext
        nav.setNavigationBarHidden(true, animated: false)
        Globals.tabBarController?.present(nav, animated: false, completion: nil)
    }
    
    func didTapCancelDate(date: UTDate) {
        let alert = UTAlertController(title: "Decline request", message: "Are you sure you want to decline this date request?", backgroundColor: UIColor(red: 234, green: 244, blue: 223, alpha: 1), backgroundAlpha: 0.5)
        let yesAction = UTAlertAction(title: "Yes", {
            
        }, color: UIColor(red: 126, green: 211, blue: 33, alpha: 1))
        let noAction = UTAlertAction(title: "No", {
            
        }, color: UIColor.flatOrange)
        alert.addNewAction(action: yesAction)
        alert.addNewAction(action: noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didTapRescheduleDate(date: UTDate) {
        
    }
}

extension DatesViewController : DatePopupDelegate {
    func didAcceptDate(date: UTDate) {
        if let row = self.dates.firstIndex(where: { $0.id == date.id }) {
            dates[row] = date
            collectionView.reloadData()
        }
    }
}
