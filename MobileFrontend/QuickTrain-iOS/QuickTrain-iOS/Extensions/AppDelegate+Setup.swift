//
//  AppDelegate+Setup.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 13/11/2020.
//

import Foundation
import CleanroomLogger

extension AppDelegate {
    /**
        Set up logging to console and to file with 15 days log retention
        */
    internal func setupLogging() {
        var configs = [LogConfiguration]()
        
        // create a recorder for logging to stdout & stderr
        // and add a configuration that references it
        let stderr = StandardStreamsLogRecorder(formatters: [XcodeLogFormatter()])
        configs.append(BasicLogConfiguration(minimumSeverity: .debug, recorders: [stderr]))
        
        // create a recorder for logging via OSLog (if possible)
        // and add a configuration that references it
        if let osLog = OSLogRecorder(formatters: [ReadableLogFormatter()]) {
            // the OSLogRecorder initializer will fail if running on
            // a platform that doesn’t support the os_log() function
            configs.append(BasicLogConfiguration(recorders: [osLog]))
        }
        
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true)[0])
        let logsPath = documentsPath.appendingPathComponent("logs")
        
        // create a configuration for a 15-day rotating log directory
        let fileCfg = RotatingLogFileConfiguration(minimumSeverity: .debug,
                                                   daysToKeep: 15,
                                                   directoryPath: logsPath!.path,
                                                   formatters: [ReadableLogFormatter()])
        
        // crash if the log directory doesn’t exist yet & can’t be created
        do {
            try fileCfg.createLogDirectory()
        } catch {}
        
        configs.append(fileCfg)
        
        // enable logging using the LogRecorders created above
        Log.enable(configuration: configs)
    }
}
