import { LightningElement,track,api } from 'lwc';

export default class Helloworld extends LightningElement {
    greeting = "Jackie's world"

    changeHandler(e){
        this.greeting = e.target.value
    }

    @track greetingObj = {name:"Init value from greetingObj"}
    @api myAPIProperty;

    handleClick(e){
        this.greetingObj.name = "Value Changed"
    }

    connectedCallback() {
        //code
    }
}