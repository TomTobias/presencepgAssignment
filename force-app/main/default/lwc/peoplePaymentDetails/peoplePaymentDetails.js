import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPeoplePaymentDetails from '@salesforce/apex/PaymentsService.getPeoplePaymentDetails';
import updatePaymentList from '@salesforce/apex/PaymentsService.updatePaymentList';
import { refreshApex } from '@salesforce/apex';


const SUCCESS_TITLE = 'Success';
const MESSAGE_SHIP_IT = '';
const SUCCESS_VARIANT = 'success';
const ERROR_TITLE   = 'Error';
const ERROR_VARIANT = 'error';

export default class PeoplePaymentDetails extends LightningElement {
    columns = [
        { label: 'Payment Date', fieldName: 'Payment_Date__c', type: 'date-local', editable: 'true' },
        { label: 'Payment Amount', fieldName: 'Payment_Amount__c', type: 'currency', editable: 'true', cellAttributes: { alignment: 'left' } },
    ];

    actions = [
      { label: 'Delete', name: 'delete' }
    ];

    @api contactid = '';

    @wire(getPeoplePaymentDetails, {contactId: '$contactid'})
    peoplePaymentDetails;


    // debugging from button
    handleClick(event) {
      console.log(this.clickedButtonLabel);
      console.log(this.contactid);
      console.log(this.peoplePaymentDetails);
    }

    @api 
    async refresh() {
      await refreshApex(this.peoplePaymentDetails);
    }

    handleSave(event) {
        const updatedFields = event.detail.draftValues;
        // Update the records via Apex
        updatePaymentList({data: updatedFields})
        .then(() => {
          this.refresh();
          const event = new ShowToastEvent({
            title: SUCCESS_TITLE,
            variant: SUCCESS_VARIANT,
            message: MESSAGE_SHIP_IT
          });
          this.dispatchEvent(event);
          
          // alert parent to refresh summary data
          const refreshEvent = new CustomEvent('refreshsummary');
          this.dispatchEvent(refreshEvent);
         })
        .catch(error => {
          const event = new ShowToastEvent({
            title: ERROR_TITLE,
            variant: ERROR_VARIANT
          });
          this.dispatchEvent(event);
        })
      }

}