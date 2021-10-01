//
//  ApiConstants.swift
//  Juvoxa
//
//  Created by sudhakar dalli on 28/01/19.
//  Copyright © 2019 Thukaram. All rights reserved.
//

import Foundation
//https://spinlogics.com/sicuremi/user/activity_garmin.php
//https://sicuremi.com/user/webservices/login.php
let BASEURL = "https://hrd.alainholding.ae/api/"
struct MyStrings {
    
    let loginUrl                     =   BASEURL + "login"
    let MyGeneralInfo                =   BASEURL + "Employees/api/MyGeneralInfo"
    let MyPersonalInfo               =   BASEURL + "EmployeePersonalInfoes"
    let AccountingInfo               =   BASEURL + "EmployeeAccountingInfoes"
    let SalarySlipsInfo              =   BASEURL + "SalarySlips/EmployeeId"
    let SalarySlipsPDF               =   BASEURL + "SalarySlips"

    let EmployeeDocumentsInfo                =   BASEURL + "EmployeeDocuments"
    let DeleteEmployeeDocumentsInfo          =   BASEURL + "EmployeeDocuments"
    let LeavesInfo                =   BASEURL + "LeaveApplications/api/MyLeaves"
    let BusinessTravelListInfo                =   BASEURL + "BusinessTravelApplications/api/MyBusinessTrips"
    let AllowanceApplicationsListInfo                =   BASEURL + "AllowanceApplications/api/MyAllowanceApplications"
    let FormalityListInfo                =   BASEURL + "FormalityApplications/api/MyFormalities"
    let NotificationsListInfo                =   BASEURL + "AllowanceTasks/api/MyApprovals"

    let ReimbursmentListInfo                =   BASEURL + "ReimbursmentApplications/api/MyReimbursmentApplications"
    let MyParticipatedDMS                =   BASEURL + "DMSApplications/MyParticipatedDMSApplications"
    
    let MyDMSListInfo                =   BASEURL + "DMSApplications/api/MyDMSApplications"
    let MyDMSRequestListInfo                =   BASEURL + "DMSApplications"
    let MyDMSRequestApprovalHistoryInfo                =   BASEURL + "DMSApplicationTasks/api/Approvals"
    let ReimbursmentViewListInfo                =   BASEURL + "ReimbursmentApplications"
    let FormalityViewListInfo                =   BASEURL + "FormalityApplications"
    let ReimbursmentApprovalListInfo                =   BASEURL + "ReimbursmentTasks/api/Approvals"
    let formalityApprovalListInfo                =   BASEURL + "FormalityTasks/api/Approvals"

    let AllowanceViewListInfo                =   BASEURL + "AllowanceApplications"
    let AllowanceApprovalListInfo                =   BASEURL + "AllowanceTasks/api/Approvals"
    let BusinessTravelViewListInfo                =   BASEURL + "BusinessTravelApplications"
    let BusinessTravelApprovalListInfo                =   BASEURL + "BusinessTravelTasks/api/Approvals"
    
    let LeaveViewListInfo                =   BASEURL + "LeaveApplications"
    let LeaveApprovalListInfo                =   BASEURL + "LeaveTasks/api/Approvals"
    let LeaveTypeInfo                =   BASEURL + "LeaveTypes"
    
    let FormalityTypesInfo                =   BASEURL + "FormalityTypes"

    let AllowanceTypes                =   BASEURL + "AllowanceTypes"
    let AllowanceEligibityBalance     =   BASEURL + "AllowanceEmployeeMasters/api/GetEligibilityBalanceByEmp/"
    let LeaveEligibityBalance     =   BASEURL + "LeaveApplications/api/GetEligibilityBalanceByEmp/"
    let ReimbursementEligibityBalance     =   BASEURL + "ReimbursmentEmployeeMasters/api/GetEligibilityBalanceByEmp/"

    let ReimbursmentParticularsTypes                =   BASEURL + "ReimbursmentTypes"
    let AddReimbursmentInfo                =   BASEURL + "ReimbursmentApplications"
    let AddAllowanceApplications               =   BASEURL + "AllowanceApplications"
    let AddEmployeeDocument               =   BASEURL + "EmployeeDocuments"
    let DMSDepartmentInfo               =   BASEURL + "DMSCategories"
    let DMSDepartmentProcessName               =   BASEURL + "DMSSubCategories/ByCategoryId"
    let DMSDepartmentApprovalList               =   BASEURL + "DMSApprovals/subCategoryId"
    let SubmitLeaveRequestApplications            =   BASEURL + "LeaveApplications"
    let BusinessTravelApplications            =   BASEURL + "BusinessTravelApplications"
    let AddFormalityApplications            =   BASEURL + "FormalityApplications"
    let AddDMSRequest           =   BASEURL + "DMSApplications"
    let PostGeneralInfo            =   BASEURL + "Employees"
    let PostPersonalInfo            =   BASEURL + "EmployeePersonalInfoes"
    let PostAccountingInfo            =   BASEURL + "EmployeeAccountingInfoes"

    
    let AllowanceIDInfo            =   BASEURL + "AllowanceTasks/"
    let AllowanceDetailsInfo            =   BASEURL + "AllowanceApplications/"
    let NotAllowanceApprovalDetailsInfo            =   BASEURL + "AllowanceTasks/api/Approvals"
    let GetAllowanceEligibityBalance     =   BASEURL + "AllowanceEmployeeMasters/api/GetEligibilityBalance/"

    let PostAllowanceApprovalDetails            =   BASEURL + "AllowanceTasks/"
    
    let ReimbursmentIDInfo            =   BASEURL + "ReimbursmentTasks/"
    let ReimbursmentDetailsInfo            =   BASEURL + "ReimbursmentApplications/"
    let NotReimbursmentApprovalDetailsInfo            =   BASEURL + "ReimbursmentTasks/api/Approvals"
    let GetReimbursementEligibityBalance     =   BASEURL + "ReimbursmentEmployeeMasters/"
    let PostReimbursmentApprovalDetails            =   BASEURL + "ReimbursmentTasks/"
    
    let LeaveIDInfo            =   BASEURL + "LeaveTasks/"
    let LevelReqDetailsInfo            =   BASEURL + "LeaveApplications/"
    let GetLeaveEligibityBalance     =   BASEURL + "LeaveApplications/api/GetEligibilityBalance/"
    let NotLeaveApprovalDetailsInfo            =   BASEURL + "LeaveTasks/api/Approvals"
    let UpdateLeaveEligibityBalance     =   BASEURL + "LeaveApplications/api/GetEligibilityBalanceByEmp/"
    let PostLeaveApprovalDetails                    =   BASEURL + "LeaveTasks/"

    let DMSIDInfo                                   =   BASEURL + "DMSApplicationTasks/"
    let DMSProcessNameInfo                          =   BASEURL + "DMSSubCategories"
    let DMSReqDetailsInfo                           =   BASEURL + "DMSApplications/"
    let NotDMSReqApprovalDetailsInfo                =   BASEURL + "DMSApplicationTasks/api/Approvals"
    let PostDMSApprovalDetails                      =   BASEURL + "DMSApplicationTasks/"

    let FormalityIDInfo                             =   BASEURL + "FormalityTasks/"
    let FormalityReqDetailsInfo                     =   BASEURL + "FormalityApplications/"
    let NotFormalityReqDetailsInfo                  =   BASEURL + "FormalityTasks/api/Approvals"
    let PostFormalityReqDetails                     =   BASEURL + "FormalityTasks/"

    let BusinessTravelIDInfo                        =   BASEURL + "BusinessTravelTasks/"
    let BusinessTravelDetailsInfo                   =   BASEURL + "BusinessTravelApplications/"
    let NotBusinessTravelDetailsInfo                =   BASEURL + "BusinessTravelTasks/api/Approvals"
    let PostBusinessTravelDetailsDetails            =   BASEURL + "BusinessTravelTasks/"


    let NotificationsAlerts                 =   BASEURL + "Alerts"
    let DeleteNotificationsAlerts           =   BASEURL + "Alerts/"
    
    let categoryTypeInfo                =   BASEURL + "ITSupportCategories"
    let subcategoryTypeInfo                =   BASEURL + "ITSupportSubCategories/GetByCategory/"
    let serviceTypeInfo                =   BASEURL + "ITSupportServiceTypes"
    let PriorityTypeInfo                =   BASEURL + "ITSupportPriorities"
    let submitITsupport                =   BASEURL + "ITSupportApplications"
    
    let DepartmentTypeInfo                =   BASEURL + "Departments"
    let BudgetActualBalanceInfo                =   BASEURL + "TrainingBudgets/ByDepartmentId/"
    let submitTrainingReq                =   BASEURL + "TrainingApplications"
    let TrainingListInfo                =   BASEURL + "TrainingApplications/MyTrainingApplications"
    let ItSupportListInfo                =   BASEURL + "ITSupportApplications/MyITSApplications"
    let ItSupportDetailedListInfo                =   BASEURL + "ITSupportApplications"
    let ItSupportDetailsApprovalListInfo                =   BASEURL + "ITSupportTasks/api/Approvals"

    let TrainingDetailedListInfo                =   BASEURL + "TrainingApplications"
    let TrainingDetailsApprovalListInfo                =   BASEURL + "TrainingTasks/Approvals"




}
