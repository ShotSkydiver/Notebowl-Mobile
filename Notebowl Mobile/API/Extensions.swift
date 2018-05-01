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

enum CodingError : Error {
    case RuntimeError(String)
}

public extension Decodable {
    init(json: String, keyPath: String? = "result") throws {
        guard let data = json.data(using: .utf8) else { throw CodingError.RuntimeError("cannot create data from string") }
        try self.init(data: data, keyPath: keyPath)
    }
    
    init(data: Data, keyPath: String? = "result") throws {
        if let keyPath = keyPath {
            let topLevel = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            guard let nestedJson = (topLevel as AnyObject).value(forKeyPath: keyPath) else { throw CodingError.RuntimeError("Cannot decode data to object")  }
            let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
            
            self = try JSONDecoder().decode(Self.self, from: nestedData)
            return
        }
        self = try JSONDecoder().decode(Self.self, from: data)
    }
}


public extension String {
    func encodeURIComponent() -> String? {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-_.!~*'()")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)
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
    
    public var isX: Bool {
        // case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        if modelName.contains("iPhone10,3") || modelName.contains("iPhone10,6") {
            return true
        }
        else {
            return false
        }
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
    //let grad = UIImage().createGradientImage()
    // let gradColor = UIColor(patternImage: grad)
    public var gradientColor: UIColor {
        // let grad = createGradientImage(size: 40)
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

public extension UIImageView {
    
    public func download(
        from url: URL,
        contentMode: UIViewContentMode = .scaleAspectFit,
        placeholder: UIImage? = nil,
        completionHandler: ((UIImage?) -> Void)? = nil) {
        
        image = placeholder
        self.contentMode = contentMode
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            DispatchQueue.main.async {
                self.image = image
                completionHandler?(image)
            }
            }.resume()
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

    func showViewAnimated(_ show: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = show ? 1.0 : 0.0
        }
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

extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.visibleViewController(from: rootViewController)
    }
    
    public static func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return UIWindow.visibleViewController(from: navigationController.visibleViewController ?? navigationController.topViewController)
            
        case let tabBarController as UITabBarController:
            return UIWindow.visibleViewController(from: tabBarController.selectedViewController)
            
        case let presentingViewController where viewController?.presentedViewController != nil:
            return UIWindow.visibleViewController(from: presentingViewController?.presentedViewController)
            
        default:
            return viewController
        }
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
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

class ImageTransform: TransformType {
    public typealias Object = UIImage
    public typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> UIImage? {
        let urlToGet = value as! String
        
        
        
        return UIImage().createGradientImage(size: 40)
    }
    
    func transformToJSON(_ value: UIImage?) -> String? {
        return nil
    }
}

class ObjectTransform<T: Object>: TransformType {
    public typealias Object = T
    public typealias JSON = String
    private let actionType: Action
    private let updateDate: Date?
    
    public init(action: Action = .updated, update: Date? = nil) {
        self.actionType = action
        self.updateDate = update
    }
    
    func transformFromJSON(_ value: Any?) -> T? {
        let urlToGet = value as! String
        let url = URL(string: urlToGet)

        if let objectExists = NBClient.shared.storedTypes[T.classIdentifier]?.first(where: {$0.resourceKey == url!.lastPathComponent }) {
            // TTLog.debug("object exists! ", objectExists.url.absoluteString)
            if self.actionType == .deleted {
                TTLog.debug("action type: delete!")
                if T.routeType == .notification || T.routeType == .enrollment {
                    TTLog.debug("notification about deleted!")
                    return NBClient.shared.storedTypes[T.classIdentifier]!.remove(at: (NBClient.shared.storedTypes[T.classIdentifier]?.index(of: objectExists))!) as? T
                    
                }
                else {
                    TTLog.debug("delete object!")
                    return NBClient.shared.storedTypes[T.classIdentifier]!.remove(at: (NBClient.shared.storedTypes[T.classIdentifier]?.index(of: objectExists))!) as? T
                }
            }
            else {
                
                if (self.updateDate != nil) && (self.updateDate!.timeIntervalSinceReferenceDate > objectExists.updatedAt.timeIntervalSinceReferenceDate) {
                    TTLog.debug("new object is more recent than existing object!")
                    // TODO: THIS MIGHT SLOW THINGS WAY THE HELL DOWN BECAUSE IT"S GOING TO BE RELOADING AND REMAPPING EVERY TIME IT'S UPDATED
                    
                    let r = Just.get(urlToGet, params: ["uuid": UIDevice().uuid])
                    let finalmap = Mapper<T>().map(JSONObject: (r.json as AnyObject).value(forKeyPath: "result")!)
                    
                    finalmap?.refresh()
                    
                    NBClient.shared.storedTypes[T.classIdentifier]![NBClient.shared.storedTypes[T.classIdentifier]!.index(of: objectExists)!] = finalmap!
                    return finalmap
                }
                objectExists.refresh()
                return objectExists as? T
            }
        }
        else if self.actionType == .deleted {
            return nil
        }

        else {
            let r = Just.get(urlToGet, params: ["uuid": UIDevice().uuid])
            TTLog.debug("objtransform req: ", r.url!)
            if r.statusCode != 200 || !r.ok {
                let exception = NSException(name:NSExceptionName(rawValue: "URLResponseError"),
                                            reason:"Error \(r.statusCode!): \(r.reason), url: \(r.url!.absoluteString)",
                                            userInfo:nil)
                Bugsnag.notify(exception)
                
            }
            let finalmap = Mapper<T>().map(JSONObject: (r.json as AnyObject).value(forKeyPath: "result")!)
            //if T.routeType != .course {
                finalmap?.refresh()
            finalmap?.firstTimeLoading = true
            //}
            
            
            if NBClient.shared.storedTypes[T.classIdentifier] == nil {
                NBClient.shared.storedTypes[T.classIdentifier] = [finalmap!]
            }
                
            else if NBClient.shared.storedTypes[T.classIdentifier]!.first(where: {$0.resourceKey == finalmap!.resourceKey}) == nil {
                
                NBClient.shared.storedTypes[T.classIdentifier]!.append(finalmap!)
            }
            
            
            return finalmap
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

public let valueForObjectType: Dictionary<ObjectIdentifier, Object.Type> = [
    User.classIdentifier: User.self,
    Course.classIdentifier: Course.self,
    Assignment.classIdentifier: Assignment.self,
    Post.classIdentifier: Post.self,
    Comment.classIdentifier: Comment.self,
    Like.classIdentifier: Like.self,
    Attachment.classIdentifier: Attachment.self,
    Notification.classIdentifier: Notification.self
]

