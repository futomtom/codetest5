

import UIKit



@objc protocol SideMenuDelegate {
    func sideMenuDidSelectedItem(url:String)
    optional func sideMenuWillOpen()
    optional func sideMenuWillClose()
}

class SideMenu : NSObject ,MenuTableViewControllerDelegate {
    
    let menuWidth : CGFloat = 200.0
    let menuTableViewTopInset : CGFloat = 64.0 // if you use translusent navigation bar
    let sideMenuContainerView =  UIView()
    var sideMenuTableViewController:MenuViewController!
    var animator : UIDynamicAnimator!
    var sourceView : UIView!
    var delegate : SideMenuDelegate?
    var isMenuOpen : Bool = false
    
    init(sourceView: UIView) {
        super.init()
        self.sourceView = sourceView
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sideMenuTableViewController = storyboard.instantiateViewControllerWithIdentifier("menuvc") as? MenuViewController
    
      
        
        self.setupMenuView()
        
        animator = UIDynamicAnimator(referenceView:sourceView)
        // Add show gesture recognizer
        var showGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("handleGesture:"))
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        sourceView.addGestureRecognizer(showGestureRecognizer)
        
        // Add hide gesture recognizer
        var hideGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("handleGesture:"))
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        sideMenuContainerView.addGestureRecognizer(hideGestureRecognizer)
    }
    
    
    func setupMenuView() {
        
        // Configure side menu container
        sideMenuContainerView.frame = CGRectMake(-menuWidth-1.0, sourceView.frame.origin.y, menuWidth, sourceView.frame.size.height)
   //     sideMenuContainerView.backgroundColor = UIColor.cyanColor()
        sideMenuContainerView.clipsToBounds = false
        sideMenuContainerView.layer.masksToBounds = false;
        sideMenuContainerView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        sideMenuContainerView.layer.shadowRadius = 1.0;
        sideMenuContainerView.layer.shadowOpacity = 0.125;
        sideMenuContainerView.layer.shadowPath = UIBezierPath(rect: sideMenuContainerView.bounds).CGPath
        
        sourceView.addSubview(sideMenuContainerView)
        

        
        // Configure side menu table view
        sideMenuTableViewController.delegate = self
        sideMenuTableViewController.tableView.frame = sideMenuContainerView.bounds
        sideMenuTableViewController.tableView.contentInset = UIEdgeInsetsMake(menuTableViewTopInset, 0, 0, 0)
        
      
        
        sideMenuContainerView.addSubview(sideMenuTableViewController.tableView)
    }
    
    func handleGesture(gesture: UISwipeGestureRecognizer) {
        
        if (gesture.direction == .Left) {
            toggleMenu(false)
   
        }
        else{
            toggleMenu(true)
         
        }
    }
    
    func toggleMenu (shouldOpen: Bool) {
        if (shouldOpen) {
            delegate?.sideMenuWillOpen?()
        }
        else
        {
        delegate?.sideMenuWillClose?()
        }
        animator.removeAllBehaviors()
        isMenuOpen = shouldOpen
        let gravityDirectionX: CGFloat = (shouldOpen) ? 0.5 : -0.5;
        let pushMagnitude: CGFloat = (shouldOpen) ? 20.0 : -20.0;
        let boundaryPointX: CGFloat = (shouldOpen) ? menuWidth : -menuWidth-1.0;
        
        let gravityBehavior = UIGravityBehavior(items: [sideMenuContainerView])
        gravityBehavior.gravityDirection = CGVectorMake(gravityDirectionX, 0.0)
        animator.addBehavior(gravityBehavior)
        
        let collisionBehavior = UICollisionBehavior(items: [sideMenuContainerView])
        collisionBehavior.addBoundaryWithIdentifier("menuBoundary", fromPoint: CGPointMake(boundaryPointX, 20.0),
            toPoint: CGPointMake(boundaryPointX, sourceView.frame.size.height))
        animator.addBehavior(collisionBehavior)
        
        let pushBehavior = UIPushBehavior(items: [sideMenuContainerView], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = pushMagnitude
        animator.addBehavior(pushBehavior)
        
        let menuViewBehavior = UIDynamicItemBehavior(items: [sideMenuContainerView])
        menuViewBehavior.elasticity = 0.3
        animator.addBehavior(menuViewBehavior)
    }
    
    func menuControllerDidSelectRow(url:String) {
        toggleMenu(false)
        delegate?.sideMenuDidSelectedItem(url)
    }
    
    func toggleMenu () {
        if (isMenuOpen) {
            toggleMenu(false)
            
        }
        else {
            sideMenuTableViewController.tableView.reloadData()
            toggleMenu(true)
      
        }
    }
}


