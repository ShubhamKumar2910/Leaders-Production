trigger DeleteRadarRating on Radar_Rating__c (before delete , before update) {
    if(Trigger.IsBefore && Trigger.IsDelete )
    {
        system.debug('Trigger is running');
        DeleteOnePagerResponseHelper.Del_Radar_Rating_Response(Trigger.Old);
        
    }
	if(Trigger.IsBefore && Trigger.Isupdate )
    {
        system.debug('Trigger is running');
        DeleteOnePagerResponseHelper.update_Radar_Rating_Response(Trigger.new,Trigger.oldMap);
        
    }
}