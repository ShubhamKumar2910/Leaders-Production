({
    fetchData : function(component,event,helper)
    {
        
        component.set("v.showLoadingSpinner",true);
        var action = component.get("c.getData");
        action.setParams({
            "Conid": component.get("v.recordId"),
            "mandateId":component.get("v.mandateRecId")
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    debugger;
                    if(storeResponse.Contact__r != null && storeResponse.Contact__r != undefined){
                        if(storeResponse.Contact__r.Comp__c != null && storeResponse.Contact__r.Comp__c != undefined){
                            component.set("v.CurentCompany",storeResponse.Contact__r.Comp__c != null?storeResponse.Contact__r.Comp__c : '');
                        }
                        component.set("v.ContactName", storeResponse.Contact__r.Name !=  null?storeResponse.Contact__r.Name : '');
                        component.set("v.AssLang",storeResponse.Mandate_Language__c != null?storeResponse.Mandate_Language__c :'English');
                        component.set("v.linkedinUrl",storeResponse.Contact__r.LinkedIn_URL__c != null?storeResponse.Contact__r.LinkedIn_URL__c : '');
                        component.set("v.Email",storeResponse.Contact__r.Email != null?storeResponse.Contact__r.Email : '');
                        component.set("v.Direct",storeResponse.Contact__r.MobilePhone != null?storeResponse.Contact__r.MobilePhone : '');
                        component.set("v.Phone",storeResponse.Contact__r.Phone != null?storeResponse.Contact__r.Phone : '');
                        component.set("v.CurentTitle",storeResponse.Current_Title__c != null ? storeResponse.Current_Title__c :'');
                        component.set("v.CurentTitleFr",storeResponse.Current_Title_French__c != null?storeResponse.Current_Title_French__c :'');
                        component.set("v.originSelected",storeResponse.Origin__c != null?storeResponse.Origin__c : '');
                        //component.set("v.AssLang",storeResponse.Mandate_Language__c != null?storeResponse.Mandate_Language__c :'');
                        component.set("v.stateSelected",storeResponse.Contact__r.Office_State__c != null?storeResponse.Contact__r.Office_State__c :'');
                        component.set("v.candidateLocationCity",storeResponse.Contact__r.Office_City__c != null?storeResponse.Contact__r.Office_City__c : '');
                        component.set("v.showLoadingSpinner",false);
                    }
                    
                }
                
                
            }else{
                component.set("v.showLoadingSpinner",false);  
            }
        }));
        $A.enqueueAction(action);
    },
    fetchPicklistVal : function(component,event,helper)
    {
        var objectName,pickFieldName ;
        
        if(component.get("v.origin")){
            objectName = 'Application__c';
            pickFieldName = 'Origin__c';
        }else if(component.get("v.location")){
            objectName = 'Contact';
            pickFieldName = 'Residence_State__c';
        }
        component.set("v.showLoadingSpinner",true);
        var action = component.get("c.getPickListValuesIntoList");
        action.setParams({
            "strObjectName": objectName,
            "strPicklistField":pickFieldName
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    debugger;
                    if(component.get("v.origin")){
                        component.set("v.candidateOrigin",storeResponse);
                    }else if(component.get("v.location")){
                        component.set("v.candidateLocationState",storeResponse);
                    }
                    component.set("v.showLoadingSpinner",false);
                }
            }else{
                component.set("v.showLoadingSpinner",false);  
            }
        }));
        $A.enqueueAction(action);
    },
    /*fetchBoardDirectorApplicationList : function(component,event,helper)
    {
        debugger;
        component.set("v.showLoadingSpinner",true);
        var action = component.get("c.getBDList");
        action.setParams({
            "Conid": component.get("v.recordId")
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    debugger;
                    component.set("v.boardDirectorList",storeResponse);
                    component.set("v.showLoadingSpinner",false);
                }
            }else{
                component.set("v.showLoadingSpinner",false);  
            }
        }));
        $A.enqueueAction(action);
    },
    removeBoardMemberApp : function(component,event,helper)
    {
        debugger;
        var appId = event.getSource().get("v.value");
        var updatedList = component.get("v.updatedBoardList");
        var actualList = component.get("v.boardDirectorList");
        for(var i=0;i<actualList.length;i++){
            if(actualList[i].Id == appId){
                updatedList.push(actualList[i].Id);
                actualList.splice(i,1);
            }
        }
        component.set("v.updatedBoardList",updatedList);
        component.set("v.boardDirectorList",actualList);
    },
    updateBoardDirectorList : function(component,event,helper)
    {
        debugger;
        component.set("v.showLoadingSpinner",true);
        var action = component.get("c.updatingBoardDirectorlist");
        action.setParams({
            "applicationId": component.get("v.updatedBoardList")
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    debugger;
                    component.set("v.showLoadingSpinner",false);
                    component.set("v.showLinkedInUpload",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Updated successfully.",
                        "type": 'success'
                    });
                    toastEvent.fire();
                    
                }
            }else{
                component.set("v.showLoadingSpinner",false);  
                component.set("v.showLinkedInUpload",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Some Error Occured.",
                    "type": 'error'
                });
                toastEvent.fire();
            }
        }));
        $A.enqueueAction(action);
    },*/
})