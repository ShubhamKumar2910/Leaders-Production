public class ReferenceHelper {

     @AuraEnabled 
    public static list<Reference__c> ReferenceValues(String mandateRecId){
        
        //Assignment_language__c,Assignment__c,Ass_language__c,Name,Reference_Fr_Ques__c,Reference_Ques__c,Seq_Number__c,
        List<Reference__c > RefList =  [select Reference_Fr_Ques__c,Reference_Ques__c,Ass_language__c,Assignment__c,Seq_Number__c from Reference__c  where Assignment__c =: mandateRecId ];
        List<Reference_Value__c> customSettingData = [select name,French__c from Reference_Value__c];
        List<Reference__c > newRefList = new List<Reference__c >();
        List<Reference__c> Reference_List =  [select Reference_Ques__c,Reference_Fr_Ques__c from Reference__c where Assignment__c =: mandateRecId ];
		List<One_Pager__c> One_Pager_List =  [select English__c,French__c from One_Pager__c where Mandate__c =: mandateRecId ];
        String AssLang = [SELECT Language__c FROM Mandate__c WHERE Id =:mandateRecId].Language__c;
        
        if(RefList.size() > 0){
            return  RefList;
        }else{
            if(One_Pager_List.size() > 0){
                for(One_Pager__c op:One_Pager_List ){
                    newRefList.add(new Reference__c(Reference_Ques__c = op.English__c,Assignment_language__c=AssLang,Reference_Fr_Ques__c = op.French__c,Assignment__c = mandateRecId));}
            }else{
                for(Reference_Value__c ra :customSettingData)
                {
                    newRefList.add(new Reference__c(Reference_Ques__c = ra.Name,Assignment_language__c=AssLang,Reference_Fr_Ques__c = ra.French__c,Assignment__c = mandateRecId));}
            }
            return newRefList;
        }
    }
    @AuraEnabled 
    public static String createReferences(List<Reference__c> RefList,List<String> deleteList){
        
        List<Reference__c> listToBeUpdated = new List<Reference__c>();
        List<Reference__c> listToBeInserted = new List<Reference__c>();
        
        if(!deleteList.isEmpty()){
            Database.delete(deleteList);
        }
        for(Reference__c ref : RefList ){
            if(ref.Id != null){
                listToBeUpdated.add(ref);
            }else{
                listToBeInserted.add(ref);
            } 
        }
        if(!listToBeUpdated.isEmpty()){
            update listToBeUpdated;
        }
        if(!listToBeInserted.isEmpty()){
            insert listToBeInserted;
        }
        return 'Success';
    }
    
}