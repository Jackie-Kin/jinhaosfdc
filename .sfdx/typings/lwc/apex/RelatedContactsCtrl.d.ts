declare module "@salesforce/apex/RelatedContactsCtrl.loadRelatedContacts" {
  export default function loadRelatedContacts(param: {accountId: any}): Promise<any>;
}
declare module "@salesforce/apex/RelatedContactsCtrl.createContact" {
  export default function createContact(param: {accountId: any, firstName: any, lastName: any, phone: any, email: any}): Promise<any>;
}
