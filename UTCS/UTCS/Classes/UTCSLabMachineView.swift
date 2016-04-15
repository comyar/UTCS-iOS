//
//  UTCSLabMachineView.swift
//  UTCS
//
//  Created by Taylor Schmidt on 4/8/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

import Foundation
import UIKit

class UTCSLabMachineView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor(white: 0.0, alpha: 0.1).CGColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}