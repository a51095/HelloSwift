//
//  Preferences.swift
//  HelloSwift
//
//  Created by well on 2024/2/22.
//

import Foundation

struct Preferences {
	private init() {}

	static func setInt(_ value: Int, forKey key: String) {
		UserDefaults.standard.set(value, forKey: key)
	}

	static func getInt(forKey key: String) -> Int {
		UserDefaults.standard.integer(forKey: key)
	}

	static func setBool(_ value: Bool, forKey key: String) {
		UserDefaults.standard.set(value, forKey: key)
	}

	static func getBool(forKey key: String) -> Bool {
		UserDefaults.standard.bool(forKey: key)
	}

	static func setString(_ value: String, forKey key: String) {
		UserDefaults.standard.set(value, forKey: key)
	}

	static func getString(forKey key: String, defaultValue: String) -> String {
		UserDefaults.standard.string(forKey: key) ?? defaultValue
	}

	static func setData<T: Codable>(_ value: T?, forKey key: String) {
		do {
			let data = try JSONEncoder().encode(value)
			UserDefaults.standard.set(data, forKey: key)
		} catch {
			print("Error encoding value for key \(key): \(error)")
		}
	}

	static func getData<T: Codable>(forKey key: String) -> T? {
		if let data = UserDefaults.standard.data(forKey: key) {
			do {
				let value = try JSONDecoder().decode(T.self, from: data)
				return value
			} catch {
				print("Error decoding value for key \(key): \(error)")
			}
		}
		return nil
	}
}

@propertyWrapper
struct IntPreference {
	private let key: String

	var wrappedValue: Int {
		get {
			Preferences.getInt(forKey: key)
		}
		set {
			Preferences.setInt(newValue, forKey: key)
		}
	}

	init(key: String) {
		self.key = key
	}
}

@propertyWrapper
struct BoolPreference {
	private let key: String

	var wrappedValue: Bool {
		get {
			Preferences.getBool(forKey: key)
		}
		set {
			Preferences.setBool(newValue, forKey: key)
		}
	}

	init(key: String) {
		self.key = key
	}
}

@propertyWrapper
struct StringPreference {
	private let key: String
	private let defaultValue: String

	var wrappedValue: String {
		get {
			Preferences.getString(forKey: key, defaultValue: defaultValue)
		}
		set {
			Preferences.setString(newValue, forKey: key)
		}
	}

	init(key: String, defaultValue: String = String()) {
		self.key = key
		self.defaultValue = defaultValue
	}
}

@propertyWrapper
struct DataPreference<T: Codable> {
	private let key: String
	private let defaultValue: T?

	var wrappedValue: T? {
		get {
			Preferences.getData(forKey: key) ?? defaultValue
		}
		set {
			Preferences.setData(newValue, forKey: key)
		}
	}

	init(key: String, defaultValue: T? = nil) {
		self.key = key
		self.defaultValue = defaultValue
	}
}
