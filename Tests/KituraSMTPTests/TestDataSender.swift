/**
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import XCTest
import KituraSMTP

class TestDataSender: XCTestCase {
    static var allTests : [(String, (TestDataSender) -> () throws -> Void)] {
        return [
            ("testSendNonASCII", testSendNonASCII),
            ("testSendFile", testSendFile),
            ("testSendHTMLAlternative", testSendHTMLAlternative),
            ("testSendHTML", testSendHTML),
            ("testSendData", testSendData),
            ("testSendRelatedAttachment", testSendRelatedAttachment),
            ("testSendMultipleAttachments", testSendMultipleAttachments)
        ]
    }
    
    func testSendNonASCII() {
        let mail = Mail(from: user, to: [user], subject: "Non ASCII", text: "💦")
        smtp.send(mail) { (err) in
            XCTAssertNil(err)
            self.x.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func testSendFile() {
        let fileAttachment = Attachment(filePath: imgFilePath)
        let mail = Mail(from: user, to: [user], subject: "File attachment", attachments: [fileAttachment])
        smtp.send(mail) { (err) in
            XCTAssertNil(err)
            self.x.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func testSendHTMLAlternative() {
        let htmlAttachment = Attachment(htmlContent: html)
        let mail = Mail(from: user, to: [user], subject: "HTML alternative attachment", text: text, attachments: [htmlAttachment])
        smtp.send(mail) { (err) in
            XCTAssertNil(err)
            self.x.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func testSendHTML() {
        let htmlAttachment = Attachment(htmlContent: html, alternative: false)
        let mail = Mail(from: user, to: [user], subject: "HTML attachment", text: text, attachments: [htmlAttachment])
        smtp.send(mail) { (err) in
            XCTAssertNil(err)
            self.x.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func testSendData() {
        let data = "{\"key\": \"hello world\"}".data(using: .utf8)!
        let attachment = Attachment(data: data, mime: "application/json", name: "file.json")
        let mail = Mail(from: user, to: [user], subject: "Data attachment", attachments: [attachment])
        smtp.send(mail) { (err) in
            XCTAssertNil(err)
            self.x.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func testSendRelatedAttachment() {
        let fileAttachment = Attachment(filePath: imgFilePath, inline: true, additionalHeaders: ["CONTENT-ID": "megaman-pic"])
        let htmlAttachment = Attachment(htmlContent: "<html><p>Lorum Ipsum Blah Blah</p><img src=\"cid:megaman-pic\"/><p>Lorum Ipsum Blah Blah</p></html>", related: [fileAttachment])
        let mail = Mail(from: user, to: [user], subject: "HTML with related attachment", attachments: [htmlAttachment])
        smtp.send(mail) { (err) in
            XCTAssertNil(err)
            self.x.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    func testSendMultipleAttachments() {
        let fileAttachment = Attachment(filePath: imgFilePath)
        let htmlAttachment = Attachment(htmlContent: html, alternative: false)
        let mail = Mail(from: user, to: [user], subject: "Multiple attachments", text: text, attachments: [fileAttachment, htmlAttachment])
        smtp.send(mail) { (err) in
            XCTAssertNil(err)
            self.x.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    var x: XCTestExpectation!
    override func setUp() { x = expectation(description: "") }
}