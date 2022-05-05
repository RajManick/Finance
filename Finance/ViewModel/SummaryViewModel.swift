//
//  SummaryViewModel.swift
//  Finance
//
//  Created by Manickam on 04/05/22.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay


protocol searchBarDelegate : AnyObject {
    var searchValue: BehaviorRelay<String>{ get }
}



@objc protocol loaderDelegate : AnyObject {
    func showLoading()
    func stopLoading()
    @objc optional func ShowToast(msg : String)
}

class SummaryViewModel {
    
    weak var delegate : loaderDelegate?

    
    var items = PublishSubject<[Result]>()
    var filteredItems = PublishSubject<[Result]>()
    let disposeBag = DisposeBag()
    private let searchValue = BehaviorSubject<String?>(value: "")
    var searchValueObservable: AnyObserver<String?> { searchValue.asObserver() }
    lazy var itemsObservable : Observable<[Result]> = self.items.asObservable()
    lazy var filteredItemsObservable : Observable<[Result]> = self.filteredItems.asObservable()
    
    
    init(){
        
        filteredItemsObservable = Observable.combineLatest(
            searchValue
                .map { $0 ?? "" }
                      .startWith("")
                      .throttle(.milliseconds(500), scheduler: MainScheduler.instance),
            items
              )
              .map { searchValue, books in
                  searchValue.isEmpty ? books : books.filter { $0.fullExchangeName.lowercased().contains(searchValue.lowercased()) }
              }
    }
    
    func fetchItems(){
        delegate?.showLoading()
        let headers = [
            "X-RapidAPI-Host": "yh-finance.p.rapidapi.com",
            "X-RapidAPI-Key": "68b915acfdmsh1e045479fee2690p11482bjsn7359ec2c1257"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://yh-finance.p.rapidapi.com/market/v2/get-summary?region=US")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
//                print(error)
            } else {
                if let jsonResponse = String(data: data!, encoding: String.Encoding.utf8) {
                    print(jsonResponse)
                    let blogPost: SummaryModel = try! JSONDecoder().decode(SummaryModel.self, from: data!)
                    self.items.onNext(blogPost.marketSummaryAndSparkResponse.result)
                    self.items.onCompleted()
                }
                self.delegate?.stopLoading()
            }
        })

        dataTask.resume()
    }
}
