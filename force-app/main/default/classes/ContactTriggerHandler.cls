public with sharing class ContactTriggerHandler {
    public static void afterInsertHandler(List<contact> newContacts) {
          Set<Id> accountIds = new Set<Id>();
          for(Contact con: newContacts){
              if(!String.isblank(con.AccountId)){
                  String accId = con.AccountId;
                  accountIds.add(accId);
              }
          }

          AccountContactService.updateActiveContacts(accountIds);
    }
    public static void afterUpdateHandler(List<Contact> newContacts,Map<Id,Contact> oldMapContacts) {
            Set<Id> accountIds = new Set<Id>();
            for(Contact con: newContacts){
                if(!String.isblank(con.AccountId) && oldMapContacts.get(con.Id).Active__c!=con.Active__c){
                    String accId = con.AccountId;
                    accountIds.add(accId);
                }else if(oldMapContacts.get(con.Id).AccountId!=con.AccountId){
                    accountIds.add(con.AccountId);
                    accountIds.add(oldMapContacts.get(con.Id).AccountId);
                }
            }

            AccountContactService.updateActiveContacts(accountIds);
    }

    public static void afteDeleteHandler(List<Contact> oldContacts) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact con: oldContacts){
            if(!String.isblank(con.AccountId)){
                String accId = con.AccountId;
                accountIds.add(accId);
            }
        }

        AccountContactService.updateActiveContacts(accountIds);
    }

    public static void afteUndeleteHandler(List<Contact> newContacts) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact con: newContacts){
            if(!String.isblank(con.AccountId)){
                String accId = con.AccountId;
                accountIds.add(accId);
            }
        }

        AccountContactService.updateActiveContacts(accountIds);
    }
}