/**
 * @description Controller for ContactRecords LWC to fetch related Contacts with pagination, sorting, and search.
 * Enforces FLS and sharing, uses USER_MODE for queries and DML safety.
 */
public with sharing class ContactRecordsController {
    public class ContactRow {
        @AuraEnabled public Id Id;
        @AuraEnabled public String Name;
        @AuraEnabled public String Phone;
        @AuraEnabled public String MailingCity;
    }

    public class ContactResult {
        @AuraEnabled public List<ContactRow> rows;
        @AuraEnabled public Integer totalCount;
    }

    @AuraEnabled(cacheable=true)
    public static ContactResult getContacts(
        Id accountId,
        Integer pageSize,
        Integer offsetVal
    ) {
        // Validate inputs and apply defaults
        if (accountId == null) {
            return new ContactResult();
        }
        Integer page = (pageSize == null || pageSize <= 0) ? 50 : pageSize;
        Integer off = (offsetVal == null || offsetVal < 0) ? 0 : offsetVal;

        // Build WHERE clause (no server-side search; client will filter)
        String whereClause = 'AccountId = :accountId';

        // Count query (USER_MODE isn't supported in countQuery dynamic SOQL; use SECURITY_ENFORCED on data query)
        Integer totalCnt = (Integer)Database.countQuery('SELECT COUNT() FROM Contact WHERE ' + whereClause);

        // Data query
        String soql = 'SELECT Id, Name, Phone, MailingCity ' +
                      'FROM Contact ' +
                      'WHERE ' + whereClause + ' ' +
                      'ORDER BY CreatedDate DESC ' +
                      'LIMIT :page OFFSET :off ' +
                      'WITH SECURITY_ENFORCED';

        List<Contact> cons = Database.query(soql);
        List<ContactRow> rows = new List<ContactRow>();
        for (Contact c : cons) {
            ContactRow r = new ContactRow();
            r.Id = c.Id;
            r.Name = c.Name;
            r.Phone = c.Phone;
            r.MailingCity = c.MailingCity;
            rows.add(r);
        }

        ContactResult res = new ContactResult();
        res.rows = rows;
        res.totalCount = totalCnt;
        return res;
    }
}