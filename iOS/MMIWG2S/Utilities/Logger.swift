//
//  Logger.swift
//  MMIWG2S
//
//  Created by Callum Johnston on 4/7/21.
//  Copyright © 2021 Google LLC. All rights reserved.
//

import Foundation

let log = Logger([.info, .error, .warn])

class Logger {
    private let levels: [Level]
    
    init(_ levels: [Level]) {
        self.levels = levels
    }
    
    enum Level: String {
        case info = "ℹ️"
        case debug = "💻"
        case error = "🛑"
        case warn = "⚠️"
    }
    
    func info(_ msg: String, function: String = #function,  fileName: String = #file, lineNumber: Int = #line) {
        log(msg, level: .info, function: function, fileName: fileName, lineNumber: lineNumber)
    }
    
    func debug(_ msg: String, function: String = #function,  fileName: String = #file, lineNumber: Int = #line) {
        log(msg, level: .debug, function: function, fileName: fileName, lineNumber: lineNumber)
    }
    
    func error(_ msg: String, function: String = #function,  fileName: String = #file, lineNumber: Int = #line) {
        log(msg, level: .error, function: function, fileName: fileName, lineNumber: lineNumber)
    }
    
    func warn(_ msg: String, function: String = #function,  fileName: String = #file, lineNumber: Int = #line) {
        log(msg, level: .warn, function: function, fileName: fileName, lineNumber: lineNumber)
    }
    
    private func log(_ msg: String, level: Level, function: String, fileName: String, lineNumber: Int) {
        if levels.contains(level) {
            print("MMIW: \(level.rawValue) \(msg)\r\tCalled from: \(fileName): \(function), line: \(lineNumber)")
        }
    }
}
