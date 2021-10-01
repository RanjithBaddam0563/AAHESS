//
//  BaseModel.swift
//  Alain
//
//  Created by MicroExcel on 7/9/20.
//  Copyright © 2020 Microexcel. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SalarySlipModel {
    var salarySlipId = Int()
    var year : String = ""
    var month = Int()
    
    init() {
        
    }
    init(json : JSON){
        salarySlipId = json["salarySlipId"].intValue
        month = json["month"].intValue
        year = json["year"].stringValue
        
    }
}
struct LeaveTypeModel {
    var leaveTypeId = Int()
    var name : String = ""

    init() {
        
    }
    init(json : JSON){
        leaveTypeId = json["leaveTypeId"].intValue
        name = json["name"].stringValue
        
    }
}
struct DepartmentTypeModel {
    var departmentId = Int()
    var name : String = ""

    init() {
        
    }
    init(json : JSON){
        departmentId = json["departmentId"].intValue
        name = json["name"].stringValue
        
    }
}
//struct BudgetActualBalanceModel {
//    var trainingBudgetId = Int()
//    var departmentId = Int()
//    var budgetAmount = Int()
//    var availedAmount = Int()
//    var balanceAmount = Int()
//    var amountOnHold = Int()
//
//    init() {
//        
//    }
//    init(json : JSON){
//        trainingBudgetId = json["trainingBudgetId"].intValue
//        departmentId = json["departmentId"].intValue
//        budgetAmount = json["budgetAmount"].intValue
//        availedAmount = json["availedAmount"].intValue
//        balanceAmount = json["balanceAmount"].intValue
//        amountOnHold = json["amountOnHold"].intValue
//
//    }
//}
struct categoryDetailsModel {
    var itSupportCategoriesId = Int()
    var name : String = ""

    init() {
        
    }
    init(json : JSON){
        itSupportCategoriesId = json["itSupportCategoriesId"].intValue
        name = json["name"].stringValue
        
    }
}
struct subcategoryDetailsModel {
    var itSupportSubCategoriesId = Int()
    var name : String = ""

    init() {
        
    }
    init(json : JSON){
        itSupportSubCategoriesId = json["itSupportSubCategoriesId"].intValue
        name = json["name"].stringValue
        
    }
}
struct serviceTypeModel {
    var itSupportServiceTypesId = Int()
    var name : String = ""

    init() {
        
    }
    init(json : JSON){
        itSupportServiceTypesId = json["itSupportServiceTypesId"].intValue
        name = json["name"].stringValue
        
    }
}
struct PriorityTypeModel {
    var itSupportPriorityId = Int()
    var name : String = ""
    var slaHours = Int()

    init() {
        
    }
    init(json : JSON){
        itSupportPriorityId = json["itSupportPriorityId"].intValue
        name = json["name"].stringValue
        slaHours = json["slaHours"].intValue
    }
}
struct DMSDepModel {
    var dmsCategoryId = Int()
    var name : String = ""

    init() {
        
    }
    init(json : JSON){
        dmsCategoryId = json["dmsCategoryId"].intValue
        name = json["name"].stringValue
        
    }
}
struct DMSDepProcessModel {
    var dmsSubCategoryId = Int()
    var name : String = ""
    var dmsCategoryId = Int()
    var dmsCategory : String = ""

    init() {
        
    }
    init(json : JSON){
        dmsSubCategoryId = json["dmsSubCategoryId"].intValue
        name = json["name"].stringValue
        dmsCategoryId = json["dmsCategoryId"].intValue
        dmsCategory = json["dmsCategory"].stringValue
        
    }
}
struct DMSDepApprovalModel {
    var dmsApprovalId = Int()
    var dmsSubCategoryId = Int()
    var approverId = Int()
    var approvalLevel = Int()


    init() {
        
    }
    init(json : JSON){
        dmsApprovalId = json["dmsApprovalId"].intValue
        dmsSubCategoryId = json["dmsSubCategoryId"].intValue
        approverId = json["approverId"].intValue
        approvalLevel = json["approvalLevel"].intValue

    }
}
struct ReimbursmenParticularsModel {
    var reimbursmentTypeId = Int()
    var name : String = ""

    init() {
        
    }
    init(json : JSON){
        reimbursmentTypeId = json["reimbursmentTypeId"].intValue
        name = json["name"].stringValue
        
    }
}
struct AllowanceTypesModel {
    var allowanceTypeId = Int()
    var name : String = ""

    init() {
        
    }
    init(json : JSON){
        allowanceTypeId = json["allowanceTypeId"].intValue
        name = json["name"].stringValue
        
    }
}
struct formalitiesReqModel {
    var formalityTypeId = Int()
    var name : String = ""

    init() {
        
    }
    init(json : JSON){
        formalityTypeId = json["formalityTypeId"].intValue
        name = json["name"].stringValue
        
    }
}
struct employeeDocumentModel {
    var name : String = ""
    var expiresOn : String = ""
    var employee : String = ""
    var employeeDocumentsId = Int()
    var employeeId : String = ""
    var associatedFile : String = ""

    init() {
        
    }
    init(json : JSON){
        name = json["name"].stringValue
        expiresOn = json["expiresOn"].stringValue
        employee = json["employee"].stringValue
        employeeDocumentsId = json["employeeDocumentsId"].intValue
        employeeId = json["employeeId"].stringValue
        associatedFile = json["associatedFile"].stringValue

    }
}
    struct LeavesListModel {
    var id = Int()
    var leaveType : String = ""
    var fromDate : String = ""
    var toDate : String = ""
    var status : String = ""
    var expanded = Bool()
    var requesterName : String = ""

    init() {
        
    }
    init(json : JSON){
        id = json["id"].intValue
        leaveType = json["leaveType"].stringValue
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        status = json["status"].stringValue
        expanded = json["expanded"].boolValue
        requesterName = json["requesterName"].stringValue


    }
    
}
struct AllowanceListModel {
    var id = Int()
    var leaveType : String = ""
    var fromDate : String = ""
    var toDate : String = ""
    var status : String = ""
    var expanded = Bool()
    var requesterName : String = ""
   

    

    init() {
        
    }
    init(json : JSON){
        id = json["id"].intValue
        leaveType = json["leaveType"].stringValue
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        status = json["status"].stringValue
        expanded = json["expanded"].boolValue
        requesterName = json["hotelBooking"].stringValue
        

    }
    
}
struct ReimbursmentListModel {
    var id = Int()
    var leaveType : String = ""
    var fromDate : String = ""
    var toDate : String = ""
    var status : String = ""
    var expanded = Bool()
    var requesterName : String = ""
   

    

    init() {
        
    }
    init(json : JSON){
        id = json["id"].intValue
        leaveType = json["leaveType"].stringValue
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        status = json["status"].stringValue
        expanded = json["expanded"].boolValue
        requesterName = json["hotelBooking"].stringValue
        

    }
    
}
struct FormalityListModel {
    var id = Int()
    var leaveType : String = ""
    var status : String = ""

    init() {
        
    }
    init(json : JSON){
        id = json["id"].intValue
        leaveType = json["leaveType"].stringValue
        status = json["status"].stringValue
    }
    
}
struct TrainingListModel {
    var id = Int()
    var leaveType : String = ""
    var status : String = ""

    init() {
        
    }
    init(json : JSON){
        id = json["id"].intValue
        leaveType = json["leaveType"].stringValue
        status = json["status"].stringValue
    }
    
}

struct ItSupportListModel {
    var dmsApplicationId = Int()
    var leaveType : String = ""
    var status : String = ""

    init() {
        
    }
    init(json : JSON){
        dmsApplicationId = json["dmsApplicationId"].intValue
        leaveType = json["leaveType"].stringValue
        status = json["status"].stringValue
    }
    
}


struct NotificationListModel {
    var name : String = ""
    var approvalUrl : String = ""
    var employeeName : String = ""

    init() {
        
    }
    init(json : JSON){
        name = json["name"].stringValue
        approvalUrl = json["approvalUrl"].stringValue
        employeeName = json["employeeName"].stringValue
    }
    
}
struct MyDMSListModel {
    var dmsApplicationId = Int()
    var leaveType : String = ""
    var fromDate : String = ""
    var toDate : String = ""
    var status : String = ""
    var expanded = Bool()
    var requesterName : String = ""
   

    

    init() {
        
    }
    init(json : JSON){
        dmsApplicationId = json["dmsApplicationId"].intValue
        leaveType = json["leaveType"].stringValue
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        status = json["status"].stringValue
        expanded = json["expanded"].boolValue
        requesterName = json["hotelBooking"].stringValue
        

    }
    
}

struct MyDMSApprovalHistoryModel {
    var dmsApplicationTaskId = Int()
    var name : String = ""
    var dmsApplicationId = Int()
    var dmsApplication : String = ""
    var approvalLevel = Int()
    var approverId = Int()
    var outcome : String = ""
    var comment : String = ""
    var isCompleted = Bool()
    var created : String = ""
    var completed : String = ""
    
    init() {
        
    }
    init(json : JSON){
        dmsApplicationTaskId = json["dmsApplicationTaskId"].intValue
        name = json["name"].stringValue
        dmsApplicationId = json["dmsApplicationId"].intValue
        dmsApplication = json["dmsApplication"].stringValue
        approvalLevel = json["approvalLevel"].intValue
        approverId = json["approverId"].intValue
        outcome = json["outcome"].stringValue
        comment = json["comment"].stringValue
        isCompleted = json["isCompleted"].boolValue
        created = json["created"].stringValue
        completed = json["completed"].stringValue

    }
    
}
struct ReimbursmentViewListModel {
    var dmsApplicationTaskId = Int()
    var name : String = ""
    var dmsApplicationId = Int()
    var dmsApplication : String = ""
    var approvalLevel = Int()
    var approverId = Int()
    var outcome : String = ""
    var comment : String = ""
    var isCompleted = Bool()
    var created : String = ""
    var completed : String = ""
    
    init() {
        
    }
    init(json : JSON){
        dmsApplicationTaskId = json["dmsApplicationTaskId"].intValue
        name = json["name"].stringValue
        dmsApplicationId = json["dmsApplicationId"].intValue
        dmsApplication = json["dmsApplication"].stringValue
        approvalLevel = json["approvalLevel"].intValue
        approverId = json["approverId"].intValue
        outcome = json["outcome"].stringValue
        comment = json["comment"].stringValue
        isCompleted = json["isCompleted"].boolValue
        created = json["created"].stringValue
        completed = json["completed"].stringValue

    }
    
}
struct formalityViewListModel {
    var dmsApplicationTaskId = Int()
    var name : String = ""
    var dmsApplicationId = Int()
    var dmsApplication : String = ""
    var approvalLevel = Int()
    var approverId = Int()
    var outcome : String = ""
    var comment : String = ""
    var isCompleted = Bool()
    var created : String = ""
    var completed : String = ""
    
    init() {
        
    }
    init(json : JSON){
        dmsApplicationTaskId = json["dmsApplicationTaskId"].intValue
        name = json["name"].stringValue
        dmsApplicationId = json["dmsApplicationId"].intValue
        dmsApplication = json["dmsApplication"].stringValue
        approvalLevel = json["approvalLevel"].intValue
        approverId = json["approverId"].intValue
        outcome = json["outcome"].stringValue
        comment = json["comment"].stringValue
        isCompleted = json["isCompleted"].boolValue
        created = json["created"].stringValue
        completed = json["completed"].stringValue

    }
    
}
struct TrainingViewApprovalModel {
    var trainingTaskId = Int()
    var name : String = ""
    var trainingApplicationsId = Int()
    var trainingApplications : String = ""
    var approvalLevel = Int()
    var approverId = Int()
    var outcome : String = ""
    var comment : String = ""
    var isCompleted = Bool()
    var created : String = ""
    var completed : String = ""
    
    init() {
        
    }
    init(json : JSON){
        trainingTaskId = json["trainingTaskId"].intValue
        name = json["name"].stringValue
        trainingApplicationsId = json["trainingApplicationsId"].intValue
        trainingApplications = json["trainingApplications"].stringValue
        approvalLevel = json["approvalLevel"].intValue
        approverId = json["approverId"].intValue
        outcome = json["outcome"].stringValue
        comment = json["comment"].stringValue
        isCompleted = json["isCompleted"].boolValue
        created = json["created"].stringValue
        completed = json["completed"].stringValue

    }
    
}

struct ITSupportViewApprovalModel {
    var itSupportTaskId = Int()
    var name : String = ""
    var itSupportApplicationId = Int()
    var itSupportApplication : String = ""
    var approvalLevel = Int()
    var approverId = Int()
    var outcome : String = ""
    var comment : String = ""
    var isCompleted = Bool()
    var created : String = ""
    var completed : String = ""
    
    init() {
        
    }
    init(json : JSON){
        itSupportTaskId = json["itSupportTaskId"].intValue
        name = json["name"].stringValue
        itSupportApplicationId = json["itSupportApplicationId"].intValue
        itSupportApplication = json["itSupportApplication"].stringValue
        approvalLevel = json["approvalLevel"].intValue
        approverId = json["approverId"].intValue
        outcome = json["outcome"].stringValue
        comment = json["comment"].stringValue
        isCompleted = json["isCompleted"].boolValue
        created = json["created"].stringValue
        completed = json["completed"].stringValue

    }
    
}

struct ITSupportViewListModel {
    var itSupportApplicationsId = Int()
    var title : String = ""
    var description = Int()
    var resolution : String = ""
    var storeInKB = Bool()
    var status : String = ""
    var refNum : String = ""
    var applicationDate : String = ""
    var slaDate : String = ""
    var warningLevel : String = ""
    var itSupportCategoryId = Int()
    var itSupportSubCategoryId = Int()
    var itSupportServiceTypeId = Int()
    var priorityId = Int()
    var priority : String = ""

    init() {
        
    }
    init(json : JSON){
        itSupportApplicationsId = json["itSupportApplicationsId"].intValue
        title = json["title"].stringValue
        description = json["description"].intValue
        resolution = json["resolution"].stringValue
        storeInKB = json["storeInKB"].boolValue
        status = json["status"].stringValue
        refNum = json["refNum"].stringValue
        applicationDate = json["applicationDate"].stringValue
        slaDate = json["slaDate"].stringValue
        warningLevel = json["warningLevel"].stringValue
        itSupportCategoryId = json["itSupportCategoryId"].intValue
        itSupportSubCategoryId = json["itSupportSubCategoryId"].intValue
        itSupportServiceTypeId = json["itSupportServiceTypeId"].intValue
        priorityId = json["priorityId"].intValue
        priority = json["priority"].stringValue


    }
    
}

struct TrainingViewListModel {
    var trainingApplicationId = Int()
    var trainingName : String = ""
    var conductedBy : String = ""
    var venue : String = ""
    var numberOfDays = Int()
    var trainingFees = Int()
    var otherExpenses = Int()
    var totalFees = Int()
    var departmentId = Int()
    var department : String = ""
    var remarks : String = ""
    var associatedFile : String = ""
    var status : String = ""
    var refNum : String = ""
    var applicationDate : String = ""

    init() {
        
    }
    init(json : JSON){
        trainingApplicationId = json["trainingApplicationId"].intValue
        trainingName = json["trainingName"].stringValue
        conductedBy = json["conductedBy"].stringValue
        venue = json["venue"].stringValue
        numberOfDays = json["numberOfDays"].intValue
        trainingFees = json["trainingFees"].intValue
        otherExpenses = json["otherExpenses"].intValue
        totalFees = json["totalFees"].intValue
        departmentId = json["departmentId"].intValue
        department = json["department"].stringValue
        remarks = json["remarks"].stringValue
        associatedFile = json["associatedFile"].stringValue
        status = json["status"].stringValue
        refNum = json["refNum"].stringValue
        applicationDate = json["applicationDate"].stringValue
    }
    
}

struct AllowanceReqViewListModel {
    var dmsApplicationTaskId = Int()
    var name : String = ""
    var dmsApplicationId = Int()
    var dmsApplication : String = ""
    var approvalLevel = Int()
    var approverId = Int()
    var outcome : String = ""
    var comment : String = ""
    var isCompleted = Bool()
    var created : String = ""
    var completed : String = ""
    
    init() {
        
    }
    init(json : JSON){
        dmsApplicationTaskId = json["dmsApplicationTaskId"].intValue
        name = json["name"].stringValue
        dmsApplicationId = json["dmsApplicationId"].intValue
        dmsApplication = json["dmsApplication"].stringValue
        approvalLevel = json["approvalLevel"].intValue
        approverId = json["approverId"].intValue
        outcome = json["outcome"].stringValue
        comment = json["comment"].stringValue
        isCompleted = json["isCompleted"].boolValue
        created = json["created"].stringValue
        completed = json["completed"].stringValue

    }
    
}
struct NotificationsListModel {
    var alertId = Int()
    var created : String = ""
    var category : String = ""
    var text : String = ""
    var read = Bool()
    var detailsLink : String = ""
    var detailsText : String = ""
    var applicationType : String = ""
    var applicationId = Int()
    var employeeId = Int()


    
    init() {
        
    }
    init(json : JSON){
        alertId = json["alertId"].intValue
        created = json["created"].stringValue
        category = json["category"].stringValue
        text = json["text"].stringValue
        read = json["read"].boolValue
        detailsLink = json["detailsLink"].stringValue
        detailsText = json["detailsText"].stringValue
        applicationType = json["applicationType"].stringValue
        applicationId = json["applicationId"].intValue
        employeeId = json["employeeId"].intValue
    }
    
}
struct BusinessTravelViewListModel {
    var dmsApplicationTaskId = Int()
    var name : String = ""
    var dmsApplicationId = Int()
    var dmsApplication : String = ""
    var approvalLevel = Int()
    var approverId = Int()
    var outcome : String = ""
    var comment : String = ""
    var isCompleted = Bool()
    var created : String = ""
    var completed : String = ""
    
    init() {
        
    }
    init(json : JSON){
        dmsApplicationTaskId = json["dmsApplicationTaskId"].intValue
        name = json["name"].stringValue
        dmsApplicationId = json["dmsApplicationId"].intValue
        dmsApplication = json["dmsApplication"].stringValue
        approvalLevel = json["approvalLevel"].intValue
        approverId = json["approverId"].intValue
        outcome = json["outcome"].stringValue
        comment = json["comment"].stringValue
        isCompleted = json["isCompleted"].boolValue
        created = json["created"].stringValue
        completed = json["completed"].stringValue

    }
    
}
struct LeaveListViewListModel {
    var dmsApplicationTaskId = Int()
    var name : String = ""
    var dmsApplicationId = Int()
    var dmsApplication : String = ""
    var approvalLevel = Int()
    var approverId = Int()
    var outcome : String = ""
    var comment : String = ""
    var isCompleted = Bool()
    var created : String = ""
    var completed : String = ""
    
    init() {
        
    }
    init(json : JSON){
        dmsApplicationTaskId = json["dmsApplicationTaskId"].intValue
        name = json["name"].stringValue
        dmsApplicationId = json["dmsApplicationId"].intValue
        dmsApplication = json["dmsApplication"].stringValue
        approvalLevel = json["approvalLevel"].intValue
        approverId = json["approverId"].intValue
        outcome = json["outcome"].stringValue
        comment = json["comment"].stringValue
        isCompleted = json["isCompleted"].boolValue
        created = json["created"].stringValue
        completed = json["completed"].stringValue

    }
    
}
struct BusinessTravelListModel {
    var id = Int()
    var leaveType : String = ""
    var fromDate : String = ""
    var toDate : String = ""
    var status : String = ""
    var expanded = Bool()
    var requesterName : String = ""
    
    


    

    init() {
        
    }
    init(json : JSON){
        id = json["id"].intValue
        leaveType = json["leaveType"].stringValue
        fromDate = json["fromDate"].stringValue
        toDate = json["toDate"].stringValue
        status = json["status"].stringValue
        expanded = json["expanded"].boolValue
        requesterName = json["requesterName"].stringValue
        

    }
    
}

