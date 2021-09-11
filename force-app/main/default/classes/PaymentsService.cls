public with sharing class PaymentsService {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getPeoplePaymentSummaries() {
        
        return [SELECT Id, Name, Total_Payments_Amount__c, Most_Recent_Payment__c 
                FROM Contact
                WHERE Total_Payments_Amount__c != NULL];
    }

    @AuraEnabled(cacheable=true)
    public static List<Payment__c> getPeoplePaymentDetails(Id contactId) {

        return [SELECT Id, Contact__c, Payment_Amount__c, Payment_Date__c 
                FROM Payment__c
                WHERE Contact__c = :contactId
                ORDER BY Payment_Date__c DESC];
    }

    @AuraEnabled
    public static string updateContactList(Object data){
        List<Contact> contactsForUpdate = (List<Contact>) JSON.deserialize(
            JSON.serialize(data),
            List<Contact>.class
        );

        update contactsForUpdate;
        return 'Success: Contacts updated successfully';
    }
}