//
//  NBLoadingView.swift
//
//  Code generated using QuartzCode 1.62.0 on 11/1/17.
//  www.quartzcodeapp.com
//

import UIKit

@IBDesignable
class NBLoadingView: UIView, CAAnimationDelegate {
	
	var layers = [String: CALayer]()
	var completionBlocks = [CAAnimation: (Bool) -> Void]()
	var updateLayerValueForCompletedAnimation : Bool = false
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupProperties()
		setupLayers()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		setupProperties()
		setupLayers()
	}

    init() {
        let dimensions: CGFloat = 170
        if let window = UIApplication.shared.keyWindow {
            let centerX = (window.center.x-(dimensions/2))
            let centerY = ((window.center.y-141)-(dimensions/2))
            super.init(frame: CGRect(x: centerX, y: centerY, width: dimensions, height: dimensions))
            
            self.alpha = 0.0
            
            setupProperties()
            setupLayers()
        }
        else {
            super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            setupProperties()
            setupLayers()
        }
    }

	
	func setupProperties(){
		
	}
	
	func setupLayers(){
		self.backgroundColor = UIColor.groupTableViewBackground
        self.layer.cornerRadius = 10
		
		let Group = CALayer()
		let originalFrame = CGRect(x: 18, y: 17.6, width: 114.14, height: 129.9)
		Group.frame = CGRect(x: 28, y: 27.6, width: 114.14, height: 129.9)
        
		self.layer.addSublayer(Group)
		layers["Group"] = Group
		let oval = CAShapeLayer()
		oval.anchorPoint = CGPoint(x: 0.5, y: -2.4)
		oval.frame       = CGRect(x: 5.86, y: 108.67, width: 102.53, height: 21.23)
		oval.fillColor   = nil
		oval.strokeColor = UIColor(red:0.383, green: 0.383, blue:0.383, alpha:1).cgColor
		oval.lineWidth   = 3
		oval.path        = ovalPath().cgPath
		Group.addSublayer(oval)
		layers["oval"] = oval
		let oval2 = CAShapeLayer()
		oval2.anchorPoint = CGPoint(x: 0.5, y: -2.4)
		oval2.frame       = CGRect(x: 10.59, y: 103.76, width: 92.59, height: 19.14)
		oval2.fillColor   = nil
		oval2.strokeColor = UIColor(red:0.277, green: 0.712, blue:0.91, alpha:1).cgColor
		oval2.lineWidth   = 3
		oval2.path        = oval2Path().cgPath
		Group.addSublayer(oval2)
		layers["oval2"] = oval2
		let oval3 = CAShapeLayer()
		oval3.anchorPoint = CGPoint(x: 0.5, y: -2.4)
		oval3.frame       = CGRect(x: 16.72, y: 97.22, width: 80.71, height: 16.68)
		oval3.fillColor   = nil
		oval3.strokeColor = UIColor(red:0.384, green: 0.753, blue:0.51, alpha:1).cgColor
		oval3.lineWidth   = 3
		oval3.path        = oval3Path().cgPath
		Group.addSublayer(oval3)
		layers["oval3"] = oval3
		
		let nblogotransparent = CALayer()
		let originalLogoFrame           = CGRect(x: 47.5, y: 56.16, width: 55, height: 37.4)
        nblogotransparent.frame           = CGRect(x: 57.5, y: 66.16, width: 55, height: 37.4)
		nblogotransparent.contents        = UIImage(named:"nb-logo-transparent")?.cgImage
		nblogotransparent.contentsGravity = kCAGravityResizeAspect
		self.layer.addSublayer(nblogotransparent)
		layers["nblogotransparent"] = nblogotransparent
	}
	
	
	func addUntitled2Animation(){
		let fillMode : String = kCAFillModeForwards
		
		let ovalTransformAnim         = CAKeyframeAnimation(keyPath:"transform.rotation.z")
		ovalTransformAnim.values      = [0, 
			 360 * CGFloat.pi/180]
		ovalTransformAnim.keyTimes    = [0, 1]
		ovalTransformAnim.duration    = 1.5
		ovalTransformAnim.repeatCount = Float.infinity
		
		let ovalUntitled2Anim : CAAnimationGroup = QCMethod.group(animations: [ovalTransformAnim], fillMode:fillMode)
		layers["oval"]?.add(ovalUntitled2Anim, forKey:"ovalUntitled2Anim")

		let oval2TransformAnim         = CAKeyframeAnimation(keyPath:"transform.rotation.z")
		oval2TransformAnim.values      = [0, 
			 360 * CGFloat.pi/180]
		oval2TransformAnim.keyTimes    = [0, 1]
		oval2TransformAnim.duration    = 2
		oval2TransformAnim.repeatCount = Float.infinity
		
		let oval2Untitled2Anim : CAAnimationGroup = QCMethod.group(animations: [oval2TransformAnim], fillMode:fillMode)
		layers["oval2"]?.add(oval2Untitled2Anim, forKey:"oval2Untitled2Anim")

		let oval3TransformAnim         = CAKeyframeAnimation(keyPath:"transform.rotation.z")
		oval3TransformAnim.values      = [0, 
			 360 * CGFloat.pi/180]
		oval3TransformAnim.keyTimes    = [0, 1]
		oval3TransformAnim.duration    = 1
		oval3TransformAnim.repeatCount = Float.infinity
		
		let oval3Untitled2Anim : CAAnimationGroup = QCMethod.group(animations: [oval3TransformAnim], fillMode:fillMode)
		layers["oval3"]?.add(oval3Untitled2Anim, forKey:"oval3Untitled2Anim")
	}
	
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
		if let completionBlock = completionBlocks[anim]{
			completionBlocks.removeValue(forKey: anim)
			if (flag && updateLayerValueForCompletedAnimation) || anim.value(forKey: "needEndAnim") as! Bool{
				updateLayerValues(forAnimationId: anim.value(forKey: "animId") as! String)
				removeAnimations(forAnimationId: anim.value(forKey: "animId") as! String)
			}
			completionBlock(flag)
		}
	}
	
	func updateLayerValues(forAnimationId identifier: String){
		if identifier == "Untitled1"{
			QCMethod.updateValueFromPresentationLayer(forAnimation: layers["oval2"]!.animation(forKey: "oval2Untitled1Anim"), theLayer:layers["oval2"]!)
			QCMethod.updateValueFromPresentationLayer(forAnimation: layers["oval3"]!.animation(forKey: "oval3Untitled1Anim"), theLayer:layers["oval3"]!)
		}
		else if identifier == "Untitled2"{
			QCMethod.updateValueFromPresentationLayer(forAnimation: layers["oval"]!.animation(forKey: "ovalUntitled2Anim"), theLayer:layers["oval"]!)
			QCMethod.updateValueFromPresentationLayer(forAnimation: layers["oval2"]!.animation(forKey: "oval2Untitled2Anim"), theLayer:layers["oval2"]!)
			QCMethod.updateValueFromPresentationLayer(forAnimation: layers["oval3"]!.animation(forKey: "oval3Untitled2Anim"), theLayer:layers["oval3"]!)
		}
	}
	
	func removeAnimations(forAnimationId identifier: String){
		if identifier == "Untitled1"{
			layers["oval2"]?.removeAnimation(forKey: "oval2Untitled1Anim")
			layers["oval3"]?.removeAnimation(forKey: "oval3Untitled1Anim")
		}
		else if identifier == "Untitled2"{
			layers["oval"]?.removeAnimation(forKey: "ovalUntitled2Anim")
			layers["oval2"]?.removeAnimation(forKey: "oval2Untitled2Anim")
			layers["oval3"]?.removeAnimation(forKey: "oval3Untitled2Anim")
		}
	}
	
	func removeAllAnimations(){
		for layer in layers.values{
            
			layer.removeAllAnimations()
		}
	}
	
	func ovalPath() -> UIBezierPath{
		let ovalPath = UIBezierPath()
		ovalPath.move(to: CGPoint(x: 0, y: 0))
		ovalPath.addCurve(to: CGPoint(x: 65.501, y: 19.831), controlPoint1:CGPoint(x: 17.796, y: 17.796), controlPoint2:CGPoint(x: 42.542, y: 24.406))
		ovalPath.addCurve(to: CGPoint(x: 102.53, y: 0), controlPoint1:CGPoint(x: 79.069, y: 17.127), controlPoint2:CGPoint(x: 92.014, y: 10.517))
		
		return ovalPath
	}
	
	func oval2Path() -> UIBezierPath{
		let oval2Path = UIBezierPath()
		oval2Path.move(to: CGPoint(x: 0, y: 0))
		oval2Path.addCurve(to: CGPoint(x: 92.587, y: 0), controlPoint1:CGPoint(x: 25.567, y: 25.514), controlPoint2:CGPoint(x: 67.02, y: 25.514))
		
		return oval2Path
	}
	
	func oval3Path() -> UIBezierPath{
		let oval3Path = UIBezierPath()
		oval3Path.move(to: CGPoint(x: 0, y: 0))
		oval3Path.addCurve(to: CGPoint(x: 80.708, y: 0), controlPoint1:CGPoint(x: 22.287, y: 22.24), controlPoint2:CGPoint(x: 58.421, y: 22.24))
		
		return oval3Path
	}
	
    
    func showLoadView(_ show: Bool, completionHandler: (() -> Swift.Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = show ? 1.0 : 0.0
        }) { (_) in
            if (completionHandler != nil) {
                completionHandler!()
            }
        }
    }
}
