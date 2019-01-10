//
//  EventsListCoordinator.swift
//  GreenChallenge
//
//  Created by Matheus Alano on 09/01/19.
//  Copyright © 2019 Matheus Alano. All rights reserved.
//

import UIKit
import RxSwift

class EventsListCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = EventsListViewModel()
        let eventsListVC = EventsListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: eventsListVC)
        
        eventsListVC.viewModel = viewModel
        
        viewModel.openEventDetail.subscribe(onNext: { [weak self] in
            self?.showEventDetail(by: $0, in: navigationController)
        }).disposed(by: disposeBag)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return Observable.never()
    }
    
    private func showEventDetail(by id: String, in navigationController: UINavigationController) {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .red
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
