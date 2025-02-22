@isTest
public with sharing class ContactTriggerHandlerTest {
    @isTest
    public static void afterInsertHandlerTest2() {
        List<Account> accs = [SELECT Id, Name, Active_Contacts__c FROM Account];
        for (Account acc : accs) {

        }

        List<Contact> allContacts = [SELECT Id FROM Contact];
    }

}
