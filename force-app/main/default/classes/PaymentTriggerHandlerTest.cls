@isTest
public class PaymentTriggerHandlerTest {
	@testSetup static void methodName() {
        
        Contact con = new Contact();
        con.LastName = 'Contact1';
        insert con;
        
        Project__c proj = new Project__c();
        proj.Name = 'Project1';
        insert proj;
        
        //Contact con = [SELECT Id, Lastname from Contact where LastName = 'Contact1'];
        //Project__c proj = [SELECT Id, Name from Project__c where Name = 'Project1'];

        List<Payment__c> payments = new List<Payment__c>();
        for(Integer i = 0; i < 10; i++){
            Payment__c pay = new Payment__c();
            pay.Name = 'Payment'+ i;
            pay.Payment_Amount__c = i;
            pay.Payment_Date__c = Date.today() - i;
            pay.Contact__c = con.Id;
            pay.Project__c = proj.Id;
            payments.add(pay);
            system.debug(pay);
        }
        insert payments;
        //system.debug(payments);
        
        Contact con2 = new Contact();
        con2.LastName = 'Contact2';
        insert con2;
        //system.debug(con2);
        
        Project__c proj2 = new Project__c();
        proj2.Name = 'Project2';
        insert proj2;
        //system.debug(proj2);
        
        //Contact con2 = [SELECT Id, Lastname from Contact where LastName = 'Contact2'];
        //Project__c proj2 = [SELECT Id, Name from Project__c where Name = 'Project2'];
        
        List<Payment__c> payments2 = new List<Payment__c>();
        for(Integer i = 0; i < 10; i++){
            Payment__c pay = new Payment__c();
            pay.Name = 'Payment'+ (i+100);
            pay.Payment_Amount__c = i+100;
            pay.Payment_Date__c = Date.today() - i;
            pay.Contact__c = con2.Id;
            pay.Project__c = proj2.Id;
            payments2.add(pay);
            system.debug(pay);
        }
        insert payments2;
        //system.debug(payments2);

	}
    
    @isTest
    static void testInsert() {
        Contact con = [SELECT Id, Lastname from Contact where LastName = 'Contact1'];
        Project__c proj = [SELECT Id, Name from Project__c where Name = 'Project1'];
        //Contact con2 = [SELECT Id, Lastname from Contact where LastName = 'Contact2'];
        //Project__c proj2 = [SELECT Id, Name from Project__c where Name = 'Project2'];
        
        Payment__c pay = new Payment__c();
        pay.Name = 'PaymentTest';
        pay.Payment_Amount__c = 50000;
        pay.Payment_Date__c = Date.today() + 1;
        pay.Contact__c = con.Id;
        pay.Project__c = proj.Id;
        
        Test.startTest();
        insert pay;
        Test.stopTest();
        
        proj = [SELECT Id, Total_Payments_Amount__c from Project__c where Name = 'Project1'];
        
        System.assertEquals(50045, proj.Total_Payments_Amount__c, 'Project__c.Total_Payments_Amount__c wrong on Insert');
        
		con = [SELECT Id, Total_Payments_Amount__c, Most_Recent_Payment__c from Contact where LastName = 'Contact1'];
        
        System.assertEquals(50045, con.Total_Payments_Amount__c, 'Contact.Total_Payments_Amount__c wrong on Insert');
        
        System.assertEquals(Date.today()+1, con.Most_Recent_Payment__c, 'Contact.Most_Recent_Payment__c wrong on Insert');
        
    }
    
        @isTest
        static void testUpdate() {
            
            Payment__c pay = [SELECT Id, Payment_Amount__c from Payment__c where Payment_Amount__c = 9];
            
            pay.Payment_Amount__c = 19;
            
            Test.startTest();
            update pay;
            Test.stopTest();
            
            Project__c proj = [SELECT Id, Total_Payments_Amount__c from Project__c where Name = 'Project1'];
            
            System.assertEquals(55, proj.Total_Payments_Amount__c, 'Project__c.Total_Payments_Amount__c wrong on Update');
            
            Contact con = [SELECT Id, Total_Payments_Amount__c from Contact where LastName = 'Contact1'];
            
            System.assertEquals(55, con.Total_Payments_Amount__c, 'Contact.Total_Payments_Amount__c wrong on Update');
            
        }

    
        @isTest
        static void testDelete() {
            
            Payment__c pay = [SELECT Id, Payment_Amount__c from Payment__c where Payment_Amount__c = 9];
            
            Test.startTest();
            delete pay;
            Test.stopTest();
            
            Project__c proj = [SELECT Id, Total_Payments_Amount__c from Project__c where Name = 'Project1'];
            
            System.assertEquals(36, proj.Total_Payments_Amount__c, 'Project__c.Total_Payments_Amount__c wrong on Delete');
            
            Contact con = [SELECT Id, Total_Payments_Amount__c from Contact where LastName = 'Contact1'];
            
            System.assertEquals(36, con.Total_Payments_Amount__c, 'Contact.Total_Payments_Amount__c wrong on Delete');
            
        }

}