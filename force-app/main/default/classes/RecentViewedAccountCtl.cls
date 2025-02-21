public with sharing class RecentViewedAccountCtl{
    @AuraEnabled
    public static AuraResponse loadAccounts() {
        AuraResponse res = new AuraResponse();
        try {
             List<Column> columns = initColumns();
             List<OIWrapper> actList = new List<OIWrapper>();

            
            for(Account act : [SELECT Id, Name,Phone
                                FROM Account
                                WHERE LastViewedDate !=null
                                ORDER BY LastViewedDate DESC
                                ]){
                                    
                actList.add(new OIWrapper(act));
            }
            
            Map<String, Object> data = new Map<String, Object>();
            data.put('actList', actList);
            data.put('columns', columns);
         
            res.setSuccess(data, null);
        } catch (Exception e) {
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
    
    // add a wrapper class for datatable, because product name is from a related object, 
    // datatable does not support to get value from nested objects.
    public class OIWrapper {
        @AuraEnabled public String Id {get; set;}
        @AuraEnabled public String Name {get; set;}
        @AuraEnabled public String Phone {get; set;}
        @AuraEnabled public String UrlLink {get; set;}
        @AuraEnabled public String Email {get; set;}
        
        public OIWrapper(){}

        public OIWrapper(Account act) {
            this.Id = act.Id;
            this.Name = act.Name;
            this.Phone = act.Phone;
            this.UrlLink = '/lightning/n/AccountDetailPage?id='+act.Id;
            this.Email = act.Phone;
        }
    }    
    
    public class Column {
        @AuraEnabled public String label;
        @AuraEnabled public String fieldName;
        @AuraEnabled public String type;
        
        public Column(String label, String fieldName,String type) {
            this.label = label;
            this.fieldName = fieldName;
            this.type= type;
        }
    }
    
   private static List<Column> initColumns() {
        List<Column> columns = new List<Column>();
        columns.add(new Column('Name', 'urlLink','url'));
        columns.add(new Column('Phone', 'Phone',null));
        return columns;
    }
}