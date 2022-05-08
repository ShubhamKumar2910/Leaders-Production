public with sharing class CandidatesListDynamicCompHelper {
    @AuraEnabled 
    public static List<Application__c> getActiveAssignments(String contactId, String mandateId)
    {
        system.debug('contactId::'+contactId);
        system.debug('mandateId::'+mandateId);
        if(!string.isBlank(contactId) ){
            List<Application__c> assignmentsList = new List<Application__c>();
            assignmentsList = [Select Id,Name,Contact__c,Contact__r.Status_Summary_Line__c ,Mandate__c,Mandate__r.Assignment_Status__c,Mandate__r.Company_Name_French__c,Mandate__r.Company__c,Mandate__r.Name,Mandate__r.Mandate_Start_Date__c  from Application__c Where Contact__c =: contactId AND Mandate__r.Assignment_Status__c ='Active' AND Mandate__c != :mandateId];
            system.debug('assignmentsList::'+assignmentsList);
            if(!assignmentsList.isEmpty()){
                return assignmentsList;
            }else{
                return null;
            }
        }else{
            return null;
        }
    }
}