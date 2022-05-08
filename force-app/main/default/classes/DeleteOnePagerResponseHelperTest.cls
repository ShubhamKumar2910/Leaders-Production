@isTest
public class DeleteOnePagerResponseHelperTest {
    
    public static testMethod void validateSampleApex() {
        Mandate__c man = new mandate__c();
        insert man;
        
        Radar_Rating__c rad = new Radar_Rating__c ();
        rad.Radar_Rating_Ques__c = 'Self-Evaluation';
        rad.Assignment__c = man.id;
        insert rad;
        
        One_Pager__c op = new One_Pager__c();
        op.English__c = 'Self-satisfaction';
        op.French__c = 'Self-satisfaction';
        op.Mandate__c = man.Id;
        insert op;
        
        Radar_Rating__c rad1 = new Radar_Rating__c();
        rad1.Id = rad.Id;
        rad1.Radar_Rating_Ques__c = 'French-Evaluation';
        
        One_Pager__c op1 = new One_Pager__c();
        op1.Id = op.Id;
        op1.English__c = 'French-Evaluation';
        op1.French__c = 'French-Evaluation';
        
        Reference__c ref = new Reference__c();
        ref.Reference_Ques__c = 'Motivation';
        ref.Reference_Fr_Ques__c = 'Motivation';
        ref.Assignment__c = man.Id;
        insert ref;
         
        Reference__c re1 = new Reference__c();
        re1.Id = ref.Id;
        re1.Reference_Ques__c = 'French-Evaluation';
        re1.Reference_Fr_Ques__c = 'French-Evaluation';
        
        Test.startTest();
        update rad1;
        delete rad1;
        update op1;
        delete op;
        update re1;
        delete ref;
        
        Test.stopTest();
    }
}