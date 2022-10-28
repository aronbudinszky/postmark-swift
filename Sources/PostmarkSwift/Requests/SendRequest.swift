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

extension PostmarkSwift.Client {
    
    /// Response from sending a single email
    ///
    /// See API [documentation](https://postmarkapp.com/developer/user-guide/send-email-with-api/send-a-single-email)
    struct SendRequest: Codable, RequestResponsePairing {
        
        typealias ResponseType = SendResponse
        
        // MARK: - Type definitions
        
        /// A string matching the '"First Last" <first@example.com>' format
        public typealias EmailAddress = String
        
        /// An email header
        public struct EmailHeader: Codable {
            
            /// Name of the header, such as "Message-ID"
            let Name: String
            
            /// Value of the header, such as "<my-id-123@example.com>"
            let Value: String
        }
        
        /// An attached file
        public struct EmailAttachment: Codable {

            /// The file name
            let Name: String
            
            /// The Content field stores the binary data for the file, which must be transmitted as a base64-encoded string.
            let Content: String

            /// The ContentType field is the MIME content type that email clients use to interpret the attachment.
            let ContentType: String
            
            /// Postmark also allows you to send inline images via HTML messages. Images must be base64-encoded and the ContentID field must match the image's CID.
            ///
            /// Seealso: https://postmarkapp.com/developer/user-guide/send-email-with-api/send-a-single-email#attachments
            let ContentID: String?
        }
        
        /// Possible settings for tracking links
        ///
        /// Seealso: https://postmarkapp.com/developer/user-guide/tracking-links
        public enum TrackLinksSetting: String, Codable {
            
            /// No links will be replaced or tracked. This is the default setting for all messages and new and existing servers.
            case None
            
            /// Links will be replaced in both HTML and Text bodies. Identical links in either body part will be considered the "same" link, and only count as one unique click, regardless of which body part the recipient clicks from.
            case HtmlAndText
            
            /// Links will be replaced in only the HTMLBody. This is useful in some cases where you do not want to include encoded tracking links in the plain text of an email.
            case HtmlOnly
            
            /// Links will be replaced in only the TextBody.
            case TextOnly
        }
        
        // MARK: - Properties
        
        /// The `From` address. Must be a registered sending signature in Postmark.
        ///
        /// You can also use '"First Last" <first@example.com>' format to override the default name. Make sure to quote the name (fixes issues with punctuation, etc.).
        let From: EmailAddress
        
        /// The recipients' address
        ///
        /// One or comma-separated list up to 50.
        let To: String?
        
        /// Copy
        ///
        /// One or comma-separated list up to 50.
        let Cc: String?
        
        /// Blind copy
        ///
        /// One or comma-separated list up to 50.
        let Bcc: String?
        
        /// The subject line
        let Subject: String
        
        /// The tag for this email
        ///
        /// You can categorize outgoing email using the Tag property. This enables you to get detailed statistics for all of your tagged emails. Only one tag may be used for each message.
        let Tag: String?
        
        /// The HTML body
        let HtmlBody: String?
        
        /// The text body
        let TextBody: String
        
        /// A single reply to address, if differs to From
        let ReplyTo: EmailAddress?
        
        /// Add metadata to an email
        ///
        /// Seealso: https://postmarkapp.com/support/article/1125-custom-metadata-faq
        let MetaData: Dictionary<String, String>?
        
        /// An array of headers
        let Headers: [EmailHeader]?
        
        /// Per-email setting for track opens
        ///
        /// Seealso: https://postmarkapp.com/developer/user-guide/tracking-opens/tracking-opens-per-email
        let TrackOpens: Bool?
        
        /// Any tracked link that the user clicks on will record statistics, regardless of whether it was clicked from the HTML or Text parts of the email.
        ///
        /// Defaults to `.none` which means tracking is off.
        let TrackLinks: TrackLinksSetting?
    }
}
