//
//  ActivityIndicator.swift
//  CCEP


import Foundation
import UIKit

class ActivityIndicator {
    
    static let sharedIndicator = ActivityIndicator()
    private var spinnerView = UIView()
    
    func displayActivityIndicator(onView : UIView) {
        spinnerView = UIView(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center
        DispatchQueue.main.async { [weak self] in
            guard let _self = self else { return }
            _self.spinnerView.addSubview(activityIndicator)
            onView.addSubview(_self.spinnerView)
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {[weak self] in
            guard let _self = self else { return }
            _self.spinnerView.removeFromSuperview()
        }
    }
    
}
