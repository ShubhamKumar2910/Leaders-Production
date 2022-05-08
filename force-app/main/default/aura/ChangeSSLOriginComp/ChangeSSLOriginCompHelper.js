({
    fetchSSL : function(component, event, object, fieldApi, itemToSet) {
        debugger;
        var action = component.get("c.getPicklistValues");
        action.setParams({
            objectType : object,
            selectedField : fieldApi
        });
        
        action.setCallback(this,function(response){
            var list = response.getReturnValue();
            debugger;
            component.set(itemToSet,list);
            
        })
        $A.enqueueAction(action);
    },
    saveStatus : function(component, event, saveType) {
        debugger;
        component.set("v.spinner",true);
        var totalmap = JSON.parse(component.get("v.candidatesMap"));
        var newList = component.get("v.recordList");
        for (let i = 0; i < newList.length; i++) {
            var canId = newList[i].Id;
            totalmap[canId].Status_Summary_Line__c = component.get("v.selectedSSLValue");
        }
        component.set("v.candidatesMap",JSON.stringify(totalmap));
        var listName ;
        if(component.get("v.displaySourceList") == true){
            component.set("v.displaySourceList",false);  
            listName = 'Source';
        }else if(component.get("v.displayClientList") == true){
            component.set("v.displayClientList",false);
            listName = 'Client';
        }else if(component.get("v.displayRawList") == true){
            component.set("v.displayRawList",false);
            listName = 'Raw';
        }else if(component.get("v.displayCandidateList") == true){
            component.set("v.displayCandidateList",false);
            listName = 'Human';
        }
        
        
        
        var action = component.get("c.updateStatus");
        action.setParams({
            ssl : component.get("v.selectedSSLValue"),
            origin : component.get("v.selectedOriginValue"),
            recListString : JSON.stringify(component.get("v.recordList")),
            saveType : saveType
        });
        
        action.setCallback(this,function(response){
            var toastEvent = $A.get("e.force:showToast");
            if(response.getReturnValue() == true){
                
                swal.fire({
                    title: "Success!",
                    text: "Records updated successfully.",
                    type: "Error",
                    timer: 3000
                });
                component.set("v.displayChangeSSLOriginModal",false);
                if(listName == 'Source'){
                    component.set("v.displaySourceList",true);
                }else if(listName == 'Client'){
                    component.set("v.displayClientList",true);
                }else if(listName == 'Raw'){
                    component.set("v.displayRawList",true);
                }else{
                    component.set("v.displayCandidateList",true);
                }
                //component.set("v.displaySourceList",true);
                component.set("v.spinner",true);
            }else{
                component.set("v.spinner",true);
                swal.fire({
                    title: "Something went wrong!",
                    text: "contact admin",
                    type: "Error",
                    timer: 3000
                });
            }
        })
        $A.enqueueAction(action);
    }
    
})