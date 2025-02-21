import { LightningElement, api } from 'lwc';

export default class OrderStatusPicker extends LightningElement {
    @api defaultVal = '';
    @api options = [];

    label = {
        title: 'Select Reason',
        rejectionReasonComb: 'rejectionReasonComb',
        rejectionReasonLabel: 'Rejection Reasion',
        placeholder: 'Select an option',
        confirmBtn: 'Confirm',
        cancelBtn: 'Cancel'
    }

    confirmReason() {
        let rrComb = this.template.querySelector('lightning-combobox[data-name="' + this.label.rejectionReasonComb + '"]');
        if(rrComb.reportValidity()) {
            let crEvt = new CustomEvent('reasonselected', {
                detail: {
                    reason: rrComb.value
                }
            })
            this.dispatchEvent(crEvt);
        }
    }

    closeAction() {
        this.dispatchEvent(new CustomEvent('close'));
    }
}