({
    /*
     * this function will build table data
     * based on current page selection
     * */
    getRecordsHelper : function(component, event, searchText,helper) {
        debugger;
        var whereClause='';
        var fieldAPIs = component.get("v.fieldAPIs");
        var objectAPI = component.get("v.objectAPI");
        if(component.get("v.whereClause")!='')
        whereClause = component.get("v.whereClause")+'\'' +component.get("v.clauseValue")  + '\'';
        if(fieldAPIs != undefined && objectAPI != undefined){
            var action = component.get('c.getRecords');
            action.setParams({
                "fieldAPIs" : fieldAPIs,
                "sObjectType" : objectAPI,
                "filter" : searchText,
                "replaceHeaders":component.get("v.replaceHeaders"),
                "whereClause":whereClause
            });
			//"whereClause":component.get("v.whereClause")+'\'' + 'Active' + '\''
            action.setCallback(this, function(response){
                var state = response.getState();
                if( state === 'SUCCESS' && component.isValid()){
                    component.set("v.RecordList",response.getReturnValue().sObjectData);
                    if(response.getReturnValue().sObjectData.length==0){
                        //component.set("v.noRecordsError","No Records found in Database for this Entry :) ");
                    }
                    this.doInitHelper(component, helper);
                    
                }
                else{
                    var errors = response.getError();
                    $A.log('Error Details '+errors);
                    if( errors || errors[0].message){
                        console.log('Error Details '+errors[0].message);
                    }
                }
                component.set("v.showSpinner",false);
            });
            $A.enqueueAction(action);
        }
        else{
            
        }


    },
    fetchAssignmentHelper : function(component, event,searchText,helper) {
        	//var searchString = component.get("v.selectedRecord");
        	//alert(searchString.name);
        this.getRecordsHelper(component,event,searchText,helper);
       
    },
    doInitHelper:function(component, helper) {
        debugger;

        if(component.get("v.objName")=='Account'){
            component.set("v.objName",'Company');
        }
        if(component.get("v.objName")=='Contact'){
            component.set("v.objName",'People');
        }
        if(component.get("v.objName")=='Mandate__c'){
            component.set("v.objName",'Assignment');
        }
        component.set("v.totalPages", Math.ceil(component.get("v.RecordList").length/component.get("v.pageSize")));
        component.set("v.allData", component.get("v.RecordList"));
        component.set("v.currentPageNumber",1);
        var allData=component.get("v.RecordList");
        console.log("allData="+allData);
        
        
        var custs = [];
        //var conts = component.get("v.objFieldList");
        var conts = {'Name':'Name','Company Name':'Company__r.Name','Assignment Status':'Assignment_Status__c','Partner':'Partner__r.Name','Second Partner':'Partner_2__r.Name'};
        var i=0;
        for(var key in conts){
            custs.push({value:conts[key], key:key,sortAsc:true,Id:i}); //Here we are creating the list to show on UI.
            i++;
        }
        component.set("v.fieldMap",custs);
        console.log('custs');
        console.log(custs);
        this.buildData(component, helper);
    },
    buildData : function(component, helper) {
        debugger;
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allData");
        var x = (pageNumber-1)*pageSize;
        
        console.log(allData);
        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
        component.set("v.data", data);
        
        this.generatePageList(component, pageNumber);
    },
    
    /*
     * this function generate page list
     * */
    generatePageList : function(component, pageNumber){
        pageNumber = parseInt(pageNumber);
        var pageList = [];
        var totalPages = component.get("v.totalPages");
        if(totalPages > 1){
            if(totalPages <= 10){
                var counter = 2;
                for(; counter < (totalPages); counter++){
                    pageList.push(counter);
                } 
            } else{
                if(pageNumber < 5){
                    pageList.push(2, 3, 4, 5, 6);
                } else{
                    if(pageNumber>(totalPages-5)){
                        pageList.push(totalPages-5, totalPages-4, totalPages-3, totalPages-2, totalPages-1);
                    } else{
                        pageList.push(pageNumber-2, pageNumber-1, pageNumber, pageNumber+1, pageNumber+2);
                    }
                }
            }
        }
        component.set("v.pageList", pageList);
    },
    sortByFieldHelper:function(component, event, helper){
        debugger;
        var sortAsc;
        
        var fielddesc= event.currentTarget.name;
        var fieldsMap=component.get("v.fieldMap");
        
        for(var i=0;i<fieldsMap.length;i++){
            if(fieldsMap[i].Id ==fielddesc.Id ){
                sortAsc = fieldsMap[i].sortAsc;
                fieldsMap[i].sortAsc = !sortAsc;
            }
            
        }
        
        
        var sortField = fielddesc.value;
        var field = fielddesc.value;
        
        var data =component.get("v.data");
        sortAsc =  !sortAsc;
        
        data.sort(function(a, b) {
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
        });
        component.set("v.data",data);
        component.set("v.fieldMap",fieldsMap);
    },
    recordOperationHelper:function(component, event, helper){
        debugger; 
        // var record=event.getSource().get('v.name');
        //var value=event.getParam("value");
        var record=component.get("v.eachRecord");
        var value=component.get("v.recordOperationValue");	
        
        var recordId=[];
        var dataR=[];
        dataR=component.get("v.data");
        
        if(value=='Delete')
        {
            recordId.push(record.Id);
            var deleteR = component.get("c.deleteRecord");
            deleteR.setParams({ 
                "idList" : recordId
            });
            deleteR.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    dataR.splice(dataR.indexOf(record),1);
                    component.set("v.data",dataR);                    
                    
                } 
            });
            $A.enqueueAction(deleteR);
        }    
    },
    onCheckHelper:function(component, event, helper){
        debugger;
        var records=event.getSource().get("v.text");
        
        var selectedRecord=[];
        var selectedRecordId=[];
        selectedRecord=component.get("v.selectedRecord");
        selectedRecordId=component.get("v.selectedRecordId")
        
        var checkBoolean=event.getSource().get("v.value");
        if(checkBoolean==true){
            selectedRecord.push(records);  
            selectedRecordId.push(records['Id']);
        }else{
            //  selectedRecord.pop(records);   
            selectedRecord.splice(selectedRecord.indexOf(records),1);
            
            // selectedRecordId.pop(records['Id']);
            selectedRecordId.splice(selectedRecordId.indexOf(records['Id']),1);
            
        }
        component.set("v.selectedRecord",selectedRecord);
        component.set("v.selectedRecordId",selectedRecordId);
        
        console.log('selectedRecord'+selectedRecord);
        console.log('selectedRecord'+selectedRecordId);
        
    },
    deleteAllHelper:function(component, event, helper){
        debugger;
        var selectedRecord=[];
        var selectedIdList=[];
        var data=[];
        var data1=[];
        var  selectAll= new Boolean(component.get("v.selectAll"));
        if(selectAll==true)
        {
            data=component.get("v.data");
            for(var i=0; i<data.length; i++){
                var record=data[i];
                selectedIdList.push(record['Id']);
            }
        }  
        else{            
            
            selectedRecord=component.get("v.selectedRecord");
            data=component.get("v.data");
            for(var i=0; i<selectedRecord.length; i++){
                var record=selectedRecord[i];
                selectedIdList.push(record['Id']);
            }
        }       
        //Calling Apex deleteRecord Method
        var deleteR = component.get("c.deleteRecord");
        deleteR.setParams({ 
            "idList" : selectedIdList
        });
        deleteR.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var objName=response.getReturnValue();
                //if will execute if all the records are selected
                if(selectAll==true){
                    data1=data.slice(); //for copying array
                    for(var i=0; i<data1.length; i++){ //This loop for refreshing data by applying splice
                        data.splice(data.indexOf(data1[i]),1);
                    } 
                    component.set("v.selectAll",false);
                    //component.set("v.data",data);
                    var pageNumber = component.get("v.currentPageNumber");
                    component.set("v.currentPageNumber", pageNumber+1);
                    helper.buildData(component,helper);
                    component.set("v.selectAll",false);
                }//This else will execute when few records are selected
                else{
                    var data2=data.slice(); //for copying array
                    for(var i=0; i<selectedRecord.length; i++){
                        data.splice(data.indexOf(data2[i]),1); //This loop for refreshing data by applying splice
                    } 
                    component.set("v.selectedRecord",[]);
                    component.set("v.data",data);
                }
                var selectedObjLength=selectedIdList.length;
                selectedIdList=[]; 
            } 
            //Fire the delete All event
            var deleteAllEvent=$A.get("e.c:deleteAllEvent");
            deleteAllEvent.setParams({"objName" : objName,
                                      "objCount": selectedObjLength
                                     });
            deleteAllEvent.fire();
        });
        $A.enqueueAction(deleteR);
    },
    onCheckAllHelper:function(component, event, helper){
        //Start checkAll   
        var master = component.find("master");
        var boxPack = component.find("dependent");
        if (!Array.isArray(boxPack)) {
            boxPack = [boxPack];
        }
        var val = master.get("v.value");
        for (var i = 0; i < boxPack.length; i++) {
            boxPack[i].set("v.value", val);
        }
        //End CheckAll
        component.set("v.selectAll",true);
        var recordIdList=[];
    },
    createNewRecordHelper:function(component, event, helper){
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Contact"
        });
        createRecordEvent.fire();
    },
    navigateHelper:function(component,event,helper){
        debugger;
        // component.set("v.mergeDuplicateSpinner",true);
        this.spinner(component,helper);
    },
    spinner : function(component,helper){
        component.set("v.isOpen",true); 
        //component.set("v.mergeDuplicateSpinner",false); 
    },
    addtoAssHelper:function(component,event,helper){
        debugger;
        component.set("v.displayAddCandidateToOtherAssignment",true);
    },
    
})