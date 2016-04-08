//
//  ViewController.swift
//  CodeTest3
//
//  Created by alexfu on 3/17/16.
//  Copyright © 2016 alexfu. All rights reserved.
//

import UIKit

protocol MenuTableViewControllerDelegate {
    func menuControllerDidSelectRow(url:String)
}



class MenuViewController: UITableViewController {
     var items:[Item]=[]
     var selectedMenuItem : Int = -1
     var imageProvider: ImageProvider?
     var delegate : MenuTableViewControllerDelegate?
  
    @IBOutlet var ActivtyIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        imageProvider = ImageProvider.sharedInstance
        WebService.GetData { (success, result) -> Void in
            if (success){
                self.items=result!
                self.prefetch()
               // self.tableView.reloadData()
                }
            }
    }
    
    func prefetch() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            for i in  0...10 {
                if let thumbURL = self.items[i].thumb {
                    self.imageProvider!.provideImage(NSURL(string:thumbURL)!, completition: {_,_ in })
                }
                
                
            }
        }
    }
    
}

extension MenuViewController {

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
            return 80
    }
 
    override func viewWillAppear(animated: Bool) {
        print("will Appear")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

            let item=items[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("menucell", forIndexPath: indexPath) as! menuCell
            cell.config(item)
            if let imageProvider = self.imageProvider, let thumbUrl = item.thumb {
                imageProvider.provideImage(NSURL(string:thumbUrl)!, completition: { (image, error) -> Void in
                self.setImage(image, forCellAtIndexPath: indexPath, inTableView: tableView)
            })
            }
           else{
                cell.thumbView.image = UIImage(named: "list-image-placeholder")
            }
                    
            return cell
    }
    
    func setImage(image: UIImage?, forCellAtIndexPath indexPath: NSIndexPath, inTableView tableView: UITableView) {
        guard let image = image, let cell = tableView.cellForRowAtIndexPath(indexPath) as? menuCell else {
            return
        }
        
        cell.setImageForThumb(image)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedMenuItem = indexPath.row
        self.delegate?.menuControllerDidSelectRow(items[indexPath.row].original!)
    }

}




