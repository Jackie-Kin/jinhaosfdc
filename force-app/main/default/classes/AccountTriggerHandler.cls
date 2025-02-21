public with sharing class AccountTriggerHandler {
    public AccountTriggerHandler() {

    }

    public void BeforeInsert(List<Account> accList){
        for (Account acc: acclist){
            system.debug('Inside AccountTriggerHandler BeforeInsert acc'+acc);
            if(acc.NumberOfEmployees==NULL){
                acc.NumberOfEmployees=1;
            }
            system.debug('Inside AccountTrigger BeforeInsert after'+acc);
        }
    }

    public void AfterInsert(List<Account> accList){
        List<contact> contactList = new List<contact>();

        for (Account acc: acclist){
            system.debug('Inside AccountTriggerHandler Afterinsert acc'+acc);
            for(integer i =0;i<=acc.NumberOfEmployees;i++){
                contact con = new Contact();
                con.AccountId=acc.Id;
                con.LastName=acc.Name+String.valueOf(i);
                contactList.add(con);
            }
        }

        system.debug('Inside AccountTriggerHandler Afterinsert contactList'+contactList);
        if (contactList.size()>0){
            insert contactList;
        }
    }
}