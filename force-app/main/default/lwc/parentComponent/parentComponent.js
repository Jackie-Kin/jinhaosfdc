import { LightningElement } from 'lwc';

export default class ParentComponent extends LightningElement {
    accountId;

    handleNavigate(event) {
        this.accountId = event.detail.accountId;
    }
}