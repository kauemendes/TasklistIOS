//
//  Status.swift
//  Tasklist
//
//  Created by Kaue Mendes on 4/14/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//

import Foundation
import CoreData

class Status: NSManagedObject {

    @NSManaged var tipo: String
    @NSManaged var tasks: Task

}
