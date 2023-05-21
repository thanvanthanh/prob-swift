//
//  AirdropsInteractor.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 26/12/2565 BE.
//  
//

import Foundation

class AirdropsInteractor: PresenterToInteractorAirdropsProtocol {
    // MARK: Properties
    var tabActive: UIViewController
    var tabEnded: UIViewController
    var presenter: InteractorToPresenterAirdropsProtocol?
    var menus: [MenuBar]
    
    init() {
        tabActive = AirdropsCollectionPageRouter(request: AirdropListRequestModel(page: 1, title: nil,
                                                                                  type: nil, status: .active,
                                                                                  service: .global, displayOn: .events,
                                                                                  locale: AppConstant.locale)).createModule()
        
        tabEnded = AirdropsCollectionPageRouter(request: AirdropListRequestModel(page: 1, title: nil,
                                                                                 type: nil, status: .ended,
                                                                                 service: .global, displayOn: .events,
                                                                                 locale: AppConstant.locale)).createModule()
        menus = [MenuBar(name: "activity_event_activebutton".Localizable(),
                         icon: nil,
                         controller: self.tabActive,
                         isSelected: true),
                 MenuBar(name: "activity_event_endedbutton".Localizable(),
                         icon: nil,
                         controller: self.tabEnded)]
    }
}


