public class DeleteOnePagerResponseHelper {
    // ONE-PAGER
    public static String Del_One_Pager_Response(List<One_Pager__c> OnePagerRec){
        try{
            List<One_Pager_Response__c > ResponseListToBeDeleted = new List<One_Pager_Response__c >(); 
            set<ID> onePagerId = new set<ID>();
            for(One_Pager__c op:OnePagerRec){
                onePagerId.add(op.Id);
            }
            system.debug('onePagerId'+onePagerId);
            ResponseListToBeDeleted = [select id from One_Pager_Response__c where One_Pager__c  IN:onePagerId];
            system.debug('ResponseListToBeDeleted'+ResponseListToBeDeleted);
            delete ResponseListToBeDeleted;
            return 'Success';
        }
        catch(exception e){
            system.debug('Line number of Error'+e.getLineNumber()+'The error is'+e.getMessage());
            return null;
        }
    }
    public static String update_One_Pager_Response(List<One_Pager__c> OnePagerRec,map<id,One_Pager__c> OnePageroldMap){
        try{
            List<One_Pager_Response__c > ResponseListToBeUpdated = new List<One_Pager_Response__c >(); 
            map<string,string> oldAndNewOPValue = new map<string,string>();
            set<ID> OPId = new set<ID>();
            List<String> totalChangedValues = new List<String>();
            for(One_Pager__c rad:OnePagerRec){
                if((OnePageroldMap.get(rad.ID)).English__c != rad.English__c  ) {
                    totalChangedValues.add(OnePageroldMap.get(rad.ID).English__c);
                    oldAndNewOPValue.put(OnePageroldMap.get(rad.ID).English__c,rad.English__c);
                    OPId.add(rad.Id);    
                }
                if((OnePageroldMap.get(rad.ID)).French__c  != rad.French__c){
                    totalChangedValues.add(OnePageroldMap.get(rad.ID).French__c);
                    oldAndNewOPValue.put(OnePageroldMap.get(rad.ID).French__c,rad.French__c );
                    OPId.add(rad.Id);    
                }
            }
            system.debug(oldAndNewOPValue);
            List<One_Pager_Response__c > OPResponses = [select id,Question_Eng__c,Question_Fr__c from One_Pager_Response__c where One_Pager__c  IN:OPId];
            for(One_Pager_Response__c res:OPResponses){
                for(String str:totalChangedValues){
                    if(res.Question_Eng__c == str){
                        res.Question_Eng__c = oldAndNewOPValue.get(str);
                    }
                    if(res.Question_Fr__c == str){
                        res.Question_Fr__c = oldAndNewOPValue.get(str);
                    }
                }
                    ResponseListToBeUpdated.add(res);
            }
            system.debug('ResponseListToBeUpdated'+ResponseListToBeUpdated);
            update ResponseListToBeUpdated;
            return 'Success';
        }
        catch(exception e){
            system.debug('Line number of Error'+e.getLineNumber()+'The error is'+e.getMessage());
            return null;
        }
    }
    
    // REFERENCE 
     public static String Del_Reference_Response(List<Reference__c> RefRec){
        try{
            List<Reference_Response__c > ResponseListToBeDeleted = new List<Reference_Response__c >(); 
            set<ID> refId = new set<ID>();
            for(Reference__c ref:RefRec){
                refId.add(ref.Id);
            }
            system.debug('refId'+refId);
            ResponseListToBeDeleted = [select id from Reference_Response__c where Reference__c IN:refId];
            system.debug('ResponseListToBeDeleted'+ResponseListToBeDeleted);
            delete ResponseListToBeDeleted;
            return 'Success';
        }
        catch(exception e){
            system.debug('Line number of Error'+e.getLineNumber()+'The error is'+e.getMessage());
            return null;
        }
    }
    public static String update_Reference_Response(List<Reference__c> ReferenceRec,map<id,Reference__c> ReferenceoldMap){
        try{
            List<Reference_Response__c > ResponseListToBeUpdated = new List<Reference_Response__c>(); 
            map<string,string> oldAndNewRefValue = new map<string,string>();
            set<ID> RefId = new set<ID>();
            List<String> totalChangedValues = new List<String>();
            for(Reference__c rad:ReferenceRec){
                if((ReferenceoldMap.get(rad.ID)).Reference_Ques__c != rad.Reference_Ques__c  ) {
                    totalChangedValues.add(ReferenceoldMap.get(rad.ID).Reference_Ques__c);
                    oldAndNewRefValue.put(ReferenceoldMap.get(rad.ID).Reference_Ques__c,rad.Reference_Ques__c);
                    RefId.add(rad.Id);    
                }
                if((ReferenceoldMap.get(rad.ID)).Reference_Fr_Ques__c != rad.Reference_Fr_Ques__c ){
                    totalChangedValues.add(ReferenceoldMap.get(rad.ID).Reference_Fr_Ques__c);
                    oldAndNewRefValue.put(ReferenceoldMap.get(rad.ID).Reference_Fr_Ques__c,rad.Reference_Fr_Ques__c );
                    RefId.add(rad.Id);    
                }
            }
            system.debug(oldAndNewRefValue);
            List<Reference_Response__c > RefResponses = [select id,Question_Eng__c,Question_Fr__c from Reference_Response__c where Reference__c IN:RefId];
            for(Reference_Response__c res:RefResponses){
                for(String str:totalChangedValues){
                    if(res.Question_Eng__c == str){
                        res.Question_Eng__c = oldAndNewRefValue.get(str);
                    }
                    if(res.Question_Fr__c == str){
                        res.Question_Fr__c = oldAndNewRefValue.get(str);
                    }
                }
                    ResponseListToBeUpdated.add(res);
            }
            system.debug('ResponseListToBeUpdated'+ResponseListToBeUpdated);
            update ResponseListToBeUpdated;
            return 'Success';
        }
        catch(exception e){
            system.debug('Line number of Error'+e.getLineNumber()+'The error is'+e.getMessage());
            return null;
        }
    }
    // RADAR
    public static String Del_Radar_Rating_Response(List<Radar_Rating__c> RadarRatingRec){
        
        try{
            List<Radar_Rating_Response__c > ResponseListToBeDeleted = new List<Radar_Rating_Response__c >(); 
            
            set<ID> RadarId = new set<ID>();
            
            for(Radar_Rating__c op:RadarRatingRec){
                RadarId.add(op.Id);
            }
            system.debug('RadarId'+RadarId);
            ResponseListToBeDeleted = [select id from Radar_Rating_Response__c where Radar_Rating_Lookup__c IN:RadarId];
            system.debug('ResponseListToBeDeleted'+ResponseListToBeDeleted);
            delete ResponseListToBeDeleted;
            return 'Success';
        }
        catch(exception e){
            system.debug('Line number of Error'+e.getLineNumber()+'The error is'+e.getMessage());
            return null;
        }
    }
    public static String update_Radar_Rating_Response(List<Radar_Rating__c> RadarRatingRec,map<id,Radar_Rating__c> RadarRatingoldMap){
        
        try{
            List<Radar_Rating_Response__c > ResponseListToBeUpdated = new List<Radar_Rating_Response__c >(); 
            List<String> totalChangedValues = new List<String>();
            map<string,string> oldAndNewRadarValue = new map<string,string>();
            String earliervalue ;
            List<String> RadRespEnglish = new List<String>();
            set<ID> RadarId = new set<ID>();
            
            for(Radar_Rating__c rad:RadarRatingRec){
                if((RadarRatingoldMap.get(rad.ID)).Radar_Rating_Ques__c != rad.Radar_Rating_Ques__c ) {
                    Radar_Rating__c oldvalue = RadarRatingoldMap.get(rad.ID);
                    earliervalue = oldvalue.Radar_Rating_Ques__c;
                    totalChangedValues.add(earliervalue);
                    oldAndNewRadarValue.put(earliervalue,rad.Radar_Rating_Ques__c);
                    RadarId.add(rad.Id);    
                }
                if((RadarRatingoldMap.get(rad.ID)).Radar_Rating_Fr_Ques__c != rad.Radar_Rating_Ques__c){
                    Radar_Rating__c oldvalue = RadarRatingoldMap.get(rad.ID);
                    earliervalue = oldvalue.Radar_Rating_Fr_Ques__c ;
                    totalChangedValues.add(earliervalue);
                    oldAndNewRadarValue.put(earliervalue,rad.Radar_Rating_Fr_Ques__c );
                    RadarId.add(rad.Id);    
                }
            }
            
            system.debug(oldAndNewRadarValue);
            List<Radar_Rating_Response__c > RadarResponses = [select id,Radar_Ques__c  from Radar_Rating_Response__c where Radar_Rating_Lookup__c IN:RadarId];
            for(Radar_Rating_Response__c res:RadarResponses){
                for(String str:totalChangedValues){
                    if(res.Radar_Ques__c == str){
                        res.Radar_Ques__c = oldAndNewRadarValue.get(str);
                    }
                }
                ResponseListToBeUpdated.add(res);
            }
            system.debug('ResponseListToBeUpdated'+ResponseListToBeUpdated);
            update ResponseListToBeUpdated;
            return 'Success';
        }
        catch(exception e){
            system.debug('Line number of Error'+e.getLineNumber()+'The error is'+e.getMessage());
            return null;
        }
    }
}