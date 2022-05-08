global without sharing class addFileComponentController {
    @AuraEnabled
    public static List<ContentDocument> UpdateFiles(String documentId, String title, String recordId){
        system.debug('title:'+title);
        
        ContentDocument cd = [select id,title from ContentDocument where Id=:documentId]; // Getting files from Parent record 
        cd.Title = title;  // Changing file Title with user entered title
        try{  
            update cd;  // Update ContentDocument (File)
        }  
        catch(DMLException e){  
            system.debug('Exception has occurred! ' +e.getMessage());  
        }  
        List<ContentDocument> DocumentList = new List<ContentDocument>();  
        Set<Id> documentIds = new Set<Id>();  
        List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }      
        DocumentList = [select Id,Title,FileType,ContentSize,Description from ContentDocument where id IN: documentIds];  
        return DocumentList;  // Return list of files on parent record
    } 
    
    @AuraEnabled
    public static Contact ContactDeatils(String recordId){
        Contact con = [select Id, FirstName, LastName from Contact where Id=: recordId limit 1]; // Getting details of the Parent Record
        system.debug(con);
        
        return con;
    } 
    // Apex Methods for addAttachmentComponent Starts
    
    @AuraEnabled
    public static Id saveChunk(String parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
        
        return Id.valueOf(fileId);
    }
    
    public static Id saveTheFile(String parentId, String fileName, String base64Data, String contentType) {
        system.debug('base64Data'+base64Data);
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
        
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        
        insert oAttachment;
        
        return oAttachment.Id;
        
        
        /*  ContentVersion cVersion = new ContentVersion();
cVersion.IsMajorVersion = false;
cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
cVersion.PathOnClient = fileName;//File name with extention
cVersion.Origin = 'C';//C-Content Origin. H-Chatter Origin.
//cVersion.OwnerId = attach.OwnerId;//Owner of the file
cVersion.Title = fileName;//Name of the file
cVersion.VersionData = EncodingUtil.base64Decode(base64Data);//File content

system.debug('VersionData'+cVersion);
Insert cVersion;

//After saved the Content Verison, get the ContentDocumentId

Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;

//Insert ContentDocumentLink
ContentDocumentLink cDocLink = new ContentDocumentLink();
cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
cDocLink.LinkedEntityId = parentId;//Add attachment parentId
cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
Insert cDocLink;

return cVersion.Id;
*/
        
        
        
    }
    
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
        
        String existingBody = EncodingUtil.base64Encode(a.Body);
        
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
        
        update a;
        
        
        /*
ContentVersion cv = [SELECT ContentDocumentId ,VersionData FROM ContentVersion WHERE Id =:fileId];

system.debug('VersionData'+cv);


String existingBody = EncodingUtil.base64Encode(cv.VersionData);

system.debug('VersionData'+existingBody);

cv.VersionData = EncodingUtil.base64Decode(existingBody + base64Data );



update cv;
*/
        
    }
    @AuraEnabled
    public static String updateDocType(String mandateId,String docType){
        try{
            Mandate__c mandateRec = new Mandate__c(Id=mandateId,Document_Type__c=docType,Has_Research_Strategy__c=(docType=='Research Strategy'?true:false));
            update mandateRec;
            return 'Record Updated Sucessfully';
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return e.getMessage();
        }
        
    }
    @AuraEnabled
    public static Application__c getData(String mandateId,String Conid){
        try{
            //contact Conrecdata = [SELECT Name,LinkedIn_URL__c,Title__c,Origin__c,Comp__c,Phone,Email,Office_City__c,Office_State__c,MobilePhone,Additional_Comments_for_Compensation__c ,Stock_Equity__c ,Allowance__c,Company_Name_French__c,Base_Salary__c,Bonus__c,Other__c FROM Contact where id=:Conid limit 1];
            Application__c applicationRec = [SELECT Contact__c,Contact__r.Name,Contact__r.LinkedIn_URL__c, Current_Title__c,Current_Title_French__c,Mandate_Language__c,Contact__r.Title__c,Origin__c,Contact__r.Phone,Contact__r.Email,Contact__r.Office_City__c,Contact__r.Office_State__c,Contact__r.MobilePhone,Contact__r.Additional_Comments_for_Compensation__c ,Contact__r.Stock_Equity__c ,Contact__r.Allowance__c,Contact__r.Company_Name_French__c,Contact__r.Base_Salary__c,Contact__r.Bonus__c,Contact__r.Other__c,Contact__r.Comp__c FROM Application__c Where Contact__c =: Conid and mandate__c =:mandateId  limit 1];
            return applicationRec;
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return null;
        }
        
    }
    /*@AuraEnabled
    public static List<Application__c> getBDList(String Conid){
        try{
            List<Application__c> applicationList = [SELECT Id,Board_of_Director__c,Contact__c,Contact__r.Name,Current_Company_EN__c,Current_Title__c,Name,Stage__c,Status_Of_Ass__c,Mandate__r.Name,Mandate__r.Company__r.Name FROM Application__c WHERE Contact__c =: Conid AND Board_of_Director__c = true ];
            return applicationList;
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return null;
        }
        
    }
    @AuraEnabled
    public static string updatingBoardDirectorlist(List<String> applicationId){
        try{
            System.debug('applicationId::'+applicationId);
            List<Application__c> applicationList = [SELECT Id,Board_of_Director__c FROM Application__c WHERE Id =: applicationId ];
            for(Application__c apprec : applicationList){
                apprec.Board_of_Director__c = false;
            }
            System.debug('applicationId::'+applicationId);
            update applicationList;
            
            return 'Success';
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return 'error';
        }
    }*/
    
    @AuraEnabled
    public static String updateLinkedIn(String linkedInUrl,String Direct,String Phone,String Email,String Conid,String Title,String TitleFr,String applicationId, String origin,String locationState, string locationCity ){
        try{
            system.debug('locationState'+locationState);
            system.debug('locationCity'+locationCity);
            system.debug('Title'+Title);
            system.debug('Title'+Phone);
            contact Conrecdata = [SELECT Name,Email__c,Email,LinkedIn_URL__c,Title_FR__c,Residence_State__c,Residence_City__c,MobilePhone,phone,title__c,Office_State__c,Office_City__c FROM Contact where id=:Conid limit 1];
            Conrecdata.LinkedIn_URL__c = linkedInUrl != null? linkedInUrl:Conrecdata.LinkedIn_URL__c ;
            Conrecdata.Phone = phone != null? phone:Conrecdata.Phone ;
            Conrecdata.MobilePhone = Direct != null? Direct:Conrecdata.MobilePhone ;
            Conrecdata.Email = Email != null? Email:Conrecdata.Email ;
            Conrecdata.title__c = Title != null? Title:Conrecdata.title__c ;
            Conrecdata.Title_FR__c = TitleFr != null? TitleFr:Conrecdata.Title_FR__c ;
            Conrecdata.Residence_State__c  = locationState != null?locationState:Conrecdata.Residence_State__c;
            Conrecdata.Residence_City__c  = locationCity != null?locationCity:Conrecdata.Residence_City__c;
            //Conrecdata.Office_State__c  = locationState != null?locationState:Conrecdata.Office_State__c;
            //Conrecdata.Office_City__c  = locationCity != null?locationCity:Conrecdata.Office_City__c;
            update Conrecdata;
            
            if(!string.isBlank(applicationId) && !string.isBlank(origin)){
                Application__c applicatinData = [Select Id,Origin__c From Application__c Where Id =: applicationId limit 1];
                applicatinData.Origin__c= origin != null?origin: applicatinData.Origin__c;
                update applicatinData;
            }
            return 'Success';
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return null;
        }
        
    }
    @AuraEnabled
    public static List<String> getPickListValuesIntoList(String strObjectName, String strPicklistField){
        system.debug('strObjectName::'+strObjectName);
        system.debug('strPicklistField::'+strPicklistField);
        if(!string.isBlank(strObjectName) && !string.isBlank(strPicklistField)){
            List<String> pickListValuesList= new List<String>();
            Map<String, String> mapPickListValues = new Map<String, String>();
            Schema.SObjectType objSobjectType = Schema.getGlobalDescribe().get(strObjectName);
            Schema.DescribeSObjectResult objDescribeSobject = objSobjectType.getDescribe();
            Map<String, Schema.SObjectField> mapFields = objDescribeSobject.fields.getMap();
            List<Schema.PicklistEntry> lstPickListValues = mapFields.get(strPicklistField).getDescribe().getPickListValues();
            for( Schema.PicklistEntry pickListVal : lstPickListValues){
                pickListValuesList.add(pickListVal.getLabel());
            }     
            system.debug('pickListValuesList::>'+pickListValuesList);
            return pickListValuesList;
        }
        return null;
    }
}