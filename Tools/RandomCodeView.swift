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
    private var resString: String = String()
    /// 验证码数据源
    private var codeStringSet = "abcdefghijklmnopqristuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    /// 角度数据源
    private var angleArray = [Double]()
    /// 结果label
    private var labelArray = [UILabel]()
    /// 约束布局stackView
    private var stackView: UIStackView!
    /// 结果回调
    private var callBack: ((String) -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 反初始化器
    deinit { kPrint("RandomCodeView deinit") }
        
    init(frame: CGRect, callBack: ((String) -> Void)?) {
        super.init(frame: frame)
        self.callBack = callBack
        self.initData()
        self.initSubview()
        changeValue()
    }
    
    // MARK: 数据初始化
    func initData() {
        angleArray = [-0.25, -0.45, -0.65, -0.85, 0.35, 0.55, 0.75, 0.95]
        for _ in 0..<defaultCount { labelArray.append(createLabel()) }
    }
    
    // MARK: 控件初始化
    func initSubview() {
        self.layer.masksToBounds = true
        stackView = UIStackView(arrangedSubviews: labelArray)
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        for _ in 0...9 {
            let path = UIBezierPath()
            let pX = CGFloat.random(in: 0..<frame.width)
            let pY = CGFloat.random(in: 0..<frame.height)
            path.move(to: CGPoint(x: CGFloat(pX), y: CGFloat(pY)))
            let ptX = CGFloat.random(in: 0..<frame.width)
            let ptY = CGFloat.random(in: 0..<frame.height)
            path.addLine(to: CGPoint(x: CGFloat(ptX), y: CGFloat(ptY)))

            let layer = CAShapeLayer()
            layer.strokeColor = UIColor.hexColor("#ffffff", 0.2).cgColor
            layer.lineWidth = 1
            layer.strokeEnd = 1
            layer.fillColor = UIColor.clear.cgColor
            layer.path = path.cgPath
            stackView.layer.addSublayer(layer)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        stackView.removeFromSuperview()
        initSubview()
        changeValue()
    }
    
    private func changeValue() {
        // 先清空,再更新
        resString = ""
        self.backgroundColor = randomColorWithoutBlack()
        for ele in labelArray {
            let aIndex = Int.random(in: 0..<angleArray.count)
            let cIndex = Int.random(in: 0..<codeStringSet.count)
            let codeChar = codeStringSet[codeStringSet.index(codeStringSet.startIndex, offsetBy: cIndex)]
            let angleValue = angleArray[aIndex]
            resString.append(codeChar)
            ele.text = String(codeChar)
            ele.transform = CGAffineTransform(rotationAngle: angleValue)
        }
        callBack?(resString)
    }
    
    private func createLabel() -> UILabel {
        let l = UILabel()
        l.textColor = .white
        l.font = kSemiblodFont(22)
        l.textAlignment = .center
        return l
    }
    
    private func randomColorWithoutBlack() -> UIColor {
        var randomColor: UIColor
        repeat {
            // 生成随机颜色
            randomColor = UIColor(red: .random(in: 0...1),
                                  green: .random(in: 0...1),
                                  blue: .random(in: 0...1),
                                  alpha: 1.0)
        } while randomColor.isEqual(UIColor.white) // 过滤白色
        return randomColor
    }
}
