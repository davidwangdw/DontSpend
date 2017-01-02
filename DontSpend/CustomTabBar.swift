//
//  CustomTabBar.swift
//  SimpleSky
//
//  Created by David Wang on 12/29/16.
//  Copyright © 2016 David Wang. All rights reserved.
//

import UIKit

class FrostyTabBar: UITabBar {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.backgroundImage = UIImage.imageWithColor(UIColor.clearColor())
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        frost.frame = self.bounds
        frost.autoresizingMask = .flexibleWidth
        self.insertSubview(frost, at: 0)
    }
}
