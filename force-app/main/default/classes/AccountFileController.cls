public with sharing class AccountFileController {
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getAccountFiles(Id accountId) {
        return [
            SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileType 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :accountId
        ];
    }
}