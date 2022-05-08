({
    MainPageDataFetcher: function(component, event, helper) {
        debugger;
        var abc = component.get("v.contactId"); 
        var action = component.get("c.Self_Ass_Data");
        action.setParams({
            "conRecId": abc,
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            if (state == "SUCCESS") {
                { 
                    component.set("v.MainPageapplicationData",storeResponse);
                }
            }else{
                component.set("v.showSpinner",false);
            }
        }
                                               ));
        $A.enqueueAction(action);
    },
    CVDataFetcher: function(component, event, helper) {
        debugger;
        var action = component.get("c.getCVId");
        action.setParams({
            conId : component.get("v.contactId"),
        });
        
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            debugger;
            if(result){
                component.set("v.attId",result);
                component.set("v.showSpinner",false);
            }
            else{
                component.set("v.showSpinner",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "NO CV",
                    "message": "No CV found",
                    "type": 'info'
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
    },
})