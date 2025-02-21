public with sharing class MyAccountDetail {
    
	@AuraEnabled
    public static AuraResponse loadAccountDetail(Id accountId) {
        System.debug('accountId:'+accountId);
        
        AuraResponse res = new AuraResponse();
        try {
          	Account act =[SELECT Id, Name,Phone,Email__c
                                FROM Account
                                WHERE id =:accountId
                           ];

            Map<String, Object> data = new Map<String, Object>();
            data.put('Name', act.Name);
            data.put('Phone', act.Phone);
            data.put('Email', act.Email__c);
            System.debug('data:'+data);
            
            res.setSuccess(data, null);
        } catch (Exception e) {
            res.msg = e.getMessage();
            System.debug('res.msg:'+res.msg);
        }
        return res;
    }
    
    public class OIWrapper {
        @AuraEnabled public String Id {get; set;}
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public String Phone {get; set;}
        
        public OIWrapper(){}

        public OIWrapper(Account act) {
            this.Id = act.Id;
            this.Name = act.Name;
            this.Phone = act.Phone;
        }
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