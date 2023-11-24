//
//  CellController.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/24/23.
//

import UIKit

public struct CellController  {
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    let dataSourcePrefeching: UITableViewDataSourcePrefetching?
    
    public init(dataSource : UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching) {
        self.dataSource = dataSource
        self.delegate = dataSource
        self.dataSourcePrefeching = dataSource
    }
    
    public init(_ dataSource : UITableViewDataSource) {
        self.dataSource = dataSource
        self.delegate = nil
        self.dataSourcePrefeching = nil
    }
}

