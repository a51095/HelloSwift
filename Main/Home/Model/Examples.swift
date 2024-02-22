struct Examples {
	static let all = [
		[
			"title": "Func",
			"examples": funcExamples
		],
		[
			"title": "Tool",
			"examples": toolExamples
		],
		[
			"title": "View",
			"examples": viewExamples
		],
		[
			"title": "Module",
			"examples": moduleExamples
		]
	]

	static let funcExamples = [
		Example(title: "Property", description: "An property wrapper", aClass: ExamplePropertyViewController.self),
		Example(title: "Async", description: "An async presentation", aClass: ExampleAsyncViewController.self),
	]

	static let toolExamples = [
		Example(title: "Alert", description: "An alert presentation", aClass: ExampleAlertViewController.self),
		Example(title: "Toast", description: "An toast presentation", aClass: ExampleToastViewController.self),
		Example(title: "Loading", description: "An loading presentation", aClass: ExampleLoadingViewController.self)
	]

	static let viewExamples = [
		Example(title: "Time", description: "An time presentation", aClass: ExampleTimeViewController.self),
		Example(title: "Location", description: "An location presentation", aClass: ExampleLocationViewController.self),
		Example(title: "Bluetooth", description: "An bluetooth presentation", aClass: ExampleBluetoothViewController.self),
		Example(title: "CountDown", description: "An SMS countdown presentation", aClass: ExampleCountDownViewController.self),
		Example(title: "DragView", description: "An Drag View presentation", aClass: ExampleDragViewController.self),
		Example(title: "ScaleAspectView", description: "An ScaleAspect View presentation", aClass: ExampleScaleAspectViewController.self),
		Example(title: "RandomCodeView", description: "An RandomCode View presentation", aClass: ExampleRandomCodeViewController.self),
	]

	static let moduleExamples = [
		Example(title: "Photo", description: "An photo presentation", aClass: ExamplePhotoAlbumViewController.self),
	]
}
