class LabMachineViewController: UIViewController, UTCSLabViewDataSource {
    var machines = [AnyObject]()
    var imageOffset: CGPoint!
    var shimmeringView: FBShimmeringView!
    var errorView: ServiceErrorView!
    var labView: UTCSLabView!
    var backgroundImageView: UIImageView!
    var layout = UTCSLabViewLayout()

    init(layout: UTCSLabViewLayout){
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func labView(labView: UTCSLabView!, machineViewForIndexPath indexPath: NSIndexPath!, name: String!) -> UTCSLabMachineView! {
        ()
        return nil
    }

}
