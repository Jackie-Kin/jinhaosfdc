import { LightningElement, track, api, wire } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from '@salesforce/apex';

const Account_FIELDS = ["Account.Id","Account.Name", "Account.Phone", "Account.Email__c"];

export default class AccountInfo extends LightningElement {
    label = {
        title: "Excise: Account Detail Page",
    }

    @api recordId;
    account;
    accountId;
    name;
    phone;
    o_user;
    email;
    totalContacts = 0;

    @wire(getRecord, {
        recordId: "$recordId",
        fields: Account_FIELDS
    })
    wiredRecord({ error, data }) {
        if (error) {

            let message = "Unknown error";
            if (Array.isArray(error.body)) {
                message = error.body.map((e) => e.message).join(", ");
            } else if (typeof error.body.message === "string") {
                message = error.body.message;
            }
            console.log("this.account--------:" + JSON.stringify(data));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error loading account",
                    message,
                    variant: "error",
                }),
            );
        } else if (data) {
            console.log("this.account-----------:" + JSON.stringify(data));
            this.account = data;
            this.name = this.account.fields.Name.value;
            this.phone = this.account.fields.Phone.value;
            this.email = this.account.fields.Email__c.value;

            window.addEventListener('contactCreated', this.handleContactCreated.bind(this));
        }
    };

    connectedCallback() {
        console.log("Account 's accountId:"+this.recordId);
        this.accountId=this.recordId;
    }

    showTotalContacts(event) {
        console.log('event.detail:'+event.detail);
        this.totalContacts = event.detail.quantity;
    }

    handleContactCreated() {
        refreshApex(this.wiredRecord);
    }
}