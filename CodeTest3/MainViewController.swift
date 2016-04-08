

import UIKit


class MainViewController: UIViewController ,UIScrollViewDelegate ,SideMenuDelegate{
    var imageProvider: ImageProvider?
    var sideMenu : SideMenu?
    var activityView: UIActivityIndicatorView!

    
    var imageURL:String = ""

    
    var topBarHidden:Bool=true
    var sideMenuOpened:Bool=false
    var image = UIImage()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var singleFingerTap:UIGestureRecognizer!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageView: UIImageView=UIImageView()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        sideMenu = SideMenu(sourceView: self.view)
        sideMenu!.delegate = self
        imageProvider = ImageProvider.sharedInstance
        
        setTopbarHidden(topBarHidden)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        singleFingerTap = UITapGestureRecognizer(target: self, action: #selector(MainViewController.handleSingleTap(_:)))
        self.view.addGestureRecognizer(singleFingerTap)
        SetupLoading()
       
    }
    
    func SetupLoading() {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.activityView = loadingView
        activityView.hidden = true
        scrollView.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        activityView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        
    }
    
    

    
    
    func setupScrollView() {

        let imgSize = image.size
        imageView.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: imgSize)
        scrollView.contentSize=imgSize
        scrollView.contentOffset = CGPoint(x: abs(imageView.frame.size.width - scrollView.frame.size.width) / 2,y: abs(imageView.frame.size.height - scrollView.frame.size.height) / 2)
     /*
        scrollView.layer.borderColor=UIColor .redColor().CGColor
        scrollView.layer.borderWidth=1
        imageView.layer.borderColor=UIColor .blueColor().CGColor
        imageView.layer.borderWidth=3
    */
    }
    
 
 
    func scrollViewDidScroll(scrollView: UIScrollView) {
        centerScrollViewContents()
 
    }
    
    //Center Image
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
     //   print("bh=\(boundsSize.height), ih=\(imageView.frame.height)")
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height)  - Size.navigationBarWithStatusHeight + (!topBarHidden ? Size.navigationBarWithStatusHeight : 0) / 2.0
        } else {
                contentsFrame.origin.y = 0.0 - (topBarHidden ? 0:Size.navigationBarWithStatusHeight )
        }
        
        imageView.frame = contentsFrame
    }

    
    
    func handleSingleTap(sender: UITapGestureRecognizer){
        if (!sideMenuOpened) {
            topBarHidden = !topBarHidden
            setTopbarHidden(topBarHidden)
            
        }
    }
    
    func setTopbarHidden(hidden:Bool)
    {
        UIApplication.sharedApplication().statusBarHidden = hidden
        self.navigationController?.navigationBarHidden = hidden
        print ("topBarHidden=\(topBarHidden.boolValue)")
        print ("size=\(self.view.frame.size.height)")
        scrollView.frame.size.height = self.view.frame.size.height
        // centerScrollViewContents()
        //let current=scrollView.contentOffset
       // scrollView.contentOffset = CGPoint(x: current.x,y :current.y - (topBarHidden ? 0:Size.navigationBarWithStatusHeight ))
       //  scrollTopConstaint.constant = hidden ?0:66
        
     
    }
    

    @IBAction func toggleSideMenu(sender: AnyObject) {
       sideMenu?.toggleMenu()
    }
    
    func sideMenuDidSelectedItem(url: String) {
        self.activityView?.hidden = false
        self.scrollView.bringSubviewToFront(self.activityView!)
        self.activityView?.startAnimating()
        
        self.imageView.image = nil
        imageURL = url
        imageProvider!.provideImage(NSURL(string:imageURL)!, completition: { (image, error) -> Void in
            guard let image = image else {
                self.activityView?.stopAnimating()
                self.activityView?.hidden = true
                return
            }
            self.image = image
            self.imageView.image = image
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.setupScrollView()
                self.view.setNeedsLayout()
                self.activityView?.stopAnimating()
                self.activityView?.hidden = true
            })
        })
    }
    
   
    
   
    func sideMenuWillOpen() {
         sideMenuOpened=true
        singleFingerTap.enabled = false
    }
    
    func sideMenuWillClose() {
        singleFingerTap.enabled = true
        sideMenuOpened=false
        topBarHidden=true
        setTopbarHidden(topBarHidden)
    }
    

}

