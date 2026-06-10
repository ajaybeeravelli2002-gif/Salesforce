public with sharing class MyContactListController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(Id recordId) {
        try{
       return [Select Id, FirstName, LastName, Email, Phone FROM Contact WHERE AccountId = :recordId];
        }
        catch (Exception e) {
            // Throw an AuraHandledException to send a user-friendly error to the LWC
            throw new AuraHandledException('Error retrieving contacts: ' + e.getMessage());
        }
    }
}