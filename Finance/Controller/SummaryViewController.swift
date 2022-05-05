//
//  ViewController.swift
//  Finance
//
//  Created by Manickam on 04/05/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import Foundation

class SummaryViewController: BaseViewController {

    @IBOutlet weak var summarySearchBar: UISearchBar!
    @IBOutlet weak var summaryTableview: UITableView!
    
    private var summaryViewModel = SummaryViewModel()
    private let disposeBag = DisposeBag()
    
    var summaryArr : [Result]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Yahoo Finance List"
        summaryTableview.register(UINib(nibName: "SummaryTableCell", bundle: nil), forCellReuseIdentifier: "SummaryTableCell")
        summaryTableview.tableFooterView = UIView()
        bindTableData()
        self.setSearchBar()
    }
    
    func setSearchBar() {
        self.summarySearchBar.rx.text.orEmpty.throttle(.milliseconds(500), scheduler: MainScheduler.instance).distinctUntilChanged().bind(to: summaryViewModel.searchValueObservable).disposed(by: disposeBag)
        self.summarySearchBar.searchTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe { _ in
            print("editingDidEndOnExit")
            self.summarySearchBar?.resignFirstResponder()
        }.disposed(by: disposeBag)
    }

    
    func bindTableData(){
        summaryViewModel.delegate = self
        //Bind items to table
        summaryViewModel.filteredItemsObservable.bind(to: summaryTableview.rx.items(cellIdentifier: "SummaryTableCell",cellType: SummaryTableCell.self)){ row, item, cell in
            cell.fullExchangeNameLbl.text = "ExchangeName : \(item.fullExchangeName)"
            cell.marketLbl.text = "Market : \(item.market)"
            cell.symbolLbl.text = "Symbol : \(item.symbol)"
            cell.priceHintLbl.text = "Price : \(item.priceHint)"
        }.disposed(by: disposeBag)
    
        //Bind model selected handler
        summaryTableview.rx.modelSelected(Result.self).bind { result in
            //Push to the next controller
            let descriptionController = DescriptionViewController()
            descriptionController.symbol = result.symbol
            let navEditorViewController: UINavigationController = UINavigationController(rootViewController: descriptionController)
            descriptionController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.Actofdismiss))
            self.present(navEditorViewController, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        //fetch items
        summaryViewModel.fetchItems()
        
    }
    
    @objc func Actofdismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BaseViewController : loaderDelegate{
    func showLoading() {
        showLoadingView()
    }
    
    func stopLoading() {
        hideLoadingView()
    }
    
    func ShowToast(msg: String) {
        showToast(controller: self, message : msg, seconds: 2.0)
        self.dismiss(animated: true, completion: nil)
    }
}
