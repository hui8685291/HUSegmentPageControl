//
//  RKSegmentPageConfig.swift
//  RokidApp
//
//  Created by Hu on 2018/12/24.
//  Copyright © 2018 Rokid. All rights reserved.
//

import Foundation

class RKSegmentPageConfig: NSObject {
    
    /**
     * 标题文字数据源
     * 数组个数必须和vcs个数一致
     */
    @objc public var titles: [String] = [String]()
    /**
     * 视图控制器数据源
     * 数组个数必须和titles个数一致
     */
    @objc public var vcs: [UIViewController] = [UIViewController]()
    
    /**
     * 默认的颜色
     */
    @objc public var normalColor: UIColor = RKStyles.Color.lightGrayLine
    
    /**
     * 选中的颜色
     */
    @objc public var selectedColor: UIColor = RKStyles.Color.themeColor
    
    /**
     * 指示横条的颜色
     */
    @objc public var indicatorColor: UIColor = RKStyles.Color.themeColor
    
    /**
     * 标题块的宽度
     * 默认为0
     * 如果标题块的宽度为0，则根据文字的长度自动计算标题块的宽度，否则就用设置的。
     */
    @objc public var blockWidth: CGFloat = 0
    
    /**
     * 是否隐藏指示线
     * indicatorView
     */
    @objc public var isHiddenIndicator : Bool = false
    
    /**
     * 标题栏的高度
     * 默认值40
     * 如何设置的高度为0~20，修复为20
     * 如何设置的高度为负数，则隐藏标题栏。实例：当有有且只有一个子页面的时候，要隐藏的时候
     */
    @objc public var barHeight: CGFloat = 40 {
        didSet {
            if (barHeight <= 0) { barHeight = 0 }
            if (barHeight > 0 && barHeight < 20 ) { barHeight = 40 }
        }
    }
    
    /**
     * 标题块的字体的大小
     * 默认15
     */
    @objc public var blockFont: CGFloat = 15 {
        didSet {
            if (blockFont < 10) { blockFont = 15 }
        }
    }
    
    /**
     * 标题块的背景颜色
     * 默认为白色
     */
    @objc public var blockColor: UIColor = UIColor.white
    
    
    /**
     * 当title数量少的时候，是否居左
     * 默认居中
     */
    @objc public var isLeftPosition: Bool = false
    
    /**
     * 第一次打开，默认显示第几项
     * 默认第0项
     */
    @objc public var defaultIndex: Int = 0
    
    /**
     * 底部Line的高度
     * 默认为1.5
     */
    
    @objc public var lineHeight: CGFloat = 1.5
}
