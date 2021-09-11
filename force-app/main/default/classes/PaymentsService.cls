public with sharing class PaymentsService {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getPeoplePaymentSummaries() {
        return [SELECT Id, Name, Total_Payments_Amount__c, Most_Recent_Payment__c 
                FROM Contact
                WHERE Total_Payments_Amount__c != NULL];
    }
}
