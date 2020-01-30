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
            return date.myRelationshipStatus == .waitingDateResult || date.myRelationshipStatus == .waitingDateAnswer || date.myRelationshipStatus == .shouldGiveDateResult
        }
    }
    
    var failedDates : [UTDate] {
        return dates.filter { (date) -> Bool in
            return date.myRelationshipStatus == .dateRequestExpired || date.myRelationshipStatus == .dateFailed || date.myRelationshipStatus == .heRejected || date.myRelationshipStatus == .youRejected
        }
    }
    
    var refresher:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //init refresher
        self.refresher = UIRefreshControl()
        self.refresher.tintColor = UIColor.strongGreen
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.collectionView.refreshControl = refresher
        
        //collectionview setup
        collectionView.delegate = self
        collectionView.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = flowLayout
        
        collectionView.register(DateTableHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.register(UINib(nibName: "ContainerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ContainerCollectionViewCell")
        collectionView.register(UINib(nibName: "DateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DateCollectionViewCell")
        self.loadData()
    }
    
    @objc func loadData() {
        self.collectionView.refreshControl?.beginRefreshing()
        guard let userId = UTUser.loggedUser?.userProfile?.uid else {
            self.collectionView.refreshControl?.endRefreshing()
            return
        }
        
        UTDate.fetch(forUserId: userId, withChatRooms: true) { (error, dates) in
            self.collectionView.refreshControl?.endRefreshing()
            if let error = error {
                self.present(UTAlertController(title: "Oops", message: "There was an error loading dates: \(error.localizedDescription)"), animated: true, completion: nil)
            } else {
                self.dates = dates
            }
        }
    }
}

extension DatesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = UIScreen.main.bounds.size.width
        switch section {
        case 0:
            if dateRequests.count == 0 {
                return CGSize(width: width, height: 0)
            } else {
                return CGSize(width: width, height: 35)
            }
        case 1:
            if upcomingDates.count == 0 {
                return CGSize(width: width, height: 0)
            } else {
                return CGSize(width: width, height: 35)
            }
        case 2:
            if activeDates.count == 0 {
                return CGSize(width: width, height: 0)
            } else {
                return CGSize(width: width, height: 35)
            }
        case 3:
            if pendingDates.count == 0 {
                return CGSize(width: width, height: 0)
            } else {
                return CGSize(width: width, height: 35)
            }
        case 4:
            if failedDates.count == 0 {
                return CGSize(width: width, height: 0)
            } else {
                return CGSize(width: width, height: 35)
            }
        default:
            return CGSize(width: width, height: 0)
        }
    }
    
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
        case 4:
            headerView.titleLabel.text = "\(failedDates.count) FAILED DATES"
            if failedDates.count == 0 {
                headerView.frame.size.height = 0
            }
        default:
            break
        }

        return headerView
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dateRequests.count == 0 ? 0 : 1
        case 1:
            return upcomingDates.count == 0 ? 0 : 1
        case 2:
            return activeDates.count
        case 3:
            return pendingDates.count
        case 4:
            return failedDates.count
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
            cell.delegate = self
            return cell
        case 2:
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell)
            cell.update(with: self.activeDates[indexPath.row])
            cell.delegate = self
            return cell
        case 3:
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell)
            cell.update(with: self.pendingDates[indexPath.row])
            cell.delegate = self
            return cell
        case 4:
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell)
            cell.update(with: self.failedDates[indexPath.row])
            cell.delegate = self
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            return
        case 2:
            self.didTapDate(date: activeDates[indexPath.row])
        case 3:
            self.didTapDate(date: pendingDates[indexPath.row])
        case 4:
            self.didTapDate(date: failedDates[indexPath.row])
        default:
            return
        }
    }
}

extension DatesViewController : DateDelegate {
    func didTapUserProfile(profile: Profile) {
        self.navigationController?.pushViewController(UserProfileViewController.instantiate(profile: profile), animated: true)
    }
    
    func didTapRejectDate(date: UTDate) {
        let alert = UTAlertController(title: "Decline request", message: "Are you sure you want to decline this date request?", backgroundColor: UIColor(red: 234, green: 244, blue: 223, alpha: 1), backgroundAlpha: 0.5)
              let yesAction = UTAlertAction(title: "Yes", {
                  date.accept(answer: false) { (error, blockDate) in
                                 if error != nil {
                                     self.present(UTAlertController(title: "Oops", message: "There was a problem - \(error?.localizedDescription ?? "")"), animated: true, completion: nil)
                                 } else {
                                     if let row = self.dates.firstIndex(where: { $0.id == date.id }) {
                                         self.dates[row] = date
                                         self.collectionView.reloadData()
                                            }
                                 }
                             }
              }, color: UIColor(red: 126, green: 211, blue: 33, alpha: 1))
              let noAction = UTAlertAction(title: "No", {
                  
              }, color: UIColor.flatOrange)
              alert.addNewAction(action: yesAction)
              alert.addNewAction(action: noAction)
              self.present(alert, animated: true, completion: nil)
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
        let alert = UTAlertController(title: "Cancel date", message: "Are you sure you want to cancel this date?", backgroundColor: UIColor(red: 234, green: 244, blue: 223, alpha: 1), backgroundAlpha: 0.5)
        let yesAction = UTAlertAction(title: "Yes", {
            date.accept(answer: false) { (error, blockDate) in
                if error != nil {
                    self.present(UTAlertController(title: "Oops", message: "There was a problem - \(error?.localizedDescription ?? "")"), animated: true, completion: nil)
                } else {
                    if let row = self.dates.firstIndex(where: { $0.id == date.id }) {
                        self.dates[row] = date
                        self.collectionView.reloadData()
                           }
                }
            }
        }, color: UIColor(red: 126, green: 211, blue: 33, alpha: 1))
        let noAction = UTAlertAction(title: "No", {
            
        }, color: UIColor.flatOrange)
        alert.addNewAction(action: yesAction)
        alert.addNewAction(action: noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func didTapRescheduleDate(date: UTDate) {
        let vc = RescheduleDatePopup.instantiate()
        vc.delegate = self
        vc.date = date
        Globals.tabBarController?.present(vc, animated: false, completion: nil)
    }
    
    func didTapDate(date: UTDate) {
        switch date.myRelationshipStatus {
        case .dateStarted, .chatStarted, .waitingDateResult, .shouldGiveDateResult, .dateScheduled:
            let chatVc = ChatViewController.instantiate()
            chatVc.date = date
            Globals.mainNavigationController?.pushViewController(chatVc, animated: true)
        default:
            return
        }
    }
}

extension DatesViewController : DatePopupDelegate {
    func didEdit(date: UTDate) {
        if let row = self.dates.firstIndex(where: { $0.id == date.id }) {
            dates[row] = date
            collectionView.reloadData()
        }
    }
}
