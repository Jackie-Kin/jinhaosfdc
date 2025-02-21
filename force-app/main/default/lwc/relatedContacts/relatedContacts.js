import { LightningElement, track, api, wire } from 'lwc';
import loadRelatedContacts from '@salesforce/apex/RelatedContactsCtrl.loadRelatedContacts';
import createContact from '@salesforce/apex/RelatedContactsCtrl.createContact';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';

export default class RelatedContacts extends NavigationMixin(LightningElement) {
    isContactEmpty = true;

    @track columns = [
        { label: 'FirstName', fieldName: 'FirstName' },
        { label: 'LastName', fieldName: 'LastName' },
        { label: 'Email', fieldName: 'Email' },
        { label: 'Phone', fieldName: 'Phone' }
    ];

    @track contactList = [];
    @api accountId;
    totalAccount = 0;
    newContactName = '';
    isShowContactCreate = false;
    // columns = ["FirstName","LastName","Email","Phone"];


    // @wire(loadRelatedContacts, { accountId: '$accountId' })
    // wiredContacts({ error, data }) {
    //     if (data) {
    //         this.contactList = data;
    //         this.error = undefined;
    //     } else if (error) {
    //         this.error = error;
    //         this.contacts = undefined;
    //     }
    // }

    initComp() {
        console.log("this.accountId:" + this.accountId);

        loadRelatedContacts({ accountId: this.accountId })
            .then(result => {
                this.isEmpty = true;
                if (result.success) {
                    console.log("contact result.data:" + JSON.stringify(result.data));
                    this.contactList = result.data.account;

                    this.isContactEmpty = result.data.account.length === 0;
                    this.totalAccount = this.contactList.length;
                } else {
                    this.showMsg("error", "Contact Error", result.msg);
                }
            })
            .catch(error => {
                this.contactList = [];
                this.isContactEmpty = true;
                this.showMsg("error", "Error", error.body.message);
            }).finally(() => {
                console.log("Contact load complete");

                let crEvt = new CustomEvent('totalcontacts', {
                    detail: {
                        quantity: this.totalAccount
                    }
                })
                this.dispatchEvent(crEvt);
            });
    }

    showMsg(variant, title, msg) {
        let mode = variant == 'success' ? "dismissible" : "sticky";
        const event = new ShowToastEvent({
            "variant": variant,
            "title": title,
            "message": msg,
            "mode": mode,
            "label": "msg"
        });
        this.dispatchEvent(event);
    }

    connectedCallback() {
        this.initComp();
    }

    handleNameChange(event) {
        this.newContactName = event.target.value;
        console.log('event.target.value:' + event.target.value);
    }

    handleClose() {
        this.isShowContactCreate = false;
    }

    handleContactCreated(e) {
        console.log('e.detail:'+JSON.stringify(e.detail));
        this.isShowContactCreate = false;
        createContact({
            accountId: this.accountId,
            firstName: e.detail.firstName,
            lastName: e.detail.lastName,
            phone: e.detail.phone,
            email: e.detail.email
        }).then(result => {
            if (result.success) {
                !!result.msg && this.showMsg("success", "Success", result.msg);
                this.contactList = [...this.contactList, result.contact];
                console.log('this.contactList:'+this.contactList);
            } else {
                this.showMsg("error", "Error", result.msg);
            }
        })
        .catch(error => {
            console.log('error:'+JSON.stringify(error));
            this.showMsg("error", "Error", error.body.message);
        }).finally(() => {
            this.initComp();
        });
    }

    showMsg(variant, title, msg) {
        let mode = variant == 'success' ? "dismissible" : "sticky";
        const event = new ShowToastEvent({
            "variant": variant,
            "title": title,
            "message": msg,
            "mode": mode
        });
        this.dispatchEvent(event);
    }

    // handleCreateContact() {
    //     if (this.newContactName) {
    //         console.log('this.accountId:'+this.accountId+'/this.newContactName:'+this.newContactName);
    //         createContact({ accountId: this.accountId, name: this.newContactName })
    //             .then(contact => {
    //                 this.contactList = [...this.contactList, contact];
    //                 this.newContactName = '';
    //             })
    //             .catch(error => {
    //                 this.error = error;
    //             });
    //     }
    // }

    handleCreateContact() {
        console.log('handleCreateContact start');
        this.isShowContactCreate = true;
        // console.log('handleCreateContact start');
        // window.dispatchEvent(new CustomEvent('contactCreated'));

        // this[NavigationMixin.Navigate]({
        //     type: 'standard__objectPage',
        //     attributes: {
        //         objectApiName: 'Contact',
        //         actionName: 'new'
        //     },
        //     state: {
        //         defaultFieldValues: `AccountId=${this.accountId}`,
        //         navigationLocation: 'RELATED_LIST',
        //         // navigationLocation:this.recordPageUrl,
        //         customState: 'fromLWC'
        //     }

        // }).then((url) => {
        //     console.log('refreshApex start');
        //     // this.recordPageUrl = 'https://163com38-dev-ed.lightning.force.com/lightning/r/Account/'+this.accountId+'/view';
        //     // this.dispatchEvent(new CloseActionScreenEvent());
        //     // refreshApex(this.initComp());
        // });
        // // });

        // // this[NavigationMixin.Navigate]({
        // //     "type": "standard__component",
        // //     "attributes": {
        // //         //Here customLabelExampleAura is name of lightning aura component
        // //         //This aura component should implement lightning:isUrlAddressable
        // //         "componentName": "c-related-contacts"
        // //     }
        // // });

        //     // console.log('refreshApex start');
        //     // this.dispatchEvent(new CloseActionScreenEvent());
        //     // refreshApex(this.initComp());
    }
}