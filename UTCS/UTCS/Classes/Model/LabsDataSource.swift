typealias Lab = [String: UTCSLabMachine]
final class LabsDataSource: ServiceDataSource {
    override var router: Router {
        return Router.Labs()
    }

    var labsData: [String: Lab]? {
        return data as? [String: Lab]
    }

    var third: Lab? {
        return labsData?["third"]
    }
    var basement: Lab? {
        return labsData?["basement"]
    }

    init() {
        super.init(service: .Labs, parser: LabsDataSourceParser())
    }
}
