//
//  FinanceViewController.swift
//  Finance
//
//  Created by Manickam on 04/05/22.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var loadingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initLoadingView()
    }
    
    func initLoadingView() {
        
        let activityIndicatorView = UIActivityIndicatorView.init(style: .large)
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
        
        self.loadingView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.loadingView!.backgroundColor = UIColor.black
        self.loadingView!.alpha = 0.5
        self.loadingView!.addSubview(activityIndicatorView)
        self.loadingView!.isUserInteractionEnabled = false
    }
    
    func showLoadingView() {
        if (self.loadingView != nil) {
            self.view.addSubview(self.loadingView!)
        }
    }
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func hideLoadingView() {
        if (self.loadingView != nil) {
            DispatchQueue.main.async {
                self.loadingView!.removeFromSuperview()
            }
        }
    }
}
