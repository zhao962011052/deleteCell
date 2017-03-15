//
//  SGFunc.swift
//  deleteCell
//
//  Created by 盖特 on 2017/3/15.
//
//

import UIKit

func printLog<T>(message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
