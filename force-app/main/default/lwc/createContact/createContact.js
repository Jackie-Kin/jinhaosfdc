import { LightningElement, track, api, wire } from 'lwc';

export default class CreateContact extends LightningElement {
    @api accountId;
    firstName="";
    lastName="";
    phone="";
    email="";

    handleFirstNameChange(e){
        this.firstName = e.target.value;
    }
    handleLastNameChange(e){
        this.lastName = e.target.value;
    }
    handlePhoneChange(e){
        this.phone = e.target.value;
    }
    handleEmailChange(e){
        this.email = e.target.value;
    }        
    

    handleConfirm() {
        // this.firstName = this.template.querySelector("lightning-input[name='FirstName']").value;
        
        let crEvt = new CustomEvent('contactcreated', {
                    detail: {
                        firstName:this.firstName,
                        lastName:this.lastName,
                        phone:this.phone,
                        email:this.email
                    }
                })
        this.dispatchEvent(crEvt);
    }

    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    connectedCallback() {
    }
}