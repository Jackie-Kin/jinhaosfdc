trigger LeadTrigger on Lead (before insert,after insert,before update,after update) {
    switch on Trigger.operationType{
        when BEFORE_INSERT{
            LeadTriggerHandler.beforeInsertHandler(Trigger.New);
        }
        
        when AFTER_INSERT{
            LeadTriggerHandler.afterInsertHandler(Trigger.New);
        }
        
        when BEFORE_UPDATE{
            LeadTriggerHandler.beforeUpdateHandler(Trigger.new,Trigger.oldMap); 
        }
    }
}