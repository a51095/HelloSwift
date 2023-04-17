public protocol ExampleProtocol: AnyObject { }

extension ExampleProtocol {
    func convertToNumber(_ number: String) -> String {
        let dict = ["1":"一", "2":"二", "3":"三", "4":"四", "5":"五", "6":"六", "7":"七", "8":"八", "9":"九", "0":"零"]
        var result = ""
        for char in number {
            if let chinese = dict[String(char)] {
                result += chinese
            }
        }
        return result
    }
}
