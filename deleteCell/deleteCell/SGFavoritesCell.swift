//
//  SGFavoritesCell.swift
//  SouGet
//
//  Created by 盖特 on 2017/3/8.
//  Copyright © 2017年 souget.com. All rights reserved.
//

import UIKit

enum notifyStyle {
    case closeCell
    case otherCellIsOpen
    case otherCellIsClose
}

class SGFavoritesCell: UITableViewCell {

    let kMiddle : CGFloat = 250
    
    var titleLabel : UILabel?
    var urlLabel   : UILabel?
    var iconView   : UIImageView?
    var showView   : UIView?
    
    var cellHelper: deleteCellHelper?
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?,tableView:UITableView) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellHelper = deleteCellHelper.sharedHelper(cell: self, currentTableView: tableView)
        
        setupUI()
        
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


