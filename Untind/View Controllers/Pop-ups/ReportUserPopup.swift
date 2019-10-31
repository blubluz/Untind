//
//  ReportUserPopup.swift
//  Untind
//
//  Created by Honceriu Mihai on 15/10/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class ReportUserPopup: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var reasonsTableView: UITableView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    private let reasons = ["Inappropriate behaviour", "Fake Profile", "Disrespectful", "Multiple Accounts"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 20
        reasonsTableView.delegate = self
        reasonsTableView.dataSource = self
        
        self.heightConstraint?.constant = CGFloat(reasons.count) * 60.0
        self.modalPresentationStyle = .fullScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor(red: 51, green: 67, blue: 78, alpha: 0)
        containerView.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reasonsTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = UIColor(red: 51, green: 67, blue: 78, alpha: 0.97)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.containerView.transform = CGAffineTransform.identity
        }) { (completed) in
            
        }
    }
    
    @IBAction func didTapBackground(_ sender: Any) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.containerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.backgroundColor = UIColor(red: 51, green: 67, blue: 78, alpha: 0)
        }) { (completed) in
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    static func instantiate() -> ReportUserPopup {
          let vc = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: "ReportUserPopup") as! ReportUserPopup
          return vc
      }
    
    //MARK: - TableView Delegate & DataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasons.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportReasonCell", for: indexPath) as! ReportReasonCell
        cell.configureWith(reason: reasons[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
