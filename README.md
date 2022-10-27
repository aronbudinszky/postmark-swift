# PostmarkSwift

A Swift package that connects to the Postmark API to reliably send emails.

## WARNING! This package is work in progress

Although a basic email can be sent at this point, a lot of functionality is still being developed. APIs might change.

## Add the package

This is a SwiftPM package - add it in your `Package.swift` file or via Xcode as you would any other package (will add more docs on this later :)).

## Send your first message

Since PostmarkSwift uses the new async/await API, it will require at least iOS 13 or macOS 12.

```
// Create client and send
let client = PostmarkSwift.Client(serverToken: "your-server-token")
        
// Create an email message
let message = PostmarkSwift.OutgoingEmail(
    from: "you@yourcompany.com",
    to: "user@example.com",
    subject: "Hello",
    textBody: "World!"
)
        
// Send it and report the results
let result = try await client.send(message)
print("Message was submitted for sending at \(result.submittedAt) to recipient(s) \(result.to) with ID \(result.messageID)")
```

If there are any problems with your request the appropriate error will be thrown when you try to send.

## Send an HTML message

You can also send HTML messages, like so:
```
// Create an email message
let message = PostmarkSwift.OutgoingEmail(
    from: "you@yourcompany.com",
    to: "user@example.com",
    subject: "Hello",
    textBody: "World!",
    htmlBody: "<strong>World!</strong>"
)
```
