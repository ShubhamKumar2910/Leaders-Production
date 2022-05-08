({
     doInit: function(component, event, helper) {
     debugger;
         var recList = component.get("v.recordList");
     },
    handleSelectAllContact: function(component, event, helper) {
        helper.handleSelectAllContactHelper(component,event);
    },
    selectAll: function(component, event, helper) {
        helper.selectAllHelper(component,event);
    },
    openRelatedAssignment: function(component, event, helper) {
        debugger;
        helper.showRelatedAssignment(component,event);
    },
    closeModel : function(component, event, helper){
        debugger;
        component.set("v.showModal",false);
    }
})