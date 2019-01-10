//
//  EventsListViewController.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 09/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EventsListViewController: UIViewController {

    var viewModel: EventsListViewModel
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    init(viewModel: EventsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .blue
        
        setupBindinds()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.sendActions(for: .valueChanged)
    }

    private func setupBindinds() {
        viewModel.events
            .subscribe({ (events) in
            print(events)
            }).disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        
    }
    
}
