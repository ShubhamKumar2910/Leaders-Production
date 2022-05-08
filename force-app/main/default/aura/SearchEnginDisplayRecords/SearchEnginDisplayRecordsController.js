({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
    },
    openAttDetail : function(component, event, helper){
        debugger;
        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.name,
                actionName: 'view'
            }
        };
        
        var navService = component.find("navService");
        event.preventDefault();
        navService.navigate(pageReference);
    },
    handleClickForAss : function(component, event, helper){
        debugger;
        //https://leadersinternational--test.lightning.force.com/lightning/r/Mandate__c/a01U000001PBoNEIA1/view?0.source=alohaHeader
        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.name,
                actionName: 'view'
            }
        };
        
        var navService = component.find("navService");
        event.preventDefault();
        navService.navigate(pageReference);
    },
    openModal : function(component, event, helper){
        debugger;
        component.set("v.checkSpinner",true);
        var value = component.get("v.obj");
        var id = value.Id;
        var action = component.get("c.getAssDetailsFromCon");
        
        action.setParams({
            "ConId": id,
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    debugger;
                    if(storeResponse.length > 0){
                        component.set("v.AssDetails",storeResponse);
                        component.set("v.checkSpinner",false);
                        component.set("v.showModal",true);      
                    }else{
                        swal.fire({
                            title: "No Active Assignments",
                            text: "No Active Assignments Found for this Contact",
                            type: "error",
                            timer: 3000
                        }); 
                        component.set("v.checkSpinner",false);
                    }
                    
                }
            }else{}
        }));
        $A.enqueueAction(action);
    },
    closeModel : function(component, event, helper){
        debugger;
        component.set("v.showModal",false);
    }
})