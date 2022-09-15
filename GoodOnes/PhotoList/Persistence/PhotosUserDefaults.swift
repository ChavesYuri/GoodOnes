//
//  PhotosUserDefaults.swift
//  GoodOnes
//
//  Created by Yuri Chaves on 14/09/22.
//

import Foundation
protocol UserDefaultsPersistenceProtocol {
    func getObject<T>(key: String) -> T?
    func setObject<T>(key: String, object: T)
}

final class UserDefaultsPersistence: UserDefaultsPersistenceProtocol {
    private let userDefaults: UserDefaults

    init(
        userDefaults: UserDefaults
    ) {
        self.userDefaults = userDefaults
    }

    public func getObject<T>(key: String) -> T? {
        return userDefaults.object(forKey: key) as? T
    }

    public func setObject<T>(key: String, object: T) {
        userDefaults.set(object, forKey: key)
    }
}
