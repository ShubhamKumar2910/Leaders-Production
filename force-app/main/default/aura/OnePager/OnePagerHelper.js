({
    helperMethod : function() {
        
    },
    fetchDataHelper: function(component,event,helper){
       // component.set("v.showLoadingSpinner",true);
        debugger;
        var action = component.get("c.One_Pager_Con_Values");
        
        action.setParams({
            "mandateRecId" : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(response.getState() === "SUCCESS"){
                {
                    
                    result =  result.sort(function (a, b) {
                        return a.Seq_Number__c - b.Seq_Number__c;
                    });
                    component.set("v.one_Pager_Values",result);
                    //component.set("v.Contact_Values",result[1]);
                    component.set("v.showLoadingSpinner",false);
                    
                    if(result[0].Assignment_language__c != undefined && result[0].Assignment_language__c != null){
                        if(result[0].Assignment_language__c == 'English'){
                             component.set("v.Is_English",true)
                        }else{
                             component.set("v.Is_English",false)
                        }
                    }
                    else if(result[0].Ass_language__c != undefined && result[0].Ass_language__c != null){
                        if(result[0].Ass_language__c == 'English'){
                             component.set("v.Is_English",true)
                        }else{
                             component.set("v.Is_English",false)
                        }
                    }
                    helper.handleChange(component,event,helper);
                   
                }
            }
        });
        $A.enqueueAction(action);
    },
      handleChange: function(component, event, helper) {
        
        var abc = component.get("v.Is_English");
        if(abc == true){
             component.set("v.tabId",'1'); 
        }else{
            component.set("v.tabId",'2'); 
        }
    },
    removeValues : function(component, index) {
        debugger;
        var values = component.get("v.one_Pager_Values");
        values.splice(index, 1);
        component.set("v.one_Pager_Values", values);
    },
    addValues : function(component) {
        
        var allRecs = component.get("v.one_Pager_Values");
        allRecs.push({'English__c':'','French__c':'','Seq_Number__c':'','Mandate__c':component.get("v.recordId")});
        component.set("v.one_Pager_Values",allRecs);
        
    },
})