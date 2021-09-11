import { LightningElement, wire } from 'lwc';
//import getPeoplePayments from '@salesforce/apex/PeoplePayments.getPeoplePayments';
import getPeoplePaymentSummaries from '@salesforce/apex/PaymentsService.getPeoplePaymentSummaries';

export default class PeoplePayments extends LightningElement {
    
    @wire(getPeoplePaymentSummaries) 
    peoplePaymentSummaries;

    

    
}