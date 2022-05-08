({
    doInit:function(component,event,helper){
        debugger;
        component.get("v.recordId");
        helper.getSelfAssResponse(component,event,helper);
        helper.getassgnname(component,event,helper);
        
        //helper.getLanguage(component,event,helper);
    },
    
    closeModalSecond:function(component,event,helper){
        debugger;
        component.set("v.noResponse",false);
    },
    
    updateSelfAssessment : function(component, event, helper)
    {
        debugger;
        
        var label = event.getSource().get("v.label");
        
        if(label == "Save" || label == "Download PDF Copy" )
        {
            component.set("v.isSave", true);   
        }
        else{
            component.set("v.isSave", false);
        }
        var value = component.get("v.self_assesment_resp");
        var length = value.length;
        var b = 0;
        for (i = 0; i < value.length; i++) {
            if(value[i].Response__c == undefined || value[i].Response__c == null)
            {
                b++;
            }else{
                if(value[i].Response__c.length == 0){
                    b++;    
                }
                
            }    
        }
        if(b == length){
            component.set("v.noResponse", true);     
        }else{
            component.set("v.showSpinner", true);
            var i;
            var resp = [];
            var self_ass_length = component.get("v.Self_Ass_Response_length");
            for (i = 0; i < value.length; i++) {
                if(value[i].Response__c!= null  && value[i].Response__c.length > self_ass_length )
                {
                    resp.push(value[i].Question_name__c);
                }    
            }
            console.log('the values are'+resp.length);
            if(resp.length > 0)
            {
                alert('these fields have exceeded their length :'+resp);
                component.set("v.showSpinner", false);
                return;
                
            }else
            {
                helper.update(component,event);
            }
        }
    },
    updateSelfAssessmentStill : function(component, event, helper)
    {
        debugger;
        var abc = component.get("v.isSave");
        if(abc == false){
            component.set("v.isSave", false);    
        }else{
            component.set("v.isSave", true);
        }
        
        component.set("v.noResponse", false);
        var value = component.get("v.self_assesment_resp");
        component.set("v.showSpinner", true);
        var i;
        var resp = [];
        var self_ass_length = component.get("v.Self_Ass_Response_length");
        for (i = 0; i < value.length; i++) {
            if(value[i].Response__c!= null  && value[i].Response__c.length > self_ass_length )
            {
                resp.push(value[i].Question_name__c);
            }    
        }
        console.log('the values are'+resp.length);
        if(resp.length > 0)
        {
            alert('these fields have exceeded their length :'+resp);
            component.set("v.showSpinner", false);
            return;
            
        }else
        {
            helper.update(component,event);
        }
    },
    downloadDocument : function(component, event, helper){
        debugger;
        component.set("v.isSave",true);
        helper.update(component, event, helper);
        var sendDataProc = component.get("v.sendData");
        var sendData = component.get("v.self_assesment_resp");
        
        var dataToSend = {
            label : sendData
        }; 
        sendDataProc(dataToSend, function(){
            //handle callback
        }); 
        
        
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
})