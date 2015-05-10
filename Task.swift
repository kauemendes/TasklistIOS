//
//  Task.swift
//  Tasklist
//
//  Created by Kaue Mendes on 4/14/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//

import Foundation
import CoreData

class Task: NSManagedObject {

    @NSManaged var nome: String
    @NSManaged var status: Status

}
