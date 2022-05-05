//
//  DescriptionViewController.swift
//  Finance
//
//  Created by Manickam on 04/05/22.
//

import UIKit
import RxSwift

class DescriptionViewController: BaseViewController {
        
    var symbol : String = ""
    
    private var descriptionViewModel = DescriptionViewModel()
    private let disposeBag = DisposeBag()
    
    private var tableview : UITableView = {
        let table  = UITableView()
        table.register(UINib(nibName: "DescriptionTableCell", bundle: nil), forCellReuseIdentifier: "DescriptionTableCell")
        table.tableFooterView = UIView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Stock Detail"
        view.addSubview(tableview)
        tableview.frame = view.bounds
        tableview.separatorStyle = .none
        bindTableData()
    }

    
    func bindTableData(){
        descriptionViewModel.delegate = self
        descriptionViewModel.items.bind(to: tableview.rx.items(cellIdentifier: "DescriptionTableCell",cellType: DescriptionTableCell.self)){ row, element, cell in
            let keyString =  (element as! String).components(separatedBy: "  ")
            cell.keyLbl.text = keyString[0]
            cell.valueLbl.text = keyString[1]
        }.disposed(by: disposeBag)
        
        //fetch items
        descriptionViewModel.fetchItems(symbol: symbol)

    }
}
