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
    
    
    fileprivate func addGesture(toCell cell : UITableViewCell){
        let gesPan = UIPanGestureRecognizer(target: self, action: #selector(pan(ges:)))
        gesPan.delegate = self
        cell.contentView.addGestureRecognizer(gesPan)
        
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
            printLog(message: "\(fabs(translation.x)) ------\(fabs(translation.y))")
            
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
               cell.open()
            }else{//滑到右侧
               cell.close()
            }
            
        default:
            printLog(message: "默认")
        }
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
                    cell.close()
                }
            }
            
        }
    }
    
    
}

