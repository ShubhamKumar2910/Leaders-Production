({
    doInitHelper : function(component, event, helper) {
        var obj=component.get("v.obj");
        var fieldName=component.get("v.fieldName");
        var fieldV=obj[fieldName];
        //alert(fieldName);
        //alert(fieldV);
        
        component.set("v.fieldValue",fieldV);
    },
    showAssDetails : function(component, event, helper) {    
        debugger;
        var ConId = event.getSource().get("v.title");
        var action = component.get("c.getAssDetailsFromCon");
        action.setParams({
            "ConId": ConId,
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    debugger;
                    if(storeResponse.length > 0){
                        component.set("v.AssAvailable",true);               
                    }
                    component.set("v.AssDetails",storeResponse);
         
                    component.set("v.ShowPeopleinfoPage",true);
                }
            }else{}
        }));
        $A.enqueueAction(action);
    
    },
})