//
//  ChatMessageTextViewModel.swift
//  Rocket.Chat
//
//  Created by Rafael Machado on 01/04/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import UIKit
import RealmSwift

protocol ChatMessageTextViewModelProtocol {
    var color: UIColor { get }
    var title: String { get }
    var text: String { get }
    var thumbURL: URL? { get }
    var collapsed: Bool { get }
    var attachment: Attachment { get }
    func toggleCollapse()
}

final class ChatMessageTextViewModel: ChatMessageTextViewModelProtocol {
    var color: UIColor {
        if let color = attachment.color {
            return UIColor.normalizeColorFromString(string: color)
        }

        return .lightGray
    }

    var title: String {
        return "\(collapsed ? "▶" : "▼") \(attachment.title)"
    }

    var text: String {
        if attachment.titleLinkDownload && attachment.titleLink.count > 0 {
            return localized("chat.message.open_file")
        }

        return attachment.text ?? ""
    }

    var thumbURL: URL? {
        return URL(string: attachment.thumbURL ?? "")
    }

    var collapsed: Bool {
        return attachment.collapsed
    }

    let attachment: Attachment

    init(withAttachment attachment: Attachment) {
        self.attachment = attachment
    }

    func toggleCollapse() {
        Realm.executeOnMainThread({ _ in
            self.attachment.collapsed = !self.attachment.collapsed
        })
    }
}

final class ChatMessageAttachmentFieldViewModel: ChatMessageTextViewModelProtocol {
    var color: UIColor {
        return  attachment.color != nil
            ? UIColor(hex: attachment.color)
            : UIColor.lightGray
    }

    var title: String {
        return attachmentField.title
    }

    var text: String {
        return attachmentField.value
    }

    var thumbURL: URL? {
        return nil
    }

    var collapsed: Bool {
        return attachment.collapsed
    }

    let attachment: Attachment
    let attachmentField: AttachmentField

    init(withAttachment attachment: Attachment, andAttachmentField attachmentField: AttachmentField) {
        self.attachment = attachment
        self.attachmentField = attachmentField
    }

    func toggleCollapse() {
        Realm.executeOnMainThread({ _ in
            self.attachment.collapsed = !self.attachment.collapsed
        })
    }
}
