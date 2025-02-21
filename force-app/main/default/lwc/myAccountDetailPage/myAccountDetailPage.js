import { LightningElement, track, api, wire } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const Account_FIELDS = ["Account.Name", "Account.Phone", "Account.Email__c"];

export default class MyAccountDetailPage extends LightningElement {
    label = {
        title: "Account Detail Page",
    }

    @api recordId;
    account;
    name;
    phone;
    o_user;
    email;

    @wire(getRecord, {
        recordId: "0015g000010snKSAAY",
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
        }
    };

    connectedCallback() {
        console.log("form load succeed!");
    }
}