({
    doInit: function(component, event, helper) {
        debugger;
        helper.fetchData(component,event,helper);
        helper.fetchPicklistVal(component,event,helper);
        //helper.fetchBoardDirectorApplicationList(component,event,helper);
    },
    googleSearch : function(component, event, helper) {
        var link = 'https://www.google.com/search?q='+component.get("v.ContactName")+' '+component.get("v.CurentCompany"); 
        window.open(link); 
    },
    closeModel: function(component,event,helper){
        component.set("v.showLinkedInUpload",false);
    },
    UpdateLinkedIn : function(component,event,helper)
    {
        
        component.set("v.showLoadingSpinner",true);
        var action = component.get("c.updateLinkedIn");
        action.setParams({
            "linkedInUrl": component.get("v.linkedinUrl"),
            "Direct": component.get("v.Direct"),
            "Phone": component.get("v.Phone"),
            "Title":component.get("v.CurentTitle"),
            "TitleFr":component.get("v.CurentTitleFr"),
            "Email": component.get("v.Email"),
            "Conid":component.get("v.recordId"),//add 
            "applicationId": component.get("v.applicationId"),
            "origin": component.get("v.originSelected"),
            "locationState": component.get("v.stateSelected"),
            "locationCity": component.get("v.candidateLocationCity")
        });
        
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            var storeResponse = response.getReturnValue();
            
            if (state == "SUCCESS") {
                {
                    debugger;
                    var abc = component.get("v.currentList");
                    
                    for (let i = 0; i < abc.length; i++) {
                        if(component.get("v.linkedinUrl") != null){
                            if(abc[i].candidate.Contact__c == component.get("v.recordId")){
                                abc[i].candidate.Contact__r.LinkedIn_URL__c = component.get("v.linkedinUrl");
                            } 
                        }
                        if(component.get("v.Direct") != null){
                            if(abc[i].candidate.Contact__c == component.get("v.recordId")){
                                abc[i].candidate.Contact__r.MobilePhone = component.get("v.Direct");
                            }
                        }
                        if(component.get("v.Email") != null){
                            if(abc[i].candidate.Contact__c == component.get("v.recordId")){
                                abc[i].candidate.Contact__r.Email = component.get("v.Email");
                            }
                        }
                        if(component.get("v.Phone") != null){
                            if(abc[i].candidate.Contact__c == component.get("v.recordId")){
                                abc[i].candidate.Contact__r.Phone = component.get("v.Phone");
                            }
                        }
                        if(component.get("v.CurentTitle") != null){
                            if(abc[i].candidate.Contact__c == component.get("v.recordId")){
                                abc[i].candidate.Current_Title__c = component.get("v.CurentTitle");
                            }
                        }
                        if(component.get("v.CurentTitleFr") != null){
                            if(abc[i].candidate.Contact__c == component.get("v.recordId")){
                                abc[i].candidate.Current_Title_French__c = component.get("v.CurentTitleFr");
                            }
                        }
                        if(component.get("v.originSelected") != null && component.get("v.originSelected") != ''){
                            if(abc[i].candidate.Contact__c == component.get("v.recordId")){
                                abc[i].candidate.Origin__c = component.get("v.originSelected");
                            }
                        }
                        if(component.get("v.stateSelected") != null && component.get("v.stateSelected") != ''){
                            if(abc[i].candidate.Contact__c == component.get("v.recordId")){
                                abc[i].candidate.Location_State__c = component.get("v.stateSelected");
                            }
                        }
                        if(component.get("v.candidateLocationCity") != null && component.get("v.candidateLocationCity") != ''){
                            if(abc[i].candidate.Contact__c == component.get("v.recordId")){
                                abc[i].candidate.Location_City__c = component.get("v.candidateLocationCity");
                            }
                        }
                    }
                    component.set("v.currentList",abc);
                    swal.fire({
                        title: "Success",
                        text: "Details Updated",
                        type: "success",
                        timer: 3000,
                        showConfirmButton: false
                    });
                    component.set("v.showLoadingSpinner",false);  
                    component.set("v.showLinkedInUpload",false);  
                }
            }else{
                component.set("v.showLoadingSpinner",false);  
            }
        }));
        $A.enqueueAction(action);
    },
    
    updateLocation : function(component, event, helper) {
        debugger;
        var stateVal = event.getSource().get("v.value");
        component.set("v.stateSelected",stateVal); 
        
    },
    updateorigin : function(component, event, helper) {
        debugger;
        var originVal = event.getSource().get("v.value");  
        component.set("v.originSelected",originVal); 
    },
    saveOrigin : function(component, event, helper) {
        debugger;
        helper.saveOrigin(component, event, helper);
    },
    saveLocation : function(component, event, helper) {
        debugger;
        helper.saveLocation(component, event, helper);
    },
    /*removeBoardMemberApp : function(component, event, helper) {
        debugger;
        helper.removeBoardMemberApp(component, event, helper);
    },
    updateBoardDirectorList : function(component, event, helper) {
        debugger;
        helper.updateBoardDirectorList(component, event, helper);
    },*/
})