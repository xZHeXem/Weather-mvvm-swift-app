//
//  GlobalSplitViewController.swift
//  Weather
//
//  Created by 1234 on 22.11.2020.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    // MARK: - Functions
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.delegate = self
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            preferredDisplayMode = .oneBesideSecondary
            if #available(iOS 14, *) {
                preferredSplitBehavior = .tile
            }
        }
 
    }
}

// MARK: - UISplitViewControllerDelegate
extension SplitViewController {
        
    @available(iOS 14.0, *)
    public func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        
        return .primary
    }
    
    
    public func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        
        return true
    }
}
