//
//  Score.swift
//  RepeatAfterMe
//
//  Created by JESMOND CAMILLERI on 24/6/18.
//  Copyright © 2018 JesmondCamilleri. All rights reserved.
//

import Foundation
import RealmSwift

class HighScores: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var score: Int = 0
    @objc dynamic var mode: String = ""
}
