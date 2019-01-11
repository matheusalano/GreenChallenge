//
//  EventDetailViewController.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 10/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class EventDetailViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let myTableView = UITableView()
        myTableView.estimatedRowHeight = 60
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.refreshControl = refreshControl
        myTableView.tableFooterView = UIView()
        myTableView.separatorStyle = .none
        myTableView.allowsSelection = false
        myTableView.register(EventGeneralInfoTableViewCell.self, forCellReuseIdentifier: EventGeneralInfoTableViewCell.description())
        myTableView.register(EventPeopleTableViewCell.self, forCellReuseIdentifier: EventPeopleTableViewCell.description())
        myTableView.register(EventCouponsTableViewCell.self, forCellReuseIdentifier: EventCouponsTableViewCell.description())
        return myTableView
    }()
    
    private lazy var barButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: String.localized(by: "checkIn"), style: .plain, target: self, action: #selector(presentCheckInAlert))
        return button
    }()
    
    var viewModel: EventDetailViewModel
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    
    init(viewModel: EventDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        setupUI()
        setupBinding()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.beginRefreshing()
        refreshControl.sendActions(for: .valueChanged)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func setupBinding() {
        viewModel.event.observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() })
            .map { event in
                let sections: [EventDetailSectionModel] = [
                    .generalInfoSection(items: [.generalInfo(event: event)]),
                    .peopleSection(items: event.people.map({ .people(people: $0) })),
                    .couponsSection(items: event.cupons.map({ .coupons(coupons: $0) }))
                ]
                return sections
            }
            .bind(to: tableView.rx.items(dataSource: EventDetailViewController.dataSource()))
            .disposed(by: disposeBag)
        
        viewModel.event.subscribe(onNext: { [weak self] (event) in
            self?.title = event.title
        }).disposed(by: disposeBag)
        
        viewModel.alert.subscribe(onNext: { [weak self] in self?.showErrorAlert(message: $0) })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        
        viewModel.didCheckIn.subscribe(onNext: { [weak self] success in
            if success {
                self?.showAlert(title: String.localized(by: "checkedIn"), message: nil)
            } else {
                self?.showErrorAlert(message: String.localized(by: "checkInError"))
            }
        }).disposed(by: disposeBag)
    }
    
    @objc private func presentCheckInAlert() {
        let alert = UIAlertController(title: String.localized(by: "checkIn"), message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = String.localized(by: "name")
        }
        alert.addTextField { (textField) in
            textField.placeholder = String.localized(by: "email")
            textField.keyboardType = .emailAddress
        }
        let sendAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            let name = alert.textFields?[0].text ?? ""
            let email = alert.textFields?[1].text ?? ""
            let user = User(name: name, email: email)
            self?.viewModel.checkIn.onNext(user)
        }
        let cancelAction = UIAlertAction(title: String.localized(by: "cancel"), style: .cancel, handler: nil)
        
        alert.addAction(sendAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    static func dataSource() -> RxTableViewSectionedReloadDataSource<EventDetailSectionModel> {
        return RxTableViewSectionedReloadDataSource<EventDetailSectionModel>(
            configureCell: { (dataSource, tableView, indexPath, _) -> UITableViewCell in
                switch dataSource[indexPath] {
                case .generalInfo(let event):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: EventGeneralInfoTableViewCell.description(), for: indexPath) as? EventGeneralInfoTableViewCell else { return UITableViewCell() }
                    
                    cell.configure(with: event)
                    return cell
                case .people(let people):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: EventPeopleTableViewCell.description(), for: indexPath) as? EventPeopleTableViewCell else { return UITableViewCell() }
                    
                    cell.configure(with: people)
                    return cell
                case .coupons(let coupons):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCouponsTableViewCell.description(), for: indexPath) as? EventCouponsTableViewCell else { return UITableViewCell() }
                    
                    cell.configure(with: coupons)
                    return cell
                }
            },
            titleForHeaderInSection: { dataSource, index in
                switch dataSource[index] {
                case .generalInfoSection:
                    return nil
                case .peopleSection(let people):
                    return people.isEmpty ? nil : String.localized(by: "people")
                case .couponsSection(let coupons):
                    return coupons.isEmpty ? nil : String.localized(by: "coupons")
                }
            }
        )
    }
}
