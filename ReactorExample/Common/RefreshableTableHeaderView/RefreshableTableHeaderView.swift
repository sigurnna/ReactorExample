//
//  RefreshableTableHeaderView.swift
//  ReactorExample
//
//  Created by 이승준 on 24/01/2019.
//  Copyright © 2019 seungjun. All rights reserved.
//

import UIKit

class RefreshableTableHeaderView: UIView {
    
    fileprivate struct Colors {
        static let backgroundButtonBackgroundColor = #colorLiteral(red: 0.9332515597, green: 0.9333856702, blue: 0.9332222342, alpha: 1)
//        static let backgroundButtonTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        static let foregroundButtonBackgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
//        static let foregroundButtonTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    fileprivate let shapeLayer = CAShapeLayer()
    fileprivate let backgroundButton = UIButton()
    fileprivate let foregroundButton = UIButton()
    
    fileprivate var lastProgress: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundButton.layer.cornerRadius = backgroundButton.frame.height / 2
        foregroundButton.layer.cornerRadius = foregroundButton.frame.height / 2
    }
    
    /// progress는 0 ~ 1 사이의 값이 전달되어야 함.
    func update(progress: CGFloat) {
        
        if lastProgress < 1.0 && progress >= 1.0 {
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.foregroundButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { success in
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            })
        } else if lastProgress > 1.0 && progress < 1.0 {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.foregroundButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
        
        let rect = CGRect(x: 0,
                          y: foregroundButton.bounds.height - foregroundButton.bounds.height * min(progress, 1.0),
                          width: foregroundButton.bounds.width,
                          height: foregroundButton.bounds.height)
        
        let path = UIBezierPath(rect: rect).cgPath
        
        shapeLayer.path = path
        
        lastProgress = progress
    }
}

// MARK: - Internal

fileprivate extension RefreshableTableHeaderView {
    
    func setup() {
        addSubview(backgroundButton)
        addSubview(foregroundButton)
        
        backgroundButton.setImage(UIImage(named: "icon_refresh"), for: .normal)
        backgroundButton.backgroundColor = Colors.backgroundButtonBackgroundColor
//        backgroundButton.tintColor = Colors.backgroundButtonTintColor
        backgroundButton.translatesAutoresizingMaskIntoConstraints = false
        
        foregroundButton.setImage(UIImage(named: "icon_refresh"), for: .normal)
        foregroundButton.backgroundColor = Colors.foregroundButtonBackgroundColor
//        foregroundButton.tintColor = Colors.foregroundButtonTintColor
        foregroundButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set Layers
        foregroundButton.layer.mask = shapeLayer
        foregroundButton.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            // backgroundButton Constraints
            backgroundButton.widthAnchor.constraint(equalToConstant: 35),
            backgroundButton.heightAnchor.constraint(equalToConstant: 35),
            backgroundButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            // foregroundButton Constraints
            foregroundButton.widthAnchor.constraint(equalToConstant: 35),
            foregroundButton.heightAnchor.constraint(equalToConstant: 35),
            foregroundButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            foregroundButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
