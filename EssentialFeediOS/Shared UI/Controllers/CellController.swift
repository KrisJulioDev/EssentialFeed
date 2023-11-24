//
//  CellController.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/24/23.
//

import UIKit

public struct CellController  {
    let id: AnyHashable
    let dataSource: UITableViewDataSource
    let delegate: UITableViewDelegate?
    let dataSourcePrefeching: UITableViewDataSourcePrefetching?
    
    public init(id: AnyHashable, dataSource : UITableViewDataSource & UITableViewDelegate & UITableViewDataSourcePrefetching) {
        self.id = id
        self.dataSource = dataSource
        self.delegate = dataSource
        self.dataSourcePrefeching = dataSource
    }
    
    public init(id: AnyHashable, _ dataSource : UITableViewDataSource) {
        self.id = id
        self.dataSource = dataSource
        self.delegate = nil
        self.dataSourcePrefeching = nil
    }
}

extension CellController: Equatable {
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
}

extension CellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


