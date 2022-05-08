public class BatchForUpdatingSSLinMN implements Database.Batchable<sObject>, Database.Stateful {
    
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id,Rel_Ass_SSL__c,Status_Summary_Line__c FROM Meeting_Note__c WHERE Is_SSL_Similar__c = false AND Most_Recent__c = true' );
    }
    public void execute(Database.BatchableContext bc, List<Meeting_Note__c> scope){
        List<Meeting_Note__c> newlist = new List<Meeting_Note__c>();
        
        List<SSL_Values_Conversion__c> customSettingData = [select SSL_English__c,SSL_French__c	 from SSL_Values_Conversion__c];
        Map<String,String> SslValuesMap = new Map<String,String>() ;    
        
        for( SSL_Values_Conversion__c Ssl: customSettingData){
            SslValuesMap.put(Ssl.SSL_English__c,Ssl.SSL_French__c);
        }
        system.debug('SslValuesMap'+SslValuesMap);
        
        for(Meeting_Note__c mn : scope){
            mn.Status_Summary_Line__c = mn.Rel_Ass_SSL__c;
            mn.Status_Summary_Line_French__c = SslValuesMap.get(mn.Rel_Ass_SSL__c);
            newlist.add(mn);
        }
        
        try{
            update newlist;
        }catch(Exception e){
            System.debug('@@@'+e.getMessage());
        }
    }
    public void finish(Database.BatchableContext bc){
        system.debug('recordsProcessed'+recordsProcessed);    
    }
}