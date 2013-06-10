

#import <Foundation/Foundation.h>

typedef void(^AutoCompleteBlock)(BOOL,id);
typedef NSString*(^AutoCompleteDisplayBlock)(id);
typedef NSArray*(^AutoCompleteDataBlock)(NSString*);

//Global date formatter string
#define kRestKitDateFormatterString @"yyyy-MM-dd'T'HH:mm:ss"
#define kDisplayDateFormatterString @"MM/dd/yy HH:mm"
#define kLocalIdentifier @"en_US_POSIX"

//process status
#define kProcessStatusNew @"NEW"
#define kProcessStatusSUBMITTED @"SUBMITTED"
#define kProcessStatusPROCESSING @"PROCESSING"
#define kProcessStatusFAILED @"FAILED"
#define kProcessStatusCOMPLETED @"COMPLETED"
#define kTimeZone @"EST"

//Receive Type
#define kReceivingDescriptionTemplate @"Receive via %@"
//miscellaneouse receive 
#define kReceivingMiscellaneous @"Miscellaneous"
#define kTransactionTypeMRC @"MRC"


#define kReceivingShipList @"Ship List"
#define kTransactionTypeDRC @"DRC"
//#define kReceivingNoShipList @"300"

#define kReceivingVendorRepair @"Vendor Repair"
#define kTransactionTypeRRFV @"RRFV"
//#define kReceivingNoVendorRepair @"800"

#define kReceivingRepairOrder @"Repair Order"
#define kTransactionTypeRFR @"RFR"
//#define kReceivingNoRepairOrder @"900"

//Cycle Count Type
#define kCycleCountTypeBin @"BIN"
#define kCycleCountTypePart @"PART"



//Shipping Type
#define kShippingTypePick @"PICK"
#define kShippingTypeShip @"SHIP"
#define kShippingTypePickStatID @"50"
#define kShippingTypeShipStatID @"100"
#define kShippingDocTypeID10 @"10"
#define kShippingDocTypeID600 @"600"

//Menu Item
#define kMenuSpace @""
#define kMenuSectionTransation @"Transation"
#define kMenuSectionUtility @"Utility"
#define kMenuReceiving @"Receiving"
#define kMenuShipping @"Shipping"
#define kMenuInventory @"Inventory"
#define kMenuRepair @"Repair"
#define kMenuCycleCount @"Cycle Count"
#define kMenuQueries @"Reports"
#define kMenuSynchronization @"Synchronization"
#define kMenuLogout @"Logout"

//Template
#define kURLWithHostName @"http://%@"
#define kSegueTemplate @"Show%@Segue"
#define kMenuIconTemplate @"icon%@"
#define kStoryboardTemplate @"%@Storyboard"
#define kWebViewJasperReportTemplate @"http://%@/%@&j_username=%@&j_password=%@"
#define kBinPartDisplayTemplate @"%@ (qty:%@; type:%@)"
#define reportsample @"http://srv-rptprod-nor.ltx-credence.com/flow.html?_flowId=viewReportFlow&standAlone=true&_flowId=viewReportFlow&ParentFolderUri=%2FCS%2FLOG%2FDEMAND&reportUnit=%2FCS%2FLOG%2FDEMAND%2FBoardDemand&j_username=jlu&j_password=Firewood%2610"

//******************************IPAD ID************************************
#define kIPADIDTransactionTypeReceiving @"RV"
#define kIPADIDTransactionTypeCycleCount @"CC"
#define kIPADIDTransactionTypeShipping @"SHP"


//*******************************Restkit Call *************************
#define kWebServiceURLTemplate @"http://%@/%@/rest"
#define kUrlBaseUserAccount @"/user/myaccount"
#define kUrlBaseWarehouse @"/synch/warehouse"
#define kUrlBaseCompany @"/synch/company"
#define kUrlBaseCarrier @"/synch/carrier"
#define kUrlBaseBinPart @"/synch/binpart"
#define kUrlBaseShipmentInstructions @"/synch/shipmentinstructions"
#define kUrlBaseQueries @"/synch/queries"
#define kUrlBaseManAdjustReason @"/synch/manadjustreason"
#define kUrlBaseInventory @"/inventory/load"
#define kUrlBaseCycleCountMaster @"/synch/cyclecountmaster"
#define kUrlBaseCycleCount @"/cyclecount/load"
#define kUrlBaseShippingList @"/synch/shippinglistview" //@"/synch/shippinglist"
#define kUrlBaseShippingTransaction @"/shipping/loadall"
#define kUrlBaseRPInformation @"/views/repairinfo"

#define kQueryParamFirstResult @"firstresult"
#define kQueryParamMaxResult @"maxresult"
#define kQueryParamWarehouseId @"warehouseid"
#define kQueryParamLastDate @"lastdate"


#define kDetailViewDefault @"default"
#define kSynchDateTemplate @"E MMM d yyyy HH:mm:ss zzz"

#define kIdVersion @"version"
#define kIdPrinter @"printer"
#define kIdServerDomain @"server"
#define kIdAppName @"appname"
#define kIdDefaultWarehouseId  @"warehouseid"
#define kIdLastLogin @"lastlogin"
#define kIdLastLoginAA @"lastloginaa"
#define kIdIsRemember @"isremember"
#define kIdBackgroundPeriod @"bgtimerseconds"
#define kIdMaxRows @"maxrow"
#define kIdReportServer @"reportserverurl"
#define kIdLastSynchCompany @"lastsynch_comapny"
#define kIdLastSynchCarrier @"lastsynch_carrier"
#define kIdLastSynchWarehouse @"lastsynch_warehouse"
#define kIdLastSynchBin @"lastsynch_bin"
#define kIdLastSynchReason @"lastsynch_reason"
#define kIdLastSynchReports @"lastsynch_reports"
#define kIdLastSynchShipmentInstructions @"lastsynch_shipmentinstructions"

#define kDefaultPrinter @"\\miprint\CP03CA"
#define kDefaultServerDomain @"srv-tpgen-nor.ltx-credence.com"
#define kDefaultAppName @"customerservice"
#define kDefaultDefaultWarehouseId  @"A-SAN-JOSE"
#define kDefaultLastLogin @""
#define kDefaultIsRemember (BOOL)1
#define kDefaultBackgroundPeriod 30.0
#define kDefaultMaxRows 50.0
#define kDefaultReportServer @"srv-rptprod-nor.ltx-credence.com"
#define kDefaultVersion @"1.0.0"

//******************** Data Model and Mapping ****************************
#define kSharedStoreFileName @"CustomerServiceMobile.sqlite"
#define kEntityUserProfile @"UserProfile"

//attribute -- sort attribute
#define kSortAttributeCompany @"company_id"
#define kSortAttributeWarehouse @"warehouse_id"
#define kSortAttributeCarrier @"carrier_id"
#define kSortAttributeManAdjustReason @"reasoncode"
#define kSortAttributeBinPart @"bpart_id"
#define kSortAttributeQueries @"queryname"


//attribute - db, keypath - json
//userprofile
#define kAttributeUserProfileUserName @"username"
#define kKeyPathUserProfileUserName @"userid"
#define kAttributeUserProfileLastUpdated @"lastUpdated"
#define kAttributeUserProfileAAAcount @"aaacount"
#define kKeyPathUserProfileAAAcount @"aaacount"
#define kAttributeUserProfileIsAuthorized @"isAuthorized"
#define kKeyPathUserProfileIsAuthorized @"authorized"
#define kAttributeServerID @"server_id"
#define kKeyPathPrinter @"printer"

//warehouse
#define kKeyPathLastChangeDate @"last_change_date"
#define kKeyPathServerID @"id"
#define kKeyPathKeyID @"keyid"
#define kKeyPathWarehouseWarehouseID @"warehouse_id"
#define kKeyPathWarehouseDescr @"descr"
#define kKeyPathCompanyCompanyID @"company_id"
#define kKeyPathCarrierCarrierID @"carrier_id"
//binpart
#define kKeyPathBinPartBinCodeID  @"binCodeId"
#define kAttributeBinPartBinCodeID  @"bin_code_id"
#define kKeyPathBinPartInvTypeID  @"invTypeId"
#define kAttributeBinPartInvTypeID  @"inv_type_id"
#define kKeyPathBinPartBpartID  @"bpartId"
#define kAttributeBinPartBpartID  @"bpart_id"
#define kKeyPathBinPartQty  @"qty"
#define kAttributeBinPartQty  @"qty"
//shipment instructions
#define kKeyPathShipmentInstructionsDescription  @"ap_description"
#define kKeyPathShipmentInstructionsTableKey  @"ap_table_key"
#define kKeyPathShipmentInstructionsTableName  @"ap_table_name"
#define kKeyPathShipmentInstructionsLastUpdated  @"lastupdated"


#define kKeyPathBinPartLastRecDate @"lastRecDate"
#define kAttributeBinPartLastRecDate @"last_rec_date"
#define kKeyPathManAdjustReasonReasonCode @"reasoncode"
#define kAttributeManAdjustReasonReasonCode @"reasoncode"
#define kKeyPathManAdjustReasonDescription @"description"
#define kAttributeManAdjustReasonDescription @"descr"

//reports
#define kKeyPathQueriesDescr @"descr"
#define kKeyPathQueriesGroupName @"groupname"
#define kKeyPathQueriesQueryName @"queryname"
#define kKeyPathQueriesTag @"tag"
#define kKeyPathQueriesURL  @"url"
//cycle count master  CycleCountMaster
#define kKeyPathCycleCountMasterBinCodeID  @"binCodeId"
#define kAttributeCycleCountMasterBinCodeID  @"bin_code_id"
#define kKeyPathCycleCountMasterBpartID  @"bpartId"
#define kAttributeCycleCountMasterBpartID  @"bpart_id"
#define kKeyPathCycleCountMasterCycleType  @"cycleType"
#define kAttributeCycleCountMasterCycleType  @"cycle_type"
#define kKeyPathCycleCountMasterServerID  @"id"
#define kAttributeCycleCountMasterServerID  @"server_id"
#define kKeyPathCycleCountMasterAssignedDate  @"assigneddate"
#define kAttributeCycleCountMasterAssignedDate  @"assigneddate"
#define kKeyPathCycleCountMasterQty  @"qty"
#define kAttributeCycleCountMasterQty  @"qty"

//inventory mapping
#define kKeyPathInventoryCarrier  @"carrier"
//#define kKeyPathInventoryCarrierCarrier_ID  @"(carrier).carrier_id"
#define kAttributeInventoryCarrier_ID  @"carrier_id"
#define kKeyPathInventoryCarrierRefNo  @"carrier_refno"
#define kKeyPathInventoryCompany  @"company"
//#define kKeyPathInventoryCompanyCompany_ID  @"(company).company_id"
#define kAttributeInventoryCompany_ID  @"company_id"
#define kKeyPathInventoryCreatedBy  @"created_by"
#define kKeyPathInventoryCreated_Date  @"created_date"
#define kKeyPathInventoryInventoryLineItems  @"inventoryLineItems"
#define kKeyPathInventoryInventoryLineItemsBin_Code_ID  @"bin_code_id"
#define kKeyPathInventoryInventoryLineItemsBPart_ID  @"bpart_id"
#define kKeyPathInventoryInventoryLineItemsInvTypeID  @"inv_type_id"
#define kKeyPathInventoryInventoryLineItemsLineReasonCode  @"man_adj_reason_id"
#define kKeyPathInventoryInventoryLineItemsCause @"cause"
#define kKeyPathInvenoryInventoryLineItemsLineNumber @"lineitemnumber"
#define kKeyPathInventoryInventoryLineItemsLineQty  @"qty"
#define kKeyPathInventoryInventoryLineItemsSerialNo @"serial_no"
#define kKeyPathInventoryIPad_ID  @"ipad_id"
#define kAttributeInventoryIPad_ID @"ipad_id"
#define kKeyPathInventoryNoOfPackages  @"no_of_packages"
#define kKeyPathInventorySenderRefNo  @"sender_refno"
#define kKeyPathInventoryToWarehouse  @"to_warehouse"
//#define kKeyPathInventoryToWarehouseWarehouseID  @"(to_warehouse).warehouse_id"
#define kKeyPathInventoryToWarehouseWarehouseID  @"warehouse_id"
#define kAttributeInventoryToWarehouseID  @"warehouse_id"
#define kKeyPathInventoryFrWarehouse  @"fr_warehouse"
#define kKeyPathInventoryFrWarehouseWarehouseID  @"warehouse_id"
#define kAttributeInventoryFrWarehouseID  @"fr_warehouse_id"
//#define kKeyPathInventoryFrWarehouseWarehouseID  @"(fr_warehouse).warehouse_id"
#define kKeyPathInventoryTransactionType @"transaction_type"
#define kAttributeInventoryType @"transaction_type"
#define kKeyPathInventoryOurRefNo @"our_refno"

#define kKeyPathInventoryWeight @"weight"

//repair information
#define kRootPathRPInformation @"viewRepairInfo"
#define kQueryParamRPInformationRequestID @"request_id"
#define kKeyPathRPInformationCconthID @"cconth_id"
#define kKeyPathRPInformationDestWarehouseID @"dest_warehouse_id"
#define kKeyPathRPInformationPcodeID @"pcode_id"
#define kKeyPathRPInformationPOID @"po_id"
#define kKeyPathRPInformationPriority @"priority"
#define kKeyPathRPInformationRequestID @"request_id"
#define kKeyPathRPInformationWarrTypeID @"warr_type_id"

//cycle count mapping
#define kAttributeCycleCountWho @"who"
#define kKeyPathCycleCountWho @"who"
#define kAttributeCycleCountWarehouseID @"warehouse_id"
#define kKeyPathCycleCountWarehouseID @"warehouseId"
#define kAttributeCycleCountCycleType @"cycle_type"
#define kKeyPathCycleCountCycleType @"cycleType"
#define kAttributeCycleCountBinCodeID @"bin_code_id"
#define kKeyPathCycleCountBinCodeID @"binCodeId"
#define kAttributeCycleCountBpartID @"bpart_id"
#define kKeyPathCycleCountBpartID @"bpartId"
#define kAttributeCycleCountIsClear @"isclear"
#define kKeyPathCycleCountIsClear @"isclear"


#define kKeyPathCycleCounts @"counts"
#define kAttributeCycleCountTarget @"target"
#define kKeyPathCycleCountTarget @"target"
#define kAttributeCycleCountQty @"qty"
#define kKeyPathCycleCountQty @"qty"


//Shipping List mapping
#define kAttributeShippingListServerID  @"server_id"
#define kKeyPathShippingListServerID  @"serverid"//@"id"
#define kAttributeShippingListDueDate @"due_date"
#define kKeyPathShippingListDueDate @"due_dt"

#define kKeyPathShippingBPartID @"bpart_id"
#define kKeyPathShippingDemandID @"demand_id"
#define kKeyPathShippingDocTypeID @"doc_type_id"
#define kKeyPathShippingFRBinCodeID @"fr_bin_code_id"
#define kKeyPathShippingItemID @"item_id"
#define kKeyPathShippingLDMNDStatID @"ldmnd_stat_id"
#define kKeyPathShippingOrderID @"order_id"
#define kKeyPathShippingOrigDocID @"orig_doc_id"
#define kKeyPathShippingPriority @"priority"
#define kKeyPathShippingQty @"qty"
#define kKeyPathShippingSerialNo @"serial_no"
#define kKeyPathShippingToCompany @"to_company_id"
#define kKeyPathShippingToWarehouseID @"to_warehouse_id"

#define kKeyPathShippingCarrierID @"carrier_id"
#define kKeyPathShippingCarrierRefNo @"carrier_refno"
#define kKeyPathShippingFrWarehouseID @"fr_warehouse_id"
#define kKeyPathShippingNoOfPackages @"no_of_packages"
#define kKeyPathShippingWeight @"weight"
#define kKeyPathShippingShippedBy @"shipped_by"
#define kKeyPathShippingShippingInstructions @"ship_instructions"
#define kKeyPathShippingTransactionType @"transaction_type"
#define kKeyPathShippingIPADID @"ipad_id"

#define kKeyPathShippingShippedQty @"shipped_qty"
#define kKeyPathShippingServerID @"shippinglist_id"
#define kAttributeShippingServerID @"server_id"

#define kAttributeShippingLineItems @"shippingLineItems"
//#define kAttributeCycleCount @""
//#define kKeyPathCycleCount @""

//process result mapping
#define kKeyPathProcessResultType @"transactionType"
#define kKeyPathProcessResultTransactionID @"transactionId"
#define kKeyPathProcessResultStatus @"process_status"
#define kKeyPathProcessResultMessage @"process_message"
#define kKeyPathProcessResultDate @"process_date"
#define kKeyPathProcessCreatedBy @"created_by"
#define kKeyPathProcessCreatedDate @"created_date"
//******************************* Web Service Root Element ************************
#define kKeyPathCompany @"company"
#define kKeyPathQueries @"queries"
#define kKeyPathBinPart @"binPart"
#define kKeyPathCarrier @"carrier"
#define kKeyPathWarehouse @"warehouse"
#define kKeyPathManAdjustReason @"manAdjustReason"
#define kKeyPathCycleCountMaster @"cycleCountMaster"
#define kKeyPathShippingList @"shippingList"
#define kKeyPathShipmentInstructions @"shipmentInstructions"

//******************************** Entity Classes ******************
#define kEntityCompany @"Company"
#define kEntityQueries @"Queries"
#define kEntityBinPart @"BinPart"
#define kEntityCarrier @"Carrier"
#define kEntityWarehouse @"Warehouse"
#define kEntityManAdjustReason @"ManAdjustReason"
#define kEntityInventoryHeader @"InventoryHeader"
#define kEntityInventoryLineItem @"InventoryLineItem"
#define kEntityCycleCountCount @"CycleCountCount"
#define kEntityCycleCountMaster @"CycleCountMaster"
#define kEntityShippingList @"ShippingList"
#define kEntityShippingHeader @"ShippingHeader"
#define kEntityShippingLineItem @"ShippingLineItem"
#define kEntityRPInformation @"RPInformation"
#define kEntityShipmentInstructions @"ShipmentInstructions"

//******************************* Core Data Fetch Template *********************************
#define kFetchTemplateToCompany @"to_company_id==%@"
#define kFetchTemplateToWarehouse @"to_warehouse_id==%@"
#define kFetchTemplateAnd @"(%@) AND (%@)"
#define kFetchTemplateOr @"(%@) OR (%@)"
#define kPredicatePick @"(ldmnd_stat_id == '50') AND (shipping_ipad_id == NULL)"
#define kPredicateShip @"((ldmnd_stat_id == '100') OR (ldmnd_stat_id == '50')) AND (shipping_ipad_id == NULL)"
#define kFetchTemplateServerID @"server_id==%@"
#define kPredicateShipmentInstruction @"ap_table_key == %@"

//******************** NSNotification **************************
#define kNotificationSynchFailTemplate @"%@ failed. Error Message:%@."
#define kNotificationSynchSuccessTemplate @"%@ finished successfully. %@"
#define kNotificationStatus @"status"
#define kNotificationMessage @"message"
#define kNotificationNameWarehouse @"syncWarehouse"
#define kNotificationNameCarrier @"syncCarrier"
#define kNotificationNameCompany @"syncCompany"
#define kNotificationNameBinPart @"syncBinPart"
#define kNotificationNameManAdjustReason @"syncReasonCode"
#define kNotificationReports @"syncReports"
#define kNotificationShipmentInstructions @"shipmentInstructions"

//******************** Message ********************************
#define kAlertTitleSystemError @"System Error"
#define kAlertTitleTransactionError @"Transaction Error"
#define kMessageValidationRequiredTemplate @"Field %@ is required..."

#define kMessageLoginTitle @"Login Failed..."

#define kMessageLoginFirstTime @"First time user must be authentiated with the server at least once. Please contact IT for help."
#define kMessageLoginMissMatch @"User name and password your enter do not match with what are in the system."
#define kMessageSynchRecordTemplate @"Total %d records received..."
#define kMessageSynchFailedTemplate @"Server may not be reachable. Detail:%@"

#define kMessageReceivingNoLineItem @"No line item is available."
#define kMessageQtyNotNumber @"Quantity must be a number."
#define kMessageReceivingBinSearchFailure @"Please enter the product information first to enable the bin code suggestion."
#define kMessageReceivingSerialNoRule @"If serial number is provided, the quantity can only be 1. Reset automatically."

#define kMessageDataControllerCallFailed @"It failed to complete successfully. Please check the process message for the reason..."

#define kMessageDataSynchControllerCallFailed @"It failed to synch with the server. Please double check the connection..."

#define kMessageDataSynchControllerCallOK @"Total %@ records received..."

#define kMessageCycleCountPN @"Part number"

#define kMessageShippingDestination @"Please select a ship to company id or warehouse id before you do the pick or ship transaction..."

#define kMessageShippingNoLineItem @"No line item has been selected..."

#define kMessageNoOfPackages @"No of packages must be a number larger than 0..."

#define kMessageWeight @"Weight must be a number larger than 0..."

#define kMessageShippingCarrierIDRequired @"Carrier ID is the required field..."

#define kMessageShippingInstructionsRequired @"Shipping Instructions is the required field..."

#define kMessageShippingCarrierRefNoRequired @"Carrier RefNo is the required field..."

#define kMessageSHippingNoDestinationValue @"Please provide either to company id or to warehouse id..."

#define kMessageShippingNotMatch @"The field (%@) do not match with what system has..."

#define kMessageRPInformation @"Failed to retrieve the Repair Information. Please double check the connection if you are sure that the RP number you entered is valid..."

#define kMessageCycleCountMasterFailed @"Failed to retrieve the list from the server. Cached data will be displayed. Error: Can not connect to the server. Detail Info:%@"
