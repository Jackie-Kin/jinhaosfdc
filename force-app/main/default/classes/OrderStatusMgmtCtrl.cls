// controller class for orderStatusManagement lightning component
public with sharing class OrderStatusMgmtCtrl {
    
    /**
     * @Description load the order lines and the initial params
     * @Input orderId
     * @Return AuraResponse
     */
    @AuraEnabled
    public static AuraResponse loadOLs(String orderId) {
        AuraResponse res = new AuraResponse();
        try {
            Order o = [SELECT Id, Status FROM Order WHERE Id = :orderId];
            System.debug('o.Status:'+o.Status);
            if(o.Status != 'Activated'){
                throw new OrderMgmtException(OrderStatusMgmtConsts.OD_STATUS_CHECK_FAILED);
            }

            // get data table columns
            List<Column> columns = initColumns();

            // get data to display
            List<OIWrapper> availableOiwList = new List<OIWrapper>();
            List<OIWrapper> rejectedOiwList = new List<OIWrapper>();
            for(OrderItem oi : [SELECT Id, Product2.Name, Quantity, UnitPrice, TotalPrice, Reject_Reason__c, Status1__c 
                                FROM OrderItem 
                                WHERE OrderId = :orderId AND Status1__c IN (null, 'Draft', 'Submitted', 'Rejected')]){
                if(oi.Status1__c != 'Rejected'){
                    availableOiwList.add(new OIWrapper(oi));
                } else {
                    rejectedOiwList.add(new OIWrapper(oi));
                }
            }
            System.debug('availableOiwList:'+availableOiwList);
            System.debug('rejectedOiwList'+rejectedOiwList);
            
            Map<String, Object> data = new Map<String, Object>();
            data.put('availableOiwList', availableOiwList);
            data.put('rejectedOiwList', rejectedOiwList);
            data.put('columns', columns);
            data.put('rrOptions', getRROptions());
            
            System.debug('data:'+data);
            res.setSuccess(data, null);
        } catch (Exception e) {
            res.msg = e.getMessage();
            System.debug('res.msg:'+res.msg);
        }
        return res;
    }

    private static List<Column> initColumns() {
        List<Column> columns = new List<Column>();
        columns.add(new Column('Product', 'ProductName', null));
        columns.add(new Column('Quantity', 'Quantity', null));
        columns.add(new Column('Unit Price', 'UnitPrice', 'currency'));
        columns.add(new Column('Total Price', 'TotalPrice', 'currency'));
        columns.add(new Column('Rejection Reason', 'RejectionReason', null));
        return columns;
    }

    private static List<Option> getRROptions() {
        List<Option> options = new List<Option>();
        for (Schema.PicklistEntry op : OrderItem.Reject_Reason__c.getDescribe().getPicklistValues()) {
            options.add(new Option(op.getLabel(), op.getValue()));
        }
        return options;
    }

    /**
     * @Description update order line rejection reason
     * @Input oiws
     * @Input rejectReason
     * @Return AuraResponse
     */
    @AuraEnabled
    public static AuraResponse rejectOLs(List<OIWrapper> oiws, String rejectReason) {
        System.debug('--- oiws: ' + oiws);
        AuraResponse res = new AuraResponse();
        try{
            // validation...

            List<OrderItem> ois = new List<OrderItem>();
            for(OIWrapper oiw : oiws){
                OrderItem oi = new OrderItem();
                ois.add(oi);
                oi.Id = oiw.Id;
                oi.Reject_Reason__c = rejectReason;
                oi.Status1__c = 'Rejected';
            }
            update ois;
            res.setSuccess(null, OrderStatusMgmtConsts.MSG_ACTION_SUCCESS);
        } catch (Exception e) {
            res.msg = e.getMessage();
        }
        return res;
    }

    /**
     * @Description update order line rejection reason
     * @Input orderId
     * @Input oiws
     * @Return AuraResponse
     */
    @AuraEnabled
    public static AuraResponse unrejectOis(List<OIWrapper> oiws) {
        System.debug('--- oiws: ' + oiws);
        AuraResponse res = new AuraResponse();
        try {
            List<OrderItem> ois = new List<OrderItem>();
            for(OIWrapper oiw : oiws){
                OrderItem oi = new OrderItem();
                ois.add(oi);
                oi.Id = oiw.Id;
                oi.Reject_Reason__c = null;
                oi.Status1__c = 'Draft';
            }
            update ois;
            res.setSuccess(null, OrderStatusMgmtConsts.MSG_ACTION_SUCCESS);
        } catch (Exception e) {
            res.msg = e.getMessage();
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

    public class Column {
        @AuraEnabled public String label;
        @AuraEnabled public String fieldName;
        @AuraEnabled public String type;

        public Column(String label, String fieldName, String type) {
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
        }
    }

    public class Option {
        @AuraEnabled public String label;
        @AuraEnabled public String value;
        public Option(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }

    // add a wrapper class for datatable, because product name is from a related object, 
    // datatable does not support to get value from nested objects.
    public class OIWrapper {
        @AuraEnabled public String Id {get; set;}
        @AuraEnabled public String ProductName {get; set;}
        @AuraEnabled public Decimal Quantity {get; set;}
        @AuraEnabled public Decimal UnitPrice {get; set;}
        @AuraEnabled public Decimal TotalPrice {get; set;}
        @AuraEnabled public String RejectionReason {get; set;}

        public OIWrapper(){}

        public OIWrapper(OrderItem oi) {
            this.Id = oi.Id;
            this.ProductName = oi.Product2.Name; //from related product object
            this.Quantity = oi.Quantity;
            this.UnitPrice = oi.UnitPrice;
            this.TotalPrice = oi.TotalPrice;
            this.RejectionReason = oi.Reject_Reason__c;
        }
    }

    public class OrderMgmtException extends Exception{}
}