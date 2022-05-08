({
    selectAllHelper: function(component,event){
        debugger;
        var allApp = component.get("v.recordList");
        var valuetoset = component.get("v.isSelectAll");
        for(var i=0;i<allApp.length;i++){
            allApp[i].isSelected=valuetoset;
        }
        component.set("v.recordList",allApp);
        console.log(allApp);
        
    },
    handleSelectAllContactHelper : function(component,event) {
        // get the selected Account record from the COMPONETN event
        var selectedAccountGetFromEvent = event.getParam("accountByEvent");
        debugger;
        component.set("v.selectedRecord" , selectedAccountGetFromEvent);
    },
    showRelatedAssignment : function(component,event) {
        debugger;
        var contactId = event.getSource().get("v.value");
        var action = component.get("c.getActiveAssignments");
        action.setParams({
            contactId : contactId,
            mandateId : component.get('v.mandateRecId')
        });
        
        action.setCallback(this,function(response){
            var state= response.getState();
            var list = response.getReturnValue();
            
            if(state=="SUCCESS"){              
                component.set("v.assignmentList",list);
                component.set("v.showModal",true);
            }
        })
        $A.enqueueAction(action);        
    },
})