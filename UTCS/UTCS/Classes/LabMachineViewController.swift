import UIKit
import Shimmer

class LabViewController: UIViewController {
    var imageOffset: CGPoint!
    var shimmeringView: FBShimmeringView!
    var errorView: ServiceErrorView = {
        let view = ServiceErrorView.loadFromNib()
        view.errorLabel.text = "Ouch! Something went wrong.\n\nPlease check your network connection."
        view.alpha = 0.0
        return view
    }()
    var labView: LabView!
    var backgroundImageView: UIImageView!
    var layout: LabViewLayout!
    var backgroundContainer: UIView!

    var machines: [String: LabMachine]?
    
    init(layout: LabViewLayout) {
        super.init(nibName: nil, bundle: nil)
        self.layout = layout
        
        // Set up background's container
        backgroundContainer = UIView(frame: view.bounds)
        backgroundContainer.clipsToBounds = true
        
        // Set up background image
        backgroundImageView = UIImageView(frame: view.bounds)

        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.clipsToBounds = false
        
        // Add image to background container
        backgroundContainer.addSubview(backgroundImageView)
        view.addSubview(backgroundContainer)
        
        // Set up the labview and add to self
        labView = LabView(frame: CGRectZero, layout: layout)
        labView.frame = CGRect(x: 0.0, y: 44.0, width: view.bounds.size.width, height: view.bounds.size.height - 44.0)
        labView.backgroundColor = .clearColor()
        labView.alpha = 0.0
        labView.dataSource = self
        view.addSubview(labView)
        
        shimmeringView = FBShimmeringView(frame: CGRectZero)
        
        let label = UILabel(frame: CGRectZero)
        label.font = .systemFontOfSize(50.0)
        label.textAlignment = .Center
        label.textColor = .whiteColor()
        label.numberOfLines = 0
        
        shimmeringView.contentView = label
        
        errorView.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.size.width, height: 0.5 * view.bounds.size.height)
        errorView.center = CGPoint(x: view.center.x, y: 0.9 * view.center.y)
        view.addSubview(errorView)
        labView.prepareLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds
        labView.invalidateLayout()
    }
    
    func setImageOffset(imageOffset: CGPoint) {
        self.imageOffset = imageOffset
        let frame = backgroundContainer.bounds
        let offsetFrame = CGRectOffset(frame, imageOffset.x, imageOffset.y)
        backgroundImageView.frame = offsetFrame
    }
}

extension LabViewController: LabViewDataSource {
    func labView(labView: LabView, machineViewForIndexPath: NSIndexPath, name: String) -> LabMachineView {
        let machineView = labView.dequeueMachineViewForIndexPath(machineViewForIndexPath)
        guard let machine = machines?[name] else {
            machineView.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
            return machineView
        }
        if !machine.status {
            machineView.backgroundColor = UIColor(white: 0.5, alpha: 0.25)
        } else if machine.occupied {
            machineView.backgroundColor = UIColor(red: 0.863, green: 0.000, blue: 0.052, alpha: 1.000)
        } else {
            machineView.backgroundColor = UIColor(red: 0.180, green: 0.901, blue: 0.150, alpha: 1.000)
        }
        return machineView
    }
}
