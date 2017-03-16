//
//  SGFavoritesCell.swift
//  SouGet
//
//  Created by 盖特 on 2017/3/8.
//  Copyright © 2017年 souget.com. All rights reserved.
//

import UIKit



class SGFavoritesCell: UITableViewCell {

    let kMiddle : CGFloat = 250
    
    var titleLabel : UILabel?
    var urlLabel   : UILabel?
    var iconView   : UIImageView?
    var showView   : UIView?
    var superTableView : UITableView?
    var isHiding : Bool?
    var isShowing: Bool?
    let rightfinalWidth:CGFloat = 300
    var otherCellIsOpen :Bool = false
    
    
    
    
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?,tableView:UITableView) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        superTableView = tableView
        setupUI()
        addObserverEvent()
        addGesture()
        addNotify()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

// MARK: - 界面布局
extension SGFavoritesCell{
    
    fileprivate func setupUI() {
        //取消选中效果
        selectionStyle = .none
        contentView.backgroundColor = UIColor.blue
        // 1. 添加控件
        let bottomView = getBottomView()
        contentView.addSubview(bottomView)
        
        showView = getShowView()
        contentView.addSubview(showView!)
        
        // 2. 添加约束
        bottomView.snp_makeConstraints{ (make) -> Void in
            make.edges.equalTo(0)
        }
        showView!.snp_makeConstraints{ (make) -> Void in
            make.edges.equalTo(0)
        }


       
    }
    
    
    private func getBottomView() -> UIView{
        
        let bottomView = UIView()
        let deleteBtn  = UIButton()
        let shareBtn   = UIButton()
        deleteBtn.setTitle("删除", for: .normal)
        deleteBtn.backgroundColor = UIColor.red
        shareBtn.setTitle("分享", for: .normal)
        shareBtn.backgroundColor = UIColor.green
        
        bottomView.addSubview(deleteBtn)
        bottomView.addSubview(shareBtn)
        
        deleteBtn.snp_makeConstraints{ (make) -> Void in
            make.centerY.equalTo(bottomView)
            make.right.equalTo(bottomView.snp_right).offset(-50)
            make.width.height.equalTo(50)
        }
        
        shareBtn.snp_makeConstraints{ (make) -> Void in
            make.centerY.equalTo(bottomView)
            make.right.equalTo(deleteBtn.snp_left).offset(-50)
            make.width.height.equalTo(50)
        }


        return bottomView
    }
    
    private func getShowView() -> UIView{
        
        let showView = UIView()
        showView.backgroundColor = UIColor.white
        
        titleLabel = UILabel()
        titleLabel?.text = "你好你好你好你好你好你好"
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        titleLabel?.numberOfLines = 2
        
        urlLabel = UILabel()
        urlLabel?.text = "www.baidu.com"
        urlLabel?.font = UIFont.systemFont(ofSize: 14)
        
        iconView = UIImageView()
        iconView?.backgroundColor = UIColor.brown
        
        showView.addSubview(titleLabel!)
        showView.addSubview(urlLabel!)
        showView.addSubview(iconView!)
        
        //布局
        titleLabel!.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.width.equalTo(200)
        }
        urlLabel!.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(titleLabel!.snp_bottom).offset(10)
            make.left.equalTo(10)

        }
        iconView!.snp_makeConstraints{ (make) -> Void in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.width.height.equalTo(150)
        }

        return showView
    }
}

// MARK: - 手势交互
extension SGFavoritesCell{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SC_CELL_SHOULDCLOSE"), object: nil, userInfo: ["action":"closeCell"])
    }
    
    fileprivate func addGesture(){
        let gesPan = UIPanGestureRecognizer(target: self, action: #selector(pan(ges:)))
        gesPan.delegate = self
        contentView.addGestureRecognizer(gesPan)
        
    }
    
    //解决手势冲突问题
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;

    }

    
    @objc private func pan(ges: UIPanGestureRecognizer){
        //获取偏移量
        let translation = ges.translation(in: self.showView)
        let location = ges.translation(in: self.contentView)
        switch ges.state {
        case .began:
            fallthrough
        case .changed:
            printLog(message: "\(fabs(translation.x)) ------\(fabs(translation.y))")
            
            if fabs(location.x)<=fabs(location.y) {
                superTableView?.isScrollEnabled = true
                return
            }else {
                superTableView?.isScrollEnabled = false
            }
            if otherCellIsOpen {
                return
            }
            
            //右滑禁用
            if (showView?.frame.origin.x)! + translation.x > 0 {
                return
            }
            
            //左滑禁止
            if (showView?.frame.origin.x)! + translation.x < -kMiddle {
                return
            }
            //改变root的transform
            self.showView?.transform = (self.showView?.transform)!.translatedBy(x: translation.x, y: 0)
            
            //恢复到初始状态
            ges.setTranslation(CGPoint(x: 0, y: 0), in: self.showView)
         
        case .ended: fallthrough
        case .cancelled: fallthrough
        case .failed:
            if (self.showView?.frame.origin.x)! < -kMiddle/2 { //滑到左侧
                open()
            }else{//滑到右侧
                close()
            }
            
        default:
            printLog(message: "默认")
        }
    }
    
}




// MARK: - 观察者&通知
extension SGFavoritesCell{
    
    fileprivate func addObserverEvent(){
        
        superTableView?.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath! as NSString).isEqual(to: "contentOffset") {
            let oldPoint = change![NSKeyValueChangeKey.oldKey] as! CGPoint
            let newPoint = change![NSKeyValueChangeKey.newKey] as! CGPoint
            
            if oldPoint.y != newPoint.y {
                
                if self.showView?.frame.origin.x == -self.kMiddle{
                    close()
                }
            }
            
        }
    }
    
    fileprivate func addNotify(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotify(_:)), name: NSNotification.Name(rawValue: "SC_CELL_SHOULDCLOSE"), object: nil)
    }
    @objc private func handleNotify(_ notify:NSNotification){
        printLog(message:"收到通知啦")
        
        /*
         if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"closeCell"]) {
         [self hideBtn];
         _otherCellIsOpen = NO;
         }
         else if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"otherCellIsOpen"]){
         _otherCellIsOpen = YES;
         }
         else if ([[notify.userInfo objectForKey:@"action"] isEqualToString:@"otherCellIsClose"])
         {
         _otherCellIsOpen = NO;
         }
         */
        var dict = notify.userInfo
        if (dict?["action"] as! NSString).isEqual(to: "closeCell")  {
            close()
            otherCellIsOpen = false
        }
        else if (dict?["action"] as! NSString).isEqual(to: "otherCellIsOpen")  {
            otherCellIsOpen = true
        }
        else if (dict?["action"] as! NSString).isEqual(to: "otherCellIsClose")  {
            otherCellIsOpen = false
        }

        
    }


}



// MARK: - 方法
extension SGFavoritesCell{
    //打开
    fileprivate func open(){
        
        UIView.animate(withDuration: 0.2, animations: {
            self.showView?.transform = CGAffineTransform(translationX:-self.kMiddle, y: 0)
        }) { (_) in
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SC_CELL_SHOULDCLOSE"), object: nil, userInfo: ["action":"otherCellIsOpen"])
            self.superTableView?.isScrollEnabled = true
        }
    }
    //关闭
    fileprivate func close(){
        
        UIView.animate(withDuration: 0.2, animations: {
            self.showView?.transform = CGAffineTransform.identity
        }) { (_) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SC_CELL_SHOULDCLOSE"), object: nil, userInfo: ["action":"otherCellIsClose"])
            self.superTableView?.isScrollEnabled = true
        }
    }
    
}

