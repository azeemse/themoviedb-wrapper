//
//  Extensions.swift
//  SPTest
//
//  Created by Azeem Akram on 03/12/2018.
//  Copyright © 2018 StarzPlay. All rights reserved.
//

import Foundation
import UIKit




extension UIAlertController{
    
    class func showAlertView(title:String, message:String, buttons:[String], completionHandler:((_ buttonText:String, _ alertView:UIAlertController)-> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            for buttonName in buttons {
                var style = UIAlertAction.Style.default
                if ((buttonName.lowercased().range(of: "delete") != nil) || (buttonName.lowercased().range(of: "cancel") != nil)) {
                    style = UIAlertAction.Style.cancel
                }
                
                alert.addAction(UIAlertAction(title: buttonName, style: style, handler: { action in
                    if completionHandler != nil{
                        completionHandler!(action.title!, alert)
                    }
                }
                ))
            }

            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                topController.present(alert, animated: true, completion: nil)
            }
        }
    }
}


extension UIViewController{
    
}

extension UIView{
    func focus(isFocused:Bool, borderColor:UIColor, scaleAnimation:Bool) {
        self.layer.borderWidth      = isFocused ? 6.0 : 0.0
        self.layer.borderColor      = isFocused ? borderColor.cgColor : UIColor.clear.cgColor
        
        self.layer.shadowColor      = isFocused ? borderColor.cgColor : UIColor.clear.cgColor
        self.layer.shadowRadius     = isFocused ? 6.0 : 0.0
        self.layer.shadowOffset     = CGSize(width: 0, height: 0)
        
        if scaleAnimation {
            let scale:CGFloat   = isFocused ? 1.2 : 1.0
            UIView.animate(withDuration: 0.4) {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
    }
}

extension String{
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isNill() -> Bool {
        return (self.trimmingCharacters(in: .whitespacesAndNewlines).count <= 0) ? true :false
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func randomWith(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    func isEqualTo(String input:String) -> Bool {
        var isEqual = false
        if self.caseInsensitiveCompare(input) == ComparisonResult.orderedSame {
            isEqual = true
        }
        
        return isEqual
    }
    
    func withPrefix(prefixString:String) ->String {
        return String.init(format: "%@%@",prefixString, self)
    }
    
    func url() -> URL? {
        return URL.init(string: self)
    }
}


extension UIColor{
    
    func hexCode() -> String {
        let ciColor = CIColor(color: self)
        var r:CGFloat = ciColor.red
        var g:CGFloat = ciColor.green
        var b:CGFloat = ciColor.blue
        var a:CGFloat = ciColor.alpha
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String.init(format:"#%06x", rgb)
    }
    
    class func random() -> UIColor {
        return UIColor(red:   CGFloat(arc4random()) / CGFloat(UInt32.max),
                       green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                       blue:  CGFloat(arc4random()) / CGFloat(UInt32.max),
                       alpha: 1.0)
    }
    
    class func colorFromHexString(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}


extension UIImage{
    func resizeByKeepingAspectRatio(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize.init(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize.init(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, true, 3.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func save(atPath path:URL, withName name:String, completionHandler:@escaping(String)-> Void) {
        let filename = path.appendingPathComponent(name)
        do{
            try self.pngData()?.write(to: filename)
            completionHandler(filename.lastPathComponent)
        }catch{
            completionHandler("")
        }
    }
    
    class func getImageFrom(Path path:URL, withName name:String) -> UIImage {
        let filename = path.appendingPathComponent(name)
        if let image = UIImage.init(contentsOfFile: filename.path) {
            return image
        }else{
            return UIImage.imageWithColor(color: UIColor.black, size: CGSize.init(width: 10.0, height: 10.0))
        }
    }
}


extension UISearchBar {
    
    func font(textFont : UIFont?) {
        for view : UIView in (self.subviews[0]).subviews {
            if let textField = view as? UITextField {
                textField.font = textFont
            }
        }
    }
    
    func textColor(color : UIColor?) {
        for view : UIView in (self.subviews[0]).subviews {
            if let textField = view as? UITextField {
                textField.textColor = color
            }
        }
    }
}


extension URL{
    func documentsDirectoryPath() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func cacheDirectoryPath() -> URL{
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
}





