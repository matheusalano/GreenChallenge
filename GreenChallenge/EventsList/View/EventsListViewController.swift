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

    private lazy var tableView: UITableView = {
        let myTableView = UITableView()
        myTableView.rowHeight = 100
        myTableView.refreshControl = refreshControl
        myTableView.tableFooterView = UIView()
        myTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        myTableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.description())
        return myTableView
    }()
    
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
        
        setupUI()
        setupBindinds()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.sendActions(for: .valueChanged)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupBindinds() {
        viewModel.events
        .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() })
            .bind(to: tableView.rx.items(cellIdentifier: EventTableViewCell.description(), cellType: EventTableViewCell.self)) { (_, event, cell) in
                cell.configure(event: event)
        }
        .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Event.self)
            .bind(to: viewModel.selectEvent)
            .disposed(by: disposeBag)
    }
}
