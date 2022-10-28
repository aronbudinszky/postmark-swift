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

extension PostmarkSwift {
    
    /// Use to create an outgoing email to then `send()` with the client
    open class OutgoingEmail: Codable {
        
        // MARK: - Type definitions
        
        /// A string matching the '"First Last" <first@example.com>' format
        public typealias EmailAddress = String
        
        /// Successful email send response
        public struct Success {
            
            /// The UUID of the message retutrned
            public let messageID: UUID?
            
            /// The time at which the request was submitted
            public let submittedAt: String?
            
            /// The email(s) to which the message was sent
            public let to: String?
            
            /// Creates a success
            public init(messageID: UUID?, submittedAt: String?, to: String?) {
                self.messageID = messageID
                self.submittedAt = submittedAt
                self.to = to
            }
        }
                        
        // MARK: - Properties
                
        /// The `From` address. Must be a registered sending signature in Postmark.
        ///
        /// You can also use '"First Last" <first@example.com>' format to override the default name. Make sure to quote the name (fixes issues with punctuation, etc.).
        private(set) var from: Client.SendRequest.EmailAddress
        
        /// The recipients' address
        ///
        /// One or comma-separated list up to 50.
        private(set) var to: [Client.SendRequest.EmailAddress]
        
        /// The subject line
        private(set) var subject: String
        
        /// Copy
        ///
        /// One or comma-separated list up to 50.
        private(set) var cc: [Client.SendRequest.EmailAddress]?
        
        /// Blind copy
        ///
        /// One or comma-separated list up to 50.
        private(set) var bcc: [Client.SendRequest.EmailAddress]?
        
        /// The tag for this email
        ///
        /// You can categorize outgoing email using the Tag property. This enables you to get detailed statistics for all of your tagged emails. Only one tag may be used for each message.
        var tag: String?
        
        /// The HTML body
        var htmlBody: String?
        
        /// The text body
        var textBody: String
        
        /// A single reply to address, if differs to From
        var replyTo: Client.SendRequest.EmailAddress?
        
        /// Add metadata to an email
        ///
        /// Seealso: https://postmarkapp.com/support/article/1125-custom-metadata-faq
        var metaData: Dictionary<String, String>?
        
        /// An array of headers
        var headers: [Client.SendRequest.EmailHeader]?
        
        /// Per-email setting for track opens
        ///
        /// Seealso: https://postmarkapp.com/developer/user-guide/tracking-opens/tracking-opens-per-email
        var trackOpens: Bool?
        
        /// Any tracked link that the user clicks on will record statistics, regardless of whether it was clicked from the HTML or Text parts of the email.
        ///
        /// Defaults to `.none` which means tracking is off.
        var trackLinks: Client.SendRequest.TrackLinksSetting = .None
        
        // MARK: - Methods
        
        /// Initializer with multiple recipients
        ///
        /// Creates an email with the required fields.
        public init(from: EmailAddress, to: [EmailAddress], subject: String, textBody: String, htmlBody: String? = nil) {
            self.from = from
            self.to = to
            self.subject = subject
            self.textBody = textBody
            self.htmlBody = htmlBody
        }

        /// Initializer with a single recipient
        ///
        /// Creates an email with the required fields.
        public convenience init(from: EmailAddress, to: EmailAddress, subject: String, textBody: String, htmlBody: String? = nil) {
            self.init(from: from, to: [to], subject: subject, textBody: textBody, htmlBody: htmlBody)
        }

    }
}
