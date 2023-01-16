//
//  RandomCodeView.swift
//  HelloSwift
//
//  Created by well on 2021/9/24.
//

/**
 * RandomCodeView:
 * 随机验证码视图
 * 支持随机背景色、支持随机角度
 **/

class RandomCodeView: UIView {
    
    /// 验证码个数(默认4)
    private let defaultCount: Int = 4
    /// 结果字符串
    private var resString: String = ""
    /// 验证码数据源
    private var codeArray = [String]()
    /// 角度数据源
    private var angleArray = [Double]()
    /// 结果label
    private var labelArray = [UILabel]()
    /// 约束布局stackView
    private var stackView: UIStackView!
    /// 结果回调
    var callBack: ((String) -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 反初始化器
    deinit { kPrint("RandomCodeView deinit") }
    
    // MARK: 初始化器
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.initData()
        self.setUI()
    }
    
    // MARK: 数据初始化
    func initData()  {
        angleArray = [0, 0.25, 0.5, 0.75, 1]
        codeArray = ["0","1","2","3","4","5","6","7","8","9",
                     "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                     "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        for _ in 0..<defaultCount { labelArray.append(createLabel()) }
    }
    
    // MARK: 控件初始化
    func setUI() {
        self.layer.masksToBounds = true
        stackView = UIStackView(arrangedSubviews: labelArray)
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        for _ in 0...9 {
            let path = UIBezierPath()
            let pX = arc4random_uniform(UInt32(self.frame.width))
            let pY = arc4random_uniform(UInt32(self.frame.height))
            path.move(to: CGPoint(x: CGFloat(pX), y: CGFloat(pY)))
            let ptX = arc4random_uniform(UInt32(self.frame.width))
            let ptY = arc4random_uniform(UInt32(self.frame.height))
            path.addLine(to: CGPoint(x: CGFloat(ptX), y: CGFloat(ptY)))
            
            let layer = CAShapeLayer()
            layer.strokeColor = UIColor.hexColor("#ffffff", 0.2).cgColor
            layer.lineWidth = 1
            layer.strokeEnd = 1
            layer.fillColor = UIColor.clear.cgColor
            layer.path = path.cgPath
            stackView.layer.addSublayer(layer)
        }
        changeValue()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { changeValue() }
    
    // MARK: - 私有方法
    private func changeValue() {
        // 先清空,再更新
        resString = ""
        self.backgroundColor = .random
        for (_, ele) in labelArray.enumerated() {
            let aIndex = Int(arc4random_uniform(UInt32(angleArray.count)))
            let cIndex = Int(arc4random_uniform(UInt32(codeArray.count)))
            let textString = codeArray[cIndex]
            let angleValue = angleArray[aIndex]
            resString.append(textString)
            
            ele.text = textString
            ele.transform = CGAffineTransform(rotationAngle: angleValue)
        }
        callBack?(resString)
    }
    
    private func createLabel() -> UILabel {
        let l = UILabel()
        l.textColor = .black
        l.font = RegularFont(16)
        l.textAlignment = .center
        return l
    }
}
