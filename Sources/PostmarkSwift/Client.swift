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
                
        // MARK: - Properties
        
        /// The server token
        let serverToken: String
        
        // MARK: - Methods
        
        /// Create a new `Client`
        ///
        /// - Parameter serverToken: The server token to user for the client.
        init(serverToken: String) {
            self.serverToken = serverToken
        }
        
        /// Sends a simple email
        ///
        /// - Parameters:
        ///  - from: The sender signature.
        ///  - to: The recipient's email address.
        ///  - subject: The email's subject.
        ///  - body: The email's body text.
        ///
        /// - Returns: Returns the result of the send operation.
        func send(from: String, to: String, subject: String, body: String) {
            
            fatalError("Not yet implemented!")
            
        }
        
    }
    
}
