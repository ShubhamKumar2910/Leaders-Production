public class SearchEnginApexCtrlHelper {
    
    public static void deleteOrMergeAccount(string winnerRecId , List<string> LooserRecIds){
        try{
            System.debug( 'winnerRecIds '+ winnerRecId);
            System.debug( 'LooserRecIds '+ LooserRecIds);
            List<Contact> ConListToBeUpdated							= new List<Contact>();
            List<Business_Development__c> BDListToBeUdated			= new List<Business_Development__c>();
            List<Mandate__c> AssListToBeUpdated						= new List<Mandate__c>();
            
            List<Contact> conData = [SELECT Id,AccountId FROM Contact WHERE AccountId IN :LooserRecIds];
            if(conData.size() > 0){
                for(Contact con:conData){
                    con.AccountId = winnerRecId;
                    ConListToBeUpdated.add(con);
                }    
            }
            List<Mandate__c> AssData = [SELECT id,Company__c FROM Mandate__c WHERE Company__c IN :LooserRecIds];
            if(AssData.size() > 0){
                for(Mandate__c man:AssData){
                    man.Company__c = winnerRecId;
                    AssListToBeUpdated.add(man);
                }    
            }
            List<Business_Development__c  > BDData = [SELECT id,Account_Name__c FROM Business_Development__c  WHERE Account_Name__c  IN :LooserRecIds];
            if(BDData.size() > 0){
                for(Business_Development__c BD:BDData){
                    BD.Account_Name__c = winnerRecId;
                    BDListToBeUdated.add(BD);
                }    
            }
            if(ConListToBeUpdated.size() > 0){
                system.debug('ConListToBeUpdated.size()'+ConListToBeUpdated.size());
                update ConListToBeUpdated;
            }
            if(AssData.size() > 0){
                system.debug('AssData.size()'+AssData.size());
                update AssData;
            }
            if(BDData.size() > 0){
                system.debug('BDData.size()'+BDData.size());
                update BDData;
            }
            
            
        }catch(Exception e){
            System.debug( e.getMessage() +'at '+ e.getLineNumber());
        }
    }
    
    public static void deleteOrMergeRelatedAssignment(string winnerRecId , List<string> LooserRecIds){
        try{
            List<Application__c> appListToBeInserted			= new List<Application__c>();
            List<Application__c> appListToBeUpdated			= new List<Application__c>();
            
            Set<ID> idsOfAppforDeleted = new Set<ID>();
            Set<String> winnerMandateIds = new Set<String>();
            
            for(Application__c app:[select Id,Contact__c,Name,Mandate__c from Application__c where Contact__c =:winnerRecId  ]){
                winnerMandateIds.add(app.Mandate__c);
            }
            system.debug('winnerMandateIds'+winnerMandateIds);
            for(Application__c app:[select Id,Contact__c,Name,Mandate__c from Application__c where Contact__c IN:LooserRecIds ]){
                
                if(! winnerMandateIds.contains(app.Mandate__c)){
                    app.Contact__c = winnerRecId;
                    appListToBeUpdated.add(app);
                }
            }
            
            System.debug( 'appListToBeUpdated '+ appListToBeUpdated);
            if(!appListToBeInserted.isEmpty()){
                insert appListToBeInserted;
            }
            if(!appListToBeUpdated.isEmpty()){
                system.debug('appListToBeUpdated.size()'+appListToBeUpdated.size());
                update appListToBeUpdated;
            }
        }catch(Exception e){
            System.debug( e.getMessage() +'at '+ e.getLineNumber());
        }
    }
    
    public static void deleteOrMergeActivity(string ObjectName,String winnerRecId,List<String> LooserRecIds){
        try{
            List<Task> taskListToBeUpdate					=  new List<Task>();
            if(ObjectName == 'Contact'){
                for(Task taskRec:[select Id,WhoId,whatid,Status,Subject from Task where ( WhoId IN:LooserRecIds ) limit 1000 ALL ROWS]){                   
                    taskRec.WhoId = winnerRecId;
                    taskListToBeUpdate.add(taskRec);
                }    
            }else{
                for(Task taskRec:[select Id,WhoId,whatid,Status,Subject from Task where (WhatId IN:LooserRecIds) limit 1000 ALL ROWS]){                   
                    taskRec.whatid = winnerRecId; 
                    taskListToBeUpdate.add(taskRec);
                }
            }
            
            System.debug('taskListToBeUpdate='+taskListToBeUpdate);
            if(!taskListToBeUpdate.isEmpty()){
                system.debug('taskListToBeUpdate.size()'+taskListToBeUpdate.size());
                update taskListToBeUpdate;
            }
        }catch(Exception e){
            System.debug( e.getMessage() +'at '+ e.getLineNumber());
            throw new AuraHandledException('Error :'+e.getMessage() +'at '+ e.getLineNumber());
        }
    }
    @future
    public static void deleteNotesAndAttachment(string winnerRecId , List<string> LooserRecIds){
        try{
            List<Note> noteListToBeUpdate 					= new List<Note>();
            List<Attachment> attachListToBeUpdate 			= new List<Attachment>();
            
            for(Attachment attRec:[Select Id,ParentId,Body,Name from Attachment where ParentId IN:LooserRecIds ALL ROWS]){
                attachListToBeUpdate.add(new Attachment(parentId=winnerRecId,Name=attRec.Name,Body=attRec.Body));
            }       
            
            for(Note nRec:[select Id,Body,Title from Note where ParentId IN:LooserRecIds ALL ROWS]){
                noteListToBeUpdate.add(new Note(ParentId=winnerRecId,Body=nRec.Body,Title=nRec.Title));
            }
            System.debug('noteListToBeUpdate==>'+noteListToBeUpdate);
            System.debug('attachListToBeUpdate==>'+attachListToBeUpdate);
            
            if(!noteListToBeUpdate.isEmpty()){
                system.debug('noteListToBeUpdate.size()'+noteListToBeUpdate.size());
                upsert noteListToBeUpdate;            
            }
            if(!attachListToBeUpdate.isEmpty()){
                system.debug('attachListToBeUpdate.size()'+attachListToBeUpdate.size());
                upsert attachListToBeUpdate;            
            }
            
        }catch(Exception e){
            System.debug( e.getMessage() +'at '+ e.getLineNumber());
        }
    }
    @future
    public static void deleteFiles(string winnerRecId , List<string> LooserRecIds){
        Savepoint sp = Database.setSavepoint();
        try{
            List<ContentDocumentLink> fileListToBeUpdate 					= new List<ContentDocumentLink>();
            List<ContentDocumentLink> Existingfiles  =  [select ContentDocumentId,LinkedEntityId,ShareType,Visibility from ContentDocumentLink where LinkedEntityId IN:LooserRecIds];
            if(Existingfiles.size() > 0){
                for(ContentDocumentLink cdl : Existingfiles){
                    ContentDocumentLink ccddll = new ContentDocumentLink();
                    ccddll.ContentDocumentId = cdl.ContentDocumentId;
                    ccddll.LinkedEntityId = winnerRecId;
                    ccddll.ShareType = 'V';
                    fileListToBeUpdate.add(ccddll);                 
                }
                System.debug('fileListToBeUpdate='+fileListToBeUpdate);
                if(fileListToBeUpdate.size()>0){
                    system.debug('fileListToBeUpdate.size()'+fileListToBeUpdate.size());
                    upsert fileListToBeUpdate;
                }
            }
        }catch(Exception e){
            System.debug( e.getMessage() +'at '+ e.getLineNumber()+e.getCause());
        }
    }
}