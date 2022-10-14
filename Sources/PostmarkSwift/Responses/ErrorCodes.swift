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

public extension PostmarkSwift.Client {

    /// Possible error codes returned by the Postmark API
    ///
    /// See API [documentation](https://postmarkapp.com/developer/api/overview#error-codes)
    enum ErrorCode: Int, Decodable {
        
        /// No error
        case ok = 0
 
        /// Bad or missing API token Your request did not contain the correct API token in the header. Refer to the request’s API reference page to see which API token is required or learn more about authenticating with Postmark.
        case badOrMissingToken = 10

        /// Maintenance The Postmark API is offline for maintenance.
        case apiMaintenance = 100

        /// Invalid email request Validation failed for the email request JSON data that you provided.
        case invalidEmailRequest = 300

        /// Sender Signature not found You’re trying to send email with a From address that doesn’t have a sender signature. Refer to your existing list of Sender Signatures or add a new one.
        case senderSignatureNotFound = 400

        /// Sender signature not confirmed You’re trying to send email with a From address that doesn’t have a confirmed sender signature. You can resend the confirmation email on the Sender Signatures page.
        case senderSignatureNotConfirmed = 401

        /// Invalid JSON The JSON data you provided is syntactically incorrect. We recommend running your JSON through a validator before issuing another request.
        case invalidJSON = 402

        /// Incompatible JSON The JSON data you provided is syntactically correct, but still doesn’t contain the fields we expect. Refer to the request's API reference page to see a list of required JSON body parameters.
        case incompatibleJSON = 403

        /// Not allowed to send Your account has run out of credits. You can purchase more on the Credits page.
        case outOfCredits = 405

        /// Inactive recipient You tried to send email to a recipient that has been marked as inactive. Inactive recipients have either generated a hard bounce or a spam complaint. In this case, only hard bounce recipients can be reactivated by searching for them on your server’s Activity page and clicking the “Reactivate” button.
        case inactiveRecipient = 406

        /// JSON required Your HTTP request doesn’t have the Accept and Content-Type headers set to application/json.
        case contentTypeHeaderMissing = 409

        /// Too many batch messages Your batched request contains more than 500 messages.
        case tooManyBatchMessages = 410

        /// Forbidden attachment type The file type of the attachment isn’t allowed. Refer to our list on forbidden file types.
        case forbiddenAttachmentType = 411

        /// Account is Pending The account that is associated with the send request is still pending approval. While an account is pending approval, email recipients must have the same domain as the one found in the email's from address.
        case accountPendingApproval = 412

        /// Account May Not Send The account that is associated with the send request is not approved for sending.
        case accountMayNotSend = 413

        /// Rate Limit Exceeded We have detected an excessive volume of requests originating from your application, please reduce the concurrency and request rate of your requests. If your app requires a rate limit increase, please contact support to request it.
        case accountRateLimitExceeded = 429

        /// Sender signature query exception You provided invalid querystring parameters in your request. Refer to the Sender Signatures API reference for a list of accepted querystring parameters.
        case invalidSenderSignature = 500

        /// Sender Signature not found by id We couldn’t locate the Sender Signature you’re trying to manage from the id passed in.
        case senderSignatureNotFoundById = 501

        /// No updated Sender Signature data received You didn’t pass in any valid updated Sender Signature data.
        case noUpdatedSenderSignature = 502

        /// You cannot use a public domain You tried to create a Sender Signature with a public domain which isn’t allowed.
        case noPublicDomainAllowedForSenderSignature = 503

        /// Sender Signature already exists You tried to create a Sender Signature that already exists on Postmark.
        case senderSignatureExists = 504

        /// DKIM already scheduled for renewal The DKIM you tried to renew is already scheduled to be renewed.
        case dkimAlreadyScheduledForRenewal = 505

        /// This Sender Signature already confirmed The signature you tried to resend a confirmation to has already been confirmed by a user.
        case senderSignatureAlreadyConfirmed = 506

        /// You do not own this Sender Signature This Sender Signature cannot be found using your credentials.
        case senderSignatureNotOwnedByYou = 507

        /// This domain was not found We couldn’t locate the Domain you’re trying to manage from the id passed in.
        case domainNotFound = 510

        /// Invalid fields supplied You didn’t pass in any valid Domain data.
        case invalidDomainData = 511

        /// Domain already exists You tried to create a Domain that already exists on your account.
        case domainAlreadyExists = 512

        /// You do not own this Domain This Domain cannot be found using your credentials.
        case domainNotOwnedByYou = 513

        /// Name is a required field to create a Domain You must set the Name parameter to create a Domain.
        case nameRequiredForDomain = 514

        /// Name field must be less than or equal to 255 characters The Name you have specified for this Domain is too long.
        case nameTooLongForDomain = 515

        /// Name format is invalid The Name you have specified for this Domain is formatted incorrectly.
        case nameFormatInvalidForDomain = 516

        /// You are missing a required field to create a Sender Signature. When creating a Sender Signature, you must supply a value for Name and FromEmail.
        case missingRequiredFieldForSenderSignature = 520

        /// A field in the Sender Signature request is too long. View the Message property of the response for details. ConfirmationPersonalNote has a max length of 400 characters.
        case fieldTooLongForSenderSignatureRequest = 521

        /// Value for field is invalid. Value might be an invalid email address or domain. View the Message property of the response for details. ConfirmationPersonalNote must contain at least one non-whitespace character.
        case valueFieldIsInvalid = 522

        /// Server query exception You provided invalid querystring parameters in your request. Refer to the Servers API reference for a list of accepted querystring parameters.
        case serverQueryException = 600

        /// Server does not exist You tried to manage a server that doesn’t exist with your credentials.
        case serverDoesNotExist = 601

        /// Duplicate Inbound Domain The Inbound Domain you specified is already in use on Postmark.
        case duplicateInboundDomain = 602

        /// Server name already exists You tried to create a Server name that already exists in your list.
        case serverNameAlreadyExists = 603

        /// You don’t have delete access You don’t have permission to delete Servers through the API. Please contact support if you wish to have this functionality.
        case noDeleteServerAccess = 604

        /// Unable to delete Server We couldn’t delete this Server. Please contact support.
        case unableToDeleteServer = 605

        /// Invalid webhook URL The webhook URL you’re trying to use is invalid or contains an internal IP range.
        case invalidWebhookUrl = 606

        /// Invalid Server color The server color you specified isn't supported. Please choose either Purple, Blue, Turqoise, Green, Red, Orange, Yellow, or Grey for server color.
        case invalidServerColor = 607

        /// Server name missing or invalid The Server name you provided is invalid or missing.
        case serverNameMissingOrInvalid = 608

        /// No updated Server data received You didn’t pass in any valid updated Server data.
        case noUpdatedServerDataReceived = 609

        /// Invalid MX record for Inbound Domain The Inbound Domain provided doesn’t have an MX record value of inbound.postmarkapp.com.
        case invalidMxRecordForInboundDomain = 610

        /// InboundSpamThreshold value is invalid. Please use a number between 0 and 30 in increments of 5.
        case inboundSpamThresholdValueIsInvalid = 611

        /// Messages query exception You provided invalid querystring parameters in your request. Refer to the Messages API reference for a list of accepted querystring parameters.
        case messagesQueryException = 700

        /// Message doesn’t exist This message doesn’t exist.
        case messageDoesntExist = 701

        /// Could not bypass this blocked inbound message, please contact support. There was a problem processing this bypass request. Please contact support to fix the issue.
        case couldNotBypassBlockedInboundMessage = 702

        /// Could not retry this failed inbound message, please contact support. There was a problem processing this retry request. Please contact support to fix the issue.
        case couldNotRetryFailedInboundMessage = 703

        /// Trigger query exception You provided invalid querystring parameters in your request.
        case triggerQueryException = 800

        /// No trigger data received You didn’t provide JSON body parameters in your request.
        case noTriggerDataReceived = 809

        /// This inbound rule already exists. You tried to add a rule that already exists for the server. Please choose a unique rule to add.
        case inboundRuleAlreadyExists = 810

        /// Unable to remove this inbound rule, please contact support. We weren't able to remove this rule from your server. Please contact support to resolve the issue.
        case unableToRemoveInboundRule = 811

        /// This inbound rule was not found. The inbound rule you are trying to administer does not exist for this server.
        case inboundRuleNotFound = 812

        /// Not a valid email address or domain. Please use a valid email address or valid domain to setup an inbound domain rule.
        case invalidEmailOrDomain = 813

        /// Stats query exception You provided invalid querystring parameters in your request. Refer to the Stats API reference for a list of accepted querystring parameters.
        case statsQueryException = 900

        /// Bounces query exception You provided invalid querystring parameters in your request. Refer to the Bounces API reference for a list of accepted querystring parameters.
        case bouncesQueryException = 1000

        /// Bounce was not found. The BounceID or MessageID you are searching with is invalid.
        case bounceNotFound = 1001

        /// BounceID parameter required. You must supply a BounceID to get the bounce dump.
        case bounceIdParameterRequired = 1002

        /// Cannot activate bounce. Certain bounces and SPAM complaints cannot be activated by the user.
        case cannotActivateBounce = 1003

        /// Template query exception. The value of a GET parameter for the request is not valid.
        case templateQueryException = 1100

        /// Template not found. The TemplateId,  LayoutTemplate, or Alias references a Template that does not exist, or is not associated with the Server specified for this request.
        case templateNotFound = 1101

        /// Template limit would be exceeded. A Server may have up to 100 templates, processing this request would exceed this limit. Please contact support if you need more Templates within a Server.
        case templateLimitWouldBeExceeded = 1105

        /// No Template data received. You didn’t provide JSON body parameters in your request. Refer to the Template API reference for more details on required parameters.
        case noTemplateDataReceived = 1109

        /// A required Template field is missing. A required field is missing from the body of the POST request.
        case requiredTemplateFieldMissing = 1120

        /// Template field is too large. One of the values of the request's body exceeds our size restrictions for that field.
        case templateFieldTooLarge = 1121

        /// A Templated field has been submitted that is invalid. One of the fields of the request body is invalid.
        case templateFieldInvalid = 1122

        /// A field was included in the request body that is not allowed. A field is included in the request that will be ignored, or is not applicable to the endpoint to which it has been sent.
        case templateFieldNotAllowed = 1123

        /// The template types don't match on the source and destination servers. The template alias is a layout on one server and a standard template on the other. The templates cannot share the same alias.
        case templateTypesMismatch = 1125
        
        /// The layout template cannot be deleted because it has dependent templates using it. A layout cannot be deleted when there are associated templates using the layout.
        case layoutTmeplateCannotBeDeleted = 1130
        
        /// The layout content placeholder must be present in the layout HTML and/or Text body exactly once. A single content placeholder is required for every layout. The content placeholder cannot be present in a standard template.
        case layoutContentPlaceholderMustBePresentOnce = 1131
        
        /// The 'MessageStreamType' associated with this request was invalid. Please make sure to interact with a Message Stream that supports the function you're trying (For example, not trying to send an email through an Inbound Stream).
        case messageStreamTypeInvalid = 1221
        
        /// A valid 'ID' must be provided. Postmark was unable to find a Message Stream with the provided Message Stream ID that was used with the API Token
        case idMustBeProvded = 1222
        
        /// A valid 'Name' must be provided. A Stream name cannot be null or whitespace.
        case nameMustBeProvided = 1223
        
        /// The 'Name' is too long, it is limited to 100 characters. Please create a shorter name.
        case nameTooLong = 1224
        
        /// You have reached the maximum number of message streams for this server. A stream can have up to 10 Message Streams. Please contact support if you need more Message Streams.
        case maxNumberOfMessageStreams = 1225
        
        /// The message stream for the provided 'ID' was not found. Postmark was unable to find a Message Stream with the provided Message Stream ID that was used with the API Token.
        case messageStreamNotFound = 1226
        
        /// The 'ID' must be a non-empty string starting with a letter of the English alphabet. It is limited to lowercase letters of the English alphabet, numbers, and '-', '_' characters. It is limited to a length of 30 characters.
        case idMustBeNonEmptyStringStartingWithEnglishLetter = 1227
        
        /// A server can only have one inbound stream. If more Inbound Streams are needed, please create a new Server.
        case serverCanOnlyHaveOneInboundStream = 1228
        
        /// You cannot archive the default transactional and inbound streams. The default Transaction and Inbound streams cannot be deleted.
        case cannotArchiveDefaultTransactionalAndInboundStreams = 1229
        
        /// The 'ID' provided already exists for this server. ID's must be unique.
        case idAlreadyExists = 1230
        
        /// The 'Description' is too long, it is limited to 1000 characters. Please create a shorter description.
        case descriptionTooLong = 1231
        
        /// You cannot unarchive this message stream anymore. The Message Stream is either deleted is no longer archived.
        case cannotUnarchiveMessage = 1232
        
        /// The 'ID' must not start with the 'pm-' prefix. It is not possible to create Message Streams that start with 'pm-'.
        case idMustNotStartWithPmPrefix = 1233
        
        /// The 'Description' must not contain HTML tags. The characters '<' and '>' are not allowed.
        case descriptionMustNotContainHtml = 1234
        
        /// The 'MessageStream' provided does not exist on this server. Postmark was unable to find a Message Stream with the provided Message Stream that was used with the API Token.
        case messageStreamDoesNotExist = 1235
        
        /// Sending is not supported on the supplied 'MessageStream'. Sending is not possible with Inbound Message Streams.
        case sendingNotSupportedForThisMessageStream = 1236
        
        /// This 'ID' is reserved. The ID all is reserved, please use a different ID.
        case idReserved = 1237
        
        /// An unexpected or unknown error code
        ///
        /// The error code received was not recognized by `PostmarkSwift`. Likely it needs to be added.
        case unknown = -1
    }

}
