//
// (c) Aron Budinszky (2022) - https://aron.budinszky.me
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

import Foundation

public extension PostmarkSwift {
    
    /// The `Client` allows you to connect to Postmark's API and perform supported operations
    ///
    /// Usage:
    ///
    ///         let postmarkClient = PostmarkSwift.Client(serverToken: "")
    ///         let result = await postmarkClient.send(....)
    ///
    struct Client {
        
        // MARK: - Type definitions
        
        public enum Error: Swift.Error {
            case postmarkError(code: ErrorCode, message: String)
        }
        
        
        // MARK: - Properties
        
        /// The underlying API client
        private let apiClient: ApiRequestCommunicating
        
        // MARK: - Methods

        /// Create a new `Client`
        ///
        /// - Parameter serverToken: The server token to user for the client.
        public init(serverToken: String) {
            self.init(apiClient: ApiClient(serverToken: serverToken))
        }

        /// Create a new `Client` with a custom `APIClient`. Can be used for testing.
        ///
        /// - Parameter apiClient: The underlying API Client
        init(apiClient: ApiRequestCommunicating) {
            self.apiClient = apiClient
        }
        
        /// Sends a single email
        ///
        /// - Parameters:
        ///  - from: The sender signature.
        ///  - to: The recipient's email address.
        ///  - subject: The email's subject.
        ///  - body: The email's body text.
        ///
        /// - Throws: Throws an error if something failed.
        /// - Returns: Returns the success data if operation was successful.
        @discardableResult public func send(_ outgoingEmail: OutgoingEmail) async throws -> OutgoingEmail.Success {
            
            // Create request
            let sendRequest = SendRequest(
                From: outgoingEmail.from,
                To: outgoingEmail.to.joined(separator: ","),
                Cc: outgoingEmail.cc?.joined(separator: ","),
                Bcc: outgoingEmail.bcc?.joined(separator: ","),
                Subject: outgoingEmail.subject,
                Tag: outgoingEmail.tag,
                HtmlBody: outgoingEmail.htmlBody,
                TextBody: outgoingEmail.textBody,
                ReplyTo: outgoingEmail.replyTo,
                MetaData: outgoingEmail.metaData,
                Headers: outgoingEmail.headers,
                TrackOpens: outgoingEmail.trackOpens,
                TrackLinks: outgoingEmail.trackLinks
            )
            
            // Send request
            let response = try await self.apiClient.post(sendRequest, to: .email)
            
            // Process error if any
            let errorCode = ErrorCode(rawValue: response.ErrorCode) ?? .unknown
            guard errorCode == .ok else {
                throw Error.postmarkError(code: errorCode, message: response.Message)
            }
            
            // Success
            return OutgoingEmail.Success(messageID: response.MessageID, submittedAt: response.SubmittedAt, to: response.To)
        }
        
    }
    
}
