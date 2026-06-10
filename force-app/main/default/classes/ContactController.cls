public class ContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String accountId) {
        try {
            return [SELECT Name, Email, Phone, Account.Name, Account.AnnualRevenue, Account.NumberOfEmployees 
                    FROM Contact 
                    WHERE AccountId = :accountId];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching contacts: ' + e.getMessage());
        }
    }
}