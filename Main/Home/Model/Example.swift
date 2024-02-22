struct Example {
	var title: String
	var description: String
	var aClass: ExampleProtocol.Type

	func makeViewController() -> UIViewController {
		guard let exampleClass = aClass as? UIViewController.Type else {
			fatalError("Unable to get class name from example named \(aClass)")
		}

		let exampleViewController: UIViewController

		// Look for a storyboard
		let storyboardName = String(describing: exampleClass)
		if Bundle.main.path(forResource: storyboardName, ofType: "storyboard") != nil {
			let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
			exampleViewController = storyboard.instantiateInitialViewController()!

			// Check controller is what we expect
			assert(Swift.type(of: exampleViewController) == exampleClass)
		} else {
			exampleViewController = exampleClass.init()
		}

		exampleViewController.title = title
		exampleViewController.navigationItem.largeTitleDisplayMode = .never

		return exampleViewController
	}
}
