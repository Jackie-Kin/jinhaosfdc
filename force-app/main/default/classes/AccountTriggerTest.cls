@isTest
public with sharing class AccountTriggerTest {

    private static void AccouintInsertTest(){
        Account acc =new Account();
        acc.name='MyTestAcc';

        test.startTest();
        insert acc;
        test.stopTest();
        id accId = acc.id;

        Account accRecord = [select id,NumberOfEmployees from account where id=:accId];

        system.assertEquals(1,accRecord.NumberOfEmployees);
    }

}