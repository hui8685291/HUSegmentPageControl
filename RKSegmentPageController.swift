//
//  RKPageViewController.swift
//  RokidApp
//
//  Created by Hu on 2018/12/24.
//  Copyright © 2018 Rokid. All rights reserved.
//

import Foundation

 protocol TabClickDelegate {
     func clickTabSelector(_ tag: Int)
 }

class RKSegmentPageController: RKViewController{
        
        fileprivate var kSelfWidth : CGFloat = RKStyles.Layout.screenWidth
    
        fileprivate var kSelfHeight : CGFloat = RKStyles.Layout.screenHeight
    
        fileprivate var tempTag: Int = 0
    
        var delegate: TabClickDelegate?
    
        func initPagesWithConfig(_ config: RKSegmentPageConfig) {
             settingWithConfig(config)
        }
    
        //MARK: - lazy
        private lazy var titleButtonArray = [UIButton]()
        
        private lazy var pageVC: UIPageViewController = {
            let vc = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            vc.setViewControllers([config.vcs[0]],
                                  direction: .reverse,
                                  animated: false,
                                  completion: nil)
            
            vc.delegate = self
            vc.dataSource = self
            return vc
        }()
        
        private lazy var titleScrollView: UIScrollView = {
            let sv = UIScrollView.init()
            sv.showsHorizontalScrollIndicator = false
            sv.backgroundColor = UIColor.white
            return sv
        }()
        
        private lazy var indicatorView: UIView = {
            let view = UIView()
            view.backgroundColor = config.indicatorColor
            return view
        }()
        
        private lazy var lineView: UIView = {
            let view = UIView.init()
            //view.backgroundColor = RKStyles.Color.lightGrayLine
            return view
        }()
        
        private lazy var config: RKSegmentPageConfig = {
            let c = RKSegmentPageConfig()
            return c
        }()
      
    }

    private extension RKSegmentPageController {
        // 默认实现的UI配置
        private func defaultInitUI() {
            
            let arrayM = NSMutableArray()
            for i in 0..<config.titles.count {
                let btn = UIButton.init(type: UIButton.ButtonType.custom)
                btn.frame = CGRect.init(x: CGFloat(i)*config.blockWidth, y: 0, width: config.blockWidth, height: config.barHeight - self.config.lineHeight)
                btn.backgroundColor = config.blockColor
                btn.titleLabel?.font = UIFont.resizeableSystemFont(ofSize: config.blockFont)
                btn.setTitle(config.titles[i], for: .normal)
                
                btn.setTitleColor(config.normalColor, for: .normal)
                btn.setTitleColor(config.selectedColor, for: .selected)
                btn.tag = 1000 + i
                btn.addTarget(self, action: #selector(jumpToVC(btn:)), for: .touchUpInside)
                arrayM.add(btn)
                titleScrollView.addSubview(btn)
            }
            
            titleButtonArray = arrayM as! [UIButton]
            
            let btn = view.window?.viewWithTag(self.config.defaultIndex + 1000) as! UIButton
            titleButtonClicked(btn: btn)
        }
        
        
    }

    //MARK:- 通知回调，闭包回调，点击事件
    private extension RKSegmentPageController {
        
        @objc private func jumpToVC(btn:UIButton) {
            
            // 选中对应的button
            titleButtonClicked(btn: btn)
            
            let toPage = btn.tag - 1000
            let direction: UIPageViewController.NavigationDirection = self.config.defaultIndex > toPage ? .forward : .reverse
            
            pageVC.setViewControllers([self.config.vcs[toPage]], direction: direction, animated: false) { (finished) in
                self.config.defaultIndex = toPage;
            }
        }
        
        private func titleButtonClicked(btn:UIButton) {
            
            let tagNum = btn.tag
            //当点击了同一个按钮的时候不发生改变
            if tagNum == self.tempTag {
                return
            }
            self.config.defaultIndex = tagNum - 1000
            
            if self.config.defaultIndex < 0 {
                self.config.defaultIndex = 0
            }
            
            let width = getIndicatorWidth()
            
            for button in titleButtonArray {
                
                if tagNum != button.tag {
                    button.setTitleColor(self.config.normalColor, for: .normal)
                    button.titleLabel?.font = UIFont.resizeableSystemFont(ofSize: self.config.blockFont)
                } else {
                    self.tempTag = button.tag
                    self.delegate?.clickTabSelector(button.tag)
                    
                    UIView.animate(withDuration: 0.15, delay: 0.0, options: UIView.AnimationOptions.layoutSubviews, animations: {
                        self.indicatorView.center = CGPoint.init(x: button.center.x, y: self.config.barHeight - 0.75)
                        self.indicatorView.bounds = CGRect.init(x: 0, y: 0, width: width, height: self.config.lineHeight)
                    }) { (finished) in
                        self.indicatorView.bounds = CGRect.init(x: 0, y: 0, width: width, height: self.config.lineHeight)
                        button.titleLabel?.font = UIFont.resizeableBoldFont(ofSize: self.config.blockFont)
                        button.setTitleColor(self.config.selectedColor, for: .normal)
                    }
                }
            }
            
            setScrollViewOffSet(btn: btn)
        }
        
        private func getIndicatorWidth() -> CGFloat {
            let title = self.config.titles[config.defaultIndex]
            let width = title.RKPageStringGetWidth(font: self.config.blockFont, height: config.blockFont)
            return width
        }
    }

    private extension RKSegmentPageController {
        
        private func settingWithConfig(_ config: RKSegmentPageConfig) {
            
            kSelfWidth = self.view.frame.width
            kSelfHeight = self.view.frame.height
            
            if (config.titles.count != config.vcs.count) || config.titles.count == 0 || config.vcs.count == 0 {
                //print("MCPageViewController: 请检查config的配置 config.vcs.count:\(config.titles.count) --- config.vcs.count:\(config.vcs.count)")
                return
            }
            
            // 初始化配置
            self.config = config
            
            // 基础UI的处理
            initBaseUI()
            
            defaultInitUI()

        }
        
        // 基础UI的设置
        private func initBaseUI() {
            
            defaultCalculateBlockWidth()
            
            self.view.backgroundColor = .white
            
            titleScrollView.frame = CGRect.init(x: 0, y: 0, width: kSelfWidth, height: config.barHeight)
            titleScrollView.contentSize = CGSize.init(width: config.blockWidth * CGFloat(config.titles.count), height: 0)
            view.addSubview(titleScrollView)
            
            lineView.frame = CGRect.init(x: 0, y: config.barHeight, width: kSelfWidth, height: self.config.lineHeight)
            view.addSubview(lineView)
            
            pageVC.view.frame = CGRect.init(x: 0, y: config.barHeight + 1, width: kSelfWidth, height: kSelfHeight - config.barHeight)
            view.addSubview(pageVC.view)
            
            
            let width = getIndicatorWidth()
            let indicatorView_x : CGFloat = (config.blockWidth - width)/2 + CGFloat(config.defaultIndex) * CGFloat(config.blockWidth)
            let indicatorView_y = config.barHeight - self.config.lineHeight
            indicatorView.frame = CGRect.init(x: indicatorView_x, y: indicatorView_y, width: width, height: self.config.lineHeight)
            indicatorView.isHidden = config.isHiddenIndicator
            titleScrollView.addSubview(indicatorView)
        }
        
        // 根据文字长度计算宽度
        private func defaultCalculateBlockWidth() {
            
            // 最长字符串的的宽度
            var maxW : CGFloat = 0.0;
            var allW : CGFloat = 0.0;
            
            for title in config.titles {
                let width = title.RKPageStringGetWidth(font: config.blockFont, height: config.blockFont) + 11
                if width > maxW {
                    maxW = width
                }
                allW += width;
            }
            
            // 看Config文件里面的blockWidth 的注释
            if config.blockWidth == 0 {
                if config.isLeftPosition {
                    config.blockWidth = maxW
                } else {
                    config.blockWidth = allW >= kSelfWidth ? maxW : (kSelfWidth / CGFloat(config.titles.count))
                }
            }
        }
    }

    extension RKSegmentPageController : UIScrollViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
        
        public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            
            let index = self.config.vcs.index(of: viewController) ?? 0
            if index == self.config.vcs.count - 1 {
                return nil
            }
            return self.config.vcs[index + 1]
        }
        
        public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            let index = self.config.vcs.index(of: viewController) ?? 0
            if index == 0 {
                return nil
            }
            return self.config.vcs[index - 1]
        }
        
        public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            
            let sub = pageViewController.viewControllers?[0]
            var index = 0
            for subVc in self.config.vcs {
                if subVc.isEqual(sub) {
                    self.config.defaultIndex = index
                }
                index += 1
            }
            
            let btn = view.window?.viewWithTag(self.config.defaultIndex + 1000) as! UIButton
            
            titleButtonClicked(btn: btn)
           // setScrollViewOffSet(btn: btn)
        }
        
        private func setScrollViewOffSet(btn:UIButton) {
            
            if self.config.blockWidth * CGFloat(self.config.titles.count) < kSelfWidth {
                return
            }
            
            var count = kSelfWidth * 0.5 / self.config.blockWidth
            
            if count.truncatingRemainder(dividingBy: 2) == 0 { count -= 1 }
            
            var offsetX = btn.frame.origin.x - count * self.config.blockWidth
            
            if offsetX < 0 { offsetX = 0 }
            
            let maxOffsetX = titleScrollView.contentSize.width - kSelfWidth
            
            if offsetX > maxOffsetX { offsetX = maxOffsetX }
            
            UIView.animate(withDuration: 2) {
                self.titleScrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
            }
        }
}



