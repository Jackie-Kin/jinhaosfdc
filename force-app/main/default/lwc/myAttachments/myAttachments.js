import { LightningElement, api, wire } from 'lwc';
// import getAccountFiles from '@salesforce/apex/AttachmentFileCtrl.getAccountFiles';
// import getContactFiles from '@salesforce/apex/AttachmentFileCtrl.getContactFiles';
import getFiles from '@salesforce/apex/AttachmentFileCtrl.getFiles';

const columns = [
    { label: 'File Name', fieldName: 'Title', type: 'text' },
    { label: 'Download Link', fieldName: 'DownloadUrl', type: 'url', typeAttributes: { label: { fieldName: 'Title' }, target: '_blank' } }
];


export default class MyAttachments extends LightningElement {
    @api recordId;
    @api objectType;
    files = [];
    title = "";
    columns = columns;

    @wire(getFiles, { objectId: '$recordId' })
    wiredFiles({ error, data }) {
        if (data) {
            this.files = data.map(file => ({
                Id: file.Id,
                Title: file.ContentDocument.Title,
                DownloadUrl: `/sfc/servlet.shepherd/document/download/${file.ContentDocumentId}`
            }));
        } else if (error) {
            console.error(error);
        }
    }

    connectedCallback() {
       this.title= "Current is "+this.objectType+" attachment files";
    }

}