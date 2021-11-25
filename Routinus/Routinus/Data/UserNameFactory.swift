//
//  UsernameFactory.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/08.
//

import Foundation

enum UsernameFactory {
    static func randomName() -> String {
        var result = ""
        let adjective = ["귀여운", "멋진", "정직한", "재미있는", "느긋한", "친절한", "다정한"]
        let noun = ["코끼리", "감자", "맥북", "강아지", "고양이", "토끼", "송아지", "사자", "호랑이", "병아리"]

        result += adjective.randomElement() ?? ""
        result += noun.randomElement() ?? ""

        return result
    }
}
