//
//  UTChatRoom.swift
//  Untind
//
//  Created by Mihai Honceriu on 21/01/2020.
//  Copyright © 2020 FincPicsels. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol ChatRoomDelegate : NSObject {
    func utChatRoom(room : UTChatRoom, newMessageArrived: UTMessage)
    func utChatRoom(room : UTChatRoom, messageEdited: UTMessage)
    func utChatRoom(room : UTChatRoom, messageDeleted: UTMessage)
}

extension ChatRoomDelegate {
    func utChatRoom(room : UTChatRoom, messageEdited: UTMessage) {
        
    }
    
    func utChatRoom(room : UTChatRoom, messageDeleted: UTMessage) {
        
    }
}

class UTChatRoom : NSObject {
    var id : String?
    var messages : [UTMessage] = []
    var participants : [Profile] = []
    var startDate : Date = Date()
    var isOpen : Bool = false
    var lastMessageSnapshot : DocumentSnapshot?
    weak var delegate : ChatRoomDelegate?
    var didInitialLoad : Bool = false
    var messagesListener : ListenerRegistration?
    
    convenience init(with document: DocumentSnapshot) {
           self.init(with: document.data()!)
           id = document.documentID
       }
    
    init(with json:JSONDictionary) {
        messages = []
        let participantsJsonArray = json["participants"] as! [[String : Any]]
        
        for participant in participantsJsonArray {
            let participant = Profile(with: participant)
            self.participants.append(participant)
        }
        
        startDate = (json["startDate"] as! Timestamp).dateValue()
        isOpen = json["isOpen"] as! Bool
    }
    
    override init() {
        super.init()
    }
    
    static func fetch(forDate date: UTDate, completion: @escaping (Error?, UTChatRoom?) -> Void) {
        if let invitee = date.invitee, let invited = date.invited {
            let db = Firestore.firestore()
            let document = db.collection("chats").document(invited.uid.combineUniquelyWith(string: invitee.uid))
            
            document.getDocument { (snapshot, error) in
                if let error = error {
                    completion(error,nil)
                } else {
                    if let snapshot = snapshot, snapshot.data() != nil {
                        completion(nil, UTChatRoom(with: snapshot))
                    } else {
                        let newRoom = UTChatRoom()
                        newRoom.participants.append(invitee)
                        newRoom.participants.append(invited)
                        newRoom.isOpen = true
                        newRoom.id = invitee.uid.combineUniquelyWith(string: invited.uid)
                        
                        document.setData(newRoom.jsonValue()) {
                            (error) in
                            if error != nil {
                                completion(error,nil)
                            } else {
                                completion(nil, newRoom)
                            }
                        }
                    }
                }
            }
        } else {
            completion(GenericError("Date only has one user"), nil)
        }
    }
    
    func loadMoreMessages(numberOfMessages: Int, completion: @escaping (Error?, Bool) -> Void) {
        if let lastSnapshot = self.lastMessageSnapshot {
            let db = Firestore.firestore()
           let messagesRef = db.collection("chats").document(id!).collection("messages").order(by: "postDate").start(afterDocument: lastSnapshot).limit(to: numberOfMessages)
            
            messagesRef.getDocuments { (snapshot, error) in
                if let error = error {
                    completion(error, false)
                } else {
                    if let lastSnapshot = snapshot?.documents.last {
                        self.lastMessageSnapshot = lastSnapshot
                    }
                    
                    var newArray : [UTMessage] = []
                    for document in snapshot?.documents ?? [] {
                        let message = UTMessage(with: document)
                        newArray.append(message)
                    }
                    
                    self.messages = newArray + self.messages
                    completion(nil, true)
                }
            }
        }
    }
    
    func stopLoadingMessages() {
        self.messagesListener?.remove()
    }
    
    func startLoadingMessages(numberOfMessages: Int, delegate: ChatRoomDelegate, completion: @escaping (Error?, Bool) -> Void) {
        let db = Firestore.firestore()
        let messagesRef = db.collection("chats").document(id!).collection("messages").order(by: "postDate", descending: true).limit(to: numberOfMessages)
        self.delegate = delegate
        
        self.messagesListener = messagesRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(error, false)
            } else {
                func loop() {
                    snapshot?.documentChanges.reversed().forEach({ (diff) in
                        if diff.type == .added {
                            if self.didInitialLoad {
                                let message = UTMessage(with: diff.document)
                                if !self.messages.contains(where: { (arrayMessage) -> Bool in
                                    return arrayMessage.id == message.id
                                }) {
                                    print("New message arrived!!")
                                    self.messages.append(message)
                                    self.delegate?.utChatRoom(room: self, newMessageArrived: message)
                                }
                            } else {
                                  let message = UTMessage(with: diff.document)
                                  self.messages.append(message)
                            }
                        }
                        
                        if diff.type == .modified {
                            
                        }
                        
                        if diff.type == .removed {
                            
                       }
                    })
                }
                
                loop()
                if self.didInitialLoad == false {
                    self.didInitialLoad = true
                    self.lastMessageSnapshot = snapshot?.documents.first
                    completion(nil, true)
                }
            }
        }
        
    }
    
    func addMessage(_ message: UTMessage, completion: @escaping (Error?, Bool) -> Void) {
        let db = Firestore.firestore()
        let messages = db.collection("chats").document(id!).collection("messages").addDocument(data: message.jsonValue()) { (error) in
            if error != nil {
                completion(error,false)
            } else {
                completion(nil, true)
            }
        }
    }
    
    func jsonValue() -> [String : Any] {
        var participantsArray : [JSONDictionary] = []
        
        for participant in participants {
            participantsArray.append(participant.jsonValue())
        }
        
        let json = [
            "startDate" : startDate,
            "isOpen" : isOpen,
            "participants" : participantsArray] as [String : Any]
        
        return json
    }
}
