//
// Created by Jorg on 11/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation

public class ConversationRepository: NSObject {
    private static let RootKey = "Root"
    private let _assembly: ApplicationAssembly
    private var _conversation: Conversation?
    private let _filePath: String
    private let _fileManager = NSFileManager()

    private class func DataPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0] as! String
    }

    public init(assembly: ApplicationAssembly) {
        _assembly = assembly

        let path = ConversationRepository.DataPath()
        _filePath = path.stringByAppendingPathComponent("conversation.dat")
        super.init()

        ensurePathExists(path)
    }

    private func ensurePathExists(path: String) {
        var err: NSError?
        _fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: &err)
        if err != nil {
            NSLog("ConversationRepository.init: \(err!.localizedDescription)")
        }
    }

    public class func deletePersistedData(){
        NSFileManager.defaultManager().removeItemAtPath(ConversationRepository.DataPath(), error: nil)
    }

    public func getForInput(input: RACSignal) -> Conversation {
        if _conversation != nil {
            return _conversation!;
        } else if _conversation == nil {
            if let data = NSData(contentsOfFile: _filePath) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                _conversation = unarchiver.decodeObjectForKey(ConversationRepository.RootKey) as? Conversation
            }
        }
        if _conversation == nil {
            _conversation = Conversation()
        }
        _conversation!.setInput(input)
        _conversation!.setAssembly(_assembly)
        return _conversation!
    }

    public func persist() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(_conversation, forKey: ConversationRepository.RootKey)
        archiver.finishEncoding()

        let result = data.writeToFile(_filePath, atomically: true)

    }
}
