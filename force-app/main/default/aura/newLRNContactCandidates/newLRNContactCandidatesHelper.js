({
    helperMethod : function() {
        
    },
    
    fetchLRN : function(component,event,helper){
        console.log("inside fetchLRN");
        var action=component.get("c.getLeaderNote");
        action.setParams({
            canId : component.get("v.candidateId")
        });
        
        action.setCallback(this, function(response){
            var state= response.getState();
            if(state == 'SUCCESS') {
                debugger;
                var lrn = response.getReturnValue(); 
                if(lrn != null){
                    if(lrn.length !=0)
                    {
                        component.set("v.leaderNote",lrn);
                        if(component.get("v.openLRNComp") == true){
                            component.set("v.Description",lrn.Description__c);
                        }else{
                            component.set("v.Description",lrn.Description__c);    
                        }
                        
                        component.set("v.selectedValue",lrn.Status_Summary_Line__c);
                        console.log(response.getReturnValue());
                        var lrn_ssl = component.get("v.leaderNote.Status_Summary_Line__c")
                        component.set("v.SSLValue",lrn_ssl);
                        console.log(lrn_ssl);
                    }
                }
            }
        });
        $A.enqueueAction(action);
        console.log("finish fetchLRN");
    },
    getCandidateInfo : function(component,event,helper)
    {
        var action = component.get("c.getCandidateInformation");
        action.setParams({
            canId : component.get("v.candidateId")
        });
        
        action.setCallback(this,function(response){
            var canRecord = response.getReturnValue();
            debugger;
            component.set("v.canRecord",canRecord);
            
        })
        $A.enqueueAction(action);
    },
    fetchSSL : function(component,event,helper)
    {
        var action = component.get("c.getPicklistValues");
        action.setParams({
            objectType : 'Meeting_Note__c',
            selectedField : 'Status_Summary_Line__c'
        });
        
        action.setCallback(this,function(response){
            var list = response.getReturnValue();
            debugger;
            component.set("v.SSLValues",list);
            
        })
        $A.enqueueAction(action);
    },
    
    saveLeadersNote : function(component,event,helper)
    {
        debugger;
        var field1 = component.find("canSD");
        if(field1 != null){
            if(field1.get("v.validity").valid) 
            {
                debugger;
                // continue processing
            } else 
            {
                debugger;
                field1.showHelpMessageIfInvalid();
                return;
            }
        }
        
        
        var action = component.get("c.saveLeadersNote");
        debugger;
        if(component.get("v.leaderNote") != null){
            if(!component.get("v.openEditLRNComp"))
                delete component.get("v.leaderNote")['Id'];
        }
        
        debugger;
        
        var lrn = component.get("v.leaderNote");
        if(lrn != null){
            lrn.Status_Summary_Line__c = component.get("v.selectedValue");
            lrn.Description__c = component.get("v.Description") != null ? component.get("v.Description"):'';
            lrn.Candidate_Assigned__c = component.get("v.candidateId");
            if(lrn.Candidate_Assigned__r != null){
            	delete lrn['Candidate_Assigned__r'];
            }
            if(lrn.Contact__r != null){
                delete lrn['Contact__r'];
            }
        }else{
            var abc=[];
            abc.push({'sobjectType':'Meeting_Note__c','Status_Summary_Line__c':component.get("v.selectedValue"),'Description__c':component.get("v.Description") != null ? component.get("v.Description"):'','Candidate_Assigned__c':component.get("v.candidateId")});
        	lrn = abc[0];
        }
        
        action.setParams({
            lrn : lrn
        });
        
        action.setCallback(this,function(response){
            debugger;
            var state = response.getState();
            if(state == 'SUCCESS') {
                var newlrn = response.getReturnValue();
                component.set("v.insertedLRN",newlrn);
                //v fix refreshView;
                helper.handleShowToast(component,event,helper)
                helper.closeModel(component,event,helper)
                var lrn_ssl = component.get("v.insertedLRN.Status_Summary_Line__c")
                component.set("v.SSLValue",lrn_ssl);
                console.log(lrn_ssl);
                $A.get('e.force:refreshView').fire();
            }else{
                helper.closeModel(component,event,helper)
                helper.handleShowToastError(component,event,helper)
            }
            helper.closeModel(component,event,helper)
        });
        $A.enqueueAction(action);
    },
    
    handleShowToast : function(component,event,helper)
    {
        component.find("notifLib").showToast({
            "variant" : 'success',
            "mode" : 'pester', 
            "duration" : 3000,
            "title": "Success",
            "message": "The record created successfully."        
        });
    },
    handleShowToastError : function(component,event,helper)
    {
        component.find("notifLib").showToast({
            "variant" : 'error',
            "mode" : 'pester', 
            "duration" : 3000,
            "title": "Error",
            "message": "Some Error Occured"        
        });
    },
    
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.openLRNComp",false);
        component.set("v.openEditLRNComp",false);
        
    }
})