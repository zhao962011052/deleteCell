//
//  SGFavoritesController.swift
//  SouGet
//
//  Created by 盖特 on 2017/3/8.
//  Copyright © 2017年 souget.com. All rights reserved.
//

import UIKit

class SGFavoritesController: UIViewController {

    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

}

// MARK: - UI布局
extension SGFavoritesController{
    
    fileprivate func setupUI(){
        
        view.backgroundColor = UIColor.white
        self.title = "全部分类"
        self.setupTableView()
        
    }
    
    private func setupTableView(){
        //添加tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //tableView设置
//        tableView.register(SGFavoritesCell.self , forCellReuseIdentifier: "cell")
        tableView.rowHeight = 200
        view.addSubview(self.tableView)
        
        self.tableView.snp_makeConstraints{ (make) -> Void in
            make.edges.equalTo(0)
            
        }

    
    }


}


// MARK: - 数据层
extension SGFavoritesController{
    

    
}


// MARK: - delegate
extension SGFavoritesController:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")as? SGFavoritesCell
        
        if cell == nil {
            cell = SGFavoritesCell(style: .default, reuseIdentifier: "cell", tableView: tableView)
        }
        
        return cell!
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let shareAction = UITableViewRowAction(style: .normal, title: "share") { (UITableViewRowAction, IndexPath) in
//        
//            
//            
//        }
//        
//        let deleteAction = UITableViewRowAction(style: .default, title: "delete") { (UITableViewRowAction, IndexPath) in
//            
//            
//            
//        }
//        
//        shareAction.backgroundColor = UIColor.blue
//        deleteAction.backgroundColor = UIColor.red
//        
//        return[shareAction,deleteAction]
//        
//    }
    
}








