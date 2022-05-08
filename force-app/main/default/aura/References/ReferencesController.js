({
    doInit: function(component, event, helper) {
        debugger;
        helper.handleChange(component,event,helper);
        helper.fetchDataHelper(component,event,helper);
        
    },
    closeModel: function(component,event,helper){
        var cmpTarget = component.find('Modalbox');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open'); 
        component.set("v.displayReference",false);
    },
    remove: function(component,event,helper) {
        debugger;
        var id = event.getSource().get("v.value");
        var index = event.getSource().get("v.title");
        if(id!=undefined){
            var deleteList = component.get("v.deleteList");
            deleteList.push(id)         ;
            component.set("v.deleteList",deleteList);
        }
        helper.removeValues(component, index);
        
    },
    add: function(component,event,helper) {
        helper.addValues(component);
    },
    
    save: function(component,event,helper) {
        debugger;
        var selectedValues = component.get("v.Reference_Values");
    
        selectedValues =  selectedValues.sort(function (a, b) {
            return a.Seq_Number__c - b.Seq_Number__c;
        });
        
        component.set("v.Reference_Values",selectedValues);
        
        if(selectedValues.length != 0){
            
            var deleteList = component.get("v.deleteList");
            
            var action = component.get("c.createReferences");
            
            action.setParams({RefList : selectedValues,deleteList:deleteList});
            
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                debugger;
                if(response.getState() === "SUCCESS"){
                    {
                        swal.fire({
                            title: "Success",
                            text: "One Pager Record created",
                            type: "success",
                            timer: 3000,
                            showConfirmButton: false
                        });
                        component.set('v.REF_Created',true);
                        component.set('v.ButtonClassForREF','forestGreen');
                    }
                }
            });
            $A.enqueueAction(action);
        }
        else{
            swal.fire({
                title: "error",
                text: "No values selected",
                type: "error",
                timer: 3000,
                showConfirmButton: false
            });
        }
    },
    saveAndcloseModel : function(component,event,helper) {
        debugger;
        var selectedValues = component.get("v.one_Pager_Values");
    
        selectedValues =  selectedValues.sort(function (a, b) {
            return a.Seq_Number__c - b.Seq_Number__c;
        });
        
        component.set("v.one_Pager_Values",selectedValues);
        
        if(selectedValues.length != 0){
            
            var deleteList = component.get("v.deleteList");
            
            var action = component.get("c.Create_One_Pager_Rec");
            
            action.setParams({One_Pager_List : selectedValues,deleteList:deleteList});
            
            action.setCallback(this,function(response){
                var result = response.getReturnValue();
                debugger;
                if(response.getState() === "SUCCESS"){
                    {
                        swal.fire({
                            title: "Success",
                            text: "One Pager Record created",
                            type: "success",
                            timer: 3000,
                            showConfirmButton: false
                        });
                        component.set('v.displayOnePager',false);
                        component.set('v.OP_Created',true);
                        component.set('v.ButtonClassForOP','forestGreen');
                    }
                }
            });
            $A.enqueueAction(action);
        }
        else{
            swal.fire({
                title: "error",
                text: "No values selected",
                type: "error",
                timer: 3000,
                showConfirmButton: false
            });
        }
    }
})