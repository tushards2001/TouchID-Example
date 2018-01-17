//
//  ViewController.swift
//  TouchID-Example
//
//  Created by MacBookPro on 1/17/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        navigationItem.title = "TouchID Example"
        
        setupView()
    }
    
    let touchIdButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named:"touch_id"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(validateTouch), for: .touchUpInside)
        return button
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let iv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        iv.hidesWhenStopped = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.stopAnimating()
        return iv
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Verify"
        label.numberOfLines = 4
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func setupView() {
        
        // touchId button
        self.view.addSubview(touchIdButton)
        
        touchIdButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        touchIdButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        touchIdButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        touchIdButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        // activity indicator view
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        // message label
        self.view.addSubview(messageLabel)
        
        messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: touchIdButton.topAnchor, constant: -40).isActive = true
        messageLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64 + 40).isActive = true
    }


    @objc func validateTouch() {
        updateMessageLabel(message: "")
        touchIdButton.isHidden = true
        activityIndicatorView.startAnimating()
        
        let authContext = LAContext()
        let authReason = "Please use TouchID to verify"
        
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: authReason, reply: { (success, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.updateMessageLabel(message: String(describing: error!.localizedDescription))
                        self.activityIndicatorView.stopAnimating()
                        self.touchIdButton.isHidden = false
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    self.updateMessageLabel(message: success ? "Verified successfully" : "Verification failed")
                    self.activityIndicatorView.stopAnimating()
                    self.touchIdButton.isHidden = false
                }
                
            })
        } else {
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.updateMessageLabel(message: "Device does not support TouchID")
                self.touchIdButton.isHidden = false
            }
        }
    }
    
    private func updateMessageLabel(message: String) {
        self.messageLabel.text = message
    }
}

