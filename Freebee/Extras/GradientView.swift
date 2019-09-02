//
//  GradientView.swift
//  Freebee
//
//  Created by Anthony on 30/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        guard let theLayer = self.layer as? CAGradientLayer else {
            return;
        }
        
        theLayer.colors = [UIColor(red: 74/255, green: 0/255, blue: 224/255, alpha: 1).cgColor, UIColor(red: 142/255, green: 45/255, blue: 226/255, alpha: 1).cgColor]
        theLayer.locations = [0.05, 0.8]
        theLayer.startPoint = CGPoint(x:0.5,y:0)
        theLayer.endPoint = CGPoint(x:0.5, y:1)
        theLayer.frame = self.bounds
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}
