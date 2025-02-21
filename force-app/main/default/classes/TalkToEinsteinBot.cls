public class TalkToEinsteinBot {
	@InvocableMethod(Label = 'Talk To Einstein Bot')
    public static void getValueFromBot(List<String> caseNumberList){
        System.debug('caseNumberList:'+caseNumberList);
        Case caseObj = [Select Id, Description from Case where CaseNumber =:caseNumberList[0]];
        caseObj.Description = 'The case is closed';
        update caseObj;
    }
}