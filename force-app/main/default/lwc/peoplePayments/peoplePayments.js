import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getPeoplePaymentSummaries from '@salesforce/apex/PaymentsService.getPeoplePaymentSummaries';
import { refreshApex } from '@salesforce/apex';

export default class PeoplePayments extends NavigationMixin(LightningElement) {
    
    @track customFormModal = false; 
    @track peoplePaymentSummaries = [];
    wiredPeoplePaymentSummaries; // for apex refresh

    @wire(getPeoplePaymentSummaries) 
    peoplePaySum(result){
        this.wiredPeoplePaymentSummaries = result
        if(result.data) {
            this.peoplePaymentSummaries = result.data
            this.error = undefined
        } else if (result.error){
            this.error = result.error
            this.peoplePaymentSummaries = [];
        }
    }
    
    handleRefreshSummary() {
        refreshApex(this.wiredPeoplePaymentSummaries)
        console.log('received refreshsummary event')
    }
    
    customShowModalPopup() {            
        this.customFormModal = true;
    }
 
    customHideModalPopup() {    
        
        this.customFormModal = false;
    }
    savePaymentRecord() {
        
    }
}