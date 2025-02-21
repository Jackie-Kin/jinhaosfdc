import { LightningElement, api, wire } from "lwc";
import { getRecord } from "lightning/uiRecordApi";
const FIELDS = ["Account.Rating"];

export default class StartOnRecordPage extends LightningElement {
  @api recordId;
}