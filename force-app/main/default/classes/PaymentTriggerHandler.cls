public class PaymentTriggerHandler {
    public void UpdateProjectsAndContacts(List<Payment__c> payments){
        
        UpdateProjects(payments);
        UpdateContacts(payments);
 
    }
    
    public void UpdateProjects(List<Payment__c> payments){
        
        // restrict updates to only those projects appearing in these payments
        Set<ID> projectIds = new Set<ID>();
        for(Payment__c payment : payments){
            projectIds.add(payment.Project__c);
        }
        
        // get all payments related to the above projects
        Map<Id, Project__c> projectMap = new Map<Id, Project__c>(
            [SELECT Id, Total_Payments_Amount__c FROM Project__c WHERE Id in :projectIds]);
        
        // calculate total payments by Project
        AggregateResult[] groupedResults = [SELECT Project__c, SUM(Payment_Amount__c) Total_Payments
                                            FROM Payment__c
                                            WHERE Project__c in :projectIds
                                            GROUP BY Project__c];
        
        // Update Projects with new total payments
        for (AggregateResult ar : groupedResults)  {
            Id projectId = (Id)ar.get('Project__c'); // get projectId from aggregate result
            Project__c project = projectMap.get(projectId); // get project record from Map
            project.Total_Payments_Amount__c = (Decimal)ar.get('Total_Payments');
        }
        update projectMap.values();
    }
    
    
    public void UpdateContacts(List<Payment__c> payments){
        
        // restrict updates to only those Contacts appearing in these payments
        Set<ID> contactIds = new Set<ID>();
        for(Payment__c payment : payments){
            contactIds.add(payment.Contact__c);
        }
        
        // get all payments related to the above Contacts
        Map<Id, Contact> contactMap = new Map<Id, Contact>(
            [SELECT Id, Total_Payments_Amount__c FROM Contact WHERE Id in :contactIds]);
        
        // calculate total payments by Contact
        AggregateResult[] groupedResults = [SELECT Contact__c, 
                                            SUM(Payment_Amount__c) Total_Payments,
                                            MAX(Payment_Date__c) Most_Recent_Payment
                                            FROM Payment__c
                                            WHERE Contact__c in :contactIds
                                            GROUP BY Contact__c];
        
        // Update Projects with new total payments
        for (AggregateResult ar : groupedResults)  {
            Id contactId = (Id)ar.get('Contact__c');
            Contact contact = contactMap.get(contactId);
            contact.Total_Payments_Amount__c = (Decimal)ar.get('Total_Payments');
            contact.Most_Recent_Payment__c = (Date)ar.get('Most_Recent_Payment');
        }
        update contactMap.values();
    }
}