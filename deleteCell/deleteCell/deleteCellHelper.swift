//
//  deleteCellHelper.swift
//  deleteCell
//
//  Created by 盖特 on 2017/3/17.
//
//

import UIKit

// 初始化结构体 
struct CellArray {
    var openArray : [SGFavoritesCell]
    var closeArray : [SGFavoritesCell]
}

class deleteCellHelper: NSObject {
    
    let kMiddle : CGFloat = 250
    var currentTableView : UITableView?
    fileprivate lazy var cellArray = CellArray(openArray: [SGFavoritesCell](),closeArray: [SGFavoritesCell]())
    var currentCell : SGFavoritesCell?
    
    
    private static let sharedInstance = deleteCellHelper()
    
    class func sharedHelper(cell:SGFavoritesCell,currentTableView:UITableView)-> deleteCellHelper {
        
        sharedInstance.addGesture(toCell: cell)
        sharedInstance.cellArray.closeArray.append(cell)
        
        if sharedInstance.currentTableView == nil {
            sharedInstance.currentTableView = currentTableView
            sharedInstance.addObserverEvent()
        }
        return sharedInstance
    }

}



// MARK: - 手势处理
extension deleteCellHelper : UIGestureRecognizerDelegate{
    
    
    fileprivate func addGesture(toCell cell : SGFavoritesCell){
        //平移手势
        let gesPan = UIPanGestureRecognizer(target: self, action: #selector(pan(ges:)))
        gesPan.delegate = self
        cell.addGestureRecognizer(gesPan)
        //点击手势
        let gesTap = UITapGestureRecognizer(target: self, action: #selector(tap(ges:)))
        gesPan.delegate = self
        cell.addGestureRecognizer(gesTap)
        
    }
    
    @objc private func tap(ges: UIPanGestureRecognizer){
        
        for cell in self.cellArray.openArray {
            self.close(cell: cell)
        }
        
    }
    
    @objc private func pan(ges: UIPanGestureRecognizer){
        //获取偏移量
        let cell = ges.view as! SGFavoritesCell
        let translation = ges.translation(in: cell.showView)
        let location = ges.translation(in: cell.contentView)
        switch ges.state {
        case .began:
            fallthrough
        case .changed:
//            printLog(message: "\(fabs(translation.x)) ------\(fabs(translation.y))")
            
            /*
                1.门卫标准：没有当前操作的cell || 当前操作的cell是自己
                esle
             
                 - 当前操作的cell已经全部打开
                   1.openAarray 中的cell关闭
                   2.终止本次手势
                   3.return
                 - 当前操作的cell没有全部打开
                   1.终止本次手势
                   2.return
             
             
            */
            // MARK: 当前cell判断
            guard self.currentCell == nil || self.currentCell == cell else {
                
                if self.cellArray.openArray.contains(self.currentCell!) {
                    for cell in self.cellArray.openArray {
                        self.close(cell: cell)
                    }
                    
                    //延时1秒执行
                    ges.isEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
                        ges.isEnabled = true
                    }
                    
                    return
                }else{
                    //延时1秒执行
                    ges.isEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
                        ges.isEnabled = true
                    }
                    
                    return
                }

            }
            
            //指定当前操作cell
            self.currentCell = cell
            
            // MARK: 位移操作
            if fabs(location.x)<=fabs(location.y) {
                currentTableView?.isScrollEnabled = true
                return
            }else {
                currentTableView?.isScrollEnabled = false
            }
        
            
            //右滑禁用
            if (cell.showView?.frame.origin.x)! + translation.x > 0 {
                return
            }
            
            //左滑禁止
            if (cell.showView?.frame.origin.x)! + translation.x < -kMiddle {
                return
            }
            //改变root的transform
            cell.showView?.transform = (cell.showView?.transform)!.translatedBy(x: translation.x, y: 0)
            
            //恢复到初始状态
            ges.setTranslation(CGPoint(x: 0, y: 0), in: cell.showView)
            
        case .ended: fallthrough
        case .cancelled: fallthrough
        case .failed:
            if (cell.showView?.frame.origin.x)! < -kMiddle/2 { //滑到左侧
               self.open(cell: cell)
            }else{//滑到右侧
               self.close(cell: cell)
            }
            
        default:
            printLog(message: "默认")
        }
    }

        //解决手势冲突问题
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true;

    }
}


// MARK: - 观察者&通知
extension deleteCellHelper{
    
    fileprivate func addObserverEvent(){
        
        currentTableView?.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath! as NSString).isEqual(to: "contentOffset") {
            let oldPoint = change![NSKeyValueChangeKey.oldKey] as! CGPoint
            let newPoint = change![NSKeyValueChangeKey.newKey] as! CGPoint
            
            if oldPoint.y != newPoint.y {
                for cell in self.cellArray.openArray {
                    self.close(cell:cell)
                }
            }
            
        }
    }
    
    
}


// MARK: - 方法
extension deleteCellHelper{
    //打开
    func open(cell:SGFavoritesCell){
        
        UIView.animate(withDuration: 0.2, animations: {
            cell.showView?.transform = CGAffineTransform(translationX:-self.kMiddle, y: 0)
            
        }) { (_) in
            self.currentTableView?.isScrollEnabled = true
            
            //closeArray 中删除 cell
            if let index = self.cellArray.closeArray.index(of: cell){
               self.cellArray.closeArray.remove(at: index)
            }
            //openArray  中添加 cell
            self.cellArray.openArray.removeAll()
            self.cellArray.openArray.append(cell)
           
        }
    }
    //关闭
    func close(cell:SGFavoritesCell){
        
        UIView.animate(withDuration: 0.2, animations: {
            cell.showView?.transform = CGAffineTransform.identity
        }) { (_) in
            self.currentTableView?.isScrollEnabled = true
            
            //openArray 中删除 cell
            self.cellArray.openArray.removeAll()
            //closeArray  中添加 cell
            if !self.cellArray.closeArray.contains(cell){
               self.cellArray.closeArray.append(cell)
            }
            //currentCell 为空
            self.currentCell = nil
            
        }
    }
    
}

