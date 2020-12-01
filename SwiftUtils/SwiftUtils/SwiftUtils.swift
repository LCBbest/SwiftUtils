//
//  SwiftUtils.swift
//  SwiftUtils
//  Swift 开发常用工具类
//  Created by lcb on 2020/12/1.
//  Copyright © 2020-2021 李春波. All rights reserved.
//

import Foundation
import UIKit

//MARK:常量

///获取屏幕宽度
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width

public let S_W = UIScreen.main.bounds.size.width

///获取屏幕高度
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

public let S_H = UIScreen.main.bounds.size.height

///获取导航栏高度
public let NAVH:CGFloat = S_W >= 812 ? 88 : 64

///获取状态栏高度
public let STATUSH:CGFloat = S_H >= 812 ? 44 : 20


//MARK:常用方法

//TODO:判断空值
/*
 *text可以传多个或单个参数
 */
///CBT-判断空值 单个或多个传值
public func CBT_IsNilOrEmpty(feild:UITextField ...) -> Bool{
    var result = true
    for parm in feild{
        if parm.text!.isEmpty {
            result = true
            break
        }
        else{
            result = false
        }
    }
    return result
}

public func CBT_IsNilOrEmptyBackString(feild:UITextField ...,completion: @escaping (String,Bool) -> Void){
    var resultString = ""
    var resultBool = true
    for parm in feild{
        if parm.text!.isEmpty {
            resultString = parm.placeholder ?? "必要参数为空"
            resultBool = true
            break
        }
        else{
            resultString = ""
            resultBool = false
        }
    }
    completion(resultString,resultBool)
}


//TODO:data转换为jsonString
///CBT-data转换为jsonString
public func CBT_DataToJsonString(_ data: Data) -> AnyObject? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
    } catch {
        print(error)
    }
    return nil
}

//TODO:判断是否第一次登录
///CBT-判断是否第一次登录
public func CBT_IsFirstLogin()->Bool{
    return !(UserDefaults.standard.bool(forKey: "everLaunched"))
}

//TODO:本地存值取值
///CBT-本地存值 paramter:key键value值
public func CBT_setUserDefault(key:String,value:Any) {
    UserDefaults.standard.set(value, forKey: key)
}
///CBT-本地取值
public func CBT_getUserDefault(key:String) -> Any {
    if UserDefaults.standard.string(forKey: key) == nil{
        return ""
    }
    return UserDefaults.standard.object(forKey: key) as Any
}


//MARK:继承封装

extension String{
    
    //TODO:是否含有XX字符串
    ///CBT-是否含有XX字符串
    public func CBT_iSContainsXX(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    //TODO:根据String的宽度推算高度
    ///CBT-根据String的宽度推算高度 paramter：fontSize-字体大小；width-宽度
    public func CBT_getStringHeightWithWidth(fontSize:CGFloat,width:CGFloat)->CGFloat{
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let attributes = [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle.copy()]
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
    //TODO:根据String的高度推算宽度
    ///CBT-根据String的高度推算宽度 paramter：fontSize-字体大小；height-高度；maxWidth-最大宽度
    public func CBT_getStringWidthWithHeight(fontSize:CGFloat,height:CGFloat,maxWidth:CGFloat)->CGFloat{
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let attributes = [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle.copy()]
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        if rect.size.width > maxWidth{
            return maxWidth
        }
        return rect.size.width
    }
    
    //TODO:银行卡四位一个字符串默认空格
    ///CBT-银行卡每四位 隔字符串 默认空格
    public func CBT_formateForBankCard(joined: String = " ") -> String {
        guard self.count > 0 else {
            return self
        }
        var bankArray = [Character](self)
        var index = 0
        var i = 0
        repeat{
            if(index%4 == 0 && index != 0){
                if index + i>bankArray.count{
                    break
                }
                bankArray.insert(" ", at: index + i)
                i = i + 1
            }
            index = index + 1
        }while index<bankArray.count
        let toBankString = String(bankArray)
        return toBankString
    }
    
    //TODO:根据给定位置替换为给定字符串
    ///CBT-根据给定位置替换为给定字符串
    public func CBT_toReplaceStar(_ indexs:[Int],_ icon:Character) -> String {
        var selfArray = [Character](self)
        if selfArray.count <= 1{
            return self
        }
        if indexs.count == 1{
            selfArray[indexs[0]] = icon
            return String(selfArray)
        }
        if indexs[0]>indexs[1]{
            return self
        }
        if indexs[0]>selfArray.count || indexs[1]>selfArray.count - 1{
            return self
        }
        for i in indexs[0]...indexs[1]{
            selfArray[i] = icon
        }
        return String(selfArray)
    }
    
    //TODO:拆分字符串 获取数据
    ///CBT-拆分字符串 获取数据 paramter:icon-拆分依据 index-获取拆分之后的哪一部分
    public func CBT_splitString(_ icon:String,index:Int) -> String {
        if !self.contains(icon){
            return ""
        }
        let stringArray = self.components(separatedBy: icon)
        if index>stringArray.count{
            return stringArray[stringArray.count]
        }
        return stringArray[index]
    }
    
    //TODO:图片地址转码
    /// CBT-图片地址转码
    public func CBT_imageUrlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    //TODO:String转base64
    //CBT-string转base64
    public func CBT_stringToBase64() -> String {
        let plainData = self.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: .lineLength64Characters)
        return base64String!
    }
    
    //TODO:base64转string
    ///CBT-base64转string
    public func CBT_base64ToString() -> String {
        let decodedData = NSData(base64Encoded: self, options: .ignoreUnknownCharacters)
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)
        return decodedString! as String
    }
    
    //TODO:jsonString转为字典
    ///CBT-jsonString转为字典
    public func CBT_toDictionary() -> [String:Any] {
        let jsonData:Data = self.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! [String:Any]
        }
        return [String:Any].init()
    }
    
    //TODO:urlBase64 url转码 用于网络请求
    ///CBT-urlBase64 url转码 用于网络请求
    public func urlBase64Encoded() -> String {
        let first = self.replacingOccurrences(of: "/", with: "_")
        let second = first.replacingOccurrences(of: "+", with: "-")
        let third = second.replacingOccurrences(of: "=", with: "")
        return third
    }
    ///CBT-urlbase64 解码
    public func urlBase64DecodedString() -> String {
        let first = NSMutableString(string: self)
        let mod4:Int = first.length % 4
        print(first.length)
        if(mod4>0){
            var str = "===="
            let start1 = str.index(str.startIndex, offsetBy: 0)
            str = str.substring(from: start1)
            let end1 = str.index(str.startIndex, offsetBy: 4-mod4)
            let sub5 = str.substring(to: end1)
            first.append(sub5)
        }
        let second = first.replacingOccurrences(of: "_", with: "/")
        let third = second.replacingOccurrences(of: "-", with: "+")
        return third
    }
    
    //TODO:string转float
    ///CBT-String转float
    public func CBT_toFloat() -> Float {
        if self.isEmpty{
            return 0.00
        }
        return Float(self)!
    }
    
    //TODO:string转Decimal
    ///CBT-String转Decimal 用于费率计算 提高精度
    public func CBT_toDecimal() -> Decimal {
        if self.isEmpty{
            return 0.00
        }
        
        return Decimal(string: self) ?? 0
    }
    
    //TODO:日期格式化
    ///CBT-日期格式化 format 传入格式 returnMat传出格式
    public func CBT_dateMatter(_ format:String,returnMat:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.date(from: self)
        formatter.dateFormat = returnMat
        return formatter.string(from: date!)
    }
    
    //TODO:粘贴板
    ///CBT-粘贴板
    public func CBT_pasteBoard() {
        let paste = UIPasteboard.general
        paste.string = self
    }
    
    //TODO:替换字符串
    ///CBT-替换字符串 将toString替换为forString
    public func CBT_replaceString(_ toString:String,forString:String) -> String {
        return self.replacingOccurrences(of: toString, with: forString)
    }
    
    //TODO:是否是数字
    ///CBT-是否是数字
    public func CBT_isPurnInt() -> Bool {
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    //TODO:是否是汉字
    ///CBT-是否是汉字
    public func CBT_isChinese() -> Bool {
        for (_, value) in self.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return false
            }
        }
        return true
    }
    
    //TODO:是否是英文字母
    ///CBT-是否是英文字母
    public func CBT_isLetter() -> Bool {
        let pattern = "^^[A-Za-z]+$"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self) {
            return true
        }
        return false
    }
    
}

extension UIColor{
    
    //TODO:将颜色设置为图片
    ///CBT-将颜色设置为图片
    public func CBT_getImageWithColor()->UIImage{
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //TODO:设置16进制颜色
    ///CBT-设置16进制颜色 paramter:hexString--16进制颜色#; alpha--透明度
    public static func CBT_colorWith(_ hexString:String, _ alpha:Float = 1) -> UIColor
    {
        var cString:String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        //做一些容错处理
        if cString.count < 6{ return UIColor.clear }
        if cString.hasPrefix("0X")
        {
            let start = cString.index(cString.startIndex, offsetBy: 2)
            cString = cString.substring(from: start)
        }
        
        if cString.hasPrefix("#")
        {
            let start = cString.index(cString.startIndex, offsetBy: 1)
            cString = cString.substring(from: start)
        }
        if cString.count != 6{ return UIColor.clear }
        
        
        //R
        let start_r = cString.index(cString.startIndex, offsetBy: 0)
        let end_r = cString.index(cString.endIndex, offsetBy: -4)
        let range_r = Range.init(uncheckedBounds: (lower: start_r, upper: end_r))
        let string_r:String = cString.substring(with: range_r)
        
        //G
        let start_g = cString.index(cString.startIndex, offsetBy: 2)
        let end_g = cString.index(cString.endIndex, offsetBy: -2)
        let range_g = Range.init(uncheckedBounds: (lower: start_g, upper: end_g))
        let string_g:String = cString.substring(with: range_g)
        
        //B
        let start_b = cString.index(cString.startIndex, offsetBy: 4)
        let end_b = cString.index(cString.endIndex, offsetBy: 0)
        let range_b = Range.init(uncheckedBounds: (lower: start_b, upper: end_b))
        let string_b:String = cString.substring(with: range_b)
        
        
        return UIColor.init(red: CGFloat(Float(self.hexTodec(number:string_r))/255.0),
                            green: CGFloat(Float(self.hexTodec(number: string_g))/255.0),
                            blue: CGFloat(Float(self.hexTodec(number: string_b))/255.0), alpha: CGFloat(alpha))
    }
    
    //MARK:16进制字符串转10进制数字
    public static func hexTodec(number num:String) -> Int
    {
        let str = num.uppercased()
        var sum = 0
        for i in str.utf8
        {
            sum = sum * 16 + Int(i) - 48 //0-9,从48开始
            if i >= 65
            { //A-Z,从65开始,但有初始值10,所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    
    //TODO:随机颜色
    ///CBT-随机颜色
    open class var CBT_randomColor:UIColor{
        get
        {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    //TODO:设置RGB颜色
    ///CBT-设置RGB颜色 paramter:r g b 具体数字即可不需要除以255
    public static func CBT_RGBColor(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor{
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UITableView{
    
    //TODO:table无数据显示
    ///CBT-table无数据显示
    public func CBT_noDataView(_ count:Int = 0,icon:String, title:String = "暂无信息") {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 70))
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        view.addSubview(iconView)
        view.addSubview(label)
        iconView.image = UIImage(named:icon)
        iconView.center = self.center
        label.text = title
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.center.x = self.center.x
        label.center.y = self.center.y + 40
        if count != 0{
            view.isHidden = true
        }
        self.tableFooterView = view
    }
}

extension UIView{
    
    //TODO:view添加点击事件
    ///CBT-view 添加点击事件
    public func CBT_addOnClickListener(target: AnyObject, action: Selector) {
        let gr = UITapGestureRecognizer(target: target, action: action)
        gr.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(gr)
    }
    
    ///TODO:view的位置获取
    public var top:CGFloat{
        get{
            return self.layer.frame.minY
        }
    }
    public var bottom:CGFloat{
        get{
            return self.layer.frame.maxY
        }
    }
    
    public var left:CGFloat {
        get{
            return self.layer.frame.minX
        }
    }
    
    public var right:CGFloat {
        get{
            return self.layer.frame.maxX
        }
    }
    
    //TODO:设置view为虚线
    ///CBT-设置view为虚线 paramter:lineLength-线段长度;lineSpacing-空格长度;lineColor-线段颜色
    public func CBT_drawDashLine(lineLength : Int ,lineSpacing : Int,lineColor : UIColor){
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        //        只要是CALayer这种类型,他的anchorPoint默认都是(0.5,0.5)
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        //        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        
        shapeLayer.lineWidth = self.frame.size.height
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    //TODO:设置部分圆角
    ///CBT-设置view部分圆角 paramter:byRoundingCorners-哪个叫需要圆角[数组][.topLeft,.topRight]；radii-弧度
    public func CBT_corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    //TODO:全部圆角
    ///视图圆角 paramter:radius圆角弧度
    public func CBT_cornerRadius(_ radius:CGFloat){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
}

extension Dictionary{
    //TODO:字典转换jsonString
    ///CBT-字典转换jsonString
    public func CBT_DictionaryToJsonString() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            NSLog("字典转换jsonString方法出错,无法解析出JSONString,返回空字符串")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: self, options: []) as NSData?
        let JSONString = String(data: data as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        return JSONString!
    }
}

//MARE: 加解密
extension String{
    //TODO:MD5 加密
    ///MD5加密
    public func CBT_toMD5() -> String{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        return stringFromBytes(result, length: digestLen)
    }
    
    func stringFromBytes(_ bytes: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String{
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", bytes[i])
        }
        bytes.deinitialize(count: length)
        bytes.deallocate()
        return String(format: hash as String)
    }
    
   public func CBT_hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        let digest = stringFromResult(result, length: digestLen)
        result.deinitialize(count: digestLen)
        result.deallocate()
        return digest
    }
    
    private func stringFromResult(_ result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
    //TODO:3des加解密
    ///3des加解密
    func threeDESEncryptOrDecrypt(op: Int) -> String? {
        
        //CCOperation（kCCEncrypt）加密 1
        //CCOperation（kCCDecrypt) 解密 0
        var ccop = CCOperation()
        
        let key = "Klu&pVSlHSD@2M#p6NRRjv0Gz#nkGAMC#fUfxdpWuKnb3oXG%%zb^tywMN97bU2HxqHy&50dMQSOgP#mNvNIvfOg0z8u!BY2ZeL"
        let iv = "01234567"
        // Key
        let keyData: NSData = ((key as NSString).data(using: String.Encoding.utf8.rawValue) as NSData?)!
        let keyBytes         = UnsafeRawPointer(keyData.bytes)
        
        // 加密或解密的内容
        var data: NSData = NSData()
        if op == 1 {
            ccop = CCOperation(kCCEncrypt)
            data  = ((self as NSString).data(using: String.Encoding.utf8.rawValue) as NSData?)!
        }
        else {
            ccop = CCOperation(kCCDecrypt)
            data = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
            
        }
        
        let dataLength    = size_t(data.length)
        let dataBytes     = UnsafeRawPointer(data.bytes)
        
        // 返回数据
        let cryptData    = NSMutableData(length: Int(dataLength) + kCCBlockSize3DES)
        let cryptPointer = UnsafeMutableRawPointer(cryptData!.mutableBytes)
        let cryptLength  = size_t(cryptData!.length)
        
        //  可选 的初始化向量
        let viData :NSData = ((iv as NSString).data(using: String.Encoding.utf8.rawValue) as NSData?)!
        let viDataBytes    = UnsafeRawPointer(viData.bytes)
        
        // 特定的几个参数
        let keyLength              = size_t(kCCKeySize3DES)
        let operation: CCOperation = UInt32(ccop)
        let algoritm:  CCAlgorithm = UInt32(kCCAlgorithm3DES)
        let options:   CCOptions   = UInt32(kCCOptionPKCS7Padding)
        
        var numBytesCrypted :size_t = 0
        
        let cryptStatus = CCCrypt(operation, // 加密还是解密
            algoritm, // 算法类型
            options,  // 密码块的设置选项
            keyBytes, // 秘钥的字节
            keyLength, // 秘钥的长度
            viDataBytes, // 可选初始化向量的字节
            dataBytes, // 加解密内容的字节
            dataLength, // 加解密内容的长度
            cryptPointer, // output data buffer
            cryptLength,  // output data length available
            &numBytesCrypted) // real output data length
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData!.length = Int(numBytesCrypted)
            if op == 1  {
                var base64cryptString = cryptData!.base64EncodedString(options: .lineLength64Characters)
                base64cryptString = base64cryptString.replacingOccurrences(of: "\n", with: "")
                base64cryptString = base64cryptString.replacingOccurrences(of: "\r", with: "")
                base64cryptString = base64cryptString.replacingOccurrences(of: "\t", with: "")
                return base64cryptString
            }
            else {
                let base64cryptString = NSString(data: cryptData! as Data,  encoding: String.Encoding.utf8.rawValue) as String?
                return base64cryptString
            }
        } else {
            print("Error: \(cryptStatus)")
        }
        return nil
    }
    
    //TODO:加密

    public func in3DES() -> String?{
        return self.threeDESEncryptOrDecrypt(op: 1)
    }
    //TODO:解密
    public func out3DES() -> String?{
        return self.threeDESEncryptOrDecrypt(op: 0)
    }
    
    //TODO:解密加转换字典
    public func out3DesAndToDic() -> [String:Any]{
        let decryptJsonString = self.urlBase64DecodedString().out3DES()
        /**
         打印返回数据用,可注释
         */
        print("==========================================================================================================================")
        print(decryptJsonString!)
        print("==========================================================================================================================")
        if let decryptJsonDic = decryptJsonString?.CBT_toDictionary(){
            return decryptJsonDic
        }
        return [String:Any].init()
    }
}

extension UIImageView{
    //TODO:图片转为base64
    ///图片转为base64
    public func CBT_imgToBase64() -> String {
        let imageData = self.image?.CBT_resetImgSize(sourceImage: self.image!, maxImageLenght: 300, maxSizeKB: 80)
        let imageBase64String = imageData?.base64EncodedString()
        return imageBase64String!
    }
}

extension UIImage{
    //TODO:图片压缩
    ///图片压缩 maxImageLenght-最大长度,maxSizeKB-最大kb
    public func CBT_resetImgSize(sourceImage : UIImage,maxImageLenght : CGFloat,maxSizeKB : CGFloat) -> Data {
        var maxSize = maxSizeKB
        var maxImageSize = maxImageLenght
        if (maxSize <= 0.0) {
            maxSize = 1024.0;
        }
        if (maxImageSize <= 0.0)  {
            maxImageSize = 1024.0;
        }
        //先调整分辨率
        var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
        let tempHeight = newSize.height / maxImageSize;
        let tempWidth = newSize.width / maxImageSize;
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
        }
        else if (tempHeight > 1.0 && tempWidth < tempHeight){
            newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
        }
        UIGraphicsBeginImageContext(newSize)
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //var imageData = UIImageJPEGRepresentation(newImage!, 1.0)
        var imageData = newImage?.jpegData(compressionQuality: 1.0)
        var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
        //调整大小
        var resizeRate = 0.9;
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            //imageData = UIImageJPEGRepresentation(newImage!,CGFloat(resizeRate));
            imageData = newImage?.jpegData(compressionQuality: CGFloat(resizeRate))
            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
            resizeRate -= 0.1;
        }
        return imageData!
    }
}

extension Int{
    //TODO:是否是偶数
    ///是否是偶数
    public func CBT_isOushu() -> Bool {
        if self % 2 == 0{
            return true
        }
        return false
    }
}

extension UIApplication {
    //TODO:获取当前视图
    ///获取当前视图
    public class func CBT_topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return CBT_topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return CBT_topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return CBT_topViewController(controller: presented)
        }
        return controller
    }
}

public enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
