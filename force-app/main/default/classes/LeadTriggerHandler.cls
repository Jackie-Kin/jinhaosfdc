public class LeadTriggerHandler {
    public static Boolean alreadyExecuted = false;
    
    public static void beforeInsertHandler(List<Lead> newRecords){
        for(Lead leadRecord:newRecords){
            if (String.isBlank(leadRecord.leadSource) && Trigger.isBefore){
                leadRecord.leadSource='Other'; 
            }
            
            if(String.isBlank(leadRecord.industry) && Trigger.isInsert){
                leadRecord.addError('The industry field cannot be blank');
            }
        }
    }
    
    public static void afterInsertHandler(List<Lead> newRecords){
        List<Task> leadTasks = new List<Task>();
        
        for(Lead leadRecord:newRecords){
            Task leadTask = new Task(subject='Follow up on lead status',whoId=leadRecord.Id);
            leadTasks.add(leadTask);            
        }
        
        //Bulkify
        insert leadTasks; 
        
        if (LeadTriggerHandler.alreadyExecuted==false){
            LeadTriggerHandler.alreadyExecuted=true;
            Lead anotherLead = new Lead(LastName='Test Lead Single',Status='Open - Not Contacted',Company='Test',Industry='Agriculture');
            Insert anotherLead;            
        }
    }
    
    public static void beforeUpdateHandler(List<Lead> newRecords,Map<Id,Lead> oldRecordsMap){
        for(Lead leadRecord:newRecords){
            if (String.isBlank(leadRecord.leadSource) && Trigger.isBefore){
                leadRecord.leadSource='Other'; 
            }
            
            if(leadRecord.Status =='Closed - Converted' || leadRecord.Status =='Closed - Not Converted' && oldRecordsMap.get(leadRecord.Id).Status=='Open - Not Contacted'){
                leadRecord.Status.addError('You cannot directly close an open lead record ');
            }
        }  
    }
}