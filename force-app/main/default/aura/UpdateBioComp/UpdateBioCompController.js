({
    closeModel: function(component,event,helper){
        debugger;
        if(component.get("v.isrelatedListButton")){
            component.destroy();
            window.history.back();
        }else{
            component.set("v.displayBiography",false);
        }
    },
   
    onPageReferenceChanged: function(cmp, event, helper) {
        var myPageRef = cmp.get("v.pageReference");
        var contactId = myPageRef.state.c__contactId;
        alert('Page ref Changed');
        alert(contactId);
        alert(component.get("v.recordId"));
        cmp.set("v.recordId", contactId);
    },
    getRecords: function(component, event, helper) {
        
        setTimeout(function(){ 
        },2000);
    },
    
    getRecordTypes : function(component, event, helper) {
        helper.getRecordTypesHelper(component, event, helper);
        helper.viewBioHelper(component, event, helper);
     },
    EditBio : function(component, event, helper) {
        component.set("v.truthy", false);
    },
    viewBio : function(component, event, helper) {
        component.set("v.truthy", true);
    },
    hideResume : function(component, event, helper) {
        debugger;
        if( event.getSource().get("v.label") == 'Show Resume'){
            component.set("v.hideResume",true);
            component.set("v.buttonName",'Hide Resume');
        }else{
            component.set("v.hideResume",false);
            component.set("v.buttonName",'Show Resume');     
        }
    },
    save: function(component, event, helper) {
        helper.saveBiographyList(component, event,helper);
        //debugger;
        //helper.genrateSelfAss(component, event,helper);
        
    },
    handledelete: function(component, event, helper) {
        helper.handledeleteHelper(component, event,helper);
        
    }
})