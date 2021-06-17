//
//  Department+Convenience.swift
//  RandomArt
//
//  Created by Cora Jacobson on 6/17/21.
//

import Foundation
import CoreData

extension Department {
    @discardableResult convenience init(departmentId: Int,
                                        displayName: String,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.departmentId = Int16(departmentId)
        self.displayName = displayName
    }
    
    @discardableResult convenience init(departmentRep: DepartmentRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(departmentId: departmentRep.departmentId,
                  displayName: departmentRep.displayName,
                  context: context)
    }
}
