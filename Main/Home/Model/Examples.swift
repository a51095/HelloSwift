struct Examples {
    static let all = [
        [
            "title": "Tool",
            "examples": toolExamples
        ],
        [
            "title": "View",
            "examples": viewExamples
        ]
    ]
    
    static let toolExamples = [
        Example(title: "Alert", description: "An alert presentation", aClass: ExampleAlertViewController.self),
        Example(title: "Toast", description: "An toast presentation", aClass: ExampleToastViewController.self),
        Example(title: "Loading", description: "An loading presentation", aClass: ExampleLoadingViewController.self),

    ]
    
    static let viewExamples = [
        Example(title: "Time", description: "An time presentation", aClass: ExampleTimeViewController.self),
        Example(title: "Location", description: "An location presentation", aClass: ExampleLocationViewController.self)
    ]
}
