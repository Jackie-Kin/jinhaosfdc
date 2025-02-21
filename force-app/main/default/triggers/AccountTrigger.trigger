trigger AccountTrigger on Account (before insert) {
    AccountTriggerHandler handler = new AccountTriggerHandler();

    if (Trigger.isBefore){
        handler.BeforeInsert(Trigger.new);
    }
    if(trigger.isAfter){
        handler.AfterInsert(trigger.new);
    }
    else if(trigger.isUpdate){
        
    }
}