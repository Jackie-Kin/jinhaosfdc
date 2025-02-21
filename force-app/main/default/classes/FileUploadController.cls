public with sharing class FileUploadController {
  @AuraEnabled
  public static String loadData(Id contentDocumentId) {
    String strMessage;
    List<Contact> contactList = new List<Contact>();
    if (contentDocumentId != null) {
      ContentVersion contentVersionObj = [
        SELECT Id, VersionData
        FROM ContentVersion
        WHERE ContentDocumentId = :contentDocumentId
      ];
      List<String> records = contentVersionObj.VersionData.toString()
        .split('n');
      //Removing the Header
      records.remove(0);

      for (String record : records) {
        if (record != null) {
          Contact objContact = new Contact();
          List<String> row = record.split(',');
          objContact.FirstName = row[0];
          objContact.LastName = row[1];
          objContact.Email = row[2];
          contactList.add(objContact);
        }
      }

      try {
        if (contactList.size() > 0) {
          Database.DeleteResult deleteResult = Database.delete(
            contentDocumentId,
            true
          );
          insert contactList;
          strMessage = 'Records loaded successfully';
        }
      } catch (Exception e) {
        strMessage = 'Some error occured. Please reach out to your System Admin';
        system.debug(e.getMessage());
      }
    }

    return strMessage;
  }
}