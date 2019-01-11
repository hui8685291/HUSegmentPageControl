//
//  RKSegmentPageTool.swift
//  RokidApp
//
//  Created by Hu on 2018/12/24.
//  Copyright © 2018 Rokid. All rights reserved.
//

import Foundation

public extension String {
    // 计算字符串的宽度
    func RKPageStringGetWidth(font:CGFloat,height:CGFloat) -> CGFloat {
        let statusLabelText: NSString = self as NSString
        let size = CGSize.init(width: CGFloat(MAXFLOAT), height: height)
        let dic = NSDictionary(object: UIFont.systemFont(ofSize: font), forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : Any], context: nil).size
        return strSize.width
    }
}
