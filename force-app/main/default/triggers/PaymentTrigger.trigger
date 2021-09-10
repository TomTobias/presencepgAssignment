trigger PaymentTrigger on Payment__c (after insert, after update, after delete) {
    
    PaymentTriggerHandler pmtTriggerHandler = new PaymentTriggerHandler();
    if(trigger.isAfter) {
        if(trigger.isInsert || trigger.isUpdate){
            pmtTriggerHandler.UpdateProjectsAndContacts(Trigger.new);
        }
        
        if(trigger.isDelete){
            pmtTriggerHandler.UpdateProjectsAndContacts(Trigger.old);
        }
    }
}