public class BatchForUpdatingLocations implements Database.Batchable<sObject>, Database.Stateful {
    
    public Integer recordsProcessed = 0;
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'select id,AccountId,Office_State__c,Office_city__c,office_Country__c from contact where (Account.city__c != null OR Account.state__c != null ) and (Office_City__c = null AND Office_State__c = null AND office_Country__c = null)' );
    }
    public void execute(Database.BatchableContext bc, List<Contact> scope){
        List<Contact> Contacts = new List<Contact>();
        
        set<String> accIds 	= new set<String>();
        map<Id,Account> cityandstateBYaccId = new map<Id,Account>();
        for(Contact con : scope){
            accIds.add(con.AccountId);
        }
        List<Account> CompanyLocation = [select id ,Country__c, City__c , State__c from account where id IN :accIds];
        
        for(Account acc:CompanyLocation){
            cityandstateBYaccId.put(acc.Id,acc);
        }
        for(Contact c: scope)
        {
            if(c.AccountId != null && (c.Office_City__c == null && c.Office_State__c == null)){
                c.Office_City__c = cityandstateBYaccId.get(c.AccountId).City__c;
                c.Office_State__c = cityandstateBYaccId.get(c.AccountId).State__c;
                c.Office_Country__c = cityandstateBYaccId.get(c.AccountId).Country__c ;
                Contacts.add(c);
            }
        }
        
        
        try{
            update Contacts;
        }catch(Exception e){
            System.debug('@@@'+e.getMessage());
        }
    }
    public void finish(Database.BatchableContext bc){
        system.debug('recordsProcessed'+recordsProcessed);    
    }
}