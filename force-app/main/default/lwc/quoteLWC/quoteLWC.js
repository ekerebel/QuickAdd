// apexImperativeMethod.js
import { LightningElement, track, api } from 'lwc';
import addProducts from '@salesforce/apex/QuoteCardController.addProducts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ApexImperativeMethod extends LightningElement {
    @track contacts;
    @track error;
    @track loading;
    @api recordId;
    @track myProductCodes;
    _title = 'Sample Title';
    message = 'Sample Message';
    variant = 'error';

    handleAdd(){
        this.loading=true;
        console.log('===ADDING==='+this.recordId+' <== '+this.myProductCodes);
         addProducts({quoteId: this.recordId, productCodes: this.myProductCodes})
            .then(result => {
                console.log('==OK==');
                this._title = 'Your product(s) was(were) successfully added to the quote.';
                this.message = 'You can now go to the Quote Line Editor';
                this.variant = 'success';
                this.loading=false;
                this.showNotification();
                //window.location = "/one/one.app#/alohaRedirect/apex/SBQQ__sb?id="+this.recordId;
            })
            .catch(error => {
                console.log('=ERROR=');
                this._title = 'There was an error loading your product(s) into this quote.';
                this.message = 'Check that your Product Codes are correct.';
                this.variant = 'error';
                this.loading=false;
                this.showNotification();
            });
    }
    handleChangeProducts(evt) {
        this.myProductCodes = evt.target.value;
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }


    
}