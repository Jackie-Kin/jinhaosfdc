public with sharing class RelatedContactsCtrl {
	@AuraEnabled
    public static AuraResponse loadRelatedContacts(Id accountId) {
        System.debug('accountId:'+String.valueOf(accountId));
        
        AuraResponse res = new AuraResponse();
        try {
          	List<Contact> act =[SELECT Id, FirstName,LastName,Email,Phone
                                FROM Contact
                                WHERE AccountId =:accountId
                           ];

            Map<String, Object> data = new Map<String, Object>();
            data.put('account', act);
            System.debug('data:'+data);
            
            res.setSuccess(data, null);
        } catch (Exception e) {
            res.msg = e.getMessage();
            System.debug('res.msg:'+res.msg);
        }
        return res;
    }
    
    @AuraEnabled
    public static AuraResponse createContact(Id accountId, String firstName,String lastName, String phone, String email ) {
        System.debug('accountId:'+accountId+'firstName:'+firstName+'lastName:'+lastName+'phone:'+phone+'email:'+email);
        AuraResponse res = new AuraResponse();
        
        try{
            Contact newContact = new Contact(
                AccountId = accountId,
                FirstName = firstName,
                LastName = lastName,
                Phone = phone,
                Email = email
            );
            insert newContact;
            Map<String, Object> data = new Map<String, Object>();
            data.put('contact', newContact);
            
        	res.setSuccess(data, null);
        }catch (Exception e) {
            res.msg = e.getMessage();
            System.debug('res.msg:'+res.msg);
        }
        
		return res;
    }
    
    /**
     * Wrapper classes below
     */
    public class AuraResponse {
        @AuraEnabled public Boolean success;
        @AuraEnabled public String msg;
        @AuraEnabled public Object data;

        public AuraResponse() {
            success = false;
            msg = 'Unknown error';
        }

        public void setSuccess(Object data, String msg) {
            this.success = true;
            this.data = data;
            this.msg = msg;
        }
    }
}