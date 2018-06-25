//
//  Extensions.swift
//  Notebowl Mobile
//
//  Created by Conner Owen on 11/21/17.
//  Copyright © 2017 NoteBowl. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import HGPlaceholders
import Bugsnag
import Kingfisher

public extension String {
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
    }
    
    var capitalised: String {
        var firstCharacter = self.first!
        firstCharacter = String(firstCharacter).uppercased().first!
        let first = String(firstCharacter)
        let rest = String(self.dropFirst())
        return first + rest
    }
}

public extension URL {
    public func appendingQueryParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url!
    }
    public mutating func appendQueryParameters(_ parameters: [String: String]) {
        self = appendingQueryParameters(parameters)
    }
    public func appendUUID() -> URL {
        let uuidParams = ["uuid": UIDevice().uuid]
        return self.appendingQueryParameters(uuidParams)
    }

}

public extension DateFormatter {
    static var iso8061: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }
}
public extension DateComponentsFormatter {
    static var monthYear: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.month, .year]
        formatter.zeroFormattingBehavior = .dropAll
        return formatter
    }
}

public extension Date {
    var relativelyFormatted: String {
        let now = Date()
        var tense: String = "default"
        var components: DateComponents!
        if (self.isInFuture) {
            components = Calendar.current.dateComponents( [.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: now, to: self)
            tense = ""
        }
        else if (self.isInPast || self.isInToday) {
            components = Calendar.current.dateComponents( [.year, .month, .weekOfYear, .day, .hour, .minute, .second], from: self, to: now)
            tense = "ago"
        }
        if let years = components.year, years > 0 {
            return "\(years) year\(years == 1 ? "" : "s") \(tense)"
        }
        if let months = components.month, months > 0 {
            return "\(months) month\(months == 1 ? "" : "s") \(tense)"
        }
        if let weeks = components.weekOfYear, weeks > 0 {
            return "\(weeks) week\(weeks == 1 ? "" : "s") \(tense)"
        }
        if let days = components.day, days > 0 {
            guard days > 1 else { return "yesterday" }
            return "\(days) day\(days == 1 ? "" : "s") \(tense)"
        }
        if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") \(tense)"
        }
        if let minutes = components.minute, minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") \(tense)"
        }
        if let seconds = components.second, seconds > 30 {
            return "\(seconds) second\(seconds == 1 ? "" : "s") \(tense)"
        }
        return "just now"
    }
    
    public var isInFuture: Bool {
        return self > Date()
    }

    public var isInPast: Bool {
        return self < Date()
    }
    
    public var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    public func isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return startDate.compare(self).rawValue * compare(endDate).rawValue >= 0
        }
        return startDate.compare(self).rawValue * compare(endDate).rawValue > 0
    }
}

public extension UITableViewCell {
    func showCell(_ show: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = show ? 1.0 : 0.0
        }
    }
}

extension UserDefaults {
    struct Keys {
        private init() {}
        static let HasUserLoggedIn = "hasUserLoggedIn"
    }
    
    class var hasUserLoggedIn: Bool {
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: UserDefaults.Keys.HasUserLoggedIn)
    }
    
    class func set(hasUserLoggedIn: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(hasUserLoggedIn, forKey: UserDefaults.Keys.HasUserLoggedIn)
    }
}

public extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    var uuid: String {
        return identifierForVendor!.uuidString
    }
    
    var deviceQuery: String {
        var params = "?uuid=\(identifierForVendor!)&name=\(name)&os=\(systemVersion)&type=\(model)&model=\(modelName)"
        params = params.encodeURIComponent()!
        var base = "/gateway/services/mobile/register"
        base = base.encodeURIComponent()!
        let finalEncoded = (base + params.encodeURIComponent()!)
        return finalEncoded
    }
}

public extension UIImage {
    public func filled(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public func createGradientImage(size: Int) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1).cgColor, #colorLiteral(red: 0.3249999881, green: 0.7139999866, blue: 0.4350000024, alpha: 1).cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        let frame = CGRect(x: 0, y: 0, width: size, height: size)
        gradientLayer.frame = frame
        
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }

    public var gradientColor: UIColor {
        return UIColor(patternImage: self)
    }
    
    public var base64EncodedString: String? {
        return self.compressed(quality: 1.0)?.base64EncodedString
    }

    public func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = compressedData(quality: quality) else { return nil }
        return UIImage(data: data)
    }
 
    public func compressedData(quality: CGFloat = 0.5) -> Data? {
        return UIImageJPEGRepresentation(self, quality)
    }

    public func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.height < size.height && rect.size.height < size.height else { return self }
        guard let image: CGImage = cgImage?.cropping(to: rect) else { return self }
        return UIImage(cgImage: image)
    }
}


@IBDesignable
class DesignableView: UIView {
}
extension DesignableView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

private var bottomLineColorAssociatedKey : UIColor = .black
private var topLineColorAssociatedKey : UIColor = .black
private var rightLineColorAssociatedKey : UIColor = .black
private var leftLineColorAssociatedKey : UIColor = .black
extension DesignableView {
    @IBInspectable var bottomLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &bottomLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &bottomLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var bottomLineWidth: CGFloat {
        get {
            return self.bottomLineWidth
        }
        set {
            self.addBottomBorderWithColor(color: self.bottomLineColor, width: newValue)
        }
    }
    @IBInspectable var topLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &topLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &topLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var topLineWidth: CGFloat {
        get {
            return self.topLineWidth
        }
        set {
            self.addTopBorderWithColor(color: self.topLineColor, width: newValue)
        }
    }
    @IBInspectable var rightLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &rightLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &rightLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var rightLineWidth: CGFloat {
        get {
            return self.rightLineWidth
        }
        set {
            self.addRightBorderWithColor(color: self.rightLineColor, width: newValue)
        }
    }
    @IBInspectable var leftLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &leftLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &leftLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var leftLineWidth: CGFloat {
        get {
            return self.leftLineWidth
        }
        set {
            self.addLeftBorderWithColor(color: self.leftLineColor, width: newValue)
        }
    }
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        DispatchQueue.main.async {
            let border = CALayer()
            border.name = "topBorderLayer"
            self.removePreviouslyAddedLayer(name: border.name ?? "")
            border.backgroundColor = color.cgColor
            border.frame = CGRect(x: 0, y : 0,width: self.frame.size.width, height: width)
            self.layer.addSublayer(border)
        }
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        DispatchQueue.main.async {
            let border = CALayer()
            border.name = "rightBorderLayer"
            self.removePreviouslyAddedLayer(name: border.name ?? "")
            border.backgroundColor = color.cgColor
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width : width, height :self.frame.size.height)
            self.layer.addSublayer(border)
        }
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        DispatchQueue.main.async {
            let border = CALayer()
            border.name = "bottomBorderLayer"
            self.removePreviouslyAddedLayer(name: border.name ?? "")
            border.backgroundColor = color.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - width,width : self.frame.size.width,height: width)
            self.layer.addSublayer(border)
        }
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        DispatchQueue.main.async {
            let border = CALayer()
            border.name = "leftBorderLayer"
            self.removePreviouslyAddedLayer(name: border.name ?? "")
            border.backgroundColor = color.cgColor
            border.frame = CGRect(x:0, y:0,width : width, height : self.frame.size.height)
            self.layer.addSublayer(border)
        }
    }
    func removePreviouslyAddedLayer(name : String) {
        if self.layer.sublayers?.count ?? 0 > 0 {
            self.layer.sublayers?.forEach {
                if $0.name == name {
                    $0.removeFromSuperlayer()
                }
            }
        }
    }
}


@IBDesignable class ProfileImageView: UIImageView {
    
    @IBInspectable var dashedBorder: Bool = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    @IBInspectable var isCircular: Bool = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    @IBInspectable var cornerRadious: CGFloat = 5 {
        didSet {
            self.setNeedsLayout()
        }
    }
    @IBInspectable var borderColorImg: UIColor = UIColor.blue {
        didSet {
            self.setNeedsLayout()
        }
    }
    @IBInspectable var borderWidthImg: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var colorShadow: UIColor = UIColor.darkGray {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var offsetShadow: CGSize = .zero {
        didSet {
            self.setNeedsLayout()
        }
    }

    @IBInspectable var opacityShadow: Float = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var radiusShadow: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var pathShadow: CGPath? = nil {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var masksToBounds: Bool = true {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.applyProperties()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        self.applyProperties()
    }
    func applyProperties()
    {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = borderColorImg.cgColor
        shapeLayer.lineWidth = borderWidthImg
        shapeLayer.lineJoin = kCALineJoinRound
        if dashedBorder{
            shapeLayer.lineDashPattern = [6,3]
        }
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: isCircular ? CGFloat(self.frame.size.height / 2.0) :  cornerRadious).cgPath
        self.layer.cornerRadius = isCircular ? CGFloat(self.frame.size.height / 2.0) :  cornerRadious
        
        self.layer.shadowColor = colorShadow.cgColor
        self.layer.shadowOffset = offsetShadow
        self.layer.shadowOpacity = opacityShadow
        self.layer.shadowRadius = radiusShadow
        self.layer.shadowPath = pathShadow
        
        self.layer.masksToBounds = masksToBounds
        self.layer.addSublayer(shapeLayer)
    }
}

@IBDesignable class DottedLine: UIView {
    
    @IBInspectable
    public var lineColor: UIColor = UIColor.black
    
    @IBInspectable
    public var lineWidth: CGFloat = CGFloat(4)
    
    @IBInspectable
    public var round: Bool = false
    
    @IBInspectable
    public var horizontal: Bool = true
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initBackgroundColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBackgroundColor()
    }
    
    override public func prepareForInterfaceBuilder() {
        initBackgroundColor()
    }
    
    override public func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        if round {
            configureRoundPath(path: path, rect: rect)
        } else {
            configurePath(path: path, rect: rect)
        }
        
        lineColor.setStroke()
        
        path.stroke()
    }
    
    func initBackgroundColor() {
        if backgroundColor == nil {
            backgroundColor = UIColor.clear
        }
    }
    
    private func configurePath(path: UIBezierPath, rect: CGRect) {
        if horizontal {
            let center = rect.height * 0.5
            let drawWidth = rect.size.width - (rect.size.width.truncatingRemainder(dividingBy: (lineWidth * 2))) + lineWidth
            let startPositionX = (rect.size.width - drawWidth) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: startPositionX, y: center))
            path.addLine(to: CGPoint(x: drawWidth, y: center))
            
        } else {
            let center = rect.width * 0.5
            let drawHeight = rect.size.height - (rect.size.height.truncatingRemainder(dividingBy: (lineWidth * 2))) + lineWidth
            let startPositionY = (rect.size.height - drawHeight) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: center, y: startPositionY))
            path.addLine(to: CGPoint(x: center, y: drawHeight))
        }
        
        let dashes: [CGFloat] = [lineWidth, lineWidth]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.butt
    }
    
    private func configureRoundPath(path: UIBezierPath, rect: CGRect) {
        if horizontal {
            let center = rect.height * 0.5
            let drawWidth = rect.size.width - (rect.size.width.truncatingRemainder(dividingBy: (lineWidth * 2)))
            let startPositionX = (rect.size.width - drawWidth) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: startPositionX, y: center))
            path.addLine(to: CGPoint(x: drawWidth, y: center))
            
        } else {
            let center = rect.width * 0.5
            let drawHeight = rect.size.height - (rect.size.height.truncatingRemainder(dividingBy: (lineWidth * 2)))
            let startPositionY = (rect.size.height - drawHeight) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: center, y: startPositionY))
            path.addLine(to: CGPoint(x: center, y: drawHeight))
        }
        
        let dashes: [CGFloat] = [0, lineWidth * 2]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.round
    }
}

@IBDesignable
class KerningLabel: UILabel {
    
    @IBInspectable var kerning: CGFloat = 0.0 {
        didSet {
            if attributedText?.length == nil { return }
            
            let attrStr = NSMutableAttributedString(attributedString: attributedText!)
            let range = NSMakeRange(0, attributedText!.length)
            attrStr.addAttributes([NSAttributedStringKey.kern: kerning], range: range)
            attributedText = attrStr
        }
    }
}


extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIView {
    convenience init(loadingView: NBLoadingView) {
        self.init(frame: UIScreen.main.bounds)
        
        self.backgroundColor = UIColor.groupTableViewBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(loadingView)
        loadingView.addUntitled2Animation()
    }

    func showViewAnimated(_ show: Bool, alpha: CGFloat = 1.0) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = show ? alpha : 0.0
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

public extension Bool {
    @discardableResult public mutating func toggle() -> Bool {
        self = !self
        return self
    }
}

public extension UITableView {

    public func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }

    public func scrollToTop(animated: Bool = true) {
        setContentOffset(CGPoint.zero, animated: animated)
    }
    
    var reachedBottom: Bool {
        get {
            return self.contentOffset.y >= (self.contentSize.height - self.bounds.size.height)
        }
    }
    public func reloadData(withoutScroll scroll: Bool = false) {
        if scroll {
            reloadData()
        } else {
            let offset = contentOffset
            reloadData()
            layoutIfNeeded()
            contentOffset = offset
        }
    }
}

public extension UIViewController {
    public var extendedLayout: Bool {
        set {
            extendedLayoutIncludesOpaqueBars = !newValue
            edgesForExtendedLayout = newValue ? .all : []
        }
        get {
            return edgesForExtendedLayout != []
        }
    }
}

public extension UIApplication {
    public var topestViewController: UIViewController? {
        return self.keyWindow?.topestViewController
    }
}
public extension UIWindow {
    public var topestViewController: UIViewController? {
        let root = self.rootViewController
        if let navi = root as? UINavigationController {
            return navi.topestViewController
        }
        if let tab = root as? UITabBarController {
            return tab.topestViewController
        }
        return root?.findTopestViewController()
    }
}
public extension UINavigationController {
    public var topestViewController: UIViewController? {
        let top = self.topViewController
        if let presented = top?.presentedViewController {
            if let topPresented = presented as? UINavigationController {
                return topPresented.topestViewController
            }
            return presented
        }
        return top
    }
}
public extension UITabBarController {
    public var topestViewController: UIViewController? {
        let selected = self.selectedViewController
        if let navi = selected as? UINavigationController {
            return navi.topestViewController
        }
        return selected
    }
}
public extension UIViewController {
    public func findTopestViewController() -> UIViewController? {
        if let presented = self.presentedViewController {
            if let topPresented = presented as? UINavigationController {
                return topPresented.topestViewController
            }
            return presented
        }
        return self
    }
}

extension DispatchQueue {
    func safeAsync(_ block: @escaping ()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async { block() }
        }
    }
}

extension UIColor {
    public var hexString: String {
        let components: [Int] = {
            let c = cgColor.components!
            let components = c.count == 4 ? c : [c[0], c[0], c[0], c[1]]
            return components.map { Int($0 * 255.0) }
        }()
        return String(format: "#%02X%02X%02X", components[0], components[1], components[2])
    }
    
    convenience init(hexString: String) {
        
        let hexString: String       = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner                 = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}

extension Array where Element: Equatable {
    public mutating func removeAll(_ item: Element) {
        self = self.filter { $0 != item }
    }
}
extension Dictionary {
    public func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    
    /// SwifterSwift: Count dictionary entries that where function returns true.
    ///
    /// - Parameter where: condition to evaluate each tuple entry against.
    /// - Returns: Count of entries that matches the where clousure.
    public func count(where condition: @escaping ((key: Key, value: Value)) throws -> Bool) rethrows -> Int {
        var count: Int = 0
        try self.forEach {
            if try condition($0) {
                count += 1
            }
        }
        return count
    }
    
    /// SwifterSwift: Merge the keys/values of two dictionaries.
    ///
    ///        let dict : [String : String] = ["key1" : "value1"]
    ///        let dict2 : [String : String] = ["key2" : "value2"]
    ///        let result = dict + dict2
    ///        result["key1"] -> "value1"
    ///        result["key2"] -> "value2"
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: dictionary
    /// - Returns: An dictionary with keys and values from both.
    public static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }
}
extension PlaceholdersProvider {
    
    static var emptyHome: PlaceholderData {
        var emptyStyle = PlaceholderData()
        emptyStyle.image = UIImage(named: "sad-face-vector")
        emptyStyle.title = "It's lonely in here!"
        emptyStyle.subtitle = "If you're enrolled in any courses for the current semester, you'll see them here, as well as your latest grades and assignments."
        emptyStyle.action = "Check again!"
        return emptyStyle
    }
    static var emptyCourses: PlaceholderData {
        var emptyStyle = PlaceholderData()
        emptyStyle.image = PlaceholderData.error.image
        emptyStyle.title = "Enroll in some courses!"
        emptyStyle.subtitle = "If you're enrolled in any courses for the current semester, you'll see them here, as well as your latest grades and assignments."
        emptyStyle.action = "Check again!"
        return emptyStyle
    }
    static var emptyNotifications: PlaceholderData {
        var emptyStyle = PlaceholderData()
        emptyStyle.image = UIImage(named: "thinking-face-vector")
        emptyStyle.title = "Nothing noteworthy has happened!"
        emptyStyle.subtitle = "If you're enrolled in any courses for the current semester, you'll see them here, as well as your latest grades and assignments."
        emptyStyle.action = "Check again!"
        return emptyStyle
    }
    
    static var commonStyle: PlaceholderStyle {
        var nbStyle = PlaceholderStyle()
        nbStyle.backgroundColor = .groupTableViewBackground
        nbStyle.actionBackgroundColor = #colorLiteral(red: 0.2310000062, green: 0.6510000229, blue: 0.8859999776, alpha: 1)
        nbStyle.actionTitleColor = .groupTableViewBackground
        nbStyle.titleColor = .darkText
        nbStyle.subtitleColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
        nbStyle.isAnimated = true
        nbStyle.titleFont = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
        nbStyle.subtitleFont = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        nbStyle.actionTitleFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        return nbStyle
    }
    
    static var homeFeedPlaceholders: PlaceholdersProvider {
        let homePlaceholder = Placeholder(data: emptyHome, style: commonStyle, key: .noResultsKey)
        let provider = PlaceholdersProvider(loading: Placeholder(data: .loading, style: commonStyle, key: .loadingKey), error: Placeholder(data: .error, style: commonStyle, key: .errorKey), noResults: homePlaceholder, noConnection: Placeholder(data: .noConnection, style: commonStyle, key: .noConnectionKey))
        return provider
    }
    static var coursesPlaceholders: PlaceholdersProvider {
        let coursePlaceholder = Placeholder(data: emptyCourses, style: commonStyle, key: .noResultsKey)
        let provider = PlaceholdersProvider(loading: Placeholder(data: .loading, style: commonStyle, key: .loadingKey), error: Placeholder(data: .error, style: commonStyle, key: .errorKey), noResults: coursePlaceholder, noConnection: Placeholder(data: .noConnection, style: commonStyle, key: .noConnectionKey))
        return provider
    }
    static var notifsPlaceholders: PlaceholdersProvider {
        let notificationPlaceholder = Placeholder(data: emptyNotifications, style: commonStyle, key: .noResultsKey)
        let provider = PlaceholdersProvider(loading: Placeholder(data: .loading, style: commonStyle, key: .loadingKey), error: Placeholder(data: .error, style: commonStyle, key: .errorKey), noResults: notificationPlaceholder, noConnection: Placeholder(data: .noConnection, style: commonStyle, key: .noConnectionKey))
        return provider
    }
}

class ObjectTransform<T: NBModel>: TransformType {
    public typealias Object = T
    public typealias JSON = String
    
    private let actionType: ActionType?
    private let updateDate: Date?
    
    public init(action: ActionType = .unknown, update: Date? = nil) {
        self.actionType = action
        self.updateDate = update
    }
    
    func transformFromJSON(_ value: Any?) -> T? {
        if value == nil { return nil }
        let urlToGet = value as! String
        let url = URL(string: urlToGet)
        
        if let objectExists = NBClient.shared.storedTypes[T.classIdentifier]?.first(where: {$0.resourceKey == url!.lastPathComponent }) {
            if self.actionType == .elapsed {
                TTLog.debug("action: elapsed!")
                return objectExists as? T
            }
            else if self.actionType == .deleted {
                TTLog.debug("action type: delete!")
                return NBClient.shared.storedTypes[T.classIdentifier]!.remove(at: (NBClient.shared.storedTypes[T.classIdentifier]?.index(of: objectExists))!) as? T
            }
            else {
                if (self.updateDate != nil) && (self.updateDate!.timeIntervalSinceReferenceDate > objectExists.updatedAt.timeIntervalSinceReferenceDate) {
                    TTLog.debug("new object is more recent than existing object!")
                    let mapReq = NBClient.shared.getMappable(T.self, url: urlToGet)
                    
                    return mapReq?.first
                }
                
                return objectExists as? T
            }
        }
        else if self.actionType == .deleted || self.actionType == .elapsed {
            return nil
        }

        else {
            let mapReq = NBClient.shared.getMappable(T.self, url: urlToGet)
            guard let returnObject = mapReq?.first else {
                return nil
            }
            if returnObject.itemType != "Course" {returnObject.refresh() }
            return returnObject
        }
    }
    
    func transformToJSON(_ value: T?) -> String? {
        return nil
    }
}

class ISO8601FixedDateTransform: DateFormatterTransform {
    
    static let reusableISODateFormatter = DateFormatter(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", locale: "en_US_POSIX")
    
    public init() {
        super.init(dateFormatter: ISO8601FixedDateTransform.reusableISODateFormatter)
    }
}

struct Paths {
    var insertSections: IndexSet
    var deleteSections: IndexSet
    var reloadSections: IndexSet
    var insertIndexPaths: [IndexPath]
    var deleteIndexPaths: [IndexPath]
    var reloadIndexPaths: [IndexPath]
    init() {
        insertSections = IndexSet()
        deleteSections = IndexSet()
        reloadSections = IndexSet()
        insertIndexPaths = [IndexPath]()
        deleteIndexPaths = [IndexPath]()
        reloadIndexPaths = [IndexPath]() }
    
    var shouldReload: Bool {
        if insertSections.isEmpty && deleteSections.isEmpty && reloadSections.isEmpty && insertIndexPaths.isEmpty && deleteIndexPaths.isEmpty && reloadIndexPaths.isEmpty { return false }
        else { return true }
    }
}

protocol UpdateVC {
    
    func handleUpdated(newObject: NBModel)
    func handleDeleted(deletedObject: NBModel)
    func handleElapsed(elapsedObject: NBModel)
    
    func reloadTableViews()
}



enum AppConfiguration {
    case Debug
    case TestFlight
    case AppStore
}

struct Config {
    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    static var appConfiguration: AppConfiguration {
        if isDebug {
            return .Debug
        } else if isTestFlight {
            return .TestFlight
        } else {
            return .AppStore
        }
    }
}
