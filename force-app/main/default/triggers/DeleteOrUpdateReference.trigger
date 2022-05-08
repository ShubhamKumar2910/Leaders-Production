trigger DeleteOrUpdateReference on Reference__c (before delete,before Update) {
    
    if(Trigger.IsBefore && Trigger.IsDelete )
    {   system.debug('Trigger is running :: BEFORE DELETE');
     DeleteOnePagerResponseHelper.Del_Reference_Response(Trigger.Old);
    }
    
    if(Trigger.IsBefore && Trigger.Isupdate )
    {
        system.debug('Trigger is running :: BEFORE UPDATE');
        DeleteOnePagerResponseHelper.update_Reference_Response(Trigger.new,Trigger.oldMap);
    }
}