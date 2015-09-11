//
// Created by Jorg on 11/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationRepositoryTests: XCTestCase {
    let input = RACSubject()

    override func setUp() {
        NSFileManager.defaultManager().removeItemAtPath(ConversationRepository.DataPath(), error:nil)
        TyphoonComponents.configure(DefaultAssembly())
    }

    func createRepo() -> ConversationRepository {
        return ConversationRepository(assembly: TyphoonComponents.getAssembly())
    }

    func test_init_ShouldRestorePersistedSentences() {
        let repo = createRepo()
        let conv = repo.getForInput(input)
        conv.start() // creates some statements

        repo.persist()
        let restoredRepo = createRepo()
        let restoredConv = restoredRepo.getForInput(input)

        XCTAssertGreaterThan(restoredConv.getStatementCount(), 0)
    }

    func test_getForInput_SholdReturnWorkingConversation_WhenNotPersistedBefore(){
        XCTAssertEqual(false, true)
    }

    func test_getForInput_SholdReturnWorkingConversation_WhenPersistedBefore(){
        XCTAssertEqual(false, true)
    }

    func test_persist_ShouldNotCrash_WhenNoConversationExists(){
        let repo = createRepo()

        repo.persist() // no exception ok
    }

    func test_persist_ShouldOverwriteExistingData() {
        XCTAssertEqual(false, true)
    }

    func test_init_ShouldRestorePersistedRawConversation() {
        XCTAssertEqual(false, true)
    }

    func test_init_ShouldRestorePersistedUserUtterances() {

        input.sendNext(UserUtterances.hello("Hi there!"))
        XCTAssertEqual(false, true)
    }

}
