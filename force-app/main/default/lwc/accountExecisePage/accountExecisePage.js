import { LightningElement, track, api } from 'lwc';
import loadRecentAccounts from '@salesforce/apex/RecentViewedAccountCtl.loadAccounts';
import { loadScript } from 'lightning/platformResourceLoader';
import jquery from '@salesforce/resourceUrl/JQuery';

export default class AccountExecisePage extends LightningElement {

    @track columns = [
        { 
            label: 'Name', 
            fieldName: 'UrlLink', 
            type: 'url',
            typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}
        },
        { label: 'Phone', fieldName: 'Phone', type: 'string' }
    ];

    @track recentAccountList = [];

    label = {
        title: "My recent account page",
    }

    initComp() {

       loadRecentAccounts().then(result => {
            if(result.success) {
                console.log("result.data.actList:"+JSON.stringify(result.data.actList));
                console.log("result.data.columns:"+JSON.stringify(result.data.columns));
                //columns = result.data.columns;
                this.recentAccountList = result.data.actList;
            } else {
                this.showMsg("error", "Error", result.msg);
                this.closeAction();
            }
        })
        .catch(error => {
            this.recentAccountList = [];
            this.showMsg("error", "Error", error.body.message);
        }).finally(() => {
             
        });
    }

    connectedCallback() {
    // load the jQuery script only after the component is rendered

        loadScript(this, jquery)
            .then(() => {

                // use jQuery in your component logic

                console.log('jQuery loaded');

            })

            .catch(error => {

                // handle any errors

                console.error(error);

            });


        this.initComp();
    }


}