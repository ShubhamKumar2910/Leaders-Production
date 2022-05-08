trigger DeleteOnePagerResponse on One_Pager__c (before delete,before Update) {
    
    if(Trigger.IsBefore && Trigger.IsDelete )
    {   system.debug('Trigger is running');
     DeleteOnePagerResponseHelper.Del_One_Pager_Response(Trigger.Old);
    }
   
    if(Trigger.IsBefore && Trigger.Isupdate )
    {
        system.debug('Trigger is running');
        DeleteOnePagerResponseHelper.update_One_Pager_Response(Trigger.new,Trigger.oldMap);
        
    }
}