/* **************************************************************************
* Controller Class: UploadFileController
* Created by Jesus Varela, 11-14-2014
*
* Purpose/Methods:
* - Upload Attachements
*

* 
* Modifications:
* - 
*
************************************************************************** */
public class UploadFileController {
	public String theLanguage {get;set;}
    public String fileNameC {get;set;}
    public String parentIdC {get;set;}
    public boolean isCVC {get;set;}
	public Attachment attachment {get;set;}
    
    public UploadFileController(){      
    	attachment = new Attachment(); 
        //this.theContact = [select Id, FirstName, LastName from Contact where Id =: ApexPages.currentPage().getParameters().get('id')];
    }
    public PageReference upload() {
    	system.debug('[UploadFileController] parentIdC '+parentIdC);
    	system.debug('[UploadFileController] fileNameC '+fileNameC);
    	if(string.isNotEmpty(parentIdC) && string.isNotEmpty(fileNameC)){
	        list<Application__c> CandidateAssignedList = new list<Application__c>();    
	    	Attachment att = attachment.clone(false, true, false, false);
	        att.OwnerId = UserInfo.getUserId();
	        att.ParentId = parentIdC;
	        attachment.Body = null;
	        string extension = '';
	        if(att.Name.lastIndexOf('.') > -1)
	        	extension = att.Name.substring(att.Name.lastIndexOf('.'));
	        system.debug('attachment.Name '+extension);
	        if(extension.toLowerCase().contains('pdf')){
	        	att.contentType = 'application/pdf';
	        }
	        if(theLanguage == 'English'){
	            att.Name = fileNameC+'_EN'+extension;
	        }else{
	            att.Name = fileNameC+'_FR'+extension;
	        }
	        try {
	        	insert att;
	        	if(isCVC){
	        		Contact theContact = new Contact();
	        		theContact.Id = parentIdC;
	    			theContact.CV__c = true;
	        		CandidateAssignedList = [Select Id From Application__c Where Contact__c = : theContact.Id];
	        
		        	for(Application__c TempCA : CandidateAssignedList){
		            	TempCA.CV__c = true;
		        	}
	          		update theContact;
	          		if(!CandidateAssignedList.isEmpty()){
	           			update CandidateAssignedList;
	          		}
	        	}
	        }catch (DMLException e) {
	        	ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
	        } finally {
	          	attachment = new Attachment(); 
	        }
	        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
    	}else{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'File name and parent are required'));
    	}
    	return null;
  	}
  
    public PageReference back(){        
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));          
    }

}