//
//  MyPageViewModel.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/22.
//

import Combine
import Foundation

protocol MyPageViewModelInput {

}

protocol MyPageViewModelOutput {

}

protocol MyPageViewModelIO: MyPageViewModelInput, MyPageViewModelOutput { }

final class MyPageViewModel: MyPageViewModelIO {
    init() {

    }
}
