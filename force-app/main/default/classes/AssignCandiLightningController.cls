public class AssignCandiLightningController {
    
    @AuraEnabled public List<Application__c> applicationList {get; set;}
    @AuraEnabled public list<ResultWrapper> resultWrapperList{get;set;}
    
    public String candidateIdSelected {get;set;}
    public Boolean candidateIsSelected {get;set;}
    
    @AuraEnabled
    public static Map<String,Object> fetchCandidatesList( String AssignId ,String PageType){
        system.debug('PageType::'+PageType);
        String recId = AssignId;
        String pageTypeName = PageType;
        system.debug('pageTypeName'+pageTypeName);
        String filter = '';
        String sortFullExp = ' InternalTopStatus__c DESC , Contact__r.LastName ASC';
        if(pageTypeName == 'ClientListPage')
        {
            filter = ' AND Status_Summary_Line__c =\'Client.\'';
        }
        else if(pageTypeName == 'RawListPage'){
            filter = ' AND ( Status_Summary_Line__c =\'Private\' OR Status_Summary_Line__c = Null )';
        }
        else if(pageTypeName == 'SourceListPage'){
            filter = ' AND (Status_Summary_Line__c =\'Identified as a source.\' OR Status_Summary_Line__c =\'Source [Not included in the report].\'  )';
        }
        else if(pageTypeName == 'CandidateListPage') {
            filter = ' AND Status_Summary_Line__c !=\'Identified as a source.\' AND Status_Summary_Line__c !=\'Source [Not included in the report].\'  AND Status_Summary_Line__c !=\'Client.\' AND Status_Summary_Line__c !=\'Private\' AND Status_Summary_Line__C != null';   
        }  
        else if(pageTypeName == 'HVCPage') {
            filter = ' AND Status_Summary_Line__c !=\'Identified as a source.\' AND Status_Summary_Line__c !=\'Source [Not included in the report].\'  AND Status_Summary_Line__c !=\'Client.\' AND Status_Summary_Line__c !=\'Private\' AND Status_Summary_Line__C != null';  
            sortFullExp = ' High_Value_Candidate__c DESC,InternalTopStatus__c DESC , Contact__r.LastName ASC';
        } 
        else {
            system.debug('in the else');
            filter = ' AND Assigned_To__c  = :pageTypeName';   
        }  
        system.debug('filter'+filter);
        system.debug('sortFullExp'+sortFullExp);
        List<Application__c> applicationList = new List<Application__c>();
        List<Application__c> potentialList = new List<Application__c>();
        List<Application__c> statusList = new List<Application__c>();
        
        Map<String, String> lastCVByContactId = new Map<String, String>(); 
        Map<String, String> nbOnePagerByContactId = new Map<String, String>();
        Map<String, String> nbBioByContactId = new Map<String, String>();
        Map<String, String> psyByContactId = new Map<String, String>();
        system.debug('filter::'+filter);
        system.debug('sortFullExp::'+sortFullExp);
        Set<Id> contactIds = new Set<Id>();
        applicationList = Database.query(' Select Id,Origin__c, CreatedDate, Name,Self_Assesment_Updated__c,Self_Assesment_Status__c,Has_One_Pager__c,Interview_Date__c'+
                                         ',Contact__r.hasCV__c,Contact__r.Has_Psy__c,Contact__r.Off_Limit__c'+
                                         ',Contact__r.Off_Limit_Auto__c'+
                                         ',Contact__r.Contact_Off_Limit__c'+
                                         ',Contact__r.Origin__c, Contact__c,'+
                                         ' CompanyId__c, Contact__r.Name, Contact__r.FirstName,'+
                                         ' Contact__r.LastName,Contact__r.Has_Bio__c, Current_Title__c,Current_Title_French__c,Mandate_Language__c,'+
                                         ' Potential_Candidate__c,Potential_Candidates_For_Rollup__c, Status_Summary_Line__c,'+
                                         ' Current_Company_EN__c,Contact__r.Phone,'+
                                         ' Contact__r.MobilePhone, Contact__r.Email,'+
                                         ' Contact__r.Account.Phone, InternalTopStatus__c,'+
                                         'Contact__r.LinkedIn_URL__c,'+
                                         'Schedule_Interview_Time__c,'+
                                         ' First_Name__c, Last_Name__c,'+
                                         ' LastModifiedDate ,LastModifiedBy.FirstName, LastModifiedBy.LastName,Contact__r.Board_Member_Icon__c,High_Value_Candidate__c, Board_of_Director__c,Location__c,Location_State__c,Location_City__c'+
                                         ' from Application__c where Mandate__c = \''+ recId +'\' '+filter+'  order by ' + sortFullExp+' ');
        system.debug('applicationList'+applicationList.size());
        Mandate__c mandRec = [SELECT Name,sortDirection__c,sortExpression__c,Id,Company__r.Name,Client_interviews__c,Leaders_interviews__c,number_of_days__c,Document_Type__c,Number_of_potential_candidates__c,Assignment_Status__c FROM Mandate__c WHERE Id = : recId];
        set<id> conIds = new set<id>();
        Integer i = 0;
        for(Application__c app :applicationList)
        {
            i++;
            if(i<200){
                conIds.add(app.Contact__c);    
            }
            if(app.InternalTopStatus__c)
            {
                potentialList.add(app);
            }
            else{
                statusList.add(app);
            }
            if(app.Contact__c!=null)
                contactIds.add(app.Contact__c);
        }
        
        List<application__c> appList = [Select id,mandate__r.name ,Contact__c,mandate__r.Assignment_Status__c from application__c where Contact__c in : conIds Limit 5000];//Assignment_Status__c 
        system.debug('appList'+appList.size());
        map<id,map<string,Integer>> AssignmentsCountByconWithStatus = new map<id,map<string,Integer>>();
        
        if(appList.size() > 5000 && conIds.size() > 500){
            system.debug('appList'+appList.size()+'conIds.size()'+conIds.size());
        }else{
            for(String conid : conIds){
                map<string,Integer> assStatuswithCount = new map<string,Integer>();
                for(application__c ap : appList ){
                    if(ap.Contact__c == conid){
                        if(!assStatuswithCount.ContainsKey(ap.mandate__r.Assignment_Status__c)){
                            assStatuswithCount.put(ap.mandate__r.Assignment_Status__c,1);
                        }else{
                            assStatuswithCount.put(ap.mandate__r.Assignment_Status__c,assStatuswithCount.get(ap.mandate__r.Assignment_Status__c)+1);
                        } 
                    }
                }
                AssignmentsCountByconWithStatus.put(conid,assStatuswithCount);
            }
        }
        
        system.debug('AssignmentsCountByconWithStatus'+AssignmentsCountByconWithStatus);
        for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE '%One Page%' ORDER BY LastModifiedDate DESC ]) {
            if(!nbOnePagerByContactId.containsKey(String.valueOf(result.ParentId))) {
                nbOnePagerByContactId.put(String.valueOf(result.ParentId),String.valueOf(result.Id));
            }
        }
        
        for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE '%Candidate Biography%' ORDER BY LastModifiedDate DESC ]) {
            if(!nbBioByContactId.containsKey(String.valueOf(result.ParentId))) {
                nbBioByContactId.put(String.valueOf(result.ParentId),String.valueOf(result.Id));
            }
        }
        
        for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE '%CV%' ORDER BY LastModifiedDate DESC]) {
            if(!lastCVByContactId.containsKey(String.valueOf(result.ParentId)))
                lastCVByContactId.put(String.valueOf(result.ParentId),String.valueOf(result.Id));              
        }
        for(Attachment result: [SELECT Id, ParentId FROM Attachment WHERE ParentId IN :contactIds AND Name LIKE '%PSY%' ORDER BY LastModifiedDate DESC]) {
            if(!psyByContactId.containsKey(String.valueOf(result.ParentId)))
                psyByContactId.put(String.valueOf(result.ParentId),String.valueOf(result.Id));              
        }
        
        List<ResultWrapper> resultWrapperList = new List<ResultWrapper>();
        for (Application__c app : applicationList){
            ResultWrapper rw = new ResultWrapper(app);
            
            if(app.Contact__c!=null) {
                if(app.Contact__r.hasCV__c) {
                    rw.hasCV = true;
                    if(lastCVByContactId.containsKey(String.valueOf(app.Contact__c)))
                        rw.cvId = lastCVByContactId.get(String.valueOf(app.Contact__c));
                }
                if(nbOnePagerByContactId.containsKey(String.valueOf(app.Contact__c)))
                    rw.hasOnePager = true;
                rw.opId = nbOnePagerByContactId.get(String.valueOf(app.Contact__c));
                
                if(nbBioByContactId.containsKey(String.valueOf(app.Contact__c)))
                    rw.hasBio = true;
                rw.bioId  = nbBioByContactId.get(String.valueOf(app.Contact__c));
                
                if(app.Contact__r.Has_Psy__c) {
                    rw.hasPsy = true;
                    if(psyByContactId.containsKey(String.valueOf(app.Contact__c)))
                        rw.hasPsy = true;
                    rw.psyId = psyByContactId.get(String.valueOf(app.Contact__c));    
                }
                
                if( AssignmentsCountByconWithStatus.get(app.Contact__c) != null) {
                    if(AssignmentsCountByconWithStatus.get(app.Contact__c).get('Active') > 1 ){
                        rw.buttonClass = 'redButton';
                    }else{
                        rw.buttonClass = 'blue';
                    }
                }
                app.Button_Class__c = rw.buttonClass;
                resultWrapperList.add(rw);
            }
        }
        system.debug('result'+resultWrapperList);
        
        Map<String,Object> returnObj = new Map<String,Object>{'resultList' => resultWrapperList, 'mandate' => mandRec};
            return returnObj;
    } 
    
    
    @AuraEnabled
    public static List<ResultWrapper> selectPotentialCandidates(List<ResultWrapper> rwList){
        
        system.debug('rwList'+rwList);
        List<ResultWrapper> resultWrapperList;
        
        for(ResultWrapper r : rwList){
            if(r.candidate.InternalTopStatus__c){
                system.debug('Internal Top Status: True');
                r.selected = true;
            }else{
                r.selected= false;
            }
            
            resultWrapperList.add(r);
        }
        
        system.debug(resultWrapperList);
        return resultWrapperList;
    }
    
    @AuraEnabled
    public static String DeleteAssignedListfromCan(String manId,String ListName,String subList){
        
        system.debug('ListName'+ListName+'subList'+subList);
        if(subList != null && subList != ''){
            mandate__c man = new mandate__c(id=manId,Sublist__c = subList);
            update man;
        }
        
        List<Application__c> CanList = [SELECT Assigned_To__c FROM Application__c WHERE Assigned_To__c = :ListName and mandate__c =:ManId];
        system.debug('CanList'+CanList.size());
        for(Application__c app : CanList){
            app.Assigned_To__c = '';
        }
        update CanList;
        return 'Success';
    }
    
    public class WrapperCandidatesList{
        @AuraEnabled public List<Application__c> listCandidates{get;set;}
        //     @AuraEnabled public List<ResultWrapper> resultWrapperList {get; set;}
        
    }
    
    
    public class ResultWrapper
    {
        @AuraEnabled public boolean selected {get;set;}
        @AuraEnabled public Application__c candidate {get; set;}
        @AuraEnabled public boolean hasCV {get;set;}
        @AuraEnabled public boolean Off_Limit_Auto {get; set;}
        @AuraEnabled public boolean Contact_Off_Limit {get; set;}
        @AuraEnabled public boolean hasOnePager {get;set;}
        @AuraEnabled public boolean hasBio {get;set;}
        @AuraEnabled public boolean hasPsy {get;set;}
        @AuraEnabled public boolean hasJobDescription {get;set;}
        @AuraEnabled public DateTime lastModifiedDate {get;set;}
        @AuraEnabled public String sortBy = 'CV';
        @AuraEnabled public String sortDirection = 'ASC';
        @AuraEnabled public String cvId {get;set;}
        @AuraEnabled public String psyId {get;set;}
        @AuraEnabled public String opId {get;set;}
        @AuraEnabled public String bioId {get;set;}
        @AuraEnabled public String buttonClass {get;set;}
        @AuraEnabled public String noteTitle {get;set;}
        
        
        public ResultWrapper()
        {
            
        }
        
        
        public ResultWrapper(Application__c candidate)
        {
            this.candidate = candidate;
            selected = false;
            hasCV = false;
            hasOnePager = false;
            hasJobDescription = false;
        }
        
    }
    
    @AuraEnabled
    public static List < String > deleteRecords(List < String > lstRecordId) {
        // for store Error Messages  
        List < String > oErrorMsg = new List < String > ();
        // Query Records for delete where id in lstRecordId [which is pass from client side controller] 
        List < Application__c > lstDeleteRec = [select Id from Application__c where id IN: lstRecordId];
        
        Database.DeleteResult[] DR_Dels = Database.delete(lstDeleteRec, false);
        for (Database.DeleteResult dr: DR_Dels) {
            if (dr.isSuccess()) {
                system.debug('successful delete contact');
            } else {
                oErrorMsg.add('');
                for (Database.Error err: dr.getErrors()) {
                    oErrorMsg.add(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
        return oErrorMsg;
        
    }
    
    @future(Callout = true)
    public static void Generate_Self_Ass_Future(String appId)
    {
        try{
            system.debug('appid'+appId);
            
            Application__c app = [select Self_Assesment_Link__c,Self_Assesment_Fr_Link__c,Language__c from application__c where id =:appid];
            
            system.debug('Language'+app.Language__c);
            
            if(app.Language__c.toLowerCase() == 'english')
            {
                string attachmentId = CongaHelperToolLightning.generateReport(app.Self_Assesment_Link__c,null,null,null,null);       
                system.debug('attachmentId '+attachmentId);
                
            }   
            else
            {
                string attachmentId = CongaHelperToolLightning.generateReport(app.Self_Assesment_Fr_Link__c,null,null,null,null);
                system.debug('attachmentId '+attachmentId);
                
            }
            
        }
        catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            
        }
        
    }
    @AuraEnabled
    public static wrapMandate Get_Lang(String manId)
    {      
        Boolean onePager_Created = false;
        Boolean selfAss_Created = false;
        boolean is_English = false;
        Boolean Is_Radar_Created  = false;
        Boolean Is_Ref_Created  = false;
        
        List<One_Pager__c> One_Pager_List =  [select English__c,French__c from One_Pager__c where Mandate__c =: manId ];
        
        if(One_Pager_List.size() > 0 ){
            onePager_Created =true;
        }
        
        List<Reference__c> Ref_List =  [select Reference_Ques__c,Reference_Fr_Ques__c from Reference__c where Assignment__c =: manId ];
        
        if(Ref_List.size() > 0 ){
            Is_Ref_Created =true;
        }
        
        List<Radar_Rating__c> Radar_List =  [select Radar_Rating_Fr_Ques__c,Radar_Rating_Ques__c,Assignment__c from Radar_Rating__c  where Assignment__c =:manId ];
        
        if(Radar_List.size() > 0 ){
            Is_Radar_Created =true;
        }
        
        List<Self_Assesment__c > selfAssList =  [select English__c,French__c,Assignment_Research__c from Self_Assesment__c  where Assignment_Research__c =: manId ];
        
        if(selfAssList.size() > 0){
            selfAss_Created = true;
        }
        
        Mandate__c man = [Select id , Language__c,Sublist__c  from mandate__C where id=:manId];
        if(man.Language__c == 'English')
        {
            is_English =true;
        }
        List<Boolean> Booleanvalues = new List<Boolean>();
        
        Booleanvalues.add(onePager_Created);
        Booleanvalues.add(selfAss_Created);
        Booleanvalues.add(is_English);
        Booleanvalues.add(Is_Radar_Created);
        Booleanvalues.add(Is_Ref_Created);
        
        wrapMandate wm = new wrapMandate(man,Booleanvalues);
        system.debug('wm'+wm);
        return wm;
    }
    
    @AuraEnabled
    public static String Generate_Self_Ass(String appId)
    {
        Generate_Self_Ass_Future(appId);
        
        update new application__c(id = appId,Self_Assesment_Status__c = 'Template Generated');
        
        return 'SUCCESS';
    }
    
    
    @AuraEnabled
    public static String generateSublist(String sublist,String manId)
    {
        system.debug('appid'+sublist);
        update new Mandate__c(id = manId,Sublist__c = sublist);
        
        return 'SUCCESS';
    }
    
    @AuraEnabled
    public static String assignSublist(List<String> CanIds,String SublistName)
    {
        system.debug('appid'+CanIds);
        
        List<Application__c> appList = [select id , name , Assigned_To__c from application__c where Id In:CanIds];
        for(Application__c app : appList){
            app.Assigned_To__c = SublistName;
        }
        
        update appList;
        
        return 'SUCCESS';
    }
    
    @AuraEnabled
    public static List<Application__c> get_Attach_id(String recordId,String mandateId)
    {
        try{
            system.debug('appid'+recordId);
            List<Application__c> canList = [Select Id,name , Self_Assessment_Date__c ,(Select id,Name from Attachments where name LIKE '%Self Assesment%' order by createdDate Desc) from Application__c  where Contact__c=:recordId AND Mandate__c =:mandateId];
            
            return canList;
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return null;
        }
        
    }
    @AuraEnabled
    public static List<Application__c> get_Attach_id_OnePager(String recordId,String mandateId)
    {
        try{
            system.debug('appid'+recordId);
            List<Application__c> canList = [Select Id,name ,(Select id,Name from Attachments where name LIKE '%One Pager%' order by createdDate Desc) from Application__c  where Contact__c=:recordId AND mandate__c =:mandateId ];
            
            return canList;
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return null;
        }
        
    }
    @AuraEnabled
    public static Map<Object,Object> Get_Data_For_Tool_Tip(String recordId,String mandateId)
    {
        try{
            system.debug('appid'+recordId);
            Map<Object,Object> allCandidatesBySSL = new Map<Object,Object>();
            List<AggregateResult> canList = [SELECT Status_Summary_Line__c , COUNT(Name) FROM Meeting_Note__c GROUP BY Status_Summary_Line__c]; 
            
            //SELECT Status_Summary_Line__c,COUNT(nAME) FROM Meeting_Note__c WHERE Madate_Id__c = 'a01U000001PuLSY' GROUP BY Status_Summary_Line__c
            
            for(AggregateResult agr :canList )
            {
                allCandidatesBySSL.put(agr.get('Status_Summary_Line__c'),agr.get('expr0'));
                
            }
            return allCandidatesBySSL;
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return null;
        }
    } 
    public class wrapMandate {
        @AuraEnabled 
        public Mandate__c mac {get; set;}
        @AuraEnabled 
        public List<Boolean> selected {get; set;}
        
        //This is the contructor method. When we create a new wrapAccount object we pass a Account that is set to the acc property. We also set the selected value to false
        public wrapMandate(Mandate__c mac,List<Boolean> selected) {
            this.mac = mac;
            this.selected = selected;
        }
    }
    @AuraEnabled
    public static string updateHVConCandidate(List<String> candidateId)
    {
        List<Application__c> candToUpdateHighValue = new List<Application__c>();
        try{
            system.debug('appid'+candidateId);
            if(!candidateId.isEmpty()){
                candToUpdateHighValue = [Select Id,High_Value_Candidate__c  From Application__c Where Id in: candidateId];
                system.debug('candToUpdateHighValue'+candToUpdateHighValue);
                if(!candToUpdateHighValue.isEmpty()){
                    for(Application__c appRec : candToUpdateHighValue){
                        appRec.High_Value_Candidate__c = true;
                    }
                    system.debug('candToUpdateHighValue'+candToUpdateHighValue);
                    update candToUpdateHighValue;
                }
            }
            return 'Success';
        }catch(Exception e){
            System.debug('@@@@@'+e.getLineNumber()+'@@@'+e.getMessage());
            return 'Error';
        }
    } 
}