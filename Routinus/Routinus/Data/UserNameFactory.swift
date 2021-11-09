//
//  UserNameFactory.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/08.
//

import Foundation

enum UserNameFactory {
    static func createRandomName() -> String {
        var result = ""
        let adjective = ["귀여운", "멋진", "정직한", "예쁜", "스윗한", "로맨틱한", "재미있는", "느긋한", "친절한", "다정한"]
        let noun = ["컵라면", "코끼리", "감자", "소고기", "맥북", "민서", "지현", "석환", "상우", "강아지", "고양이", "토끼", "송아지", "사자", "호랑이", "병아리"]
        let number = Int.random(in: 1...99)
        
        result += adjective.randomElement() ?? ""
        result += noun.randomElement() ?? ""
        result += "\(number)"
        
        return result
    }
}
