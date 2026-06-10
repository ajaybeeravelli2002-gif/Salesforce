global class LeadCleanUpBatch implements Database.Batchable<sObject> {
    
    // 1. START: Collect the records
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Collect all Open Leads that haven't been touched
        String query = 'SELECT Id, Status FROM Lead WHERE Status = \'Open - Not Contacted\'';
        return Database.getQueryLocator(query);
    }
    
    // 2. EXECUTE: Process records in chunks (e.g., 200 at a time)
    global void execute(Database.BatchableContext bc, List<Lead> scope) {
        List<Lead> leadsToUpdate = new List<Lead>();
        
        for (Lead l : scope) {
            l.Status = 'Closed - Not Converted';
            leadsToUpdate.add(l);
        }
        
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
    
    // 3. FINISH: Do post-processing operations
    global void finish(Database.BatchableContext bc) {
        System.debug('Batch Job Complete! High fives all around.');
        // You could also send an email alert here to yourself
    }
}