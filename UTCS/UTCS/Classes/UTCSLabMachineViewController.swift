import UIKit

class UTCSLabMachineViewController: UIViewController, UTCSLabViewDataSource {
    var machines = [AnyObject]()
    var imageOffset: CGPoint!
    var shimmeringView: FBShimmeringView!
    var errorView: ServiceErrorView!
    var labView: UTCSLabView!
    var backgroundImageView: UIImageView!
    var layout = UTCSLabViewLayout()
    var backgroundContainer: UIView
    
    init(layout: UTCSLabViewLayout) {
        super.init(nibName: nil, bundle: nil)
        self.layout = layout
        
        // Set up background's container
        self.backgroundContainer = UIView(self.view.bounds)
        self.backgroundContainer.clipsToBounds = true
        
        // Set up background image
        self.backgroundImageView = UIImageView(self.view.bounds)
        self.backgroundImageView.contentMode = UIVIewContentModeScaleAspectFill
        self.backgroundImageView.clipsToBounds = false
        
        // Add image to background container
        self.backgroundContainer.addSubview(self.backgroundImageView)
        self.view.addSubview(self.backgroundContainer)
        
        // Set up the labview and add to self
        self.labView = UTCSLabView(frame: CGRectZero(), layout: self.layout)
        self.labView.frame = CGRectMake(0.0, 44.0, self.view.bounds.size.width, self.view.bounds.size.height - 44.0)
        self.labView.backgroundColor = UIColor.clearColor
        self.labView.alpha = 0.0
        self.labView.dataSource = self
        self.view.addSubview(self.labView)
        
        self.shimmeringView = FBShimmeringView(frame: CGRectZero)
        self.shimmeringView.contentView = {
            let label = UILabel(frame: CGRectZero)
            label.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColor.whiteColor
            label.numberOfLines = 0
            label
        }
        
        self.errorView = {
            let view = ServiceErrorView(frame: CGRectZero)
            view.errorLabel.text = "Ouch! Something went wrong.\n\nPlease check your network connection."
            view.alpha = 0.0
            view
        }
        
        self.errorView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 0.5 * self.view.bounds.size.height)
        self.errorView.center = CGPointMake(self.view.center.x, 0.9 * self.view.center.y)
        self.view.addSubview(self.errorView)
        self.labView.prepareLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func labView(labView: UTCSLabView!, machineViewForIndexPath indexPath: NSIndexPath!, name: String!) -> UTCSLabMachineView! {
        let machineView = labView.dequeueMachineView(indexPath)
        let machine = self.machines[name]
        if let machine = machine {
            machineView.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        } else {
            if machine.status == nil {
                machineView.backgroundColor = UIColor(white: 0.5, alpha: 0.25)
            } else if machine.occupied != nil {
                machineView.backgroundColor = UIColor(red: 0.863, green: 0.000, blue: 0.052, alpha: 1.000)
            } else {
                machineView.backgroundColor = UIColor(red: 0.180, green: 0.901, blue: 0.150, alpha: 1.000)
            }
        }
        return machineView
    }

    func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.backgroundImageView.frame = self.view.bounds
        self.labView.invalidateLayout()
    }
    
    func viewDidLoad() { super.viewDidLoad() }
    
    func setImageOffset(imageOffset: CGPoint) {
        self.imageOffset = imageOffset
        let frame = self.backgroundContainer.bounds
        let offsetFrame = CGRectOffset(frame, self.imageOffset.x, self.imageOffset.y)
        self.backgroundImageView.frame = offsetFrame
    }
}
