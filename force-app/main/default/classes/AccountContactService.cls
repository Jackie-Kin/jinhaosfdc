public with sharing class AccountContactService {
    public static void updateActiveContacts(Set<Id> accountIds) {
        List<AggregateResult> results= [SELECT AccountId, Count(Id) contactNumber FROM Contact where Active__c =true and AccountId = :accountIds group by AccountId];

        Map<Id,Account> accs = new Map<Id,Account>();
        for(AggregateResult result : results){
            String accountId = String.valueOf(result.get('AccountId'));
            Integer totalContacts = Integer.valueOf(result.get('contactNumber'));

            Account acc = new Account(Id=accountId,Active_Contacts__c=totalContacts);
            accs.put(accountId,acc);
        }

        for (Id accId :accountIds){
            if (!accs.containsKey(accId)){
                accs.put(accId, new Account(Id=accId, Active_Contacts__c=0));
            }
        }
        update accs.values();
    }
}