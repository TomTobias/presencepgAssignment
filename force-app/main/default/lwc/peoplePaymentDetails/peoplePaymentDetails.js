import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPeoplePaymentDetails from '@salesforce/apex/PaymentsService.getPeoplePaymentDetails';
import updateContactList from '@salesforce/apex/PaymentsService.updateContactList';
import { refreshApex } from '@salesforce/apex';


const SUCCESS_TITLE = 'Success';
const MESSAGE_SHIP_IT = 'Ship it!';
const SUCCESS_VARIANT = 'success';
const ERROR_TITLE   = 'Error';
const ERROR_VARIANT = 'error';

export default class PeoplePaymentDetails extends LightningElement {
    columns = [
        { label: 'Payment Date', fieldName: 'Payment_Date__c', type: 'date-local', editable: 'true' },
        { label: 'Payment Amount', fieldName: 'Payment_Amount__c', type: 'currency', editable: 'true' },
    ];

    clickedButtonLabel;
    @api contactid = '';

    @wire(getPeoplePaymentDetails, {contactId: '$contactid'})
    peoplePaymentDetails;

    wiredActivities; // for apex refresh
    handleClick(event) {
      this.clickedButtonLabel = event.target.label;
      console.log(this.clickedButtonLabel);
      console.log(this.contactid);
      console.log(this.peoplePaymentDetails);
    }

    // this public function must refresh the boats asynchronously
    @api 
    async refresh() {
      await refreshApex(this.peoplePaymentDetails);
    }
    handleSave(event) {
        const updatedFields = event.detail.draftValues;
        // Update the records via Apex
        updateContactList({data: updatedFields})
        .then(() => {
          this.refresh();
          const event = new ShowToastEvent({
            title: SUCCESS_TITLE,
            variant: SUCCESS_VARIANT,
            message: MESSAGE_SHIP_IT
          });
          this.dispatchEvent(event);
    
         })
        .catch(error => {
          const event = new ShowToastEvent({
            title: ERROR_TITLE,
            variant: ERROR_VARIANT
          });
          this.dispatchEvent(event);
        })
        .finally(() => {
        });
      }
}