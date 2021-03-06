//
// Created by Jorg on 11/09/15.
// Copyright (c) 2015 JENNIUS LTD. All rights reserved.
//

import Foundation
import FoodHero

class ConversationRepositoryTests: XCTestCase {
    let input = RACSubject()

    override func setUp() {
        ConversationRepository.deletePersistedData()
        TyphoonComponents.configure(StubAssembly())
    }

    func createRepo() -> ConversationRepository {
        return ConversationRepository(assembly: TyphoonComponents.getAssembly())
    }

    func test_getForInput_ShouldRestorePersistedSentences() {
        let repo = createRepo()
        let conv = repo.getForInput(input)
        conv.resumeWithFeedbackRequest(false) // creates some statements
        let origStmtCount = conv.getStatementCount()

        repo.persist()
        let restoredRepo = createRepo()
        let restoredConv = restoredRepo.getForInput(input)

        XCTAssertEqual(restoredConv.getStatementCount(), origStmtCount)
    }

    func test_getForInput_ShouldReturnWorkingConversation_WhenNotPersistedBefore() {
        // create Conversation with some statements
        let repo = createRepo()
        let conv = repo.getForInput(input)
        conv.resumeWithFeedbackRequest(false)
        let origStmtCount = conv.getStatementCount()

        // send Input to Conversation
        let expectation = expectationWithDescription("")
        input.sendNext(UserUtterances.dislikesKindOfFood("I dont like that"))

        // test that Conversation generates new statements
        var stmtCount: UInt = 0
        conv.statementIndexes().subscribeNext {
            object in
            stmtCount = stmtCount + 1
            if (origStmtCount + 1) == stmtCount {
                expectation.fulfill()
            }
        }

        waitForExpectationsWithTimeout(0.5, handler: nil)
    }

    func test_getForInput_SholdReturnWorkingConversation_WhenPersistedBefore() {
        // create Conversation with some statements
        let repo = createRepo()
        let conv = repo.getForInput(input)
        conv.resumeWithFeedbackRequest(false)
        let origStmtCount = conv.getStatementCount()
        repo.persist()

        // restore Conversation
        let restoredInput = RACSubject()
        let restoredRepo = createRepo()
        let restoredConv = restoredRepo.getForInput(restoredInput)
        restoredConv.resumeWithFeedbackRequest(false)

        // send Input to restored Conversation
        let expectation = expectationWithDescription("")
        restoredInput.sendNext(UserUtterances.dislikesKindOfFood("I dont like that"))

        // test that restored Conversation generates new statements
        var stmtCount: UInt = 0
        restoredConv.statementIndexes().subscribeNext {
            object in
            stmtCount = stmtCount + 1
            if (origStmtCount + 1) == stmtCount {
                expectation.fulfill()
            }
        }

        waitForExpectationsWithTimeout(0.5, handler: nil)
    }

    func test_persist_ShouldNotCrash_WhenNoConversationExists() {
        let repo = createRepo()

        repo.persist() // no exception ok
    }

    func test_getForInput_ShouldRestoreStateOfConversation(){
        // create conversation with some statements
        let repo = createRepo()
        let conv = repo.getForInput(input)
        conv.resumeWithFeedbackRequest(false)
        input.sendNext(UserIntentUnclearError(state: FHStates.askForFoodPreference(), expectedUserUtterances: ExpectedUserUtterances(utterances: [])))
        repo.persist()

        // restore conversation
        let restoredInput = RACSubject()
        let restoredRepo = createRepo()
        let restoredConv = restoredRepo.getForInput(restoredInput)
        restoredConv.resumeWithFeedbackRequest(false)

        // continue conversation on restored conversation
        let statement1 = restoredConv.getStatement(restoredConv.getStatementCount()-1)
        XCTAssertEqual(statement1.semanticId(),"FH:DidNotUnderstandAndAsksForRepetition" )
        restoredInput.sendNext(UserUtterances.dislikesKindOfFood("I dont like that"))
        let statement2 = restoredConv.getStatement(restoredConv.getStatementCount()-1)
        XCTAssertEqual(statement2.semanticId(),"FH:AskForKindOfFood" )
    }
}
