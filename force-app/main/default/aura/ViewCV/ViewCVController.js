({
    doInit : function(component, event, helper){
        debugger;
        component.set("v.showSpinner",true);
        helper.MainPageDataFetcher(component, event, helper);
        helper.CVDataFetcher(component, event, helper);
       
    },
    
    closeModal : function(component, event, helper) {
        debugger;
        //var cmpTarget = component.find('MainDiv');
        //$A.util.removeClass(cmpTarget, 'slds-modal__container');
        
        component.set("v.displayCV",false);
        component.set("v.displayOP",false);
        component.set("v.displayPSY",false);//displayJD
        component.set("v.displayJD",false);
        component.set("v.viewCVfromPeople",false);
        component.set("v.viewOPfromPeople",false);
    },
    uploadCV  : function(component, event, helper) {
        debugger;
        component.get("v.contactId");
        component.set("v.showFileUpload",true);
    },
    
    SetSelAssId : function(component,event,helper){
        debugger;
        
        var appId = event.getSource().get("v.value");
        var action = component.get("c.get_Attach_id_SelfAss");
        action.setParams({
            "recordId": appId,
            // "mandateId":component.get("v.mandateRecId")
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    component.set("v.SelfAssId",storeResponse);
                    //component.set("v.displayOnePagerList",false);
                    //component.set("v.displayOnePager",true);
                }
            }else{}
        }));
        $A.enqueueAction(action);
    },
})