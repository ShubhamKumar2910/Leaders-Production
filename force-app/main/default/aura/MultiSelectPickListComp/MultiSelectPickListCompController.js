({
    // To prepopulate the seleted value pill if value attribute is filled
	doInit : function( component, event, helper ) {
        debugger;
        helper.doInitHelper(component);
       // helper.gettingStateValues(component, event, helper );
    },
    
    // When a keyword is entered in search box
	filterOptions : function( component, event, helper ) {
        if( !$A.util.isEmpty(component.get('v.searchString')) ) {
		    helper.filterOptionsHelper(component);
        } else {
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
	},
 
    // When an item is selected
	selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            helper.selectItemHelper(component, event);
        }
	},
    
    showOptions : function( component, event, helper ) {
        debugger;
        /*var country = component.get("v.CountryValue");
        if(component.get("v.ShowCanadaValue") == true){
            if(country[0] == 'Canada'){
                var CanadaValues =  component.get("v.StateValueListForCanada");
                component.set("v.options",CanadaValues);
            }    
        }*/
        var disabled = component.get("v.disabled");
        if(!disabled) {
        	component.set("v.message", '');
            component.set('v.searchString', '');
            var options = component.get("v.options");
            options.forEach( function(element,index) {
                element.isVisible = true;
            });
            component.set("v.options", options);
            if(!$A.util.isEmpty(component.get('v.options'))) {
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
            } 
        }else{
            //$A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        }
        if(component.get('v.isListVisible') == false){
            component.set('v.isListVisible',true);
        }else{
            var spinner = component.find('resultsDiv');
			$A.util.toggleClass(spinner, 'slds-is-open');
            component.set('v.isListVisible',false);
        }
        
	},
 
    // To remove the selected item.
	removePill : function( component, event, helper ){
        helper.removePillHelper(component, event);
    },
 
    // To close the dropdown if clicked outside the dropdown.
    blurEvent : function( component, event, helper ){
        helper.blurEventHelper(component, event);
    },
})