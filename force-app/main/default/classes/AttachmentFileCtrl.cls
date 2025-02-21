public with sharing class AttachmentFileCtrl {
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getFiles(Id objectId) {
        return [
            SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileType 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :objectId
        ];
    }
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getAccountFiles(Id accountId) {
        return [
            SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileType 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :accountId
        ];
    }
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getContactFiles(Id contactId) {
        return [
            SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileType 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :contactId
        ];
    }
}