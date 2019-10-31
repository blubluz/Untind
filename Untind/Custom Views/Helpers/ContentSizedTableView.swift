//
//  ContentSizedTableView.swift
//  Untind
//
//  Created by Honceriu Mihai on 16/10/2019.
//  Copyright © 2019 FincPicsels. All rights reserved.
//

import UIKit

class ContentSizedTableView: UITableView {

   final class ContentSizedTableView: UITableView {
        override var contentSize:CGSize {
            didSet {
                invalidateIntrinsicContentSize()
            }
        }

        override var intrinsicContentSize: CGSize {
            layoutIfNeeded()
            return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        }
    }
}
